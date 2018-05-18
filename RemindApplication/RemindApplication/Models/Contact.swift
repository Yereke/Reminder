//
//  Contact.swift
//  RemindAPP
//
//  Created by MacBook on 26.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation

class Contact {
    var name:String?
    var image:String?
    var lastName:String?
    var phoneNumber:String?
    
    init(_ name:String,_ image:String,_ lastName:String,_ phoneNumber:String) {
        self.image = image
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
    
    public func toString() -> String{
        return lastName!
    }
}
