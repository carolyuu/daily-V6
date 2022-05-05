//
//  ToDoTableViewController.swift
//  Daily
//
//  Created by Carol Yu on 4/30/22.
//

import UIKit
import UserNotifications

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
        
        // setup foreground notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        // hide keyboard when tapped outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        
        //        courseField.delegate = self
        
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", course: "", dueDate: Date().addingTimeInterval(24*60*60), notes: "", dueDateSet: true, reminderSet: false, reminderDate: Date(), completed: false)
            nameField.becomeFirstResponder()
        }
        updateUserInterface()
    }
    
    @objc func appActiveNotification() {
        print ("😯 The app just came to the foreground - cool!")
        updateReminderSwitch()
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
        enableDisableSaveButton(text: nameField.text!)
        updateReminderSwitch()
        
    }
    
    func updateReminderSwitch() {
        LocalNotificaionManager.isAuthorized { (authorized) in
            
            DispatchQueue.main.async {
                if !authorized && self.reminderSwitch.isOn{
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open Settings app, select To Do List > Notifications > Allow Notifications")
                    self.reminderSwitch.isOn = false
                }
                self.view.endEditing(true)
                self.reminderDateLabel.textColor = (self.reminderSwitch.isOn ? .black :.gray)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, course: courseField.text!, dueDate: dueDatePicker.date, notes: noteView.text, dueDateSet: dueDateSwitch.isOn, reminderSet: reminderSwitch.isOn, reminderDate: reminderDatePicker.date, completed: toDoItem.completed)
        //        let dueDateLabel = dateFormatter.string(from: toDoItem.dueDate)
    }
    
    func enableDisableSaveButton(text:String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
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
        self.view.endEditing(true)
        dueDateDateLabel.textColor = (dueDateSwitch.isOn ? .black :.gray)
        
        
        dueDateDateLabel.text = (dueDateSwitch.isOn ? dateFormatter.string(from: dueDatePicker.date) : "")
        
        if dueDateDateLabel.textColor == .gray {
            dueDateDateLabel.text = ""
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func reminderSwitchChanged(_ sender: Any) {
        updateReminderSwitch()
    }
    
    @IBAction func reminderDatePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        reminderDateLabel.text = dateFormatter.string(from: sender.date)
    }
    @IBAction func dueDateDatePickerChanged(_ sender: UIDatePicker) {
        //        if dueDateSwitch.isOn {
        self.view.endEditing(true)
        dueDateDateLabel.text = dateFormatter.string(from: sender.date)
        
        //        }
        
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
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

extension ToDoDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        courseField.becomeFirstResponder()
        
        return true
        
    }
    
    //    func performActions() {
    //
    //
    //            courseField.becomeFirstResponder()
    //
    //
    ////        if courseField.isFirstResponder{
    ////            courseField.resignFirstResponder()
    ////                    noteView.becomeFirstResponder()
    ////        }
    //
    //    }
    //
    //    private func textFieldShouldReturn(_ textField: UITextField) {
    //        if courseField.isFirstResponder {
    //            self.noteView.becomeFirstResponder()
    //        }
    ////        noteView.becomeFirstResponder()
    //        return true
    //    }
    //
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        noteView.becomeFirstResponder()
    //        return true
    //    }
    //
    
    
}
