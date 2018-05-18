//
//  AppDelegate.swift
//  RemindApplication
//
//  Created by MacBook on 30.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let defaults = UserDefaults.standard
        let phoneNumber = defaults.string(forKey: "phoneNumberUser")
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (permissin, error) in
            print(error as Any)
        }
        UNUserNotificationCenter.current().delegate = self
        
        let completeAction = UNNotificationAction.init(identifier: "Com", title: "Complete", options: .destructive)

        let remindAction = UNNotificationAction.init(identifier: "Remind", title: "Remind in 30 minutes", options: .foreground)
        
        let todoCategory = UNNotificationCategory.init(identifier: "TODO_CATEGORY", actions: [remindAction,completeAction], intentIdentifiers: ["Com","Remind"], hiddenPreviewsBodyPlaceholder: "", options: .allowInCarPlay)
        
        UNUserNotificationCenter.current().setNotificationCategories(Set([todoCategory]))
        
        
        let initalViewController = InitialViewController()
        
        if phoneNumber == nil{
            window?.rootViewController = initalViewController
        }else{
            window?.rootViewController = MainViewController()
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        let todoItems: [TodoItem] = TodoList.sharedInstance.allItems()
        UIApplication.shared.applicationIconBadgeNumber = todoItems.count
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("TodoListShouldRefresh") as NSNotification.Name, object: self)
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        
        let item = TodoItem(String(describing: notification.fireDate!), notification.userInfo!["name"] as! String, notification.userInfo!["remind"] as! String, notification.userInfo!["map"] as! String, notification.userInfo!["UUID"] as! String!,"phoneNumber")
        
        switch (identifier!) {
        case "COMPLETE_TODO":
            TodoList.sharedInstance.remove(item)
        case "REMIND":
            TodoList.sharedInstance.scheduleReminder(forItem: item)
        default: // switch statements must be exhaustive - this condition should never be met
            print("Error: unexpected notification action identifier!")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RemindApplication")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
