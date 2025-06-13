//
//  AppConstants.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//


//
//  AppConstants.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import Foundation

struct AppConstants {
    struct Authentication {
        static let sessionTimeout: TimeInterval = 30 * 24 * 60 * 60 // 30 days
        static let maxRetryAttempts = 3
    }
    
    struct UI {
        static let animationDuration: Double = 0.3
        static let cornerRadius: CGFloat = 12
        static let spacing: CGFloat = 16
    }
    
    struct API {
        // Will be populated in later sprints
    }
}