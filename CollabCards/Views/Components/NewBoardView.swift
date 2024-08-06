//
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
    @State private var boardID = UUID()
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
                }
                
                Section {
                    HStack {
                        Text("Workspace")
                        Spacer()
                        TextField("Furkan Kök's workspace", text: .constant(""))
                    }
                    
                    HStack {
                        Text("Visibility")
                        Spacer()
                        Text("Workspace")
                    }
                    
                    HStack {
                        Text("Background")
                        Spacer()
                        Color.blue
                            .frame(width: 24, height: 24)
                            .cornerRadius(4)
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
                    guard let deviceID = UserDefaults.standard.string(forKey: "deviceID") else {
                        print("Device ID is not available")
                        return
                    }
                    let newBoard = Board(id: boardID, name: boardName, deviceID: deviceID, participants: [deviceID], timerValue: ideateDuration * 60)
                    onSave(newBoard)
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    NewBoardView { _ in }
}
