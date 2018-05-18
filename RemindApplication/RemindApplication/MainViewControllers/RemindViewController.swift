//
//  RemindViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography
import ALTextInputBar
import UserNotifications
import FirebaseAuth
import Firebase
import FirebaseDatabase
import NVActivityIndicatorView

class RemindViewController: UIViewController,AddressDelegate,UISearchControllerDelegate {
    
    // MARK: - Properties
    
    var Reminds:[TodoItem] = Array()
    var filteredContact:[TodoItem] = Array()
        
    private var dbRef: DatabaseReference?
        
    var delegate:ContactsDelegate?
    var arrayToRemindPeopls:[Contact] = Array()
    
    var address: String = Constant.address
    
    let defaults = UserDefaults.standard
    
    lazy var animated:NVActivityIndicatorView = {
        let animated = NVActivityIndicatorView(frame: .init(x: self.view.frame.width/2 - self.view.frame.width/16, y: self.view.frame.height/1.7 - self.view.frame.width/6, width: self.view.frame.width/6, height: self.view.frame.width/6), type: .ballTrianglePath, color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), padding: 0)
        return animated
    }()
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        let color = defaults.string(forKey: "color")
        table.backgroundColor = UIColor(hexString: color!)
        table.separatorStyle = .none
        table.register(CellForRemindeds.self, forCellReuseIdentifier: "myCell")
        table.translatesAutoresizingMask()
        return table
    }()
    
    lazy var blurView:UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    lazy var datePicker:UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.setValue(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forKeyPath: "textColor")
        picker.addTarget(self, action: #selector(getTime), for: .valueChanged)
        picker.alpha = 0
        return picker
    }()
    
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
        picker.addGestureRecognizer(gestureSwip)
        return picker
    }()
    
    lazy var dateGlobalView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(gestureSwip)
        return view
    }()
    
    lazy var mapGlobalView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(gestureSwip)
        return view
    }()
    
    lazy var textInputBar:ALTextInputBar = {
        let view = ALTextInputBar()
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        view.layer.sublayerTransform = CATransform3DMakeTranslation(-10, 2, 0)
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(gestureSwip)
        return view
    }()
    
    lazy var remindButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        button.titleLabel?.font = FontBook.Regular.of(size: self.view.frame.height/35)
        button.setTitle("Remind", for: .normal)
        button.addTarget(self, action: #selector(remindButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(gestureSwip)
        return button
    }()
    
    lazy var dateButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        button.titleLabel?.font = FontBook.Regular.of(size: self.view.frame.height/43)
        button.setTitle("Date", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addBorders(edges: .right,color: #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1),thickness: 1)
        button.addTarget(self, action: #selector(pickDateButton), for: .touchUpInside)
        return button
    }()
    
    lazy var timeButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.titleLabel?.font = FontBook.Regular.of(size: self.view.frame.height/43)
        button.setTitle("Time", for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickDateButton), for: .touchUpInside)
        return button
    }()
    
    lazy var MapButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9732731439, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), for: .normal)
        button.titleLabel?.font = FontBook.Regular.of(size: self.view.frame.height/43)
        button.setTitle(Constant.address, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pickMapButton), for: .touchUpInside)
        return button
    }()
    
    lazy var gestureSwip:UISwipeGestureRecognizer = {
        let tap = UISwipeGestureRecognizer()
        tap.addTarget(self, action: #selector(cancleRemind))
        tap.direction = .down
        return tap
    }()
    
    // MARK: - Serach Controller
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Set up serachController
    func setUpSerachController(){
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by date"
        searchController.hidesNavigationBarDuringPresentation = false;
        self.definesPresentationContext = false
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Serach functions
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredContact = Reminds.filter({( candy : TodoItem) -> Bool in
            return (candy.name.lowercased().contains(searchText.lowercased()))
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func settingDef(){
        let color = defaults.string(forKey: "color")
        self.tableView.backgroundColor = UIColor(hexString: color!)
        for cell in tableView.visibleCells{
            (cell as! CellForRemindeds).backgroundColor = UIColor(hexString: color!)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constant.remind
        setUp()
        setUpConstrains()
        setUpSerachController()
        accessFromDB()
        setKeyBoard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAddres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        catchSelectedContacts()
        settingDef()
    }
    
    // MARK: - Inital Setup
    func setUp(){
        self.view.addViews([tableView,blurView])
        self.tableView.addSubview(animated)
        self.blurView.contentView.addViews([globalView,datePicker])
        self.globalView.addViews([dateGlobalView,mapGlobalView,textInputBar,remindButton])
        self.dateGlobalView.addViews([dateButton,timeButton])
        self.mapGlobalView.addSubview(MapButton)
    }
    
    // MARK: - Constraints
    func setUpConstrains(){
        constrain(datePicker,globalView,dateGlobalView,mapGlobalView,textInputBar,remindButton){datePicker,globalView,dateGlobalView,mapGlobalView,noteGlobalView,remindButton in
            globalView.centerX == globalView.superview!.centerX
            globalView.centerY == globalView.superview!.centerY
            globalView.width == globalView.superview!.width - self.view.frame.width/20
            globalView.height == globalView.superview!.height/2.8
            
            datePicker.top == globalView.bottom + 5
            datePicker.bottom == datePicker.superview!.bottom
            datePicker.centerX == datePicker.superview!.centerX
            
            dateGlobalView.top == dateGlobalView.superview!.top + 10
            dateGlobalView.centerX == globalView.centerX
            dateGlobalView.width == dateGlobalView.superview!.width - 18
            dateGlobalView.height == dateGlobalView.superview!.height/5.2
            
            mapGlobalView.top ==  dateGlobalView.bottom + 8
            mapGlobalView.centerX == dateGlobalView.centerX
            mapGlobalView.width == dateGlobalView.width
            mapGlobalView.height == dateGlobalView.height
            
            noteGlobalView.top ==  mapGlobalView.bottom + 8
            noteGlobalView.centerX == mapGlobalView.centerX
            noteGlobalView.width == mapGlobalView.width
            noteGlobalView.height == mapGlobalView.height
            
            remindButton.bottom ==  remindButton.superview!.bottom - self.view.frame.height*0.008
            remindButton.centerX == noteGlobalView.centerX
            remindButton.width == noteGlobalView.width
            remindButton.height == noteGlobalView.height
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
        constrain(tableView){tableView in
            tableView.width == tableView.superview!.width
            tableView.height == tableView.superview!.height
            tableView.top == tableView.superview!.top
            tableView.bottom == tableView.superview!.bottom
        }
    }
    
    // MARK: - Get Time
    @objc func getTime(_ sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        let theDateFormat = DateFormatter.Style.full
        let theTimeFormat = DateFormatter.Style.short
        
        dateFormatter.dateStyle = theDateFormat
        timeFormatter.timeStyle = theTimeFormat
        
        let dateFormat = dateFormatter.string(from: sender.date);
        let timeFormat = timeFormatter.string(from: sender.date);
        
        dateButton.setTitle("\(dateFormat)", for: .normal)
        timeButton.setTitle("\(timeFormat)", for: .normal)
    }
    
    // MARK: - Press Date and Time
    @objc func pickDateButton(){
        UIView.animate(withDuration: 0.3) {
            self.datePicker.alpha = 1
        }
    }
    
    func hidePickerDate(){
        UIView.animate(withDuration: 0.3) {
            self.datePicker.alpha = 0
        }
    }
    
    // MARK: - Press Address
    @objc func pickMapButton(){
        let vc = MapViewController()
        vc.address = self
        self.show(vc, sender: self)
    }
    
    // MARK: - Catch selected contacts
    func catchSelectedContacts(){
        if let array = delegate?.selectedItems{
            if array.count > 0{
                arrayToRemindPeopls = array
                globalView.alpha = 1
                blurView.alpha = 1
                globalView.center.y = self.view.frame.height/2
            }else{
                globalView.alpha = 0
                blurView.alpha = 0
            }
        }else{
            globalView.alpha = 0
            blurView.alpha = 0
        }
    }
    
    func getAddres(){
        MapButton.setTitle(address, for: .normal)
    }
    
    //MARK: Remind Button
    @objc func remindButtonAction(){
        getAddres()
        dbRef = Database.database().reference()
        let defaults = UserDefaults.standard
        let phoneNumber = defaults.string(forKey: "phoneNumberUser")
        for i in arrayToRemindPeopls{
            let todoItem = TodoItem(String(describing: datePicker.date.timeIntervalSince1970), phoneNumber!, textInputBar.text!, MapButton.currentTitle!, NSUUID().uuidString,i.phoneNumber!)
            dbRef?.child("reminds").childByAutoId().setValue(todoItem.toJSONFormat())
        }
        datePicker.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.globalView.alpha = 0
            self.blurView.alpha = 0
        }
        self.tableView.reloadData()
    }
    //MARK: Get information from db
    func accessFromDB(){
        UIApplication.shared.cancelAllLocalNotifications()
        animated.startAnimating()
        dbRef = Database.database().reference()
        dbRef?.child("reminds").observe(DataEventType.value, with: { (snapshot) in
            self.Reminds.removeAll()
            let defaults = UserDefaults.standard
            let phoneNumber = defaults.string(forKey: "phoneNumberUser")
            for snap in snapshot.children{
                let remind = TodoItem.init(snapshot: snap as! DataSnapshot)
                let phone = remind.phoneNumber.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
                if phone == phoneNumber{
                    let current = Date()
                    let date = Date.init(timeIntervalSince1970: TimeInterval(Double(remind.deadline)!))
                    self.Reminds.append(remind)
                    if (date.compare(current) == .orderedDescending){
                        TodoList.sharedInstance.add(remind)
                    }
                }
            }
            self.Reminds.reverse()
            self.animated.stopAnimating()
            self.tableView.reloadData()
        })
    }
    
    //MARK: Set up keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hidePickerDate()
        self.view.endEditing(true)
    }
    
    //User notification
    func userNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert , .badge , .sound]) { (success, error) in
            if error != nil{
                print("error")
            }else{
                print(Constant.success)
            }
        }
    }
    
    func timeNotification(isSecond : Date,completion: @escaping ( _ Success:Bool) -> ()){
        let content = UNMutableNotificationContent()
        content.title = "!Dont Forget!"
        content.body = "newString"
        content.sound = UNNotificationSound.init(named: "aaa.caf")
        
        content.categoryIdentifier = "newCuddlePixCategoryName"
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: isSecond)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute! + 2)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "randomImageName", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler:
            { (error) in
                if let error = error {
                    print(error)
                    completion(false)
                } else {
                    completion(true)
                }
            })
    }
    
    @objc func cancleRemind(_ sender:UISwipeGestureRecognizer){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            print(sender.accessibilityFrame)
            self.globalView.center.y = 2*self.view.frame.height
            self.datePicker.alpha = 0
            self.globalView.alpha = 0
            self.blurView.alpha = 0
        }, completion: nil)
    }
    
    @objc func toMapVc(_ sender:UIButton){
        let vc = MapViewController()
        address = sender.currentTitle!
        vc.address = self
        vc.fromRemindaddress = address
        self.show(vc, sender: self)
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
}

extension RemindViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContact.count
        }
        return Reminds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CellForRemindeds
        
        let array: TodoItem
        if isFiltering() {
            array = filteredContact[indexPath.row]
        } else {
            array = Reminds[indexPath.row]
        }
        let date = Date.init(timeIntervalSince1970: TimeInterval(Double(array.deadline)!))
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        let theDateFormat = DateFormatter.Style.full
        let theTimeFormat = DateFormatter.Style.short
        
        dateFormatter.dateStyle = theDateFormat
        timeFormatter.timeStyle = theTimeFormat
        
        let dateFormat = dateFormatter.string(from: date);
        let timeFormat = timeFormatter.string(from: date);
        
        cell.dateButton.setTitle(dateFormat, for: .normal)
        cell.timeButton.setTitle(timeFormat, for: .normal)
        cell.MapButton.setTitle(array.map, for: .normal)
        cell.MapButton.addTarget(self, action: #selector(toMapVc), for: .touchUpInside)
        cell.textInputBar.text = array.remind
        cell.Name.text = array.name
        if (Date().compare(date) == .orderedDescending){
            cell.timeIsOn.image = #imageLiteral(resourceName: "timer-off")
        }else{
            cell.timeIsOn.image = #imageLiteral(resourceName: "time-on")
        }
        return cell
    }
}
extension RemindViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

