//
//  MainCollectionCell.swift
//  DemoStory
//
//  Created by MacBook on 29.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import Gemini
import  SwiftyShadow

class MainCollectionCell:GeminiCell{
    
     // MARK: - Properties
    
    var color: UIColor = UIColor.blue{
        didSet{
            collectionView.reloadData()
            pageCollectionView.backgroundColor = .clear
            backgroundColor = color
        }
    }
    
    var events: [Event] = [Event](){
        didSet{
            self.pageCollectionView.reloadData()
        }
    }
    
    var index = 0
    
    private var filePath:String{
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Favourites").path
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = false
        collection.register(SubCollectionCell.self, forCellWithReuseIdentifier: CellIdentifier.subCell)
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    lazy var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collection = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
        collection.layer.borderWidth = 0
        collection.delegate = self
        collection.dataSource = self
        collection.layer.zPosition = 0
        collection.isScrollEnabled = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.pageCell)
        return collection
    }()
    
    lazy var favouriteAdderPulseStar:UIImageView = {
        let image:UIImageView = UIImageView.init(image: UIImage.init(named: "star"))
        image.clipsToBounds = true
        image.backgroundColor = UIColor.clear
        return image
    }()
    
    
     // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstrains()
        
        favouriteAdderPulseStar.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - Setup View
    
    func setupViews() -> Void {
        addSubview(collectionView)
        addSubview(pageCollectionView)
        addSubview(favouriteAdderPulseStar)
        
        // tap for change events page of day
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tapTap))
        tap1.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap1)
        
        //tap for add events favourites list
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(favouriteAdder))
        tap2.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap2)
        backgroundColor = .clear
    }
    
    // MARK: - Constrains
    
    func setupConstrains() -> Void {
        constrain(pageCollectionView,collectionView,favouriteAdderPulseStar){ pageCollectionView,collectionView,pulseStar in
            
            // page control constrains
            
            pageCollectionView.width == self.frame.width  * 0.95
            pageCollectionView.height == 20
            pageCollectionView.centerX == (pageCollectionView.superview?.centerX)!
            pageCollectionView.top == (pageCollectionView.superview?.top)!
            
            // events day constrains
            
            collectionView.width == self.frame.width
            collectionView.centerX == pageCollectionView.centerX
            collectionView.bottom == (collectionView.superview?.bottom)!
            collectionView.top == pageCollectionView.bottom
            
            // star pulse animation constrains
            
            pulseStar.centerY == collectionView.top + self.frame.width * 0.6/2
            pulseStar.centerX == collectionView.centerX
            pulseStar.width == self.frame.width/7
            pulseStar.height == pulseStar.width
            
        }
    }
    
    //tap tap action function for change page
    @objc func tapTap(tap: UITapGestureRecognizer) -> Void {
        
        let x = tap.location(in: self).x
        if(x > self.frame.width * 0.8){
            index += 1
            if index == events.count{
                index = 0
            }
        }
        else if(x < self.frame.width * 0.2){
            index -= 1
            if index == -1 {
                 index = events.count - 1
            }
        }
        collectionView.scrollToItem(at: IndexPath.init(row: index, section: 0), at: .centeredHorizontally, animated: true)
        pageCollectionView.reloadData()
        
    }
    
    @objc func favouriteAdder(tap: UITapGestureRecognizer) -> Void{
        
        let location = tap.location(in: self)
        
        let x = location.x
        
        // add in favourites list only user tapped center of view
        
        if x > self.frame.width * 0.2 && x < self.frame.width * 0.8 {
            
            // star pulse animation
            
            animateStarPulse()
            
            // check to exist event in favourites list
            
            var favourites:[Event] = (NSKeyedUnarchiver.unarchiveObject(withFile:Path.favourite) as? [Event])!
            
            for i in favourites {if i.eventText == events[index].eventText {Keys.checkToAdd = false;break}}
            
            if Keys.checkToAdd {
                favourites.append(events[index])
                Keys.reloadFavourite = true
                NSKeyedArchiver.archiveRootObject(favourites, toFile: Path.favourite)
            }
            
            Keys.checkToAdd = true
        }
    }
    
    func animateStarPulse() -> Void {
        UIView.animate(withDuration: 0.2, animations: {
            self.favouriteAdderPulseStar.transform = CGAffineTransform.identity
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.favouriteAdderPulseStar.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.favouriteAdderPulseStar.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.favouriteAdderPulseStar.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
                    })
                })
            })
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MainCollectionCell: UICollectionViewDelegate,UICollectionViewDataSource{
    //Number of section in collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Number of items in collections
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    //For cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            //For events of day
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.subCell, for: indexPath) as? SubCollectionCell
            cell?.tag = indexPath.row
            cell?.event = events[indexPath.row]
            cell?.color = color
            cell?.backgroundColor = .clear
            return cell!
        }
        else{
            // For top page control
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.pageCell, for: indexPath)
            cell.center.y = pageCollectionView.center.y
            cell.layer.cornerRadius = 2.5
            cell.backgroundColor = UIColor.lightGray
            if indexPath.row == index{cell.backgroundColor = UIColor.black}
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainCollectionCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    //Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            return CGSize.init(width: Size.width, height: collectionView.frame.height)
        }
        else{
            let count = events.count
            
            if count == 1 {
                return CGSize.init(width: 0, height: 0)
            }
            
            return CGSize.init(width: (collectionView.bounds.width - CGFloat(6*(count - 1)))/CGFloat(count), height: self.frame.width * 0.007)
        }
    }
}
