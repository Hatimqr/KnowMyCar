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
    
    // Mock user database for testing
    private var mockUsers: [String: (email: String, password: String, displayName: String?)] = [
        "test@example.com": ("test@example.com", "password123", "Test User")
    ]
    
    func signInWithGoogle() async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let user = User(
            email: "test@gmail.com",
            displayName: "Test User (Google)",
            authProvider: .google
        )
        
        mockUser = user
        authenticationState = .authenticated(user)
        return user
    }
    
    func signInWithEmail(_ email: String, password: String) async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
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
    
    func signUpWithEmail(_ email: String, password: String, displayName: String?) async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Check if user already exists
        if mockUsers[email] != nil {
            let error = AuthenticationError.emailAlreadyInUse
            authenticationState = .error(error)
            throw error
        }
        
        // Check password strength (simple validation for testing)
        if password.count < 6 {
            let error = AuthenticationError.weakPassword
            authenticationState = .error(error)
            throw error
        }
        
        // Add user to mock database
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
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Check if user exists
        if mockUsers[email] == nil {
            throw AuthenticationError.invalidCredentials
        }
        
        // In a real implementation, this would send an email
        // For mock, we just succeed silently
    }
}
