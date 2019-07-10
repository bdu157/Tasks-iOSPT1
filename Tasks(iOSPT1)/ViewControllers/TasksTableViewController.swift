//
//  TasksTableViewController.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/9/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    //MARK: Properties
    //note: this is not a good efficient way to do this, as the fetch request will be executed everytime the tasks properti is accessed.
    
    var tasks: [Task] {
        //moc - managed object context
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        
        do {
            return try moc.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = self.tasks[indexPath.row]
            let moc = CoreDataStack.shared.mainContext
            moc.delete(task)
            
            do {
                try moc.save()
                self.tableView.reloadData()
            } catch {
                moc.reset()
                NSLog("Error saving managed object context: \(error)")
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let detailVC = segue.destination as? TaskDetailViewController,
                let indexPath = self.tableView.indexPathForSelectedRow else {return}
                detailVC.task = self.tasks[indexPath.row]
        }
    }
}
