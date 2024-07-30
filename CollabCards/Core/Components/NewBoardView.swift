//
//  NewBoardView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI
import SwiftData

struct NewBoardView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context: ModelContext
    @State private var ideateDuration = 15
    @State private var boardName: String = ""
    
    var totalTime: Int {
        ideateDuration
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
                        TextField("Furkan Kök's workspace",text: .constant(""))
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
                
                Section {
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
            .navigationBarTitle("Board", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                }, trailing: Button(action: {
                    let newBoard = Board(name: boardName)
                    context.insert(newBoard)
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        print("Error saving context: \(error)")
                    }
                }) {
                    Text("Create").bold()
                })
        }
    }
}

#Preview {
    NewBoardView()
        .modelContainer(for: Board.self)
}
