//
//  RetrospectiveSettingsView.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//

import SwiftUI
import FirebaseCrashlytics

struct RetrospectiveSettingsView: View {
    
    @Environment(\.presentationMode) var dissmis
    
    @State private var ideateDuration = 15
    @State private var disscusDuration = 20
    
    var totalTime: Int {
        ideateDuration + disscusDuration
    }
    
    var body: some View {
        VStack {
            Text("Set the time for your retrospective steps.")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 20)
            
            DurationSettingView(stepName: "Ideate", duration: $ideateDuration)
            DurationSettingView(stepName: "Discuss (5 Whys)", duration: $disscusDuration)
            
            HStack {
                Text("Total Time")
                Spacer()
                Text("\(totalTime) min")
            }
            .padding()
            Spacer()
            
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("CANCEL")
                        .foregroundColor(.white)
                        .padding()
                        .background(.blue)
                        .cornerRadius(5)
                })
                Spacer()
                Button(action: {
                    
                }, label: {
                    NavigationLink(destination: BoardView()) {
                        Text("NEXT")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .cornerRadius(5)
                    }
                })
            }
            .padding()
            .navigationTitle("Retrospective settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.dissmis.wrappedValue.dismiss()
                        Crashlytics.log("Retrospective settings saved. Ideate Duration: \(ideateDuration) min, Discuss Duration: \(disscusDuration) min.")
                    } label: {
                        Image(systemName: "arrow.left")
                    }
                    
                }
            }
        }
    }
}

#Preview {
    RetrospectiveSettingsView()
}
