//
//  QRScannerAndManualEntryView.swift
//  CollabCards
//
//  Created by FFK on 2.08.2024.
//

import SwiftUI
import FirebaseFirestore
import AVFoundation
import FirebaseCrashlytics

struct QRScannerAndManualEntryView: View {
    // MARK: - Properties
    
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
    @ObservedObject var boardVM = BoardViewModel()
    var onCodeScanned: (Board, String) -> Void
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            QRHeaderView()
            
            QRScannerContainerView(scannedCode: $scannedCode)
            
            Text("or")
                .padding()
            
            ManualEntryView(
                manualCode: $manualCode,
                username: $username,
                password: $password,
                isPasswordVisible: $isPasswordVisible,
                isUsernameValid: $isUsernameValid,
                isPasswordValid: $isPasswordValid
            )
            
            SubmitButtonView {
                Crashlytics.log("Submit button pressed with manual code: \(manualCode)")
                handleScannedCode(manualCode)
            }
            
            Spacer()
        }
        .padding()
        .onChange(of: scannedCode) { newCode in
            Crashlytics.log("QR code scanned: \(newCode)")
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
    
    // MARK: - Functions
    
    private func handleScannedCode(_ code: String) {
        isUsernameValid = !username.isEmpty
        isPasswordValid = !password.isEmpty
        
        guard isUsernameValid, isPasswordValid else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            Crashlytics.log("Validation failed: Missing username or password.")
            return
        }
        
        if code.isEmpty { return }
        
        if let scannedUUID = UUID(uuidString: code) {
            boardVM.verifyPassword(boardID: scannedUUID, enteredPassword: password) { isValid in
                if isValid {
                    Crashlytics.log("Password verified successfully for board ID: \(scannedUUID.uuidString)")
                    self.fetchBoard(withID: scannedUUID)
                } else {
                    Crashlytics.log("Password verification failed for board ID: \(scannedUUID.uuidString)")
                    self.isPasswordValid = false
                    self.alertMessage = "Incorrect password."
                    self.showAlert = true
                }
            }
        } else {
            alertMessage = "The scanned code is not a valid Board ID."
            showAlert = true
            Crashlytics.log("Invalid Board ID scanned or entered: \(code)")
            if scannedCode == code {
                scannedCode = ""
            } else {
                manualCode = ""
            }
        }
    }
    
    private func fetchBoard(withID id: UUID) {
        boardVM.addBoardToCurrentDevice(boardID: id) { board in
            if let board = board {
                Crashlytics.log("Board successfully fetched with ID: \(id.uuidString)")
                boardVM.updateUsernameInFirestore(boardID: id, username: self.username)
                UserDefaults.standard.set(self.username, forKey: "username")
                onCodeScanned(board, self.username)
                dismiss()
            } else {
                Crashlytics.log("Failed to fetch board with ID: \(id.uuidString)")
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

// MARK: - QRHeaderView

struct QRHeaderView: View {
    var body: some View {
        VStack {
            Text("Scan QR Code or Enter Board ID")
                .font(.headline)
                .padding()
        }
    }
}

// MARK: - QRScannerContainerView

struct QRScannerContainerView: View {
    @Binding var scannedCode: String
    
    var body: some View {
        QRScannerView(scannedCode: $scannedCode)
            .frame(width: 300, height: 300)
            .cornerRadius(12)
            .padding()
    }
}

// MARK: - ManualEntryView

struct ManualEntryView: View {
    @Binding var manualCode: String
    @Binding var username: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    @Binding var isUsernameValid: Bool
    @Binding var isPasswordValid: Bool
    
    var body: some View {
        VStack {
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
        }
    }
}

// MARK: - SubmitButtonView

struct SubmitButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Submit")
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}
