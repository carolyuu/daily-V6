//
//  ViewController.swift
//  daily-V6
//
//  Created by Carol Yu on 5/2/22.
//

import UIKit
import UserNotifications

//private let dateFormatter: DateFormatter = {
//    print("📅 I JUST CREATED A DATE FORMATTER!")
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateStyle = .short
//    dateFormatter.timeStyle = .short
//    return dateFormatter
//}()


class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
        
    var toDoItems: [ToDoItem] = []
    
//    var toDoArray = ["First item", "Second Item"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.dataSource = self
        toDoListTableView.delegate = self
        
        loadData()
        autherizeLocalNotifications()
    }
    
    
    func autherizeLocalNotifications() {
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
                //TODO:
            }
        }
    }
    
    
    func setNotifications() {
        guard toDoItems.count > 0 else {
            return
        }
         // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // and let's re-create them with the updated data that we just saved
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet {
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.reminderDate)
            }
        }
    }
    
    
    func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
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
    
    
      
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            toDoListTableView.reloadData()
        } catch {
            print("😡 ERROR: Could not load data \(error.localizedDescription)")
        }
//        completed()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(toDoItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡 ERROR: Could not save data \(error.localizedDescription)")
        }
//        let toDoItem = toDoItems!.first
//        let notificationID = setCalendarNotification(title: <#T##String#>, subtitle: <#T##String#>, body: <#T##String#>, badgeNumber: <#T##NSNumber?#>, sound: <#T##UNNotificationSound?#>, date: <#T##Date#>)
        setNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = toDoListTableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = toDoListTableView.indexPathForSelectedRow {
                toDoListTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = toDoListTableView.indexPathForSelectedRow {
            toDoItems[selectedIndexPath.row] = source.toDoItem
            toDoListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            toDoItems.append(source.toDoItem)
            toDoListTableView.insertRows(at: [newIndexPath], with: .bottom)
            toDoListTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
            saveData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if toDoListTableView.isEditing {
            toDoListTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            toDoListTableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
            
        }
    }
}


extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    
//    func checkBoxToggle(sender: ListTableViewCell) {
//        if let selectedIndexPath = toDoListTableView.indexPath(for: sender) {
//
//        }
//    }
    
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = toDoListTableView.indexPath(for: sender) {
            
            toDoItems[selectedIndexPath.row].completed = !toDoItems[selectedIndexPath.row].completed
            
            
            toDoListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems[indexPath.row]
        return cell
    }
    
    
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                toDoItems.remove(at: indexPath.row)
                toDoListTableView.deleteRows(at: [indexPath], with: .fade)
                            saveData()
            }
        }
    
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let itemToMove = toDoItems[sourceIndexPath.row]
            toDoItems.remove(at: sourceIndexPath.row)
            toDoItems.insert(itemToMove, at: destinationIndexPath.row)
                    saveData()
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}



