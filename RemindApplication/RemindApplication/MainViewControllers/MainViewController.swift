//
//  MainViewController.swift
//  RemindApplication
//
//  Created by MacBook on 22.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    let contactViewController = ContactsViewController()
    let remindViewController = RemindViewController()
    let settingViewControllers = SettingViewController()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = defaults.string(forKey: "color")
        contactViewController.view.backgroundColor = UIColor(hexString: color!)
        remindViewController.view.backgroundColor = UIColor(hexString: color!)
        settingViewControllers.view.backgroundColor = UIColor(hexString: color!)
        
        contactViewController.tabBarItem = UITabBarItem(title: Constant.contact, image: #imageLiteral(resourceName: "Contact"), tag: 0)
        remindViewController.tabBarItem = UITabBarItem(title: Constant.remind, image: #imageLiteral(resourceName: "remind"), tag: 1)
        settingViewControllers.tabBarItem = UITabBarItem(title: Constant.setting, image: #imageLiteral(resourceName: "setting"), tag: 2)
        
        let NavToContactViewController = UINavigationController(rootViewController: contactViewController)
        let NavToRemindViewController = UINavigationController(rootViewController: remindViewController)
        let NavSettingViewController = UINavigationController(rootViewController: settingViewControllers)
        
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.009912127629, green: 0.009915890172, blue: 0.009911632165, alpha: 0.8204195205)
        self.tabBar.tintColor = #colorLiteral(red: 0.1647058824, green: 0.4470588235, blue: 0.7137254902, alpha: 1)
        
        self.setViewControllers([NavToContactViewController,NavToRemindViewController,NavSettingViewController], animated: true)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
