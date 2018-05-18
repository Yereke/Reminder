//
//  SettingViewController.swift
//  RemindAPP
//
//  Created by MacBook on 20.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import Cartography

class SettingViewController: UIViewController {

    // MARK: - Properties
    
    let defaults = UserDefaults.standard
    
    var isClickB:Bool = false
    var isClickL:Bool = false
    var isClickM:Bool = false
    
    lazy var  tableview:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(SettingCell.self, forCellReuseIdentifier: "myCell")
        table.separatorStyle = .none
        let color = defaults.string(forKey: "color")
        table.backgroundColor = UIColor(hexString: color!)
        return table
    }()
    
    lazy var whiteColor:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.alpha = 0
        button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        button.addTarget(self, action: #selector(white), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var blueColor:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.9529411765, blue: 0.9725490196, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        button.alpha = 0
        button.addTarget(self, action: #selector(blue), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var greenColor:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9764705882, blue: 0, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.alpha = 0
        button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        button.addTarget(self, action: #selector(green), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var redColor:UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.alpha = 0
        button.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        button.addTarget(self, action: #selector(red), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var aaa:UIButton = {
        let button = UIButton()
        button.setTitle("Bomba", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.alpha = 0
        button.addTarget(self, action: #selector(changeAAA), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bbb:UIButton = {
        let button = UIButton()
        button.setTitle("Lazy", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.layer.masksToBounds = true
        button.alpha = 0
        button.addTarget(self, action: #selector(changeBBB), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var ccc:UIButton = {
        let button = UIButton()
        button.setTitle("Happy", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.alpha = 0
        button.addTarget(self, action: #selector(changeCCC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func changeAAA(){
        defaults.removeObject(forKey: "music")
        defaults.set("aaa.wav", forKey: "music")
        self.viewDidLoad()
    }
    
    @objc func changeBBB(){
        defaults.removeObject(forKey: "music")
        defaults.set("bbb.wav", forKey: "music")
        self.viewDidLoad()
    }
    
    @objc func changeCCC(){
        defaults.removeObject(forKey: "music")
        defaults.set("ccc.wav", forKey: "music")
        self.viewDidLoad()
    }
    
    @objc func white(){
        defaults.removeObject(forKey: "color")
        defaults.set("#FFFFFF", forKey: "color")
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        for cell in tableview.visibleCells{
             (cell as! SettingCell).globalView.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.9529411765, blue: 0.9725490196, alpha: 1)
             (cell as! SettingCell).globalView1.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    @objc func blue(){
        defaults.removeObject(forKey: "color")
        defaults.set("#D7F3F8", forKey: "color")
        self.view.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.9529411765, blue: 0.9725490196, alpha: 1)
        for cell in tableview.visibleCells{
            (cell as! SettingCell).globalView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            (cell as! SettingCell).globalView1.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.9529411765, blue: 0.9725490196, alpha: 1)
        }
    }
    
    @objc func green(){
        defaults.removeObject(forKey: "color")
        defaults.set("#00F900", forKey: "color")
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.9764705882, blue: 0, alpha: 1)
        for cell in tableview.visibleCells{
            (cell as! SettingCell).globalView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            (cell as! SettingCell).globalView1.backgroundColor = #colorLiteral(red: 0, green: 0.9764705882, blue: 0, alpha: 1)
        }
    }
    
    @objc func red(){
        defaults.removeObject(forKey: "color")
        defaults.set("#CE0755", forKey: "color")
        self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        for cell in tableview.visibleCells{
            (cell as! SettingCell).globalView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            (cell as! SettingCell).globalView1.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
    }
    
    @objc func kzL(){
        defaults.removeObject(forKey: "language")
        defaults.set("kz", forKey: "language")
    }
    
    @objc func ruL(){
        defaults.removeObject(forKey: "language")
        defaults.set("ru", forKey: "language")
    }
    
    @objc func enL(){
        defaults.removeObject(forKey: "language")
        defaults.set("en", forKey: "language")
    }
    
    func backgroundColors(){
        isClickB = !isClickB
        if isClickB{
            viewB()
            hideM()
        }else{
            hideM()
            hideB()
        }
    }
    
    func Language(){
        isClickL = !isClickL
        if isClickL{
            hideM()
            hideB()
        }else{
            hideM()
            hideB()
        }
    }
    
    func Music(){
        isClickM = !isClickM
        if isClickM{
            viewM()
            hideB()
        }else{
            hideM()
            hideB()
        }
    }
    
    func hideB(){
        UIView.animate(withDuration: 0.7) {
            self.whiteColor.alpha = 0
        }
        UIView.animate(withDuration: 0.5) {
            self.blueColor.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.greenColor.alpha = 0
        }
        UIView.animate(withDuration: 0.1) {
            self.redColor.alpha = 0
        }
    }
    func viewB(){
        UIView.animate(withDuration: 0.1) {
            self.whiteColor.alpha = 1
        }
        UIView.animate(withDuration: 0.3) {
            self.blueColor.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            self.greenColor.alpha = 1
        }
        UIView.animate(withDuration: 0.7) {
            self.redColor.alpha = 1
        }
    }
    
    func viewM(){
        UIView.animate(withDuration: 0.1) {
            self.aaa.alpha = 1
        }
        UIView.animate(withDuration: 0.3) {
            self.bbb.alpha = 1
        }
        UIView.animate(withDuration: 0.5) {
            self.ccc.alpha = 1
        }
    }
    func hideM(){
        UIView.animate(withDuration: 0.5) {
            self.aaa.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.bbb.alpha = 0
        }
        UIView.animate(withDuration: 0.1) {
            self.ccc.alpha = 0
        }
    }
    
    // MARK: - Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Setting"
        setUpInital()
        setUpConstrains()
    }
    
    // MARK: - Inital Set up
    func setUpInital(){
        self.view.addViews([tableview,whiteColor,blueColor,greenColor,redColor,aaa,bbb,ccc])
    }
    
    // MARK: - Constrains
    func setUpConstrains(){
        constrain(tableview){ table in
            table.width == (table.superview?.width)!
            table.height == 2*self.view.frame.height/11
            table.top == table.superview!.top + 68
        }
        constrain(tableview,whiteColor,blueColor,greenColor,redColor){tableview,whiteColor,blueColor,greenColor,redColor in
            whiteColor.top == tableview.bottom + 20
            whiteColor.leading == whiteColor.superview!.leading + self.view.frame.width/45
            whiteColor.width == self.view.frame.width/4.5
            whiteColor.height == self.view.frame.width/4.5
            
            blueColor.top == whiteColor.top
            blueColor.leading == whiteColor.trailing + self.view.frame.width/45
            blueColor.width == whiteColor.width
            blueColor.height == whiteColor.height
            
            greenColor.top == whiteColor.top
            greenColor.leading == blueColor.trailing + self.view.frame.width/45
            greenColor.width == whiteColor.width
            greenColor.height == whiteColor.height
            
            redColor.top == whiteColor.top
            redColor.leading == greenColor.trailing + self.view.frame.width/45
            redColor.width == whiteColor.width
            redColor.height == whiteColor.height
        }
        
        constrain(tableview,aaa,bbb,ccc){tableview,aaa,bbb,ccc in
            aaa.top == tableview.bottom + 20
            aaa.leading == aaa.superview!.leading + self.view.frame.width/20
            aaa.width == self.view.frame.width/4.5
            aaa.height == self.view.frame.width/4.5
            
            bbb.top == aaa.top
            bbb.centerX == bbb.superview!.centerX
            bbb.width == aaa.width
            bbb.height == aaa.height
            
            ccc.top == bbb.top
            ccc.trailing == ccc.superview!.trailing - self.view.frame.width/20
            ccc.width == bbb.width
            ccc.height == bbb.height
        }
    }
}

extension SettingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! SettingCell
        let images:[UIImage] = [#imageLiteral(resourceName: "background"),#imageLiteral(resourceName: "music")]
        let titles:[String] = ["Background","Music"]
        cell.titleLabel.text = titles[indexPath.row]
        cell.foodImageView.image = images[indexPath.row]
        let color = defaults.string(forKey: "color")
        cell.globalView1.backgroundColor = UIColor(hexString: color!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            backgroundColors()
        }else{
             Music()
        }
    }
}
