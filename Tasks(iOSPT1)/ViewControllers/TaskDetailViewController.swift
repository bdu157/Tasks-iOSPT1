//
//  TaskDetailViewController.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/9/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    //MARK: Properties and outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task? {
        didSet {
            self.updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        self.nameTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskName = self.nameTextField.text,
            !taskName.isEmpty else {return}
        
        let notes = self.notesTextView.text
        
        if let task = self.task {
            //edit existing task
            task.name = taskName
            task.notes = notes
        } else {
            let _ = Task(name: taskName, notes: notes)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            NSLog("Error saving managed object context:\(error)")
        }
    }
    
    
    private func updateViews() {
        guard isViewLoaded else {return}
        
        self.title = self.task?.name ?? "Create Task"
        self.nameTextField.text = task?.name
        self.notesTextView.text = task?.notes
    }
    
    @objc private func toggleSaveButton() {
        self.saveButton.isEnabled = !self.nameTextField.text!.isEmpty  //if textField is not empty, then saveButton is enabled
    }
}
