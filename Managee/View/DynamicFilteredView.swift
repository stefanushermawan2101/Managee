//
//  DynamicFilteredView.swift
//  Managee
//
//  Created by Stefanus Hermawan Sebastian on 25/07/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View,T>: View where T: NSManagedObject{
    // MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T)->Content
    
    // MARK: Building Custom ForEach which will give CoreData object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T)->Content){
        // MARK: Predict to Filter current date tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        if currentTab == "Today" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            // Filter key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) =< %@ AND isCompleted == %i", argumentArray: [today,tommorow, 0])
        }else if currentTab == "Upcoming" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            // Filter key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) =< %@ AND isCompleted == %i", argumentArray: [today,tommorow, 0])
        }else if currentTab == "Failed"{
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            // Filter key
            let filterKey = "deadline"
            
            // This will fetch task between today and tommorow which is 24 HRS
            // 0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) =< %@ AND isCompleted == %i", argumentArray: [past,today, 0])
        }else {
            // 0-false, 1-true
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        // Initializing Request With NSPredicate
        // Adding Sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("There is no task!").font(.system(size: 16)).fontWeight(.light).offset(y: 100).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
            }else {
                ForEach(request, id: \.objectID){object in
                    self.content(object)
                }
            }
        }
    }
}
