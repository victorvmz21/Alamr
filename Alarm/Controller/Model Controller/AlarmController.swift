//
//  AlarmController.swift
//  Alarm
//
//  Created by Victor Monteiro on 6/8/20.
//  Copyright © 2020 Atomuz. All rights reserved.
//

import UIKit
protocol AlarmScheduler: AnyObject {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController: AlarmScheduler {
    
    //MARK: Singleton
    static var shared = AlarmController()
    
    //MARK: - Source of Thuth
    var alarms: [Alarm] = []
    
//    var mockAlarms: [Alarm] = {
//        let alarmOne = Alarm(name: "Alarm 01", enabled: true)
//        let alarmTwo = Alarm(name: "Alarm 02", enabled: true)
//        let alarmThree = Alarm(name: "Alarm 03", enabled: true)
//        return [alarmOne,alarmTwo,alarmThree]
//    }()
    
    
    weak var delegate: AlarmScheduler?
    
     func toggleIsEnabled(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        if alarm.enabled {
            delegate?.scheduleUserNotifications(for: alarm)
        } else {
            delegate?.cancelUserNotifications(for: alarm)
        }
    }
    //MARK: - CRUD Methods
    
    //CREATE
    func addAlarm(fireDate: Date, name: String, enable: Bool) {
        let newAlarm = Alarm(name: name, fireDate: fireDate, enabled: enable)
        alarms.append(newAlarm)
        savePersistence()
    }
    
    //DELETE
    func removeAlarm(alarm: Alarm) {
        guard let indexPath = alarms.firstIndex(of: alarm) else { return}
        alarms.remove(at: indexPath)
        cancelUserNotifications(for: alarm)
        savePersistence()
    }
    
    func updateAlarm(alarm: Alarm, name: String, fireDate: Date, enable: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enable
        savePersistence()
    }
    
    //MARK: Persistence
    
    func createPersistenceURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("Alarm.json")
        return fileURL
    }
    
    func savePersistence() {
        let encode = JSONEncoder()
        
        do {
            let encondedData = try encode.encode(alarms)
            try encondedData.write(to: createPersistenceURL())
        } catch  let error {
             print("There was an error encoding the Data \(error)")
        }
    }
    
    func loadPersistenceData() {
        let decoder = JSONDecoder()
        
        do {
            let data =  try Data(contentsOf: createPersistenceURL())
            alarms = try decoder.decode([Alarm].self, from: data)
        } catch let error {
            print("There was an error decoding The Data \(error)")
        }
    }
    
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Time's up!"
        notificationContent.body = "Time to wake up!"
        notificationContent.sound = .default
        notificationContent.badge = 1
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request, \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
