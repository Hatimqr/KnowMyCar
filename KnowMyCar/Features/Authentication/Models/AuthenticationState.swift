//
//  AuthenticationState.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation

enum AuthenticationState: Equatable, Sendable {
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

enum AuthenticationError: LocalizedError, Equatable, Sendable {
    case cancelled
    case networkError
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case googleSignInFailed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .cancelled:
            return "Sign in was cancelled"
        case .networkError:
            return "Network connection error. Please check your internet connection."
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .emailAlreadyInUse:
            return "This email address is already registered. Please sign in instead."
        case .weakPassword:
            return "Password is too weak. Please choose a stronger password."
        case .googleSignInFailed:
            return "Google Sign-In failed. Please try again."
        case .unknown(let message):
            return "Authentication failed: \(message)"
        }
    }
}
