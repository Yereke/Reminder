//
//  Event.swift
//  DemoStory
//
//  Created by MacBook on 29.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import  UIKit
import ObjectMapper

class Event:NSObject, Mappable,NSCoding {
    
    var id:String?
    var date:String?
    var title:String?
    var eventText:String?
    var image:String?
    var hashtag:String?
    
    override init() {}
    
    required init?(map: Map) {}
    
    required init?(coder aDecoder: NSCoder) {
        if let _id = aDecoder.decodeObject(forKey: Keys.id) as? String {
            self.id = _id
        }
        
        if let _title = aDecoder.decodeObject(forKey: Keys.title) as? String {
            self.title = _title
            
        }
        
        if let _date = aDecoder.decodeObject(forKey: Keys.date) as? String {
            self.date = _date
        }
        
        if let _eventText = aDecoder.decodeObject(forKey: Keys.eventText) as? String {
            self.eventText = _eventText
        }
        
        if let _image = aDecoder.decodeObject(forKey: Keys.image) as? String {
            self.image = _image
        }
        
        if let _hashtag = aDecoder.decodeObject(forKey: Keys.hashtag) as? String {
            self.hashtag = _hashtag
        }
    }
    
    func mapping(map: Map) {
        self.id <- map["event_id"]
        self.date <- map["event_date"]
        self.title <- map["event_name_ru"]
        self.eventText <- map["event_description_ru"]
        self.image <- map["event_picture"]
        self.hashtag <- map["hashtag"]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id)
        aCoder.encode(date, forKey: Keys.date)
        aCoder.encode(title, forKey: Keys.title)
        aCoder.encode(eventText, forKey: Keys.eventText)
        aCoder.encode(image, forKey: Keys.image)
        aCoder.encode(hashtag, forKey: Keys.hashtag)
    }
}

