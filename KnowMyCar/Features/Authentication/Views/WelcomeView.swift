//
//  WelcomeView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel  // ← Use injected ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                    
                    // App Logo/Title Section
                    VStack(spacing: 20) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 8) {
                            Text("KnowMyCar")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Track your car's maintenance with AI")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                    
                    // Authentication Section
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Text("Get Started")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Sign in to start tracking your vehicle maintenance and get AI-powered insights")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Google Sign-In Button
                        GoogleSignInButton(action: {
                            viewModel.signInWithGoogle()  // ← Use injected ViewModel
                        })
                        .disabled(viewModel.isLoading)  // ← Use injected ViewModel
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .frame(minHeight: geometry.size.height)
            }
        }
        .alert("Authentication Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.dismissError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .overlay {
            if viewModel.isLoading {  // ← Use injected ViewModel
                LoadingOverlay()
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthenticationViewModel())  // ← Preview uses injected ViewModel
}
