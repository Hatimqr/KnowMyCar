//
//  AuthenticationViewModel.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import Combine

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let authService: any AuthenticationService
    private var cancellables = Set<AnyCancellable>()
    
    // For development - switch between Mock and Firebase
    init(useFirebase: Bool = true) {
        if useFirebase {
            self.authService = FirebaseAuthService()
        } else {
            self.authService = MockAuthService()
        }
        
        // Subscribe to auth service state changes
        authService.authenticationStatePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.authenticationState, on: self)
            .store(in: &cancellables)
        
        // Update loading state based on auth state
        $authenticationState
            .map { state in
                if case .authenticating = state {
                    return true
                }
                return false
            }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // Extract error messages
        $authenticationState
            .map { state in
                if case .error(let error) = state {
                    return error.localizedDescription
                }
                return nil
            }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    func signInWithGoogle() {
        Task {
            do {
                errorMessage = nil
                _ = try await authService.signInWithGoogle()
                // AuthenticationState will be updated automatically via publisher
            } catch {
                // Error will be handled via publisher
                print("Google sign in error: \(error)")
            }
        }
    }
    
    func signInWithEmail(email: String, password: String) {
        Task {
            do {
                errorMessage = nil
                _ = try await authService.signInWithEmail(email, password: password)
                // AuthenticationState will be updated automatically via publisher
            } catch {
                // Error will be handled via publisher
                print("Email sign in error: \(error)")
            }
        }
    }
    
    func signUpWithEmail(email: String, password: String, displayName: String?) {
        Task {
            do {
                errorMessage = nil
                _ = try await authService.signUpWithEmail(email, password: password, displayName: displayName)
                // AuthenticationState will be updated automatically via publisher
            } catch {
                // Error will be handled via publisher
                print("Email sign up error: \(error)")
            }
        }
    }
    
    func resetPassword(email: String) {
        Task {
            do {
                errorMessage = nil
                try await authService.resetPassword(email: email)
                // You might want to show a success message here
            } catch {
                if let authError = error as? AuthenticationError {
                    errorMessage = authError.localizedDescription
                } else {
                    errorMessage = "Failed to send password reset email"
                }
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await authService.signOut()
            } catch {
                errorMessage = "Failed to sign out: \(error.localizedDescription)"
            }
        }
    }
    
    func dismissError() {
        errorMessage = nil
    }
}
