//
//  GetDataEvent.swift
//  DemoGemini
//
//  Created by MacBook on 14.04.2018.
//  Copyright © 2018 MacBook. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class GetDateEvent {

    var events:[Event] = []
    static var shared:GetDateEvent = GetDateEvent()
    
    private init() {}
    
    func requestData(addDay: Int, completion: @escaping () -> ()) {
        let date = getDate(day: addDay)
        let url = URL.init(string: URLs.url + "\(date[1])-\(date[0])&language=ru")!
        Alamofire.request(url).responseJSON{ (response) in
            switch response.result {
            case .success(let responseString):
                let map:[Event] = Mapper<Event>().mapArray(JSONArray: responseString as! [[String : Any]])
                GetDateEvent.shared.events = map
                completion()
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getDate(day:Int) -> [String.SubSequence] {
        let currentDate = Date()
        let nextDate = currentDate.addingTimeInterval(TimeInterval(day))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: nextDate).split(separator: ".")
        return result
    }
}
