//
//  InitialViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class InitialViewController: UIViewController {
    
    lazy var remindAppImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "remindApp")
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
    
    lazy var aboutThisApp:UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.text = "Be punctual!"
        label.textColor = #colorLiteral(red: 0.5976189971, green: 0.5933018923, blue: 0.7018104924, alpha: 1)
        label.font = UIFont(name: "Helvetica", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nextButton:UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.6431372549, blue: 0.8509803922, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToNameAndNumberViewController), for: .touchUpInside)
        return button
    }()
    
    @objc func setUpViews(){
        self.view.addViews([remindAppImage,remindAppTitle,aboutThisApp,nextButton])
        constrain(remindAppImage,remindAppTitle,aboutThisApp,nextButton){remindAppImage,remindAppTitle,aboutThisApp,nextButton in
            remindAppImage.top == remindAppImage.superview!.top + self.view.frame.width/4.5
            remindAppImage.centerX == remindAppImage.superview!.centerX
            remindAppImage.width == self.view.frame.width/3.4
            remindAppImage.height == self.view.frame.width/3.4
            
            remindAppTitle.top == remindAppImage.bottom + self.view.frame.width/7
            remindAppTitle.centerX == remindAppImage.centerX
            
            aboutThisApp.top == remindAppTitle.bottom + self.view.frame.width/6
            aboutThisApp.centerX == remindAppTitle.centerX
            
            nextButton.bottom == nextButton.superview!.bottom - self.view.frame.width/2.2
            nextButton.centerX == aboutThisApp.centerX
            nextButton.width == self.view.frame.width/1.5
            nextButton.height == self.view.frame.width/9
        }
    }
    
    @objc func buttonToNameAndNumberViewController(){
        self.show(NameAndNumberViewController(), sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpViews()
    }
}

