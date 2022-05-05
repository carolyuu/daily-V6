//
//  ListTableTableViewCell.swift
//  daily-V6
//
//  Created by Carol Yu on 5/2/22.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func checkBoxToggle(sender: ListTableViewCell)
}

private let dateFormatter: DateFormatter = {
    print("📅 I JUST CREATED A DATE FORMATTER!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()



class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var courseTextLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    
    weak var delegate: ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem! {
        didSet {
            nameTextLabel.text = toDoItem.name
            courseTextLabel.text = toDoItem.course
            
            if toDoItem.dueDateSet == false {
                dueDateLabel.text = ""
            } else {
                dueDateLabel.text = "Due: \(dateFormatter.string(from: toDoItem.dueDate))"
            }
            
            checkBoxButton.isSelected = toDoItem.completed
           
            if toDoItem.completed {
                nameTextLabel.textColor = UIColor(named: "completedTodoItemTextColor")
                dueDateLabel.alpha = 0.4
                
            } else {
                nameTextLabel.textColor = UIColor(named: "todoItemTextColor")
                dueDateLabel.alpha = 1
            }
        }
    }
    
    
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
    
    
    
}
