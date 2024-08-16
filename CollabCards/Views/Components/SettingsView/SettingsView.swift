//
//  SettingsView.swift
//  CollabCards
//
//  Created by FFK on 12.08.2024.
//

import SwiftUI
import FirebaseCrashlytics

// MARK: - SettingsView
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var boardVM = BoardViewModel()
    @State private var tempIsAuthorVisible: Bool = false
    @State private var tempIsDateVisible: Bool = false
    @State private var tempHideCards: Bool = false
    @Binding var hideCards: Bool
    @Binding var isAuthorVisible: Bool
    @Binding var isDateVisible: Bool
    @Binding var isMoveCardsDisabled: Bool
    @Binding var isAddEditCardsDisabled: Bool
    
    var board: Board
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            Form {
                FacilitatorControlsSection(hideCards: $tempHideCards)
                EnableFeaturesSection(
                    columns: columns,
                    tempIsAuthorVisible: $tempIsAuthorVisible,
                    tempIsDateVisible: $tempIsDateVisible
                )
                DisableFeaturesSection(
                    isMoveCardsDisabled: $isMoveCardsDisabled,
                    isAddEditCardsDisabled: $isAddEditCardsDisabled
                )
                DangerZoneView(boardVM: boardVM, board: board)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    Crashlytics.log("SettingsView: Cancel button tapped")
                    dismiss()
                },
                trailing: Button("Done") {
                    applyChanges()
                    dismiss()
                }
            )
        }
        .onAppear {
            tempIsAuthorVisible = isAuthorVisible
            tempIsDateVisible = isDateVisible
            tempHideCards = hideCards
            boardVM.fetchBoardSettings(boardID: board.id)
            Crashlytics.log("SettingsView appeared for board: \(board.name)")
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func applyChanges() {
        isAuthorVisible = tempIsAuthorVisible
        isDateVisible = tempIsDateVisible
        hideCards = tempHideCards
        
        boardVM.updateBoardSettings(
            boardID: board.id,
            isDateVisible: isDateVisible,
            isMoveCardsDisabled: isMoveCardsDisabled,
            isAddEditCardsDisabled: isAddEditCardsDisabled,
            hideCards: hideCards
        )
        Crashlytics.log("SettingsView: Done button tapped, settings updated for board: \(board.name)")
    }
}

// MARK: - Facilitator Controls Section
struct FacilitatorControlsSection: View {
    @Binding var hideCards: Bool
    
    var body: some View {
        Section(header: Text("Facilitator Controls")) {
            CheckButtonView(isChecked: $hideCards, title: "Hide cards")
        }
    }
}

// MARK: - Enable Features Section
struct EnableFeaturesSection: View {
    let columns: [GridItem]
    @Binding var tempIsAuthorVisible: Bool
    @Binding var tempIsDateVisible: Bool
    
    var body: some View {
        Section(header: Text("Enable Features")) {
            LazyVGrid(columns: columns, spacing: 16) {
                FeatureCardView(featureName: "Card's author", iconName: tempIsAuthorVisible ? "person.fill" : "person")
                    .onTapGesture {
                        tempIsAuthorVisible.toggle()
                    }
                FeatureCardView(featureName: "Card's date", iconName: tempIsDateVisible ? "calendar.circle.fill" : "calendar.circle")
                    .onTapGesture {
                        tempIsDateVisible.toggle()
                    }
            }
            .padding(.vertical, 10)
        }
    }
}
// MARK: - Disable Features Section
struct DisableFeaturesSection: View {
    @Binding var isMoveCardsDisabled: Bool
    @Binding var isAddEditCardsDisabled: Bool
    
    var body: some View {
        Section(header: Text("Disable Features")) {
            CheckButtonView(isChecked: $isMoveCardsDisabled, title: "Disable Move cards")
            CheckButtonView(isChecked: $isAddEditCardsDisabled, title: "Disable Add/edit cards")
        }
    }
}

// MARK: - Danger Zone Section
struct DangerZoneView: View {
    @ObservedObject var boardVM: BoardViewModel
    @State private var showDeleteAllCardsAlert = false
    @State private var showDeleteBoardAlert = false
    var board: Board
    
    var body: some View {
        Section(header: Text("Danger zone").foregroundColor(.red)) {
            ActionButtonView(action: {
                showDeleteAllCardsAlert = true
            }, label: "Delete all cards", systemImage: "trash")
            .foregroundColor(.gray)
            .alert(isPresented: $showDeleteAllCardsAlert) {
                Alert(
                    title: Text("Delete all cards"),
                    message: Text("This action cannot be undone. Are you sure you want to delete all cards?"),
                    primaryButton: .destructive(Text("Delete")) {
                        boardVM.deleteAllCards(for: board.id)
                    },
                    secondaryButton: .cancel()
                )
            }
            
            ActionButtonView(action: {
                showDeleteBoardAlert = true
            }, label: "Delete board", systemImage: "trash")
            .foregroundColor(.gray)
            .alert(isPresented: $showDeleteBoardAlert) {
                Alert(
                    title: Text("Delete board"),
                    message: Text("This action cannot be undone. Are you sure you want to delete this board?"),
                    primaryButton: .destructive(Text("Delete")) {
                        boardVM.deleteBoard(board)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


// MARK: - FeatureCardView
struct FeatureCardView: View {
    let featureName: String
    let iconName: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .frame(width: 50, height: 50)
                .font(.largeTitle)
                .foregroundColor(.gray)
            Text(featureName)
                .font(.caption)
                .foregroundColor(.primary)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    SettingsView(
        hideCards: .constant(true),
        isAuthorVisible: .constant(false),
        isDateVisible: .constant(true),
        isMoveCardsDisabled: .constant(false),
        isAddEditCardsDisabled: .constant(true),
        board: Board(
            id: UUID(),
            name: "Sample Board",
            deviceID: "SampleDeviceID",
            participants: ["SampleDeviceID"]
        )
    )
}

