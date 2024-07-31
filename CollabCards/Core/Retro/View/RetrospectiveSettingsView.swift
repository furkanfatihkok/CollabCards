//
//  RetrospectiveSettingsView.swift
//  CollabCards
//
//  Created by FFK on 25.07.2024.
//

//import SwiftUI
//import FirebaseCrashlytics
//
//struct RetrospectiveSettingsView: View {
//    @Environment(\.presentationMode) var dismiss
//    
//    @Binding var resetRetroName: String
//    
//    @State private var ideateDuration = 15
//    @State private var discussDuration = 20
//    
//    var retroName: String
//    var totalTime: Int {
//        ideateDuration + discussDuration
//    }
//    
//    var body: some View {
//        VStack {
//            Text("Set the time for your retrospective steps.")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .padding(.top, 20)
//            
//            DurationSettingView(duration: $ideateDuration, stepName: "Ideate")
//            DurationSettingView(duration: $discussDuration, stepName: "Discuss (5 Whys)")
//            
//            HStack {
//                Text("Total Time")
//                Spacer()
//                Text("\(totalTime) min")
//            }
//            .padding()
//            Spacer()
//            
//            HStack {
//                Button(action: {
//                    self.dismiss.wrappedValue.dismiss()
//                }, label: {
//                    Text("CANCEL")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(5)
//                })
//                Spacer()
//                NavigationLink(destination: BoardView(ideateDuration: ideateDuration, discussDuration: discussDuration)) {
//                    Text("NEXT")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(5)
//                }
//            }
//            .padding()
//        }
//        .navigationTitle(retroName)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//#Preview {
//    RetrospectiveSettingsView(resetRetroName: .constant(""), retroName: "Example Retro")
//}
