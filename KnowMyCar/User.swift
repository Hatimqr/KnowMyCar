//
//  User.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//


//
//  User.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: UUID = UUID()
    var email: String
    var displayName: String?
    var profileImageURL: String?
    var authProvider: AuthProvider
    var createdDate: Date = Date()
    var lastLoginDate: Date = Date()
    
    // Relationships - will be added in later sprints
    // @Relationship(deleteRule: .cascade) 
    // var vehicles: [Vehicle] = []
    
    init(email: String, displayName: String? = nil, authProvider: AuthProvider) {
        self.email = email
        self.displayName = displayName
        self.authProvider = authProvider
    }
}

enum AuthProvider: String, CaseIterable, Codable {
    case apple = "apple"
    case google = "google"
    
    var displayName: String {
        switch self {
        case .apple:
            return "Sign in with Apple"
        case .google:
            return "Sign in with Google"
        }
    }
}