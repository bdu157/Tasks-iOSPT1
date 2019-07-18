//
//  TaskController.swift
//  Tasks(iOSPT1)
//
//  Created by Dongwoo Pae on 7/15/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation
import CoreData


//why didnt it work?
let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!  //this is myown
//https://tasks-3f211.firebaseio.com/   this is what we used for class -> this crashed because fetch occurred due to data in this firebase
//https://task-coredata.firebaseio.com/  when i used mine first time it did not crash becasue there was nothing to fetch (no data in this firebase)
class TaskController {
    
    typealias CompletionHndler = (Error?) -> Void
    
    init() {
        fetchTaskFromServer()
    }
    
    //Fetch the Tasks from the server
    func fetchTaskFromServer(completion: @escaping CompletionHndler = { _ in}) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error Fetching tasks \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by the data task")
                completion(NSError())
                return
            }
            
            do {
                let taskRepresentations = Array(try JSONDecoder().decode([String: TaskRepresentation].self, from: data).values)
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                //we just update background content we just created
                try self.updateTasks(with: taskRepresentations, context: moc)   // fetchTaskFromServer() <= func updateTasks <= task and update
                completion(nil)
            } catch {
                NSLog("Error decoidng task representations: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepresentation], context: NSManagedObjectContext) throws {  //based on decoded data from firebase
        var error: Error? = nil
        
        context.performAndWait {
            for taskRep in representations {
                guard let uuid = UUID(uuidString: taskRep.identifier) else { continue }
            
                let task = self.task(forUUID: uuid, in: context) //func task  -  to figure out if uuidString exists
                if let task = task {
                    self.update(task: task, with: taskRep)   //func update - updating if uuidString exists then just update and do not create a new one
                    
                    ///////////
                    ///
                    ///this part we add context: context
                    //////////
                    
                    
                } else {
                    let _ = Task(taskRepresentation: taskRep, context: context)  //in case uuidString does not exist in Firebase then go ahead create one
                }
            }
            do {
                try context.save()
            } catch let saveError{
                error = saveError
            }
        }
        if let error = error {throw error}
    }
    
    //Get task from UUID
    private func task(forUUID uuid: UUID, in context: NSManagedObjectContext) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        fetchRequest.predicate =  NSPredicate(format: "identifier == %@", uuid as NSUUID) //%@place holder for whatever argument to follow it only has %@ so it will only have one argument
        var result: Task? = nil
        context.performAndWait {
            do {
                result = try context.fetch(fetchRequest).first  //we need to pull out to first one even though there should be only one
            } catch {
                NSLog("Error fetching task with \(uuid): \(error)")
            }
        }
        
        return result
//        do {
//            let moc = CoreDataStack.shared.mainContext
//            return try moc.fetch(fetchRequest).first
//        } catch {
//            NSLog("Error fetching task with uuid \(uuid): \(error)")
//            return nil  // no task that meets the criteria so it will just return nil
//        }
    }
    
    //update task with task representation from server
    private func update(task: Task, with representation: TaskRepresentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
    }
    
    //PUT Request
    func put(task: Task, completion: @escaping CompletionHndler = { _ in}) {
        
        let uuid = task.identifier ?? UUID()  //task.identifier is actually type UUID based on SQLite model
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"   //add and modify
        
        do {
            guard var representation = task.taskRepresentation else {   //used var so it could be modified below
                completion(NSError())
                return
            }
            representation.identifier = uuid.uuidString  //because identifier is set as string. this is why we use uuid.uuidString
            task.identifier = uuid  //local one matches what is in firebase
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation) // we encoded representation instead actual task.identifier because task.identifier is SQLite model so it needs in between struct such as TaskRepresentation
        } catch {
            NSLog("Error encoding task \(task): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing task to server:\(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    func deleteTaskFromServer(_ task: Task, completion: @escaping CompletionHndler = { _ in}) {
        guard let uuid = task.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            completion(error)
        }.resume()
    }
}
