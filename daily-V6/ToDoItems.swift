//
//  ToDoItems.swift
//  Daily-V3
//
//  Created by Carol Yu on 5/1/22.
//

//import Foundation
//import UserNotifications
//
//class ToDoItems {
//    var itemsArray: [ToDoItem] = []
//    
//   
//    
//    func saveData() {
//        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
//        
//        let jsonEncoder = JSONEncoder()
//        let data = try? jsonEncoder.encode(itemsArray)
//        do {
//            try data?.write(to:		 documentURL, options: .noFileProtection)
//        } catch {
//            print("😡 ERROR: Could not save data \(error.localizedDescription)")
//        }
////        setNotifications()
//    }
//
////    func setNotifications() {
////        guard itemsArray.count > 0 else {
////            return
////        }
////         // remove all notifications
////        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
////
////        // and let's re-create them with the updated data that we just saved
////        for index in 0..<itemsArray.count {
////            if itemsArray[index].reminderSet {
////                let toDoItem = itemsArray[index]
////                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
////            }
////        }
////    }
//}
