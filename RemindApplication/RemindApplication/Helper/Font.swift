//
//  Font.swift
//  RemindApplication
//
//  Created by MacBook on 04.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import UIKit

enum FontBook: String {
    case Regular = "Helvetica"
    case HeavyItalic = "AvenirNext-HeavyItalic"
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
