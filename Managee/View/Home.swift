//
//  Home.swift
//  Managee
//
//  Created by Stefanus Hermawan Sebastian on 20/07/22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = .init()
    // MARK: Matched  Geometry Namespace
    @Namespace var animation
    
    // MARK: Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    // MARK: Environment Values
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Tasks").font(.title.bold()).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical)
                CustomSegmentedBar().padding(.top,5)
                
                // MARK: Task View
                TaskView().padding(.top, 5)
                
            }.padding()
        }.overlay(alignment: .bottom) {
            // MARK: Add Button
            Button {
                taskModel.openEditTask.toggle()
            } label: {
                Text("Add").font(.callout).fontWeight(.semibold).foregroundColor(.white).frame(maxWidth: 400).padding(.vertical, 12).background(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255), in: Capsule())
            }
            
            // MARK: Linear Gradient BG
            .padding(.top, 10).frame(maxWidth: .infinity).background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            
        }.fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTask().environmentObject(taskModel)
        }
    }
    
    // MARK: TaskView
    @ViewBuilder
    func TaskView()->some View{
        LazyVStack(spacing: 20){
            // MARK: Custom Filtered Request View
            DynamicFilteredView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }.padding(.top,20)
    }
    
    // MARK: Task Row View
    @ViewBuilder
    func TaskRowView(task: Task)->some View{
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(task.type ?? "").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).font(.callout).padding(.vertical,5).padding(.horizontal).background{
                    Capsule().fill(.white.opacity(0.3))
                }
                
                Spacer()
                
                // MARK: Edit Button Only For Non Completed Tasks
                // !task.isCompleted
                if !task.isCompleted || taskModel.currentTab == "Failed"{
                    Button{
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    }label: {
                        Image(systemName: "square.and.pencil").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    }
                }else if task.isCompleted {
                    Button{
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    }label: {
                        Image(systemName: "square.and.pencil").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    }
                }
            }
            
            Text(task.title ?? "").font(.title2.bold()).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted)).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    } icon: {
                        Image(systemName: "calendar").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    }.font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened)).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    } icon: {
                        Image(systemName: "clock").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    }.font(.caption)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted || taskModel.currentTab == "Failed"{
                    Button{
                        // MARK: Updating Core Data
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    }label: {
                        Circle().strokeBorder(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255), lineWidth: 1.5).frame(width: 25, height: 25).contentShape(Circle())
                    }
                }
                
            }
            
        }
        .padding().frame(maxWidth: .infinity).background{
            RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(task.color ?? "pink"))
        }
    }
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar()->some View {
        let tabs = ["Today", "Upcoming", "Task Done", "Failed"]
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout).fontWeight(.semibold).scaleEffect(0.9).foregroundColor(taskModel.currentTab == tab ? .white : Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).padding(.vertical, 6).frame(maxWidth: .infinity).background{
                    if taskModel.currentTab == tab {
                        Capsule().fill(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .contentShape(Capsule()).onTapGesture {
                    withAnimation {
                        taskModel.currentTab = tab
                    }
                }
            }
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
