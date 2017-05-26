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
    var sectionRef: DatabaseReference?
    // reference to section messages
    private lazy var messageRef: DatabaseReference = self.sectionRef!.child("messages")
    // reference to firebase storage for images
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://topeats-8e944.appspot.com")
    // reference for typing status
    private lazy var userIsTypingRef: DatabaseReference = self.sectionRef!.child("typingIndicator").child(self.senderId)
    // query for all typing users
    private lazy var usersTypingQuery: DatabaseQuery = self.sectionRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
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
        switch message.senderId {
        case senderId:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
        }
    }
    

}
