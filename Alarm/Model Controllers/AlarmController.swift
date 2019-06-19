//
//  AlarmController.swift
//  Alarm
//
//  Created by Nic Gibson on 6/18/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleUserNotification(for alarm: Alarm)
    func cancelUserNotification(for alarm: Alarm)
}

class AlarmController: AlarmScheduler {
    
    init() {
        loadFromPersistentStore()
    }
    
    var alarms: [Alarm] = []
    
    static let sharedInstance = AlarmController()
    
    func addAlarm(fireDate: Date, name: String, isEnabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, isEnabled: isEnabled)
        alarms.append(newAlarm)
        saveToPersistentStore()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, isEnabled: Bool) {
        
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.isEnabled = isEnabled
        scheduleUserNotification(for: alarm)
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let index = self.alarms.firstIndex(where: {$0 == alarm}) else {return}
        self.alarms.remove(at: index)
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.isEnabled = !alarm.isEnabled
        if alarm.isEnabled{
            scheduleUserNotification(for: alarm)
        } else {
            return
        }
    }
    
    
    
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "Alarm.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
    
    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedAlarm = try jsonDecoder.decode([Alarm].self, from: data)
            alarms = decodedAlarm
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
        }
    }
    
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(AlarmController.sharedInstance.alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
}

extension AlarmScheduler{
    
    func scheduleUserNotification(for alarm: Alarm){
        
        let content = UNMutableNotificationContent()
        content.title = "Wake up sleepyhead"
        content.body = "Or not?"
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func cancelUserNotification(for alarm: Alarm){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
