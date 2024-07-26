//
//  TemplateSelectionView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct TemplateSelectionView: View {
    
    let templates = [
        Template(title: "Glad Sad Mad", description: "Describe your emotional journey in three buckets – Glad, Mad, and Sad. List things that make you happy when you think about this project, things that are driving you crazy, and some of the things that have disappointed you or that you wished could be improved.", projects: "850+ Projects (Most used)", imageName: "nodata"),
        Template(title: "New Template", description: "Accept constructive feedback and appreciate everyone’s efforts. Discuss what went well, what could have been better, and identify steps for improvement.", projects: "375+ Projects", imageName: "image2")
    ]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(templates) { template in
                    NavigationLink(destination: RetrospectiveSettingsView()) {
                        TemplateCardView(template: template)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        Crashlytics.log("Navigated to RetrospectiveSettingsView with template: \(template.title)")
                    })
                }
                .padding()
            }
        }
        .navigationTitle("Template Selection")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    Crashlytics.log("User navigated back from TemplateSelectionView")
                }, label: {
                    Image(systemName: "arrow.left")
                })
            }
        }
    }
}

#Preview {
    TemplateSelectionView()
}
