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
}

