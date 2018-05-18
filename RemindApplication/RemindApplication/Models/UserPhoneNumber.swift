//
//  UserPhoneNumber.swift
//  RemindApplication
//
//  Created by MacBook on 22.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserPhoneNumber {
    var name:String?
    var phoneNumber:String?
    
    init(_ name:String,_ phoneNumber:String) {
        self.name = name
        self.phoneNumber = phoneNumber
    }
    
    init(snapshot: DataSnapshot) {
        let tweet = snapshot.value as! NSDictionary
        name = (tweet.value(forKey: "name") as? String)!
        phoneNumber = (tweet.value(forKey: "phoneNumber") as? String)!
    }
    func toJSONFormat()-> Any{
        return ["name": name,
                "phoneNumber":phoneNumber
        ]
    }
}
