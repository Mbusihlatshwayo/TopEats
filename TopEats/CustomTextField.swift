//
//  CustomTextField.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/14/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
            
            imageView.contentMode = .scaleAspectFit
            
            imageView.alpha = 0.75
            
            imageView.image = image
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
            
            view.addSubview(imageView)
            
            leftView = view
            
        } else {
            leftViewMode = .never
        }
        
        attributedText = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor : tintColor])
    }

}
