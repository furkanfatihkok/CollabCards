//
//  TemplateCardView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI

struct TemplateCardView: View {
    
    let template: Template
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(template.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .cornerRadius(10)
            HStack {
                Image(systemName: "checkmark.circle")
                    .foregroundStyle(.blue)
                Text(template.title)
                    .font(.headline)
                Spacer()
            }
            
            Text(template.description)
                .font(.subheadline)
            Text(template.projects)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    TemplateCardView(
        template: Template(title: "Glad Sad Mad", description: "Describe your emotional journey in three buckets – Glad, Mad, and Sad. List things that make you happy when you think about this project, things that are driving you crazy, and some of the things that have disappointed you or that you wished could be improved.", projects: "850+ Projects (Most used)", imageName: "nodata")
    )
}
