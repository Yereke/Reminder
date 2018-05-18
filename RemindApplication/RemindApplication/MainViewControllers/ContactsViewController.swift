//
//  ContactsViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography
import Contacts

class ContactsViewController: UIViewController,ContactsDelegate,UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var isMultipleSelect:Bool = false
    
    var ArrayOfContacts: [Contact] = Array()
    
    var filteredContact:[Contact] = Array()
    
    var selectedItems:[Contact] = Array()
    
    var selectImages = [#imageLiteral(resourceName: "notSelected"), #imageLiteral(resourceName: "selectes")]
    
    let defaults = UserDefaults.standard
    
    lazy var tableView:UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = .none
        let color = defaults.string(forKey: "color")
        view.backgroundColor = UIColor(hexString: color!)
        view.register(MyCell.self, forCellReuseIdentifier: "myCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(gesture)
        view.addGestureRecognizer(gestureTap)
        return view
    }()
    
    lazy var buttonToRemind:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.remind, for: .normal)
        button.layer.masksToBounds = false
        button.setImage(#imageLiteral(resourceName: "toRemind"), for: .normal)
        button.addTarget(self, action: #selector(getSelectedRows), for: .touchUpInside)
        return button
    }()
    
    lazy var gesture:UILongPressGestureRecognizer = {
        let tap = UILongPressGestureRecognizer()
        tap.addTarget(self, action: #selector(selectMultipleRow))
        return tap
    }()
    
    lazy var gestureTap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didSelect))
        return tap
    }()
    
    // MARK: - Select and Deaselect Gesture
    @objc func didSelect(_ sender:UITapGestureRecognizer){
        let loc = gestureTap.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: loc)
        
        if let index = indexPath {
            
            let contact = ArrayOfContacts[index.row]
            
            let pressedIndex = selectedItems.index(where: {
                return $0.phoneNumber == contact.phoneNumber
            })
            
            if pressedIndex == nil{
                if isMultipleSelect{
                    selectedItems.append(ArrayOfContacts[index.row])
                    (tableView.visibleCells[(indexPath?.row)!] as! MyCell).deselectImage.image = selectImages[1]
                }else{
                    selectedItems.append(ArrayOfContacts[index.row])
                    sendContactsToRemindVC()
                    isMultipleSelect = false
                }
            }else{
                selectedItems.remove(at: pressedIndex!)
                (tableView.visibleCells[(indexPath?.row)!] as! MyCell).deselectImage.image = selectImages[0]
                if selectedItems.count == 0 {
                    isMultipleSelect = false
                    hideSelectors()
                }
            }
        }
    }
    
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
        searchController.searchBar.placeholder = Constant.searchByName
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    // MARK: - Serach functions
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredContact = ArrayOfContacts.filter({( candy : Contact) -> Bool in
            return (candy.name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Button to remind
    @objc func getSelectedRows(){
        sendContactsToRemindVC()
    }
    
    func sendContactsToRemindVC(){
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! RemindViewController
        vc.delegate = self
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - Select Multiple Rows
    @objc func selectMultipleRow(_ sender:UILongPressGestureRecognizer){
        let loc = gesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: loc)
        if let index = indexPath {
            if !isMultipleSelect{
                for cell in self.tableView.visibleCells {
                    UIView.animate(withDuration: 0.6, animations: {
                        (cell as! MyCell).deselectImage.isHidden = false
                    })
                }
                isMultipleSelect = !isMultipleSelect
                selectedItems.append(ArrayOfContacts[index.row])
                visibleSelectors()
                
                (tableView.visibleCells[(indexPath?.row)!] as! MyCell).deselectImage.image = selectImages[1]
                buttonToRemind.isHidden = false
            }
        }
    }
    
    // MARK: - Hide And Visite Functions
    func hideSelectors(){
        for cell in self.tableView.visibleCells {
            UIView.animate(withDuration: 0.6, animations: {
                (cell as! MyCell).deselectImage.image = self.selectImages[0]
                (cell as! MyCell).deselectImage.center.x = self.view.frame.width + 30
            })
        }
        UIView.animate(withDuration: 0.6, animations: {
            self.buttonToRemind.center.y = self.view.frame.height + 150
        })
        isMultipleSelect = false
        buttonToRemind.isHidden = true
    }
    
    func visibleSelectors(){
        UIView.animate(withDuration: 0.6, animations: {
            for cell in self.tableView.visibleCells {
                (cell as! MyCell).deselectImage.center.x = self.view.bounds.width - 40
                (cell as! MyCell).deselectImage.image = self.selectImages[0]
            }
        })
        UIView.animate(withDuration: 0.6, animations: {
            self.buttonToRemind.center.y = self.view.frame.height - 2*self.buttonToRemind.frame.height
        })
        buttonToRemind.isHidden = false
    }
    
    // MARK: - KeyBoard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.endEditing(true)
    }
    
    // MARK: - Inital Setup
    func setUp(){
        self.view.addSubview(tableView)
        self.tableView.addSubview(buttonToRemind)
    }
    
    // MARK: - Constraints
    func setUpConstrains(){
        constrain(tableView,buttonToRemind){tableView,buttonToRemind in
            tableView.width == tableView.superview!.width
            tableView.height == tableView.superview!.height
            tableView.top == tableView.superview!.top
            tableView.bottom == tableView.superview!.bottom + 68
            
            buttonToRemind.bottom == tableView.superview!.bottom + 100
            buttonToRemind.width == 50
            buttonToRemind.height == 50
            buttonToRemind.centerX == buttonToRemind.superview!.centerX
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Constant.contact
        FetchContacts.share.contacStore.requestAccess(for: .contacts) { (success, error) in
            if success{
                print(Constant.success)
            }
        }
        ArrayOfContacts = FetchContacts.share.fetchContact()
        tableView.reloadData()
        setUpSerachController()
        setUp()
        setUpConstrains()
    }
    
    func settingDef(){
        let color = defaults.string(forKey: "color")
        self.tableView.backgroundColor = UIColor(hexString: color!)
        for cell in tableView.visibleCells{
            (cell as! MyCell).backgroundColor = UIColor(hexString: color!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedItems.removeAll()
        settingDef()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         hideSelectors()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredContact.count
        }
        return ArrayOfContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyCell
        
        let contact: Contact
        if isFiltering() {
            contact = filteredContact[indexPath.row]
        } else {
            contact = ArrayOfContacts[indexPath.row]
        }
        cell.Name.text = contact.name
        cell.Image.image = UIImage(named: contact.image!)
        cell.PhoneNumber.text = contact.phoneNumber
        cell.lastName.text = contact.lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/12
    }
}

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

