//
//  ToDoTableViewController.swift
//  Daily
//
//  Created by Carol Yu on 4/30/22.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("📅 I JUST CREATED A DATE FORMATTER!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ToDoDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var courseField: UITextField!

    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var dueDateSwitch: UISwitch!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var dueDateDateLabel: UILabel!
    
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    
    @IBOutlet weak var reminderDateLabel: UILabel!
    var toDoItem: ToDoItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", course: "", dueDate: Date(), notes: "", dueDateSet: true, reminderSet: false, reminderDate: Date(), completed: false)
//            Date().addingTimeInterval(24*60*60)
        }
       updateUserInterface()
    }
    
    func updateUserInterface() {
        nameField.text = toDoItem.name
        courseField.text = toDoItem.course
        dueDatePicker.date = toDoItem.dueDate
        noteView.text = toDoItem.notes
        dueDateSwitch.isOn = toDoItem.dueDateSet
        reminderSwitch.isOn = toDoItem.reminderSet
        dueDateDateLabel.textColor = (dueDateSwitch.isOn ? .black :.gray)
        reminderDateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
        dueDateDateLabel.text = dateFormatter.string(from: toDoItem.dueDate)
        reminderDateLabel.text = dateFormatter.string(from: toDoItem.reminderDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, course: courseField.text!, dueDate: dueDatePicker.date, notes: noteView.text, dueDateSet: dueDateSwitch.isOn, reminderSet: reminderSwitch.isOn, reminderDate: reminderDatePicker.date, completed: toDoItem.completed)
//        let dueDateLabel = dateFormatter.string(from: toDoItem.dueDate)
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
            let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else {
                navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func dueDateSwitchChanged(_ sender: UISwitch) {
        
        dueDateDateLabel.textColor = (dueDateSwitch.isOn ? .black :.gray)
        
        
        dueDateDateLabel.text = (dueDateSwitch.isOn ? dateFormatter.string(from: dueDatePicker.date) : "")
        
        if dueDateDateLabel.textColor == .gray {
            dueDateDateLabel.text = ""
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func reminderSwitchChanged(_ sender: Any) {
        
        reminderDateLabel.textColor = (reminderSwitch.isOn ? .black :.gray)
    
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    @IBAction func reminderDatePickerChanged(_ sender: UIDatePicker) {
        reminderDateLabel.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func dueDateDatePickerChanged(_ sender: UIDatePicker) {
//        if dueDateSwitch.isOn {
        dueDateDateLabel.text = dateFormatter.string(from: sender.date)
        
//        }
    
    }
    
}

extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 1, section: 2):
            return dueDateSwitch.isOn ? dueDatePicker.frame.height : 0
        case IndexPath (row: 0, section: 3):
            return 200
        case IndexPath(row: 1, section: 4):
            return reminderSwitch.isOn ? reminderDatePicker.frame.height : 0
        default:
            return 44
        }
    }
}
