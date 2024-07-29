//
//  RetroView.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//
import SwiftUI
import FirebaseCrashlytics

struct RetroView: View {
    @State private var retroName: String = ""
    @State private var showAlert = false
    @State private var isNavigationActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                WelcomSelectionView()
                InputFieldView(retroName: $retroName)
                HStack {
                    Button(action: {
                        retroName = ""
                        Crashlytics.log("Input field cleared.")
                    }, label: {
                        Text("CANCEL")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(5)
                    })
                    NavigationLink(
                        destination: RetrospectiveSettingsView(resetRetroName: $retroName, retroName: retroName),
                        isActive: $isNavigationActive
                    ) {
                        Button(action: {
                            if retroName.isEmpty {
                                showAlert = true
                            } else {
                                isNavigationActive = true
                                Crashlytics.log("Navigated to RetrospectiveSettingsView from RetroView.")
                            }
                        }, label: {
                            Text("NEXT")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(5)
                        })
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("CollabCards")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Empty Field"),
                    message: Text("Please enter a name before proceeding."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                retroName = ""
            }
        }
    }
}

#Preview {
    RetroView()
}
