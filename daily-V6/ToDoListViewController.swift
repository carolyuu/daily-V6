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
        
    var toDoItems = ToDoItems()
//    var toDoItems: [ToDoItem] = []
    
//    var toDoArray = ["First item", "Second Item"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.dataSource = self
        toDoListTableView.delegate = self
        
        toDoItems.loadData {
            self.toDoListTableView.reloadData()
        }
        
        LocalNotificaionManager.autherizeLocalNotifications(viewContoller: self)
    }
    

    
    func saveData() {
        toDoItems.saveData()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = toDoListTableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems.itemsArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = toDoListTableView.indexPathForSelectedRow {
                toDoListTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = toDoListTableView.indexPathForSelectedRow {
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            toDoListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            toDoItems.itemsArray.append(source.toDoItem)
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
            
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            
            
            toDoListTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
        return cell
    }
    
    
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                toDoItems.itemsArray.remove(at: indexPath.row)
                toDoListTableView.deleteRows(at: [indexPath], with: .fade)
                            saveData()
            }
        }
    
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
            toDoItems.itemsArray.remove(at: sourceIndexPath.row)
            toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
                    saveData()
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        toDoItem.
//        cell.nameTextLabel.frame.height
//        = toDoItems.itemsArray[indexPath.row]
//            .frame.height : 0
        return 70
    }
}



