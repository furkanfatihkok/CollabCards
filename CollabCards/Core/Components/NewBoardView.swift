//
//  NewBoardView.swift
//  CollabCards
//
//  Created by FFK on 30.07.2024.
//

import SwiftUI

struct NewBoardView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var ideateDuration = 15
    
    //    var retroName: String
    var totalTime: Int {
        ideateDuration
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("New Board", text: .constant(""))
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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }, trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Create").bold()
                })
        }
    }
}

struct NewBoardView_Previews: PreviewProvider {
    static var previews: some View {
        NewBoardView()
    }
}
