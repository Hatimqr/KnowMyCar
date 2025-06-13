//
//  AuthenticationService.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import Combine

protocol AuthenticationService: ObservableObject {
    /// Current authentication state
    var authenticationState: AuthenticationState { get }
    
    /// Publisher for authentication state changes
    var authenticationStatePublisher: Published<AuthenticationState>.Publisher { get }
    
    /// Sign in with Google
    func signInWithGoogle() async throws -> User
    
    /// Get currently authenticated user
    func getCurrentUser() -> User?
    
    /// Sign out current user
    func signOut() async throws
    
    /// Check if user session is still valid
    func validateSession() async -> Bool
}
