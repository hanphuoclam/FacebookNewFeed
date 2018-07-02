//
//  Post.swift
//  FacebookNewFeed
//
//  Created by LamHan on 6/29/18.
//  Copyright © 2018 LamHan. All rights reserved.
//

import UIKit

class Post : SafeJsonObject{
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
    var statusImageUrl: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?
    
    var location : Location?
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}


class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}

class Location: NSObject {
    var city: String?
    var state: String?
}

class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}
