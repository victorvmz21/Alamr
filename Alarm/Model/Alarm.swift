//
//  Alarm.swift
//  Alarm
//
//  Created by Victor Monteiro on 6/8/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var name: String
    var fireDate: Date
    var enabled: Bool
    var uuid: String
   
    var fireTimeAsString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: fireDate)
    }
    
    init(name: String, fireDate: Date = Date(), enabled: Bool, uuid: String = UUID().uuidString) {
        self.name = name
        self.fireDate = fireDate
        self.enabled = enabled
        self.uuid = uuid
    }
    
}

extension Alarm: Equatable {
    
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.enabled == rhs.enabled && lhs.name == rhs.name && lhs.fireDate == rhs.fireDate
    }
    
}
