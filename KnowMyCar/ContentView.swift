//
//  ContentView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
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
