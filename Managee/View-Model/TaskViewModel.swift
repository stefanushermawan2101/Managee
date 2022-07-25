//
//  TaskViewModel.swift
//  Managee
//
//  Created by Stefanus Hermawan Sebastian on 20/07/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "pink"
    @Published var taskDeadline: Date =  Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: Editing Exiting Data Task
    @Published var editTask: Task?
    
    // MARK: Adding Task To Core Data
    func addTask(context: NSManagedObjectContext)->Bool{
        
        // MARK: Updating Exiting Task Data in Core Data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        
        task.isCompleted = false
        
        if let _ = try? context.save(){
            return true
        }
        
        return false
    }
    
    // MARK: Resetting Data
    func resetTaskData() {
        taskType = "Basic"
        taskColor = "pink"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    
    // MARK: If Edit Is Available then Setting Exiting Data
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "pink"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}

