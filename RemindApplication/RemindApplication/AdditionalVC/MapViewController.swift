//
//  MapViewController.swift
//  RemindApplication
//
//  Created by MacBook on 05.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import UIKit
import MapKit
import Cartography

protocol AddressDelegate {
    var address:String{get set}
}

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    var address:AddressDelegate?
    
    var fromRemindaddress:String?
    
    var geocoder:CLGeocoder!
    
    lazy var mapView:MKMapView = {
        let map = MKMapView()
        map.mapType = .hybrid
        return map
    }()
    
    lazy var textFiledToFindStreet:UITextField = {
        let text = UITextField()
        text.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        text.translatesAutoresizingMask()
        text.layer.cornerRadius = 8
        text.layer.sublayerTransform = CATransform3DMakeTranslation(10, 2, 0)
        text.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return text
    }()
    
    lazy var bacgroundViewToTextView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMask()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    lazy var saveAddress:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMask()
        button.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(saveAddressButton), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Map"
        geocoder = CLGeocoder()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        initalsetUp()
        setUpConstrains()
        setKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromRemindMap()
    }
    
    func fromRemindMap(){
        if fromRemindaddress != nil{
            saveAddress.isHidden = true
            textFiledToFindStreet.text = fromRemindaddress
            geocoder.geocodeAddressString(fromRemindaddress!) { (placemarks, error) in
                if error != nil{
                    print("\(error.debugDescription)")
                }
                if placemarks != nil{
                    if let placemark = placemarks?.first{
                        let annotetion = MKPointAnnotation()
                        annotetion.title = self.fromRemindaddress
                        annotetion.subtitle = self.fromRemindaddress
                        annotetion.coordinate = placemark.location!.coordinate
                        self.mapView.showAnnotations([annotetion], animated: true)
                        self.mapView.selectAnnotation(annotetion,animated: true)
                    }
                }
            }
        }else{
            saveAddress.isHidden = false
        }
    }
    
    // MARK: - Inital Setup
    func initalsetUp(){
        self.view.addViews([mapView,bacgroundViewToTextView,saveAddress])
        self.bacgroundViewToTextView.addSubview(textFiledToFindStreet)
    }
    
    // MARK: - Constraints
    func setUpConstrains(){
        constrain(textFiledToFindStreet,mapView,bacgroundViewToTextView,saveAddress){textFiledToFindStreet,mapView,bacgroundViewToTextView,saveAddress in
            bacgroundViewToTextView.top == bacgroundViewToTextView.superview!.top + (self.navigationController?.navigationBar.frame.height)! + 20
            bacgroundViewToTextView.width == bacgroundViewToTextView.superview!.width
            bacgroundViewToTextView.height == bacgroundViewToTextView.superview!.width/7
            
            textFiledToFindStreet.centerX == textFiledToFindStreet.superview!.centerX
            textFiledToFindStreet.centerY == textFiledToFindStreet.superview!.centerY
            textFiledToFindStreet.width == textFiledToFindStreet.superview!.width - 20
            textFiledToFindStreet.height == bacgroundViewToTextView.height * 0.6
            
            mapView.top == bacgroundViewToTextView.bottom
            mapView.height == mapView.superview!.height - 68
            mapView.width == mapView.superview!.width
            
            saveAddress.width == saveAddress.superview!.width/6
            saveAddress.height == saveAddress.superview!.width/6
            saveAddress.centerX == saveAddress.superview!.centerX
            saveAddress.bottom == saveAddress.superview!.bottom - 55
        }
    }
    
    // MARK: - Search Address
    @objc func textDidChange(){
        geocoder.geocodeAddressString(textFiledToFindStreet.text!) { (placemarks, error) in
            if error != nil{
                print("\(error.debugDescription)")
            }
            if placemarks != nil{
                if let placemark = placemarks?.first{
                    let annotetion = MKPointAnnotation()
                    annotetion.title = self.textFiledToFindStreet.text!
                    annotetion.subtitle = self.textFiledToFindStreet.text!
                    annotetion.coordinate = placemark.location!.coordinate
                    self.mapView.showAnnotations([annotetion], animated: true)
                    self.mapView.selectAnnotation(annotetion,animated: true)
                }
            }
        }
        address?.address = textFiledToFindStreet.text!
    }
    
    // MARK: - Keyboard
    func setKeyBoard(){
        NotificationCenter.default.addObserver(self, selector: #selector(topDown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downTop), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func topDown(){
        UIView.animate(withDuration: 0.6, animations: {
            self.mapView.frame.size.height = self.view.frame.height/2
        })
    }
    
    @objc func downTop(){
        self.mapView.frame.size.height = self.view.frame.height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Search Address
    @objc func saveAddressButton(){
        navigationController?.popViewController(animated: true)
    }
}
