//
//  SettingCell.swift
//  RemindApplication
//
//  Created by MacBook on 19.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class SettingCell:UITableViewCell {
    
    // MARK: - Properties
    
    lazy var foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var view1:UIView = {
        let view1 = UIView()
        return view1
    }()
    
    lazy var globalView:UIView = {
        let view1 = UIView()
        view1.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view1
    }()
    
    lazy var globalView1:UIView = {
        let view1 = UIView()
        return view1
    }()
    
    // MARK: - Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Inital Setup
    func setupViews() {
        self.addSubview(globalView1)
        self.globalView1.addSubview(globalView)
        self.globalView.addViews([ titleLabel,view1, foodImageView])
    }
    
    // MARK: - Constraints
    func setupConstraints() {
        constrain(globalView1,globalView,foodImageView, titleLabel,view1) {globalView1,globalView,newsImageView, titleLabel ,view1 in
            
            globalView1.width == globalView1.superview!.width
            globalView1.height == globalView1.superview!.height
            
            globalView.height == globalView.superview!.height*0.87
            globalView.width == globalView.superview!.width
            globalView.center == globalView.superview!.center
            
            newsImageView.width == newsImageView.superview!.height*0.4
            newsImageView.height == newsImageView.superview!.height*0.4
            newsImageView.centerY == newsImageView.superview!.centerY
            newsImageView.left == newsImageView.superview!.left + 20
            
            view1.bottom == view1.superview!.bottom + 1
            view1.height == 1
            view1.width == view1.superview!.width - self.bounds.width*0.06
            view1.right == view1.superview!.right
            
            titleLabel.left == newsImageView.right + 20
            titleLabel.centerY == newsImageView.centerY
        }
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
}

