//
//  LoadingOverlay.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//


//
//  LoadingOverlay.swift
//  KnowMyCar
//
//  Created by Hatim Rehmanjee on 6/13/25.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
                
                Text("Signing in...")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(
                Color.black.opacity(0.8)
                    .cornerRadius(16)
            )
        }
    }
}

#Preview {
    LoadingOverlay()
}