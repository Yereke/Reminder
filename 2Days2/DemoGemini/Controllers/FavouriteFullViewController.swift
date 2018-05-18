//
//  FavouriteFullViewController.swift
//  DemoGemini
//
//  Created by NURZHAN on 19.04.2018.
//  Copyright © 2018 NURZHAN. All rights reserved.
//

import UIKit
import Cartography

class FavouriteFullViewController: UIViewController, UIScrollViewDelegate {
    
    var contentOffset:CGFloat = CGFloat.init(0)
    
    var event:Event?{
        didSet{
            
            _title.text = event?.title
            
            let url = URL.init(string: "\(URLs.imageURL)\((event?.image)!)")!
            
            imageView.kf.setImage(with: url)
            
            textView.text = "\t" + (event?.eventText)!
            
            //Parallax Header
            
            scrollView.parallaxHeader.minimumHeight = 0
            
            scrollView.parallaxHeader.view = imageView
            
            scrollView.parallaxHeader.mode = .fill
            
            scrollView.parallaxHeader.height = view.frame.width  * 0.6
            
            contentOffset = scrollView.contentOffset.y
            
            constrain(_title){ title in
                title.height == heightForView(text: self._title.text!, font: self._title.font, width: (view.frame.width - (view.frame.width/50 + view.frame.width/200)) * 0.95 )
            }
            
            navigationItem.title = event?.date

            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.locale = Locale(identifier: "ru_RU")
            dateFormatterPrint.dateFormat = "dd MMMM"

            let date: NSDate? = dateFormatterGet.date(from: (event?.date!)!)! as NSDate

            navigationItem.title = "\(dateFormatterPrint.string(from: date! as Date))"
            view.layoutIfNeeded()
            
        }
    }
  
    lazy var _view:UIView = {
        let view = UIView.init()
        view.layer.cornerRadius = Size.width/41
        view.backgroundColor = UIColor.white
        view.layer.shadowRadius = Size.width/70
        view.layer.shadowOpacity = 0.7
        view.layer.shadowColor = UIColor.shadow.cgColor
        view.layer.shadowOffset = CGSize.zero
        return view
    }()
    
    lazy var line:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.line
        return view
    }()
    
    lazy var _title:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.init(name: "HelveticaNeue-Bold", size: Size.width/20)
        label.backgroundColor = UIColor.white
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var imageView:UIImageView = {
        let image:UIImageView = UIImageView.init()
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        image.kf.indicatorType = .activity
        image.backgroundColor = UIColor.white
        return image
    }()
    
    lazy var textView:UITextView = {
        let text = UITextView.init()
        text.bounces = false
        text.isEditable = false
        text.isScrollEnabled = true
        text.isSelectable = false
        text.bounces = false
        text.textAlignment = .left
        text.backgroundColor = UIColor.white
        text.showsVerticalScrollIndicator = false
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
        scroll.contentSize = CGSize.init(width: 0, height: self.view.frame.height - 80)
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstrains()
    }
    
    // MARK: - Setup View
    func setupViews() -> Void {
        view.addSubview(_view)
        scrollView.addSubview(textView)
        scrollView.addSubview(line)
        scrollView.addSubview(_title)
        view.addSubview(scrollView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupNavBar() {
        scrollView.isUserInteractionEnabled = true
        
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
        
        constrain(_view,_title,line,textView,scrollView){ view,title,line,text,scrollView in
            
            //view constrains
            
            view.right == (view.superview?.right)! - self.view.frame.width/50
            view.left == (view.superview?.left)! + self.view.frame.width/50
            view.top == (view.superview?.top)! + 54
            view.bottom == (view.superview?.bottom)! - 20
            
            
            // scroll view constrains
            
            scrollView.width == view.width
            scrollView.centerX == view.centerX
            scrollView.bottom == view.bottom - self.view.frame.width/41
            scrollView.top == view.top
            
            
            // title constrains
            
            title.width == scrollView.width * 0.95
            title.centerX == scrollView.centerX
            title.top == scrollView.top + self.view.frame.width/35
            
            
            // line constrains
            
            line.width == title.width
            line.height == self.view.frame.width/200
            line.centerX == title.centerX
            line.top == title.bottom + self.view.frame.width/35
            
            // textView constrains
            
            text.width == line.width
            text.top == line.bottom + self.view.frame.width/35
            text.bottom == view.bottom - self.view.frame.width/41
            text.centerX == view.centerX
            
        }
    }
    
    // detect scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.bounds.minY > 0 {
            textView.isScrollEnabled = true
            textView.touchesBegan([], with: UIEvent.init())
            self.scrollView.alwaysBounceVertical = false
        }
        else{
            textView.isScrollEnabled = false
            if scrollView.contentOffset.y < (contentOffset - self.view.frame.height/6) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
