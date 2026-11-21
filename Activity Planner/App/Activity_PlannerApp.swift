//
//  Activity_PlannerApp.swift
//  Activity Planner
//
//  Created by Kunal on 19/11/26.
//

import SwiftUI

@main
struct Activity_PlannerApp: App {
    
    @State private var container = AppContainer()
    
    @State private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
                .environment(container)
                .environment(coordinator)
        }
    }
}
