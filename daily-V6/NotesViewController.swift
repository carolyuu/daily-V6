//
//  NotesViewController.swift
//  daily-V6
//
//  Created by Carol Yu on 5/4/22.
//

import UIKit

struct NoteModel: Codable {
    var title: String
    var body: String
}

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//    var model: [Models] = []
    var noteModels: [NoteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Notes"
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("notes").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            noteModels = try jsonDecoder.decode(Array<NoteModel>.self, from: data)
            
        } catch {
            print("😡 ERROR: Could not load data \(error.localizedDescription)")
        }
    
    }
    
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("notes").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(noteModels)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡 ERROR: Could not save data \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNoteDetail" {
            let destination = segue.destination as! NotesDetailViewController
            let selectedIndexPath = notesTableView.indexPathForSelectedRow!
            destination.note = noteModels[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = notesTableView.indexPathForSelectedRow {
                notesTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
            
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! NotesDetailViewController
        if let selectedIndexPath = notesTableView.indexPathForSelectedRow {
            noteModels[selectedIndexPath.row] = source.note
//            model[selectedIndexPath.row].note = source.noteField
            notesTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: noteModels.count, section: 0)
            noteModels.append(source.note)
            notesTableView.insertRows(at: [newIndexPath], with: .bottom)
            notesTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
            saveData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if notesTableView.isEditing {
            notesTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            notesTableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
            
            
        }
    }
    
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell1.textLabel?.text = noteModels[indexPath.row].title
        cell1.detailTextLabel?.text = noteModels[indexPath.row].body
        return cell1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            noteModels.remove(at: indexPath.row)
            notesTableView.deleteRows(at: [indexPath], with: .fade)
                        saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = noteModels[sourceIndexPath.row]
        noteModels.remove(at: sourceIndexPath.row)
        noteModels.insert(itemToMove, at: destinationIndexPath.row)
                saveData()
    }
}
