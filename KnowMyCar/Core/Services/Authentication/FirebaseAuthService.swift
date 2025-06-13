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
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        // Listen for Firebase auth state changes
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { @MainActor [weak self] in
                if let firebaseUser = firebaseUser {
                    // Convert Firebase user to our User model
                    let user = User(
                        email: firebaseUser.email ?? "",
                        displayName: firebaseUser.displayName,
                        authProvider: firebaseUser.providerData.first?.providerID == "google.com" ? .google : .email
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
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func signInWithGoogle() async throws -> User {
        authenticationState = .authenticating
        
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                let error = AuthenticationError.unknown("Google Client ID not found")
                await MainActor.run {
                    self.authenticationState = .error(error)
                }
                throw error
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootViewController = await windowScene.windows.first?.rootViewController else {
                let error = AuthenticationError.unknown("Root view controller not found")
                await MainActor.run {
                    self.authenticationState = .error(error)
                }
                throw error
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                let error = AuthenticationError.unknown("Failed to get ID token")
                await MainActor.run {
                    self.authenticationState = .error(error)
                }
                throw error
            }
            
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let authResult = try await Auth.auth().signIn(with: credential)
            
            let user = User(
                email: authResult.user.email ?? "",
                displayName: authResult.user.displayName,
                authProvider: .google
            )
            
            await MainActor.run {
                self.currentUser = user
                self.authenticationState = .authenticated(user)
            }
            
            return user
            
        } catch {
            let authError = AuthenticationError.unknown(error.localizedDescription)
            await MainActor.run {
                self.authenticationState = .error(authError)
            }
            throw authError
        }
    }
    
    func signInWithEmail(_ email: String, password: String) async throws -> User {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            let user = User(
                email: authResult.user.email ?? "",
                displayName: authResult.user.displayName,
                authProvider: .email
            )
            
            await MainActor.run {
                self.currentUser = user
                self.authenticationState = .authenticated(user)
            }
            
            return user
            
        } catch {
            let authError = mapFirebaseError(error)
            await MainActor.run {
                self.authenticationState = .error(authError)
            }
            throw authError
        }
    }
    
    func signUpWithEmail(_ email: String, password: String, displayName: String?) async throws -> User {
        authenticationState = .authenticating
        
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update display name if provided
            if let displayName = displayName {
                let changeRequest = authResult.user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                try await changeRequest.commitChanges()
            }
            
            let user = User(
                email: authResult.user.email ?? "",
                displayName: displayName ?? authResult.user.displayName,
                authProvider: .email
            )
            
            await MainActor.run {
                self.currentUser = user
                self.authenticationState = .authenticated(user)
            }
            
            return user
            
        } catch {
            let authError = mapFirebaseError(error)
            await MainActor.run {
                self.authenticationState = .error(authError)
            }
            throw authError
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
    
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func mapFirebaseError(_ error: Error) -> AuthenticationError {
        guard let authError = error as? AuthErrorCode else {
            return AuthenticationError.unknown(error.localizedDescription)
        }
        
        switch authError.code {
        case .invalidEmail:
            return AuthenticationError.invalidCredentials
        case .wrongPassword:
            return AuthenticationError.invalidCredentials
        case .userNotFound:
            return AuthenticationError.invalidCredentials
        case .emailAlreadyInUse:
            return AuthenticationError.emailAlreadyInUse
        case .weakPassword:
            return AuthenticationError.weakPassword
        case .networkError:
            return AuthenticationError.networkError
        default:
            return AuthenticationError.unknown(error.localizedDescription)
        }
    }
}
