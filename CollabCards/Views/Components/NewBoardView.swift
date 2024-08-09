//  NewBoardView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import EFQRCode

struct NewBoardView: View {
    // MARK: - Properties
    
    @Environment(\.dismiss) var dismiss
    @State private var ideateDuration = 15
    @State private var boardName: String = ""
    @State private var boardID = UUID()
    @State private var isBoardNameValid = true
    @State private var username: String = ""
    @State private var isUsernameValid = true
    @State private var password: String = ""
    @State private var isPasswordVisible = false
    @State private var isPasswordValid = true
    var onSave: (Board) -> Void
    // MARK: - QR Code Generation
    
    var qrCode: UIImage? {
        let generator = EFQRCodeGenerator(content: boardID.uuidString)
        if let cgImage = generator.generate() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    BoardNameInputView(boardName: $boardName, isBoardNameValid: $isBoardNameValid)
                }
                
                UserCredentialsView(
                    username: $username,
                    isUsernameValid: $isUsernameValid,
                    password: $password,
                    isPasswordVisible: $isPasswordVisible,
                    isPasswordValid: $isPasswordValid
                )
                
                TimerView()
                
                QRCodeView(qrCode: qrCode, boardID: boardID)
            }
            .navigationBarTitle("Board", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button(action: {
                    isBoardNameValid = !boardName.isEmpty
                    isUsernameValid = !username.isEmpty
                    isPasswordValid = !password.isEmpty
                    if isBoardNameValid && isUsernameValid && isPasswordValid {
                        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
                            print("Device ID is not available")
                            return
                        }
                        let usernames = [deviceID: username]
                        let newBoard = Board(id: boardID, name: boardName, deviceID: deviceID, participants: [deviceID], timerValue: ideateDuration * 60, usernames: usernames, password: password)
                        UserDefaults.standard.set(username, forKey: "username")
                        onSave(newBoard)
                        dismiss()
                    }
                }) {
                    Text("Create")
                }
            )
        }
    }
}


#Preview {
    NewBoardView { _ in }
}
// MARK: - BoardNameInputView

struct BoardNameInputView: View {
    @Binding var boardName: String
    @Binding var isBoardNameValid: Bool
    
    var body: some View {
        TextField("New Board", text: $boardName)
            .onChange(of: boardName) { newValue in
                isBoardNameValid = !newValue.isEmpty
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isBoardNameValid ? Color.clear : Color.red, lineWidth: 2)
                    .padding(-10)
            )
    }
}
// MARK: - UserCredentialsView

struct UserCredentialsView: View {
    @Binding var username: String
    @Binding var isUsernameValid: Bool
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    @Binding var isPasswordValid: Bool
    
    var body: some View {
        Section {
            HStack {
                Text("Username")
                Spacer()
                TextField("Username", text: $username)
                    .onChange(of: username) { newValue in
                        isUsernameValid = !newValue.isEmpty
                    }
                    .frame(maxWidth: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(isUsernameValid ? Color.clear : Color.red, lineWidth: 2)
                    )
            }
            
            HStack {
                Text("Password")
                Spacer()
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
                .frame(maxWidth: 200)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isPasswordValid ? Color.clear : Color.red, lineWidth: 2)
                )
            }
        }
    }
}
// MARK: - QRCodeView

struct QRCodeView: View {
    var qrCode: UIImage?
    var boardID: UUID
    
    var body: some View {
        Section(header: Text("QR Code & Board ID")) {
            if let qrCodeImage = qrCode {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            Text("Board ID: \(boardID.uuidString)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}
// MARK: - TimerView

struct TimerView: View {
    @State private var ideateDuration = 15
    
    var totalTime: Int {
        ideateDuration
    }
    var body: some View {
        Section(header: Text("Timer")) {
            VStack {
                Text("Set the time for your retrospective steps.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                
                DurationSettingView(duration: $ideateDuration, stepName: "Ideate")
                
                HStack {
                    Text("Total Time")
                    Spacer()
                    Text("\(totalTime) min")
                }
                .padding()
            }
        }
    }
}
