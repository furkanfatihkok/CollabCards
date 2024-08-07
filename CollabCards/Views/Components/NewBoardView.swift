//  NewBoardView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import EFQRCode

struct NewBoardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var ideateDuration = 15
    @State private var boardName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var boardID = UUID()
    @State private var isBoardNameValid = true
    @State private var isUsernameValid = true
    @State private var isPasswordValid = true
    @State private var showPassword = false 
    var onSave: (Board) -> Void
    
    var totalTime: Int {
        ideateDuration
    }
    
    var qrCode: UIImage? {
        let generator = EFQRCodeGenerator(content: boardID.uuidString)
        if let cgImage = generator.generate() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("New Board", text: $boardName)
                        .onChange(of: boardName) { newValue in
                            isBoardNameValid = !newValue.isEmpty
                        }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isBoardNameValid ? Color.clear : Color.red, lineWidth: 2)
                        .padding(-10)
                )
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Username")
                        TextField("Username", text: $username)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(isUsernameValid ? Color.clear : Color.red, lineWidth: 2)
                            )
                            .onChange(of: username) { newValue in
                                isUsernameValid = !newValue.isEmpty
                            }
                    }
                    VStack(alignment: .leading) {
                        Text("Password")
                        ZStack(alignment: .trailing) {
                            if showPassword {
                                TextField("Password", text: $password)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(isPasswordValid ? Color.clear : Color.red, lineWidth: 2)
                                    )
                                    .onChange(of: password) { newValue in
                                        isPasswordValid = !newValue.isEmpty
                                    }
                            } else {
                                SecureField("Password", text: $password)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(isPasswordValid ? Color.clear : Color.red, lineWidth: 2)
                                    )
                                    .onChange(of: password) { newValue in
                                        isPasswordValid = !newValue.isEmpty
                                    }
                            }
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                
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
            .navigationBarTitle("Board", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Create") {
                    isBoardNameValid = !boardName.isEmpty
                    isUsernameValid = !username.isEmpty
                    isPasswordValid = !password.isEmpty
                    
                    if isBoardNameValid && isUsernameValid && isPasswordValid {
                        guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
                            print("Device ID is not available")
                            return
                        }
                        let newBoard = Board(id: boardID, name: boardName, deviceID: deviceID, participants: [deviceID], timerValue: ideateDuration * 60, username: username, password: password)
                        onSave(newBoard)
                        dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    NewBoardView { _ in }
}
