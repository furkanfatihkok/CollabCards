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
    @State private var manualCode: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var isUsernameValid = true
    @State private var isPasswordValid = true
    @ObservedObject var viewModel = BoardViewModel()
    var onCodeScanned: (Board, String) -> Void

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

            TextField("Enter Board ID", text: $manualCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isUsernameValid ? Color.gray : Color.red, lineWidth: 2)
                )

            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isPasswordValid ? Color.gray : Color.red, lineWidth: 2)
            )

            Button(action: {
                handleScannedCode(manualCode)
            }) {
                Text("Submit")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .onChange(of: scannedCode) { newCode in
            handleScannedCode(newCode)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func handleScannedCode(_ code: String) {
        isUsernameValid = !username.isEmpty
        isPasswordValid = !password.isEmpty

        guard isUsernameValid, isPasswordValid else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        if code.isEmpty { return }

        if let scannedUUID = UUID(uuidString: code) {
            viewModel.verifyPassword(boardID: scannedUUID, enteredPassword: password) { isValid in
                if isValid {
                    self.fetchBoard(withID: scannedUUID)
                } else {
                    self.isPasswordValid = false
                    self.alertMessage = "Incorrect password."
                    self.showAlert = true
                }
            }
        } else {
            alertMessage = "The scanned code is not a valid Board ID."
            showAlert = true
            if scannedCode == code {
                scannedCode = ""
            } else {
                manualCode = ""
            }
        }
    }

    private func fetchBoard(withID id: UUID) {
        viewModel.addBoardToCurrentDevice(boardID: id) { board in
            if let board = board {
                viewModel.updateUsernameInFirestore(boardID: id, username: self.username)
                UserDefaults.standard.set(self.username, forKey: "username")
                onCodeScanned(board, self.username)
                dismiss()
            } else {
                alertMessage = "Failed to decode board data or board not found."
                showAlert = true
                if scannedCode == id.uuidString {
                    scannedCode = ""
                } else {
                    manualCode = ""
                }
            }
        }
    }
}

#Preview {
    QRScannerAndManualEntryView { board, username in
        print("Scanned or entered board: \(board), username: \(username)")
    }
}

