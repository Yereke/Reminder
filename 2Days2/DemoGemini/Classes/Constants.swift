//
//  Constants.swift
//  DemoStory
//
//  Created by MacBook on 29.03.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import UIKit

struct CellIdentifier {
    static let mainCell = "mainCell"
    static let pageCell = "pageCell"
    static let subCell = "subCell"
    static let favouriteCell = "favouriteCell"
}

struct Colors {
    static let colors:[UIColor] = [
            UIColor.white,
            UIColor.white,
            UIColor.white,
            UIColor.white
        ]
}

struct URLs{
    static let url = "http://2days.kz/jsonFormat.php?date_Of_Event="
    static let imageURL = "http://2days.kz/"
}

struct Size {
    static let bounds = UIScreen.main.bounds
    static let width = bounds.width
    static let height = bounds.height
}

struct Titles{
   static let titles = ["Избранные","Вчера","Сегодня","Завтра"]
}
enum Constants {
    static let reuseIdentifier = "cellId"
    static let borderRadius: CGFloat = 12
    static let minItemSpacing: CGFloat = 7
    static let minCellSpacing: CGFloat = 7
    static let countOfColumnsIPhone: CGFloat = 2
    static let countOfColumnsIPad: CGFloat = 3
    static let titleViewPadding: CGFloat = 8
    static var textViewsHeight: [CGFloat] = []
    static var indexForHeights: Int = 0
}

struct Keys {
    static let id = "id"
    static let title = "title"
    static let date = "date"
    static let hashtag = "hashtag"
    static let image = "picture"
    static let eventText = "eventText"
    static let didLoadAllEvents = "didLoadAllEvents"
    static let searchCancel = "Отменить"
    static let searchPlaceholder = "Поиск..."
    static let emptyTableTitle = "Пусто"
    static let emptyTableDescription = "Нажмите два раза, чтобы добавить в Избранное"
    static let hasFavourites = "hasFavourites"
    static var reloadFavourite = false
    static var checkToAdd = true
}

struct Path {
    
    static let event:String = {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Events").path
    }()
    
    static let favourite:String = {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Favourites").path
    }()

}
