//
//  Photo.swift
//  FlickFinder
//
//  Created by Danish Ahmed Ansari on 8/18/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
    var farm: String?
    var hasComment: Int?
    var heightM: Int?
    var id: Int?
    var isPrimary: Bool?
    var isFamily: Bool?
    var isFriend: Bool?
    var isPublic: Bool?
    var owner: String?
    var secret: String?
    var server: Int?
    var title: String?
    var urlM: String?
    var widthM: Int?
    var image: NSData?
    
    
    override init() {
        super.init()
    }
    
    func initPhoto(data: [String: AnyObject]!) {
        self.farm = data["farm"] as? String
        self.hasComment = data["has_comment"] as? Int
        self.heightM = data["height_m"] as? Int
        self.id = data["id"] as? Int
        self.isPrimary = data["is_primary"] as? Bool
        self.isFriend = data["isfriend"] as? Bool
        self.isFamily = data["isfamily"] as? Bool
        self.isPublic = data["ispublic"] as? Bool
        self.owner = data["owner"] as? String
        self.secret = data["secret"] as? String
        self.server = data["server"] as? Int
        self.title = data["title"] as? String
        self.urlM = data["url_m"] as? String
        self.widthM = data["width_m"] as? Int
    }
}
