//
//  ChatViewController.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/25/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

final class ChatViewController: JSQMessagesViewController {

    // MARK: Properties
    
    // reference to cuisine sections
    var communitySectionsRef: DatabaseReference?
    // reference to section messages
    private lazy var messageRef: DatabaseReference = self.communitySectionsRef!.child("messages")
    // reference to firebase storage for images
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://topeats-8e944.appspot.com")
    // reference for typing status
    private lazy var userIsTypingRef: DatabaseReference = self.communitySectionsRef!.child("typingIndicator").child(self.senderId)
    // query for all typing users
    private lazy var usersTypingQuery: DatabaseQuery = self.communitySectionsRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    // database handlers
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?
    
    // mutable array of messages
    private var messages: [JSQMessage] = []
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    private var localTyping = false
    var section: Section? {
        didSet {
            title = section?.name
        }
    }
    
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get the jsq sender id from the firebase user id
        self.senderId = Auth.auth().currentUser?.uid
        self.senderDisplayName = Auth.auth().currentUser?.displayName
        print("display name = \(self.senderDisplayName)")
        
        observeMessages()
        
        // No avatars change later maybe?
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeTyping()
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        isTyping = textView.text != ""
    }
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    // set up bubble colors
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        guard let senderDisplayName = message.senderDisplayName else {
            assertionFailure()
            return nil
        }
        return NSAttributedString(string: senderDisplayName)
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId { // 1
            cell.textView?.textColor = UIColor.white // 2
        } else {
            cell.textView?.textColor = UIColor.black // 3
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 15
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = communitySectionsRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            
            // You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    private func observeMessages() {
        
        print("sec ref: \(String(describing: communitySectionsRef!))")
        print("mess ref: \(messageRef)")
        messageRef = communitySectionsRef!.child("messages")

        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()
            } else {
                print("Error! Could not decode message data")
            }
        })

    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // 1
        let itemRef = messageRef.childByAutoId()
        
        // 2
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        
        // 3
        itemRef.setValue(messageItem)
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // 5
        finishSendingMessage()
        isTyping = false
    }
    

//    func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
//        let message = messages[indexPath.item]
//
//        guard let senderDisplayName = message.senderDisplayName else {
//            assertionFailure()
//            return nil
//        }
//        return NSAttributedString(string: senderDisplayName)
//        
//    }
    
    
}
