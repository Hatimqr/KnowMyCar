//
//  FirebaseAuthService.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

@MainActor
class FirebaseAuthService: AuthenticationService {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    
    var authenticationStatePublisher: Published<AuthenticationState>.Publisher {
        $authenticationState
    }
    
    private var currentUser: User?
    
    init() {
        // Listen for Firebase auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor in
                if let firebaseUser = firebaseUser {
                    // Convert Firebase user to our User model
                    let user = User(
                        email: firebaseUser.email ?? "",
                        displayName: firebaseUser.displayName,
                        authProvider: .google
                    )
                    self?.currentUser = user
                    self?.authenticationState = .authenticated(user)
                } else {
                    self?.currentUser = nil
                    self?.authenticationState = .unauthenticated
                }
            }
        }
    }
    
    func signInWithGoogle() async throws -> User {
        authenticationState = .authenticating
        
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthenticationError.unknown("Google Client ID not found")
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = windowScene.windows.first?.rootViewController else {
                throw AuthenticationError.unknown("Root view controller not found")
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw AuthenticationError.unknown("Failed to get ID token")
            }
            
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let authResult = try await Auth.auth().signIn(with: credential)
            
            let user = User(
                email: authResult.user.email ?? "",
                displayName: authResult.user.displayName,
                authProvider: .google
            )
            
            currentUser = user
            authenticationState = .authenticated(user)
            return user
            
        } catch {
            authenticationState = .error(.unknown(error.localizedDescription))
            throw error
        }
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            currentUser = nil
            authenticationState = .unauthenticated
        } catch {
            throw AuthenticationError.unknown(error.localizedDescription)
        }
    }
    
    func validateSession() async -> Bool {
        return Auth.auth().currentUser != nil
    }
}
