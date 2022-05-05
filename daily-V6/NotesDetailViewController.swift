//
//  NewNoteViewController.swift
//  daily-V6
//
//  Created by Carol Yu on 5/4/22.
//

import UIKit

class NotesDetailViewController: UIViewController {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    var note: NoteModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if note == nil {
            note = NoteModel(title: "", body: "")
            titleField.becomeFirstResponder()
        }
        titleField.text = note.title
        noteField.text = note.body


    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        note = NoteModel(title: titleField.text!, body: noteField.text)
    }
   

}
