//
//  LocalNotificationManager.swift
//  daily-V6
//
//  Created by Carol Yu on 5/4/22.
//

import UIKit
import UserNotifications


struct LocalNotificaionManager {
    static func autherizeLocalNotifications(viewContoller: UIViewController) {
        //        (viewController: UIViewController)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                return
            }
            
            if granted {
                print("✅ Notifications Authorization Granted!")
            } else {
                print("🚫 The user has denied notifications!")
                DispatchQueue.main.async {
                    viewContoller.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open Settings app, select To Do List > Notifications > Allow Notifications")
                }
                
            }
        }
    }
    static func isAuthorized(completed: @escaping (Bool)->()) {
        //        (viewController: UIViewController)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                completed(false)
                return
            }
            
            if granted {
                print("✅ Notifications Authorization Granted!")
                completed(true)
            } else {
                print("🚫 The user has denied notifications!")
                completed(false)
                
            }
        }
    }
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        // create content:
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription) Yikes, adding notification request went wrong!")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
    
}
