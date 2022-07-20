//
//  ContentView.swift
//  Managee
//
//  Created by Stefanus Hermawan Sebastian on 20/07/22.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationView {
            Home().navigationBarTitle("Managee").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
