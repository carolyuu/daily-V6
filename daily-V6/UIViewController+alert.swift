//
//  UIViewController+alert.swift
//  daily-V6
//
//  Created by Carol Yu on 5/4/22.
//

import UIKit

extension UIViewController {
    func oneButtonAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
//        "User Has Not Allowed Notifications"
//        "To receive alerts for reminders, open Settings app, select To Do List > Notifications > Allow Notifications"
    }
}
