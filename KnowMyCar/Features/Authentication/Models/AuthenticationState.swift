//
//  AuthenticationState.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation

enum AuthenticationState: Equatable {
    case unauthenticated
    case authenticating
    case authenticated(User)
    case error(AuthenticationError)
    
    var isAuthenticated: Bool {
        if case .authenticated = self {
            return true
        }
        return false
    }
    
    var user: User? {
        if case .authenticated(let user) = self {
            return user
        }
        return nil
    }
}

enum AuthenticationError: LocalizedError, Equatable {
    case cancelled
    case networkError
    case invalidCredentials
    case googleSignInFailed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Sign in was cancelled"
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .invalidCredentials:
            return "Invalid credentials. Please try again."
        case .googleSignInFailed:
            return "Google Sign-In failed. Please try again."
        case .unknown(let message):
            return "Authentication failed: \(message)"
        }
    }
}
