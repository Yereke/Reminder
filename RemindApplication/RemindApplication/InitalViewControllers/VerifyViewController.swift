//
//  VerifyViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class VerifyViewController: UIViewController {
    
    lazy var remindAppImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "remindApp")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var preViewController:UIButton = {
        let image = UIButton()
        image.setImage(#imageLiteral(resourceName: "pre"), for: .normal)
        image.addTarget(self, action: #selector(buttonToPreviewViewController), for: .touchUpInside)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var remindAppTitle:UILabel = {
        let label = UILabel()
        label.text = "RemindApp"
        label.textColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
        label.font = UIFont(name: "Helvetica-Bold", size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var VerifyName:UITextField = {
        let text = UITextField()
        text.placeholder = "SMS Verifycation Code"
        text.textColor = #colorLiteral(red: 0.5976189971, green: 0.5933018923, blue: 0.6009261608, alpha: 1)
        text.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        text.layer.borderWidth = 1
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.font = UIFont(name: "Helvetica", size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    lazy var nextButton:UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.6431372549, blue: 0.8509803922, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToNameAndNumberViewController), for: .touchUpInside)
        return button
    }()
    
    @objc func setUpViews(){
        self.view.addViews([remindAppImage,remindAppTitle,VerifyName,nextButton,preViewController])
        constrain(remindAppImage,remindAppTitle,VerifyName,nextButton,preViewController){remindAppImage,remindAppTitle,VerifyName,nextButton,preViewController in
            
            preViewController.top == preViewController.superview!.top + self.view.frame.width/10
            preViewController.leading == preViewController.superview!.leading
            preViewController.width == self.view.frame.width/7
            preViewController.height == self.view.frame.width/10
            
            remindAppImage.top == remindAppImage.superview!.top + self.view.frame.width/4.5
            remindAppImage.centerX == remindAppImage.superview!.centerX
            remindAppImage.width == self.view.frame.width/3.4
            remindAppImage.height == self.view.frame.width/3.4
            
            remindAppTitle.top == remindAppImage.bottom + self.view.frame.width/7
            remindAppTitle.centerX == remindAppImage.centerX
            
            VerifyName.top == remindAppTitle.bottom + self.view.frame.width/6
            VerifyName.centerX == remindAppTitle.centerX
            VerifyName.width == self.view.frame.width/1.5
            VerifyName.height == self.view.frame.width/9
            
            nextButton.bottom == nextButton.superview!.bottom - self.view.frame.width/2.2
            nextButton.centerX == VerifyName.centerX
            nextButton.width == self.view.frame.width/1.5
            nextButton.height == self.view.frame.width/9
        }
    }
    
    @objc func buttonToNameAndNumberViewController(){
//        self.show(ContactsViewController(), sender: self)
        print("TabBar")
    }
    
    @objc func buttonToPreviewViewController(){
        self.show(NameAndNumberViewController(), sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpViews()
    }
    
}

