//
//  FavouriteViewController.swift
//  Favorite2Days
//
//  Created by NURZHAN on 30.03.2018.
//  Copyright © 2018 NURZHAN. All rights reserved.
//

import UIKit
import Cartography

class FavouriteViewController: UIViewController {
    
//    MARK: Properties
    public var eventDelegate: EventDelegate?
    
    private var deviceType = UIScreen.main.traitCollection.userInterfaceIdiom.rawValue
    
    lazy var viewForTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var viewForDescriptionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var modalTitle : UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Helvetica", size: 22)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = .black
        return textView
    }()
    
    lazy var modalDescription : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        return textView
    }()

//    MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addConstraints()
        modalDescription.sizeToFit()
    }
    
    private func setupViews() {
        
        view.backgroundColor = .white
        view.addSubViews([viewForTitleView, viewForDescriptionView, separatorView])
        
        viewForTitleView.addSubview(modalTitle)
        viewForDescriptionView.addSubview(modalDescription)
        
        modalDescription.text = "\t" + (eventDelegate?.event.eventText)!
        modalTitle.text = eventDelegate?.event.title
        
        modalTitle.sizeToFit()
        modalDescription.sizeToFit()
        
    }
    
//    MARK: Constraints
    private func addConstraints() {
        
        let multiplierForDevice = (deviceType == 1) ? 10 : 0
        
        modalTitle.font = UIFont(name: "Helvetica Bold", size: CGFloat(20 + multiplierForDevice))!
        modalDescription.font = UIFont.init(name: "American Typewriter", size: CGFloat(18 + multiplierForDevice))
        
        let titleHeight = modalTitle.text?.height(withConstrainedWidth: view.bounds.width * 0.9, font: UIFont(name: "Helvetica Bold", size: CGFloat(24 + multiplierForDevice))!)
        
        constrain(view, viewForTitleView, viewForDescriptionView, separatorView) { v1, v2, v3, v4 in
            
            v2.height == titleHeight! + view.bounds.height * 0.03
            v2.width == v1.width * 0.9
            v2.top == v1.top
            v2.centerX == v1.centerX
            
            v3.top == v2.bottom + 1
            v3.height == v1.height * 0.75
            v3.width == v1.width * 0.9
            v3.centerX == v1.centerX
            
            v4.width == v3.width
            v4.top == v2.bottom
            v4.centerX == v1.centerX
            v4.height == 1
        
        }
        
        separatorView.layer.cornerRadius = 0.5
        
        constrain(viewForTitleView, modalTitle) { v1, v2 in
            v2.width == v1.width
            v2.bottom == v1.bottom
            v2.centerX == v1.centerX
        }
        
        constrain(viewForDescriptionView, modalDescription) { v1, v2 in
            v2.top == v1.top
            v2.width == v1.width
            v2.height == v1.height
            v2.centerX == v1.centerX
        }
        
    }
    
}
