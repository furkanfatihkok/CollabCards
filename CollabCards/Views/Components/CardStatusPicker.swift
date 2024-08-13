//
//  CardStatusPicker.swift
//  CollabCards
//
//  Created by FFK on 13.08.2024.
//

import SwiftUI

struct CardStatusPicker: View {
    @Binding var status: String
    
    var body: some View {
        Picker("Status", selection: $status) {
            Text("Went Well").tag("went well")
            Text("To Improve").tag("to improve")
            Text("Action Items").tag("action items")
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

#Preview {
    CardStatusPicker(status: .constant("went well"))
}
