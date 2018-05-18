//
//  NameAndNumberViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography
import SinchVerification
import FirebaseDatabase

class NameAndNumberViewController: UIViewController {
    
    //MARK: Properties
    var verification:Verification?
    private var dbRef: DatabaseReference?
    
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
    
    lazy var FullName:UITextField = {
        let text = UITextField()
        text.placeholder = "Full Name"
        text.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        text.layer.borderWidth = 1
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.font = UIFont(name: "Helvetica", size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var PhoneNumber:UITextField = {
        let text = UITextField()
        text.placeholder = "Phone Number"
        text.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        text.layer.borderWidth = 1
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.font = UIFont(name: "Helvetica", size: 17)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
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
        self.view.addViews([remindAppImage,remindAppTitle,FullName,PhoneNumber,nextButton,preViewController])
        constrain(remindAppImage,remindAppTitle,FullName,PhoneNumber,nextButton,preViewController){remindAppImage,remindAppTitle,FullName,PhoneNumber,nextButton,preViewController in
            
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
            
            FullName.top == remindAppTitle.bottom + self.view.frame.width/13
            FullName.centerX == remindAppTitle.centerX
            FullName.width == self.view.frame.width/1.5
            FullName.height == self.view.frame.width/9
            
            PhoneNumber.top == FullName.bottom + 8
            PhoneNumber.centerX == remindAppTitle.centerX
            PhoneNumber.width == self.view.frame.width/1.5
            PhoneNumber.height == self.view.frame.width/9
            
            nextButton.bottom == nextButton.superview!.bottom - self.view.frame.width/2.2
            nextButton.centerX == FullName.centerX
            nextButton.width == self.view.frame.width/1.5
            nextButton.height == self.view.frame.width/9
        }
    }
    
    @objc func buttonToNameAndNumberViewController(){
        let defaults = UserDefaults.standard
        defaults.set(PhoneNumber.text!, forKey: "phoneNumberUser")
        defaults.set("#D7F3F8", forKey: "color")
        defaults.set("en", forKey: "language")
        defaults.set("aaa.wav", forKey: "music")
        self.present(MainViewController(), animated: false, completion: nil)
//        verification = CalloutVerification("349d6120-f896-4e10-b3c3-3fdb7f6b7b17", phoneNumber: PhoneNumber.text!)
//        verification?.initiate({ (result, error) in
//            if result.success{
//                self.show(VerifyViewController(), sender: self)куьщму
//            }else{
//                print(error.debugDescription)
//            }
//        })
    }
    
    func setKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(topDown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downTop), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func topDown(){
        UIView.animate(withDuration: 0.6, animations: {
            self.view.frame.origin.y = -self.view.frame.height*0.13
        })
    }
    
    @objc func downTop(){
        self.view.frame.origin.y = 0
    }
    
    @objc func buttonToPreviewViewController(){
        self.show(InitialViewController(), sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpViews()
        setKeyBoard()
    }
    
}

