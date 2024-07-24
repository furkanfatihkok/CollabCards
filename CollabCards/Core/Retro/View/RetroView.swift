//
//  RetroView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct RetroView: View {
    var body: some View {
        NavigationView {
            VStack {
                ProgressView(currentStep: 1, totalSteps: 4)
                InputFieldView()
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("CANCEL")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(5)
                    })
                    NavigationLink(destination: TemplateSelectionView()) {
                        Text("NEXT")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(5)
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("New Retro")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RetroView()
}
