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
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    var task: Task? {
        didSet {
            self.updateViews()
        }
    }
    
    var taskController: TaskController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        self.toggleSaveButton()
        self.nameTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let taskName = self.nameTextField.text,
            !taskName.isEmpty else {return}
        
        
        let priorityIndex = prioritySegmentedControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]   //allPriorities -> allCases
        
        
        let notes = self.notesTextView.text
        
        if let task = self.task {
            //edit existing task (update)
            task.name = taskName
            task.priority = priority.rawValue
            task.notes = notes
            taskController.put(task: task)
        } else {
            //creating a new task (create)
            let task = Task(name: taskName, notes: notes, priority: priority)
            taskController.put(task: task)
        }
        //this is just saving all as mainContext (saveToPersistentStore(). it gets bundled and saved
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
        
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        
        prioritySegmentedControl.selectedSegmentIndex = TaskPriority.allPriorities.firstIndex(of: priority)!   //allPriorities -> allCases
        self.title = self.task?.name ?? "Create Task"
        self.nameTextField.text = task?.name
        self.notesTextView.text = task?.notes
    }
    
    @objc private func toggleSaveButton() {
        self.saveButton.isEnabled = !self.nameTextField.text!.isEmpty  //if textField is not empty, then saveButton is enabled
    }
}
