//
//  CellForRemindeds.swift
//  RemindApplication
//
//  Created by MacBook on 18.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class CellForRemindeds: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
        setUpConstrains()
        let defaults = UserDefaults.standard
        let color = defaults.string(forKey: "color")
        self.backgroundColor = UIColor(hexString: color!)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var globalView:UIView = {
        let picker = UIView()
        picker.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        picker.layer.masksToBounds = false
        picker.layer.shadowOpacity = 1
        picker.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        picker.layer.shadowOffset = .zero
        picker.layer.shadowRadius = 5
        picker.layer.cornerRadius = 10
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var dateGlobalView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mapGlobalView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var textInputBar:UITextView = {
        let view = UITextView()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.sublayerTransform = CATransform3DMakeTranslation(2, 2, 0)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.isEditable = false
        view.text = "Note"
        view.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        view.font = FontBook.Regular.of(size: self.frame.height/2.6)
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        button.titleLabel?.font = FontBook.Regular.of(size: self.frame.height/2.6)
        button.setTitle("Date", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addBorders(edges: .right,color: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),thickness: 1)
        return button
    }()
    
    lazy var timeButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.titleLabel?.font = FontBook.Regular.of(size: self.frame.height/2.6)
        button.setTitle("Time", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var MapButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.titleLabel?.font = FontBook.Regular.of(size: self.frame.height/2.8)
        button.setTitle("Address", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var Name:UILabel = {
        let button = UILabel()
        button.backgroundColor = .clear
        button.font = UIFont(name: "American Typewriter", size: self.frame.height/2.5)
        button.textColor = #colorLiteral(red: 0.3896405101, green: 0.3873292804, blue: 0.3914203942, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var timeIsOn:UIImageView = {
        let button = UIImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Inital Setup
    func setUp(){
        self.addSubview(globalView)
        self.globalView.addViews([dateGlobalView,mapGlobalView,textInputBar,Name,timeIsOn])
        self.dateGlobalView.addViews([dateButton,timeButton])
        self.mapGlobalView.addSubview(MapButton)
    }
    
    // MARK: - Constraints
    func setUpConstrains(){
        constrain(globalView,dateGlobalView,mapGlobalView,textInputBar,Name,timeIsOn){globalView,dateGlobalView,mapGlobalView,noteGlobalView,Name,timeIsOn in
            globalView.centerX == globalView.superview!.centerX
            globalView.centerY == globalView.superview!.centerY
            globalView.width == globalView.superview!.width - self.frame.width/30
            globalView.height == globalView.superview!.height * 0.95
            
            dateGlobalView.top == dateGlobalView.superview!.top + self.frame.height/5
            dateGlobalView.centerX == globalView.centerX
            dateGlobalView.width == dateGlobalView.superview!.width - self.frame.width/25
            dateGlobalView.height == dateGlobalView.superview!.height/4.5
            
            mapGlobalView.top ==  dateGlobalView.bottom + self.frame.height/6
            mapGlobalView.centerX == dateGlobalView.centerX
            mapGlobalView.width == dateGlobalView.width
            mapGlobalView.height == dateGlobalView.height
            
            noteGlobalView.top ==  mapGlobalView.bottom + self.frame.height/6
            noteGlobalView.centerX == mapGlobalView.centerX
            noteGlobalView.width == mapGlobalView.width
            noteGlobalView.height == mapGlobalView.height
            
            Name.bottom == Name.superview!.bottom - self.frame.height/9
            Name.leading == noteGlobalView.leading + self.frame.width/4
            
            timeIsOn.bottom == Name.superview!.bottom - self.frame.height/9
            timeIsOn.trailing == noteGlobalView.trailing - self.frame.width/4
            timeIsOn.height == self.frame.height/2
            timeIsOn.width == self.frame.height/2
        }
        constrain(dateButton,timeButton,MapButton){dateButton,timeButton,MapButton in
            dateButton.leading == dateButton.superview!.leading
            dateButton.centerY == dateButton.superview!.centerY
            dateButton.height == dateButton.superview!.height
            dateButton.width == dateButton.superview!.width*0.75
            
            timeButton.leading == dateButton.trailing
            timeButton.centerY == dateButton.superview!.centerY
            timeButton.height == dateButton.superview!.height
            timeButton.width == dateButton.superview!.width*0.25
            
            MapButton.centerX == MapButton.superview!.centerX
            MapButton.centerY == MapButton.superview!.centerY
            MapButton.height == MapButton.superview!.height
            MapButton.width == MapButton.superview!.width
        }
    }
    
}
