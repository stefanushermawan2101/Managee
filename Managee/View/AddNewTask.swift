//
//  AddNewTask.swift
//  Managee
//
//  Created by Stefanus Hermawan Sebastian on 21/07/22.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var taskModel: TaskViewModel
    // MARK: All Environment Values in one Variable
    @Environment(\.self) var env
    @Namespace var animation
    var body: some View {
        VStack(spacing: 12) {
            Text("Task").font(.title3.bold()).frame(maxWidth: .infinity).overlay(alignment: .leading) {
                Button {
                    env.dismiss()
                } label: {
                    Image(systemName: "arrow.left").font(.title3).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                }
            }.overlay(alignment: .trailing){
                Button {
                    if let editTask = taskModel.editTask {
                        env.managedObjectContext.delete(editTask)
                        try? env.managedObjectContext.save()
                        env.dismiss()
                    }
                } label: {
                    Image(systemName: "trash").font(.title3).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                }.opacity(taskModel.editTask == nil ? 0 : 1)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color").font(.caption).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                
                // MARK: Sample Card Colors
           
                let colors: [String] = ["pink", "ijo", "abu1", "ungu", "abu2"]
                
                HStack(spacing: 15){
                    ForEach(colors, id: \.self){ color in
                        Circle().fill(Color(color)).frame(width: 25, height: 25).background{
                            if taskModel.taskColor == color {
                                Circle().strokeBorder(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).padding(-3)
                            }
                        }.contentShape(Circle()).onTapGesture {
                            taskModel.taskColor = color
                        }
                    }
                    
                }.padding(.top, 10)
                
            }.frame(maxWidth: .infinity, alignment: .leading).padding(.top, 30)
            
            Divider().padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline").font(.caption).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                
                
                Text(taskModel.taskDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + taskModel.taskDeadline.formatted(date: .omitted, time: .shortened)).font(.callout).fontWeight(.semibold).padding(.top, 10)
                
            }.frame(maxWidth: .infinity, alignment: .leading).overlay(alignment: .bottomTrailing) {
                Button {
                    taskModel.showDatePicker.toggle()
                }label: {
                    Image(systemName: "calendar").foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                }
            }
            
            Divider().padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title").font(.caption).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                
                
                TextField("", text: $taskModel.taskTitle).frame(maxWidth: .infinity).padding(.top, 10)
                
            }.padding(.top,10)
            
            Divider().padding(.vertical, 10)
            
            // MARK: Sample Task Type
            let taskTypes: [String] = ["Basic", "Important", "Urgent"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type").font(.caption).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                
                
                HStack(spacing: 12) {
                    ForEach(taskTypes, id: \.self) { type in
                        Text(type).font(.callout).padding(.vertical, 8).frame(maxWidth: .infinity).foregroundColor(taskModel.taskType == type ? .white : Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255)).background{
                            if taskModel.taskType == type {
                                if taskModel.taskType == "Basic" {
                                    Capsule().fill(.green).matchedGeometryEffect(id: "TYPE", in: animation)
                                }else if taskModel.taskType == "Important" {
                                    Capsule().fill(.orange).matchedGeometryEffect(id: "TYPE", in: animation)
                                }else if taskModel.taskType == "Urgent" {
                                    Capsule().fill(.red).matchedGeometryEffect(id: "TYPE", in: animation)
                                }
                                
                            }else {
                                Capsule().strokeBorder(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                            }
                        }.contentShape(Capsule()).onTapGesture {
                            withAnimation{taskModel.taskType = type}
                        }
                        
                    }
                }.padding(.top, 8)
                
            }.padding(.vertical,10)
            
            Divider().padding(.vertical, 10)
            
            // MARK: Save Button
            Button {
                // MARK: If Success Closing View
                if taskModel.addTask(context: env.managedObjectContext){
                    env.dismiss()
                }else{
                    print("gak berhasil")
                }
            } label: {
                Text("Save").font(.callout).fontWeight(.semibold).frame(maxWidth: .infinity
                ).padding(.vertical, 12).foregroundColor(.white).background{
                        Capsule().fill(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    }
            }.frame(maxHeight: .infinity, alignment: .bottom).padding(.bottom,10).disabled(taskModel.taskTitle == "").opacity(taskModel.taskTitle == "" ? 0.6 : 1)

            
        }.frame(maxHeight: .infinity, alignment: .top).padding().overlay {
            ZStack{
                if taskModel.showDatePicker{
                    Rectangle().fill(.ultraThinMaterial).ignoresSafeArea().onTapGesture {
                        taskModel.showDatePicker = false
                    }
                    
                    // MARK: Disabling Past Dates
                    DatePicker.init("", selection: $taskModel.taskDeadline, in: Date.now...Date.distantFuture).datePickerStyle(.graphical).labelsHidden().padding().background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous)).padding()
                }
            }
        }.animation(.easeInOut, value: taskModel.showDatePicker)
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask().environmentObject(TaskViewModel())
    }
}

