//
//  MainTabView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//


//
//  MainTabView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "speedometer")
                    Text("Dashboard")
                }
            
            VehiclesView()
                .tabItem {
                    Image(systemName: "car.2")
                    Text("Vehicles")
                }
            
            MaintenanceView()
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("Maintenance")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .tint(.blue)
    }
}

// Placeholder views for each tab
struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "speedometer")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Coming in Sprint 2!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct VehiclesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "car.2")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("My Vehicles")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Coming in Sprint 3!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Vehicles")
        }
    }
}

struct MaintenanceView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Maintenance")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Coming in Sprint 4!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Maintenance")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = authViewModel.authenticationState.user {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 4) {
                            Text(user.displayName ?? "User")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Sign Out") {
                            authViewModel.signOut()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationViewModel())
}