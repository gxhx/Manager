//
//  User.swift
//  Manager
//
//  Created by sue on 2020/5/28.
//  Copyright © 2020 Sharlockk. All rights reserved.
//

import Foundation
import ObjectMapper

class User:NSObject, NSSecureCoding, ImmutableMappable {
    
    static var supportsSecureCoding: Bool = true
    
    static var currentUser :User? {
        set {
            CacheManager.share.save(withKey:"user",newValue)
        }
        
        get {
            if let user : User = CacheManager.share.getObject(withKey:"user") {
                return user
            }
            return nil
        }
    }
    
    required init(map: Map) throws {
        
    }
    
    var phoneNum : String?
    var uid : String?
    var passWord : String?
    var ctm : String?
    var sex : String?
    var profileImage :String?
    var platform : String?
    var nickName : String?
    var headIcon : String?
    var headImageName : String?
    var groupId : NSNumber?
    var groupName : String?
    var permission : NSNumber?
    var userKey : String?
    
    func mapping(map: Map) {
        phoneNum        <- map["phoneNum"]
        uid             <- map["uid"]
        passWord        <- map["passWord"]
        ctm             <- map["ctm"]
        sex             <- map["sex"]
        profileImage    <- map["profileImage"]
        nickName        <- map["nickName"]
        headIcon        <- map["headIcon"]
        headImageName   <- map["headImageNamev"]
        groupId         <- map["groupId"]
        groupName       <- map["groupName"]
        permission      <- map["permission"]
        userKey         <- map["userKey"]
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(phoneNum, forKey: "phoneNum")
        coder.encode(uid, forKey: "uid")
        coder.encode(passWord, forKey: "passWord")
        coder.encode(ctm, forKey: "ctm")
        coder.encode(sex, forKey: "sex")
        coder.encode(profileImage, forKey: "profileImage")
        coder.encode(nickName, forKey: "nickName")
        coder.encode(headIcon, forKey: "headIcon")
        coder.encode(headImageName, forKey: "headImageName")
        coder.encode(groupId, forKey: "groupId")
        coder.encode(groupName, forKey: "groupName")
        coder.encode(permission, forKey: "permission")
        coder.encode(userKey, forKey: "userKey")
    }
    
    required init?(coder: NSCoder) {
    
        phoneNum = coder.decodeObject(forKey: "phoneNum") as? String
        uid = coder.decodeObject(forKey: "uid") as? String
        passWord = coder.decodeObject(forKey: "passWord") as? String
        ctm = coder.decodeObject(forKey: "ctm") as? String
        sex = coder.decodeObject(forKey: "sex") as? String
        profileImage = coder.decodeObject(forKey: "profileImage") as? String
        nickName = coder.decodeObject(forKey: "nickName") as? String
        headIcon = coder.decodeObject(forKey: "headIcon") as? String
        headImageName = coder.decodeObject(forKey: "headImageName") as? String
        groupId = coder.decodeObject(forKey: "groupId") as? NSNumber
        groupName = coder.decodeObject(forKey: "groupName") as? String
        permission = coder.decodeObject(forKey: "permission") as? NSNumber
        userKey = coder.decodeObject(forKey: "userKey") as? String
    }
}

