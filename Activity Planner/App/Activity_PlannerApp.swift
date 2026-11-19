//
//  Activity_PlannerApp.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import SwiftUI

@main
struct Activity_PlannerApp: App {
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                container: container
            )
        }
    }
}
