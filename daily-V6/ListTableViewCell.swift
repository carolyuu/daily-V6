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


class ListTableViewCell: UITableViewCell {
    
    weak var delegate: ListTableViewCellDelegate?

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var courseTextLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
    
}
