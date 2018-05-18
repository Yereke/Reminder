//
//  
//  Gemini
//
//  Created MackBook on 2017/06/19.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Gemini
import Alamofire
import NVActivityIndicatorView

class CubeViewController: UIViewController {
    
    // MARK: - Properties

    lazy var events:[[Event]] = [[],[],[]]
    
    lazy var indicator:NVActivityIndicatorView = {
        let bounds = CGRect.init(x: Size.width/2 - Size.width/17, y: Size.height/2 + Size.width/17 , width: Size.width/8.5 , height: Size.width/8.5 )
        let indicator = NVActivityIndicatorView.init(frame: bounds, type: .pacman , color: UIColor.red, padding: 5)
        indicator.center = self.view.center
        indicator.type = .ballZigZag
        indicator.color = UIColor.cyan
        return indicator
    }()
    
    // MARK: - Cube transmitter
    @IBOutlet weak var collectionView: GeminiCollectionView!{
        didSet {
            collectionView.register(MainCollectionCell.self, forCellWithReuseIdentifier: CellIdentifier.mainCell)
            collectionView.register(FavouriteCollectionCell.self, forCellWithReuseIdentifier: CellIdentifier.favouriteCell)
            collectionView.delegate   = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.gemini
                .cubeAnimation()
                .shadowEffect(.fadeIn)
                .cubeDegree(90)
            collectionView.backgroundColor =  UIColor.white
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        loadDataFromMemoryOrJSON()
    }
    
    // MARK: - 
    private func loadDataFromMemoryOrJSON() -> Void {
        if !UserDefaults.standard.bool(forKey: Keys.didLoadAllEvents) {
            fetchRequestAllDays()
            UserDefaults.standard.set(true, forKey: Keys.didLoadAllEvents)
        }
        else{
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: Path.event) as! [[Event]]
            let tomorrow = data[2][0].date!.split(separator: "-")[2]
            let today = getDate(day: 0)[0]
            if(tomorrow == today){
                fetchRequestAllDays()
            }
            else{
                events = getData()
            } 
        }
    }
    // Get events for three days
    private func fetchRequestAllDays() -> Void {
        indicator.startAnimating()
        GetDateEvent.shared.requestData(addDay: -3600 * 24 * 1) {
            self.setupEvents()
            GetDateEvent.shared.requestData(addDay: 0, completion: {
                self.setupEvents()
                GetDateEvent.shared.requestData(addDay: 3600 * 24 * 1, completion: {
                    self.setupEvents()
                    self.events = self.events.filter({$0 != []})
                    self.collectionView.reloadData()
                    self.saveData()
                    self.indicator.stopAnimating()
                })
            })
        }
    }

    // Get events for one day
    private func fetchRequestOnlyOneDay() -> Void {
        indicator.startAnimating()
        GetDateEvent.shared.requestData(addDay: 3600 * 24 * 1, completion: {
            self.setupEvents()
            self.events = self.getData()
            self.events.removeFirst()
            self.events.append(GetDateEvent.shared.events)
            self.saveData()
            self.collectionView.reloadData()
            self.indicator.stopAnimating()
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupNavigationBar() -> Void {
        title = Titles.titles[2]
        navigationController?.navigationBar.barTintColor = Colors.colors[2]
    }
    
    private func setupViews(){
        self.view.addSubview(indicator)
        
        if !UserDefaults.standard.bool(forKey: Keys.hasFavourites) {
            NSKeyedArchiver.archiveRootObject([], toFile: Path.favourite)
            UserDefaults.standard.set(true, forKey: Keys.hasFavourites)
        }

    }
    
    private func setupEvents(){
        events.append(GetDateEvent.shared.events)
    }
    
    private func saveData() -> Void {
        NSKeyedArchiver.archiveRootObject(events, toFile: Path.event)
    }
    
    private func getData() -> [[Event]] {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: Path.event) as? [[Event]] {
            return data
        }
        return events
    }
    
    func getDate(day:Int) -> [String.SubSequence] {
        let currentDate = Date()
        let nextDate = currentDate.addingTimeInterval(TimeInterval(day))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: nextDate).split(separator: ".")
        return result
    }

    
    // MARK: - Path to Controller
    
    static func make(scrollDirection: UICollectionViewScrollDirection) -> CubeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CubeViewController") as! CubeViewController
        return viewController
    }
    
    
     // Scroll automatically when collection cell will display
    var onceOnly = true
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if onceOnly {
            let indexToScrollTo = IndexPath(row: 2, section: 0)
            collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            onceOnly = false
        }
    }
    
    
}

// MARK: - UIScrollViewDelegate
extension CubeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        title = Titles.titles[Int(targetContentOffset.pointee.x/Size.width)]
        navigationController?.navigationBar.barTintColor = Colors.colors[Int(targetContentOffset.pointee.x/Size.width)]
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if Keys.reloadFavourite == true {
            collectionView.reloadItems(at: [IndexPath.init(row: 0, section: 0)])
            Keys.reloadFavourite = false
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension CubeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.favouriteCell, for: indexPath) as! FavouriteCollectionCell
            cell.DataArray = NSKeyedUnarchiver.unarchiveObject(withFile: Path.favourite) as! [Event]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.mainCell, for: indexPath) as! MainCollectionCell
            cell.events = events[indexPath.row - 1]
            cell.color = Colors.colors[indexPath.row]
            cell.backgroundColor = .clear
            return cell
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CubeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
