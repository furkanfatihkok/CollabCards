//
//  ShareSheet.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    // MARK: - Properties
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    // MARK: - UIViewControllerRepresentable
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ShareSheet(activityItems: ["Check out CollabCards!"])
}
