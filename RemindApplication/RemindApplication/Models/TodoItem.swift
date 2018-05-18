//
//  TodoItem.swift
//  RemindApplication
//
//  Created by MacBook on 21.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct TodoItem {
    var name: String
    var remind: String
    var map:String
    var deadline: String
    var UUID: String
    var phoneNumber:String
    
    init(_ deadline: String,_ name: String,_ remind:String,_ map:String,_ UUID: String,_ phoneNumber:String) {
        self.deadline = deadline
        self.name = name
        self.map = map
        self.UUID = UUID
        self.remind = remind
        self.phoneNumber = phoneNumber
    }
    
    var isOverdue: Bool {
        let dateFormatter = DateFormatter()
        let date = dateFormatter.date(from: deadline)
        return (Date().compare(date!) == .orderedSame)
    }
    
    init(snapshot: DataSnapshot) {
        let reminds = snapshot.value as! NSDictionary
        name = (reminds.value(forKey: "name") as? String)!
        remind = (reminds.value(forKey: "remind") as? String)!
        map = (reminds.value(forKey: "map") as? String)!
        deadline = (reminds.value(forKey: "deadline") as? String)!
        UUID = (reminds.value(forKey: "UUID") as? String)!
        phoneNumber = (reminds.value(forKey: "phoneNumber") as? String)!
    }
    func toJSONFormat()-> Any{
        return ["name": name,
                "remind":remind,
                "map":map,
                "deadline":String(describing: deadline),
                "UUID":UUID,
                "phoneNumber":phoneNumber
                ]
    }
}
