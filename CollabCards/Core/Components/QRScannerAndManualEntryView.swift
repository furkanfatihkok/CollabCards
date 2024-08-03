//
//  QRScannerAndManualEntryView.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import SwiftUI
import FirebaseFirestore
import AVFoundation

struct QRScannerAndManualEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scannedCode: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @ObservedObject var viewModel = BoardViewModel()
    var onCodeScanned: (Board) -> Void

    var body: some View {
        VStack {
            Text("Scan QR Code or Enter Board ID")
                .font(.headline)
                .padding()

            QRScannerView(scannedCode: $scannedCode)
                .frame(width: 300, height: 300)
                .cornerRadius(12)
                .padding()

            Text("or")
                .padding()

            TextField("Enter Board ID", text: $scannedCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Submit") {
                handleScannedCode(scannedCode)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Code"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleScannedCode(_ code: String) {
        if let scannedUUID = UUID(uuidString: code) {
            fetchBoard(withID: scannedUUID)
        } else {
            alertMessage = "The scanned code is not a valid Board ID."
            showAlert = true
        }
    }

    private func fetchBoard(withID id: UUID) {
        viewModel.addBoardToCurrentDevice(boardID: id) { board in
            if let board = board {
                onCodeScanned(board)
                dismiss()
            } else {
                alertMessage = "Failed to decode board data or board not found."
                showAlert = true
            }
        }
    }
}

#Preview {
    QRScannerAndManualEntryView { board in
        print("Scanned or entered board: \(board)")
    }
}
