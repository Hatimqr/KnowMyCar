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
        let schema = Schema([
            User.self,
            // TODO: Add Vehicle, MaintenanceRecord in later sprints
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
