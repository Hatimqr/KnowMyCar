//
//  WelcomeView.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingEmailSignIn = false
    @State private var showingEmailSignUp = false
    
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
                        
                        // Authentication Buttons
                        VStack(spacing: 16) {
                            // Google Sign-In Button
                            GoogleSignInButton(action: {
                                viewModel.signInWithGoogle()
                            })
                            .disabled(viewModel.isLoading)
                            
                            // Divider
                            HStack {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                                
                                Text("or")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            
                            // Email Sign In Button
                            Button(action: { showingEmailSignIn = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope.fill")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text("Sign in with Email")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(AppConstants.UI.cornerRadius)
                                .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(PressableButtonStyle())
                            .disabled(viewModel.isLoading)
                            
                            // Sign Up Link
                            HStack {
                                Text("Don't have an account?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button("Sign Up") {
                                    showingEmailSignUp = true
                                }
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            }
                        }
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
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .sheet(isPresented: $showingEmailSignIn) {
            EmailSignInView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showingEmailSignUp) {
            EmailSignUpView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthenticationViewModel())
}
