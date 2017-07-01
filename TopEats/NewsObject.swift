//
//  NewsObject.swift
//  TopEats
//
//  Created by Mbusi Hlatshwayo on 5/15/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import Foundation

class News {
    private var _headlineImage: String!
    private var _headlineText: String!
    private var _articleURL: String!
    
    var headlineImage: String {
        if _headlineImage == nil {
            return ""
        } else {
            return _headlineImage
        }
    }
    
    var headlineText: String {
        if _headlineText == nil {
            return ""
        } else {
            return _headlineText
        }
    }
    
    var articleURL: String {
        if _articleURL == nil {
            return ""
        } else {
            return _articleURL
        }
    }
    
    init(image: String, headText: String, articleURL: String) {
        
        _headlineImage = image
        _headlineText = headText
        _articleURL = articleURL
    }
}
