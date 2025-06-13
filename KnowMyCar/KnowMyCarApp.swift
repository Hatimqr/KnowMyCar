//
//  KnowMyCarApp.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/10/25.
//

import SwiftUI
import SwiftData

@main
struct KnowMyCarApp: App {
    var sharedModelContainer: ModelContainer = {
        // TODO: Will add our actual models (User, Vehicle, MaintenanceRecord) in later sprints
        let schema = Schema([
            // Empty for now - removing Item demo model
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
