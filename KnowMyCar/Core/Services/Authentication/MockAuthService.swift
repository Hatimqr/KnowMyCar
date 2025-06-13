//
//  MockAuthService.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import Combine

@MainActor
class MockAuthService: AuthenticationService {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var authenticationStatePublisher: Published<AuthenticationState>.Publisher {
        $authenticationState
    }
    
    private var mockUser: User?
    
    // Updated mock user database with real credentials
    private var mockUsers: [String: (email: String, password: String, displayName: String?)] = [
        "test@test.com": ("test@test.com", "tester123", "Test User"),
        "test@example.com": ("test@example.com", "password123", "Test User Example") // Keep original for fallback
    ]
    
    // Add auto-login flag
    private let autoLoginEnabled: Bool
    
    init() {
        self.autoLoginEnabled = true
        
        // Auto-login if enabled
        if autoLoginEnabled {
            Task {
                await performAutoLogin()
            }
        }
    }
    
    // New auto-login method
    private func performAutoLogin() async {
        do {
            // Automatically sign in with the test account
            _ = try await signInWithEmail("test@test.com", password: "tester123")
            print("✅ MockAuthService: Auto-login successful for test@test.com")
        } catch {
            print("❌ MockAuthService: Auto-login failed - \(error.localizedDescription)")
            // Fallback to unauthenticated state
            authenticationState = .unauthenticated
        }
    }
    
    func signInWithGoogle() async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Use the real test account data for Google sign-in simulation
        let user = User(
            email: "test@test.com",
            displayName: "Test User (Google)",
            authProvider: .google
        )
        
        mockUser = user
        authenticationState = .authenticated(user)
        return user
    }
    
    func signInWithEmail(_ email: String, password: String) async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay (reduced for auto-login)
        let delay: UInt64 = autoLoginEnabled && email == "test@test.com" ? 100_000_000 : 500_000_000 // 0.1s for auto-login, 0.5s for manual
        try await Task.sleep(nanoseconds: delay)
        
        // Check if user exists and password is correct
        if let mockUserData = mockUsers[email], mockUserData.password == password {
            let user = User(
                email: email,
                displayName: mockUserData.displayName,
                authProvider: .email
            )
            
            mockUser = user
            authenticationState = .authenticated(user)
            return user
        } else {
            let error = AuthenticationError.invalidCredentials
            authenticationState = .error(error)
            throw error
        }
    }
    
    // Rest of the methods remain the same...
    func signUpWithEmail(_ email: String, password: String, displayName: String?) async throws -> User {
        authenticationState = .authenticating
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if mockUsers[email] != nil {
            let error = AuthenticationError.emailAlreadyInUse
            authenticationState = .error(error)
            throw error
        }
        
        if password.count < 6 {
            let error = AuthenticationError.weakPassword
            authenticationState = .error(error)
            throw error
        }
        
        mockUsers[email] = (email, password, displayName)
        
        let user = User(
            email: email,
            displayName: displayName,
            authProvider: .email
        )
        
        mockUser = user
        authenticationState = .authenticated(user)
        return user
    }
    
    func getCurrentUser() -> User? {
        return mockUser
    }
    
    func signOut() async throws {
        mockUser = nil
        authenticationState = .unauthenticated
    }
    
    func validateSession() async -> Bool {
        return mockUser != nil
    }
    
    func resetPassword(email: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        if mockUsers[email] == nil {
            throw AuthenticationError.invalidCredentials
        }
    }
}
