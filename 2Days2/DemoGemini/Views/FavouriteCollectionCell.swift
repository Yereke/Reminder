//
//  FavouriteViewController.swift
//  Favourite2Day
//
//  Created by NURZHAN on 28.03.2018.
//  Copyright © 2018 NURZHAN. All rights reserved.
//

import UIKit
import Cartography
import PeekView
import PinterestLayout
import Gemini
import Kingfisher
import SHSearchBar
import DZNEmptyDataSet

protocol EventDelegate {
    var event: Event { get }
}

class FavouriteCollectionCell: GeminiCell , EventDelegate{
    
    //    MARK: Properties
    private var dataArray: [Event] = []
    
    private var filteredArray: [Event] = []
    
    private var isSeaching: Bool = false
    
    var event:Event = Event.init()
    
    private var deviceType = UIScreen.main.traitCollection.userInterfaceIdiom.rawValue
    
    var DataArray:[Event] {
        get{return self.dataArray}
        set{
            self.dataArray = newValue
            collectionView.reloadData()
        }
    }
    
    private var numberOfColumns: [Int : CGFloat] = [
        0 : Constants.countOfColumnsIPhone,
        1 : Constants.countOfColumnsIPad
    ]
    
    lazy var collectionView: UICollectionView = {
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let layout = PinterestLayout()
        let currentDeviceType = UIScreen.main.traitCollection.userInterfaceIdiom.rawValue
        let countOfColumns = numberOfColumns[currentDeviceType]!
        layout.numberOfColumns = Int(countOfColumns)
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collection.register(PinterestCell.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        
        if let pinterestDelegate = collection.collectionViewLayout as? PinterestLayout {
            pinterestDelegate.delegate = self
            pinterestDelegate.cellPadding = 5
            pinterestDelegate.numberOfColumns = deviceType + 2
        }
        
        collection.dataSource = self
        collection.delegate = self
        
        
        collection.emptyDataSetSource = self
        collection.emptyDataSetDelegate = self
        
        return collection
    }()
    
    lazy var searchView: UIView = {
        let search = UIView()
        return search
    }()
    
    lazy var searchBar: SHSearchBar = {
        let searchBar = SHSearchBar(config: SHSearchBarConfig.init())
        searchBar.backgroundColor = .lightGray
        searchBar.tintColor = .lightGray
        searchBar.updateBackgroundImage(withRadius: 6, corners: [.allCorners], color: UIColor.white)
        searchBar.delegate = self
        searchBar.layer.shadowRadius = Size.width/100
        searchBar.layer.shadowOpacity = 0.7
        searchBar.layer.shadowColor = UIColor.shadow.cgColor
        searchBar.layer.shadowOffset = CGSize.zero
        searchBar.config.useCancelButton = true
        searchBar.config.cancelButtonTitle = Keys.searchCancel
        searchBar.placeholder = Keys.searchPlaceholder
        return searchBar
    }()
    
    let options = [
        PeekViewAction(title: .removeText, style: .destructive),
        PeekViewAction(title: .cancelText, style: .default)
    ]
    
    //    MARK: LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //    MARK: SetupAnyViews
    private func setupViews() {
        
        addSubViews([searchView, collectionView])
        searchView.addSubview(searchBar)
        backgroundColor = .white
        collectionView.backgroundColor = .white
     
    }
    
    //    MARK: Constraints
    private func addConstraints() {
        
        constrain(self, searchView) { v1, v2 in
            v2.width == v1.width
            v2.height == CGFloat(50 + deviceType * 10)
            v2.centerX == v1.centerX
            v2.top == v1.top
        }
        
        constrain(searchView, collectionView) { v1, v2 in
            v2.centerX == v1.centerX
            v2.width == v1.width
            //            v2.height == (v2.superview?.height)! - CGFloat(50 + deviceType * 10)
            v2.bottom == (v2.superview?.bottom)!
            v2.top == v1.bottom
        }
        
        constrain(searchView, searchBar) { v1, v2 in
            v2.width == v1.width * 0.98
            v2.height == v1.height * 0.8
            v2.center == v1.center
        }
        
        collectionView.reloadData()
        
    }
    
    //    MARK: Gesture functions
    @objc private func longPressShowModal(gestureRecognizer: UIGestureRecognizer) {
        
        if let cell = gestureRecognizer.view as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: cell) {
            
            let controller = FavouriteViewController()
            
            event = dataArray[indexPath.row]
            
            if isSeaching {
                event = filteredArray[indexPath.row]
            }
            
            controller.eventDelegate = self
            
            let frame = CGRect(x: 15, y: (bounds.height - bounds.height * 0.7)/2, width: bounds.width - 30, height: bounds.height * 0.7)
            
            PeekView().viewForController(parentViewController: CubeViewController(), contentViewController: controller, expectedContentViewFrame: frame, fromGesture: gestureRecognizer as! UILongPressGestureRecognizer, shouldHideStatusBar: true, menuOptions: options, completionHandler: { optionIndex in
                switch optionIndex {
                case 0:
                    self.dataArray.remove(at: indexPath.row)
                    NSKeyedArchiver.archiveRootObject(self.dataArray, toFile: Path.favourite)
                    self.collectionView.reloadData()
                    break
                default:
                    break
                }
            }, dismissHandler: {
            })
            
        }
        
    }
    
}

//    MARK: Search bar functions

extension FavouriteCollectionCell: SHSearchBarDelegate {
    func searchBarDidBeginEditing(_ searchBar: SHSearchBar) {
        isSeaching = true
    }
    
    func searchBarDidEndEditing(_ searchBar: SHSearchBar) {
        isSeaching = false
    }
    
    func searchBar(_ searchBar: SHSearchBar, textDidChange text: String) {
        let searchedText = searchBar.text!
        filteredArray = dataArray.filter({
            var currentString = $0.eventText?.replace(target: "\n", withString: " ")
            currentString = currentString?.replace(target: "\t", withString: " ")
            currentString = currentString?.replace(target: "\r", withString: " ")
            return (currentString!.lowercased().contains(searchedText))
        })
        
        isSeaching = (filteredArray.count == 0) ? false : true
        Constants.textViewsHeight = []
        Constants.indexForHeights = 0
        collectionView.reloadData()
    }
    
}


//    MARK: Flow layout delegate
extension FavouriteCollectionCell: PinterestLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let currentDeviceType = UIScreen.main.traitCollection.userInterfaceIdiom.rawValue
        let countOfColumns = numberOfColumns[currentDeviceType]!
        return bounds.width / countOfColumns * 9 / 16
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        let currentDeviceType = UIScreen.main.traitCollection.userInterfaceIdiom.rawValue
        let countOfColumns = numberOfColumns[currentDeviceType]!
        let width = bounds.width / countOfColumns
        var textHeight = dataArray[indexPath.row].title?.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: CGFloat(15 + currentDeviceType * 5)))
        if isSeaching {
            textHeight = filteredArray[indexPath.row].title?.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: CGFloat(15 + currentDeviceType * 5)))
        }
        
        
        return textHeight! + Constants.titleViewPadding
    }
    
}

//    MARK: Collection view data source
extension FavouriteCollectionCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSeaching {
            return filteredArray.count
        }
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! PinterestCell
        
        var currentEvent = dataArray[indexPath.row]
        if isSeaching{
            currentEvent = filteredArray[indexPath.row]
        }
        
        let url = URL.init(string: "\(URLs.imageURL)\((currentEvent.image)!)")!
        cell.imageView.kf.setImage(with: url)
        
        var descriptionText = currentEvent.title?.replace(target: "»", withString: "“")
        descriptionText = descriptionText?.replace(target: "«", withString: "„")
        cell.descriptionLabel.text = descriptionText
        
        cell.imageView.layer.cornerRadius = 0
        cell.imageView.layer.masksToBounds = true
        
        let longPressWithEndGestureRecognizer: UILongPressGestureRecognizer = {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressShowModal))
            return gesture
        }()
        
        cell.addGestureRecognizer(longPressWithEndGestureRecognizer)
        cell.backgroundColor = .modalViewColor
        cell.layer.cornerRadius = Constants.borderRadius
        
        let radius: CGFloat = cell.frame.width / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2 * radius, height: cell.frame.height))
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.2, height: 0.4)
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowPath = shadowPath.cgPath
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minItemSpacing + 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) ->CGFloat {
        return Constants.minCellSpacing + 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = UIEdgeInsets(top: Constants.minItemSpacing, left: Constants.minItemSpacing, bottom: Constants.minItemSpacing, right: Constants.minItemSpacing)
        
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = FavouriteFullViewController()
        controller.view.backgroundColor = .white
        
        controller.event = dataArray[indexPath.row]
        let navController = UINavigationController(rootViewController: controller)
        
        (((self.superview as! UICollectionView).delegate) as! CubeViewController).present(navController, animated: true, completion: nil)
        
    }
    
}

extension FavouriteCollectionCell: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                self.searchView.transform = CGAffineTransform(translationX: 0, y: -self.searchView.bounds.height)
                self.collectionView.transform = CGAffineTransform(translationX: 0, y: -self.searchView.bounds.height)
                self.collectionView.frame.size.height = self.frame.height 
                //                self.collectionView.frame.size.height += CGFloat(50 + self.deviceType * 10)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
                
                self.searchView.transform = CGAffineTransform.identity
                self.collectionView.transform = CGAffineTransform.identity
                self.collectionView.frame.size.height = self.frame.height - CGFloat(50 + self.deviceType * 10)
                //                self.collectionView.frame.size.height -= CGFloat(50 + self.deviceType * 10)
                
            }, completion: nil)
        }
    }
    
}

//MARK: Empty set delegate and data source

extension FavouriteCollectionCell: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Keys.emptyTableTitle)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: Keys.emptyTableDescription)
    }
    
}

//    MARK: Text field field
extension FavouriteCollectionCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.textField.resignFirstResponder()
    }
    
    @objc private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
}


extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}




