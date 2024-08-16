//
//  HeaderView.swift
//  CollabCards
//
//  Created by FFK on 9.08.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct HeaderView: View {
    @Binding var showNewBoardSheet: Bool
    @Binding var showQRScanner: Bool
    
    var body: some View {
        HStack {
            Spacer(minLength: 32)
            Text("CollabCards")
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer(minLength: 0)
            Menu {
                Button(action: {
                    showNewBoardSheet = true
                    Crashlytics.log("Create a board button tapped")
                }) {
                    Text("Create a board")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    showQRScanner = true
                    Crashlytics.log("Scan or Enter Board ID button tapped")
                }) {
                    Text("Scan or Enter Board ID")
                    Image(systemName: "qrcode.viewfinder")
                }
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .background(.blue)
        .foregroundColor(.white)
    }
}

#Preview {
    HeaderView(showNewBoardSheet: .constant(true), showQRScanner: .constant(true))
}
