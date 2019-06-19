//
//  Alarm.swift
//  Alarm
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var fireDate: Date
    var name: String
    var isEnabled: Bool = false
    var uuid: String
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "en_US")
            let date = fireDate
            return(dateFormatter.string(from: date))
            
        }
    }
    
    init(fireDate: Date, name: String, isEnabled: Bool, uuid: String = UUID().uuidString) {
        self.name = name
        self.uuid = uuid
        self.fireDate = fireDate
        self.isEnabled = isEnabled
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        if lhs.fireDate == rhs.fireDate
                && lhs.isEnabled == rhs.isEnabled
                && lhs.name == rhs.name
                && lhs.uuid == rhs.uuid {return true}
        else {return false}
    }
    
    
}
