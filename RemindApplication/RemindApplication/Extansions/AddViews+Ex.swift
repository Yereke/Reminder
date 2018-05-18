//
//  AddViews+Ex.swift
//  RemindApplication
//
//  Created by MacBook on 17.05.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addViews(_ views:[UIView]){
        for i in views{
            self.addSubview(i)
        }
    }
    
    func translatesAutoresizingMask(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
