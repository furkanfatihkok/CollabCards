//
//  DurationSettingView.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//

import SwiftUI

struct DurationSettingView: View {
    
    var stepName: String
    @Binding var duration: Int
    
    var body: some View {
        HStack {
            Text(stepName)
            Spacer()
            TextField("Duration", value: $duration, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
        .padding()
    }
}

struct DurationSettingView_Previews: PreviewProvider {
    @State static var duration = 20
    
    static var previews: some View {
        DurationSettingView(stepName: "Duration", duration: $duration)
    }
}
