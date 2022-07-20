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
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Stef!").font(.callout).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    Text("Here's Update Today.").font(.title2.bold()).foregroundColor(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255))
                    
                }.frame(maxWidth: .infinity, alignment: .leading).padding(.vertical)
                CustomSegmentedBar().padding(.top,5)
                
                // MARK: Task View
                // Later Will Come
                
            }.padding()
        }.overlay(alignment: .bottom) {
            // MARK: Add Button
            Button {
                
            } label: {
                Text("Add").font(.callout).fontWeight(.semibold).foregroundColor(.white).padding(.vertical, 12).padding(.horizontal, 50).background(Color(red: 80 / 255, green: 99 / 255, blue: 105 / 255), in: Capsule())
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
            
        }
    }
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar()->some View {
        let tabs = ["Today", "Upcoming", "Task Done"]
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
