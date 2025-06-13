//
//  ContentView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/10/25.
//

import SwiftUI

struct ContentView: View {
    // Enable auto-login for mock service in development
    @StateObject private var authViewModel = AuthenticationViewModel(
        useFirebase: true // Set to false to use mock service
    )
    
    var body: some View {
        Group {
            switch authViewModel.authenticationState {
            case .unauthenticated:
                WelcomeView()
                    .environmentObject(authViewModel)
                
            case .authenticating:
                LoadingView()
                
            case .authenticated:
                MainTabView()
                    .environmentObject(authViewModel)
                
            case .error:
                WelcomeView()
                    .environmentObject(authViewModel)
            }
        }
        .animation(.easeInOut, value: authViewModel.authenticationState.isAuthenticated)
        .onAppear {
//            ensures ssession persistence
            Task {
                // The AuthenticationViewModel will automatically check for existing sessions through the FirebaseAuthService's init() method
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("Setting up your account...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}
