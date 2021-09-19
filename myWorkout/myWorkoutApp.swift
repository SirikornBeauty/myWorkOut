//
//  myWorkoutApp.swift
//  myWorkout
//
//  Created by Smart on 19/9/2564 BE.
//

import SwiftUI

@main
struct myWorkoutApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HistoryStore())
        }
    }
}
