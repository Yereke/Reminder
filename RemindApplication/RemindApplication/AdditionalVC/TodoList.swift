//
//  TodoList.swift
//  RemindApplication
//
//  Created by MacBook on 21.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseDatabase
class TodoList {
    
    private var dbRef: DatabaseReference?
    var Reminds:[TodoItem] = Array()
    
    class var sharedInstance : TodoList {
        struct Static {
            static let instance : TodoList = TodoList()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "Item"
    
    func allItems() -> [TodoItem] {
        dbRef = Database.database().reference()
        dbRef?.child("reminds").observe(DataEventType.value, with: { (snapshot) in
            self.Reminds.removeAll()
            let defaults = UserDefaults.standard
            let phoneNumber = defaults.string(forKey: "phoneNumberUser")
            for snap in snapshot.children{
                let remind = TodoItem.init(snapshot: snap as! DataSnapshot)
                let phone = remind.phoneNumber.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
                if phone == phoneNumber{
                    let date = Date.init(timeIntervalSince1970: TimeInterval(Double(remind.deadline)!))
                    if (date.compare(Date()) == .orderedDescending){
                        self.Reminds.append(remind)
                    }
                }
            }
        })
        return Reminds
    }
    
    func add(_ item: TodoItem) {
        
//        var todoDictionary = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) ?? Dictionary()
//        todoDictionary[item.UUID] = ["deadline": item.deadline, "name": item.name,"remind":item.remind,"map":item.map, "UUID": item.UUID]
//        UserDefaults.standard.set(todoDictionary, forKey: ITEMS_KEY)
        
        
        
//        let content = UNMutableNotificationContent()
//        content.title = "Open"
//        content.body = "Todo Item \"\(item.title)\" Is Overdue"
//        content.sound = UNNotificationSound.init(named: "aaa.caf")
//        content.categoryIdentifier = "TODO_CATEGORY"
//        content.userInfo = ["title": item.title, "UUID": item.UUID]
//
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents(in: .current, from: item.deadline)
//        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
//        let request = UNNotificationRequest(
//            identifier: "randomImageName", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if (error != nil){print("error")}
//        }
        
        let notification = UILocalNotification()
        
//        let dateFormatter = DateFormatter()
//        let date = dateFormatter.date(from: item.deadline)
        
        let arrayOfContact:[Contact] = FetchContacts.share.fetchContact()
        
        var name:String = ""
        
        for i in arrayOfContact{
            if i.phoneNumber == item.name{
                name = i.name!
            }
        }
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(Double(item.deadline)!))
        
        let defaults = UserDefaults.standard
        let music = defaults.string(forKey: "music")
        
        notification.alertBody = "\(item.remind)"
        notification.alertAction = "\(item.name)"
        notification.alertTitle = name
        notification.fireDate = date
        notification.soundName = music
        notification.userInfo = ["name": item.name, "UUID": item.UUID,"remind":item.remind,"map":item.map]
        notification.category = "TODO_CATEGORY"
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
        self.setBadgeNumbers()
    }
    
    func remove(_ item: TodoItem) {
        
        let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
        guard scheduledNotifications != nil else {return}
        for notification in scheduledNotifications! {
            if (notification.userInfo!["UUID"] as! String == item.UUID) {
                UIApplication.shared.cancelLocalNotification(notification)
                break
            }
        }
        
//        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [item.UUID])
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.UUID])
//
//        if var todoItems = UserDefaults.standard.dictionary(forKey: ITEMS_KEY) {
//            todoItems.removeValue(forKey: item.UUID)
//            UserDefaults.standard.set(todoItems, forKey: ITEMS_KEY) // save/overwrite todo item list
//        }
        
        self.setBadgeNumbers()
    }
    
    func scheduleReminder(forItem item: TodoItem) {
        
        let notification = UILocalNotification()
        notification.alertBody = "\(item.remind)"
        notification.alertTitle = "\(item.name)"
        notification.alertAction = "\(item.name)"
        notification.fireDate = Date(timeIntervalSinceNow: 30 * 60)
        notification.soundName = "aaa.wav"
        notification.userInfo = ["name": item.name, "UUID": item.UUID,"map":item.map,"remind":item.remind]
        notification.category = "TODO_CATEGORY"
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
//        let content = UNMutableNotificationContent()
//        content.title = "Open"
//        content.body = "Todo Item \"\(item.title)\" Is Overdue"
//        content.sound = UNNotificationSound.init(named: "aaa.caf")
//        content.categoryIdentifier = "TODO_CATEGORY"
//        content.userInfo = ["title": item.title, "UUID": item.UUID]
//
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents(in: .current, from: Date())
//        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute! + 1)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
//        let request = UNNotificationRequest(
//            identifier: "randomImageName", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { (error) in
//            if (error != nil){print("error")}
//        }
    }
    
    func setBadgeNumbers() {
        let todoItems: [TodoItem] = self.allItems()
        UIApplication.shared.applicationIconBadgeNumber = todoItems.count
    }
}
