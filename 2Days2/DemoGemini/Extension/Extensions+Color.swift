//
//  Extensions.swift
//  Favourite2Day
//
//  Created by NURZHAN on 28.03.2018.
//  Copyright © 2018 NURZHAN. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension UIColor {
    static let modalViewColor = UIColor(red: 251/255, green: 241/255, blue: 241/255, alpha: 1)
}

extension String {
    
    static let removeText = "Remove from Favourites"
    static let cancelText = "Cancel"
    static let titleText = "Favourites"
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func maxHeight(array: [Event], width: CGFloat, font: UIFont) -> CGFloat {
        var maxHei: CGFloat = 0
        for info in array {
            let current = info.title?.height(withConstrainedWidth: width, font: font)
            if current! > maxHei {
                maxHei = current!
            }
        }
        
        return maxHei
    }
}

extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}
