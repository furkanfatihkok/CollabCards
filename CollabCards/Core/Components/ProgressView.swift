//
//  ProgressView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct ProgressView: View {
    
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        HStack {
            ForEach(0..<totalSteps) { step in
                if step < currentStep {
                    Circle()
                        .fill(.blue)
                        .frame(width: 20, height: 20)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                } else {
                    Circle()
                        .fill(.blue.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
                
                if step < totalSteps - 1 {
                    Rectangle()
                        .fill(Color.blue.opacity(step < currentStep - 1 ? 1.0 : 0.3))
                        .frame(width: 50, height: 2)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ProgressView(currentStep: 3, totalSteps: 4)
}
