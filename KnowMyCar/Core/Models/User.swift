//
//  User.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation
import SwiftData

@Model
final class User: Sendable {
    var id: UUID = UUID()
    var email: String
    var displayName: String?
    var profileImageURL: String?
    var authProvider: AuthProvider
    var createdDate: Date = Date()
    var lastLoginDate: Date = Date()
    
    init(email: String, displayName: String? = nil, authProvider: AuthProvider = .google) {
        self.email = email
        self.displayName = displayName
        self.authProvider = authProvider
    }
}

// MARK: - Equatable Conformance
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

enum AuthProvider: String, CaseIterable, Codable {
    case google = "google"
    // Can add apple later when you get developer account
    
    var displayName: String {
        switch self {
        case .google:
            return "Sign in with Google"
        }
    }
}
