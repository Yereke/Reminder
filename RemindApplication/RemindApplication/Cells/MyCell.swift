//
//  MyCells.swift
//  RemindAPP
//
//  Created by MacBook on 26.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class MyCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
        let defaults = UserDefaults.standard
        let color = defaults.string(forKey: "color")
        self.backgroundColor = UIColor(hexString: color!)
        self.selectionStyle = .none
    }
    
    lazy var Name:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Helvetica", size: self.frame.height/2.5)
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var PhoneNumber:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.1090132371, green: 0.1096314862, blue: 0.1111297682, alpha: 0.7729423415)
        label.font = UIFont(name: "Helvetica", size: self.frame.height/3)
        return label
    }()
    
    lazy var lastName:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Helvetica", size: self.frame.height/2.5)
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var Image:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var h:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.1090132371, green: 0.1096314862, blue: 0.1111297682, alpha: 0.7729423415)
        label.font = UIFont(name: "Helvetica", size: self.frame.height/3.3)
        return label
    }()
    
    lazy var View:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var deselectImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.addViews([Image,View,deselectImage])
        self.View.addViews([Name,PhoneNumber,lastName,h])
        
        constrain(Name,PhoneNumber,Image,View,lastName,h,deselectImage){Title,Date,Image,View,lastName,h,deselectImage in
            
            deselectImage.width == Image.superview!.height * 0.6
            deselectImage.height == Image.superview!.height * 0.6
            deselectImage.centerY == Image.superview!.centerY
            deselectImage.leading == Image.superview!.trailing - 50
            
            Image.width == Image.superview!.height * 0.9
            Image.height == Image.superview!.height * 0.9
            Image.centerY == Image.superview!.centerY
            Image.leading == Image.superview!.leading + 10
            
            View.centerY == Image.centerY
            View.width == View.superview!.width - 145
            View.leading == Image.trailing + 10
            View.height == Image.height
            
            Title.top == Title.superview!.top + 4
            Title.leading == Title.superview!.leading
            
            lastName.top == Title.top
            lastName.leading == Title.trailing + 5
            
            Date.bottom == Title.superview!.bottom + 4
            Date.leading == Title.superview!.leading
            
            h.trailing == h.superview!.trailing
            h.centerX == h.superview!.centerX
        }
    }
    
}
