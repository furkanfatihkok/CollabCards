//
//  RetroView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct RetroView: View {
    var body: some View {
        
        NavigationView {
            VStack {
                WelcomSelectionView()
                InputFieldView()
                HStack {
                    Button(action: {
                        //TODO: cancel tıklandığında textField empty olsun.
                        Crashlytics.log("Input field cleared.")
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
                    .simultaneousGesture(TapGesture().onEnded {
                        Crashlytics.log("Navigated to TemplateSelectionView from RetroView.")
                    })
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
