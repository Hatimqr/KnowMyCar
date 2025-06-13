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
    
    func signInWithApple() async throws -> User {
        authenticationState = .authenticating
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let user = User(
            email: "test@apple.com",
            displayName: "Test User (Apple)",
            authProvider: .apple
        )
        
        mockUser = user
        authenticationState = .authenticated(user)
        return user
    }
    
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
}
