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
    private var _articleText: String!
    
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
    
    var articleText: String {
        if _articleText == nil {
            return ""
        } else {
            return _articleText
        }
    }
    
    init(image: String, headText: String, articleText: String) {
        
        _headlineImage = image
        _headlineText = headText
        _articleText = articleText
    }
}
