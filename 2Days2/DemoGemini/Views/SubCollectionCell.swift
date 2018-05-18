//
//  SubCollectionCell.swift
//  DemoStory
//
//  Created by MacBook on 29.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography
import ParallaxHeader
import SwiftyShadow
import Kingfisher

class SubCollectionCell: UICollectionViewCell, UIScrollViewDelegate ,UITextViewDelegate{
    
    // MARK: - Properties
    
    var color:UIColor?{
        didSet{
            textView.backgroundColor = color
            title.backgroundColor = color
            view.backgroundColor = color
        }
    }
    
    var event:Event?{
        didSet{
            
            title.text = event?.title
            
            title.sizeToFit()
            
            let url = URL.init(string: "\(URLs.imageURL)\((event?.image)!)")!
            
            imageView.kf.setImage(with: url)
            
            textView.text = "\t" + (event?.eventText)!
            
            //Parallax Header
            
            scrollView.parallaxHeader.minimumHeight = 0
            
            scrollView.parallaxHeader.view = imageView
            
            scrollView.parallaxHeader.mode = .fill
            
            scrollView.parallaxHeader.height = self.frame.width  * 0.6
            
            constrain(title){ title in
                title.height == heightForView(text: self.title.text!, font: self.title.font, width: (self.frame.width - (self.frame.width/50 + self.frame.width/200)) * 0.95 )
            }
            
            self.layoutIfNeeded()
            
        }
    }
    
    lazy var view:UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = Size.width/41
        view.backgroundColor = UIColor.white
        view.layer.shadowRadius = Size.width/70
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.shadow.cgColor
        view.layer.shadowOffset = CGSize.zero
        return view
    }()
    
    lazy var line:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.line
        return view
    }()
    
    lazy var title:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "HelveticaNeue-Bold", size: Size.width/20)
        label.backgroundColor = UIColor.white
        label.numberOfLines = 0
//        label.sizeToFit()
        return label
    }()
    
    lazy var favouriteAdderPulseStar:UIImageView = {
        let image:UIImageView = UIImageView.init(image: UIImage.init(named: "star"))
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    lazy var imageView:UIImageView = {
        let image:UIImageView = UIImageView.init()
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        image.kf.indicatorType = .activity
        image.backgroundColor = UIColor.white
        return image
    }()
    
    lazy var textView:UITextView = {
        let text = UITextView.init()
        text.showsVerticalScrollIndicator = false
        text.isEditable = false
        text.isScrollEnabled = true
        text.isSelectable = false
        text.textAlignment = .left
        text.backgroundColor = UIColor.white
        text.delegate = self
        text.bounces = false
        text.font = UIFont.init(name: "American Typewriter", size:Size.width/20)
        return text
    }()
    
    lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView.init()
        scroll.showsHorizontalScrollIndicator = false
        scroll.scrollsToTop = true
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        scroll.contentSize = CGSize.init(width: 0, height: self.frame.height - (self.frame.width/25 + self.frame.width/50) )
        return scroll
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup View
    func setupViews() -> Void {
        addSubview(view)
        scrollView.addSubview(textView)
        scrollView.addSubview(line)
        scrollView.addSubview(title)
        view.addSubview(scrollView)
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    // MARK: - Constrains with Cartography
    
    func setupConstrains() -> Void {
        
        constrain(view,title,line,textView,scrollView){ view,title,line,text,scrollView in
        
            //view constrains
            
            view.right == (view.superview?.right)! - self.frame.width/50
            view.left == (view.superview?.left)! + self.frame.width/50
            view.top == (view.superview?.top)! + self.frame.width/50
            view.bottom == (view.superview?.bottom)! - self.frame.width/41
            
            
            // scroll view constrains
            
            scrollView.width == view.width
            scrollView.centerX == view.centerX
            scrollView.bottom == view.bottom - self.frame.width/41
            scrollView.top == view.top
            
            
            // title constrains
            
            title.width == scrollView.width * 0.95
            title.centerX == scrollView.centerX
            title.top == scrollView.top + self.frame.width/35
            
            
            // line constrains
            
            line.width == title.width
            line.height == self.frame.width/200
            line.centerX == title.centerX
            line.top == title.bottom + self.frame.width/35
            
            // textView constrains
            
            text.width == line.width
            text.top == line.bottom + self.frame.width/35
            text.bottom == view.bottom - self.frame.width/41
            text.centerX == view.centerX

            
        }
    }
    
    // detect scrolling
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.minY > 0 {
            self.scrollView.alwaysBounceVertical = false
            textView.isScrollEnabled = true
        }
        else{
            textView.isScrollEnabled = false
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("wefwefwe")
    }
    
}
