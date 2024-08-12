//
//  SettingsView.swift
//  CollabCards
//
//  Created by FFK on 12.08.2024.
//

import SwiftUI

// MARK: - SettingsView
struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var boardVM = BoardViewModel()
    @State private var tempIsAuthorVisible: Bool = false
    @State private var tempIsDateVisible: Bool = false
    @Binding var isAuthorVisible: Bool
    @Binding var isDateVisible: Bool
    
    var board: Board
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            Form {
                FacilitatorControlsSection()
                VotingSettingsView()
                BackgroundSettingsView()
                EnableFeaturesSection(columns: columns, tempIsAuthorVisible: $tempIsAuthorVisible, tempIsDateVisible: $tempIsDateVisible)
                DisableFeaturesSection(
                    isMoveCardsDisabled: $boardVM.isMoveCardsDisabled,
                    isAddEditCardsDisabled: $boardVM.isAddEditCardsDisabled
                )
                ActionsSection()
                DangerZoneView(boardVM: boardVM, board: board)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Done") {
                    isAuthorVisible = tempIsAuthorVisible
                    isDateVisible = tempIsDateVisible
                    boardVM.updateBoardSettings(
                        boardID: board.id,
                        isDateVisible: isDateVisible, isMoveCardsDisabled: boardVM.isMoveCardsDisabled,
                        isAddEditCardsDisabled: boardVM.isAddEditCardsDisabled
                    )
                    dismiss()
                }
            )
        }
        .onAppear {
            tempIsAuthorVisible = isAuthorVisible
            tempIsDateVisible = isDateVisible
            boardVM.fetchBoardSettings(boardID: board.id)
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MARK: - Facilitator Controls Section
struct FacilitatorControlsSection: View {
    var body: some View {
        Section(header: Text("Facilitator Controls")) {
            CheckButtonView(isChecked: .constant(false), title: "Hide cards")
            CheckButtonView(isChecked: .constant(false), title: "Disable voting")
            CheckButtonView(isChecked: .constant(false), title: "Hide vote count")
            CheckButtonView(isChecked: .constant(false), title: "Presentation mode")
            CheckButtonView(isChecked: .constant(false), title: "Highlight mode")
        }
    }
}

// MARK: - Voting Settings Section
struct VotingSettingsView: View {
    var body: some View {
        Section(header: Text("Voting Settings")) {
            Picker("Max votes per user", selection: .constant("board")) {
                Text("Board").tag("board")
                Text("Column").tag("column")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Stepper(value: .constant(6), in: 1...10) {
                Text("6 votes per user")
            }
        }
    }
}

// MARK: - Background Settings Section
struct BackgroundSettingsView: View {
    var body: some View {
        Section(header: Text("Background")) {
            Button("Add background image") {
                // Background image addition logic
            }
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
                FeatureCardView(featureName: "GIFs", iconName: "photo")
                FeatureCardView(featureName: "Reactions", iconName: "heart")
                FeatureCardView(featureName: "Enable image", iconName: "photo.fill")
                FeatureCardView(featureName: "One vote per card", iconName: "hand.thumbsup")
                FeatureCardView(featureName: "Card's author", iconName: tempIsAuthorVisible ? "person.fill" : "person")
                    .onTapGesture {
                        tempIsAuthorVisible.toggle()
                    }
                FeatureCardView(featureName: "Card's date", iconName: tempIsDateVisible ? "calendar.circle.fill" : "calendar.circle")
                    .onTapGesture {
                        tempIsDateVisible.toggle()
                    }
                FeatureCardView(featureName: "Anon names", iconName: "eye.slash")
                FeatureCardView(featureName: "Anyone can edit", iconName: "pencil")
                FeatureCardView(featureName: "Password", iconName: "lock")
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
            CheckButtonView(isChecked: .constant(false), title: "Hide Prime Directive")
        }
    }
}

// MARK: - Actions Section
struct ActionsSection: View {
    var body: some View {
        Section(header: Text("Actions")) {
            ActionButtonView(action: { /* Copy to clipboard logic */ }, label: "Copy board to clipboard", systemImage: "doc.on.doc")
            ActionButtonView(action: { /* Import CSV logic */ }, label: "Import CSV", systemImage: "arrow.up.doc")
            ActionButtonView(action: { /* Export board logic */ }, label: "Export board", systemImage: "arrow.down.doc")
            ActionButtonView(action: { /* Embed board logic */ }, label: "Embed this board", systemImage: "chevron.left.slash.chevron.right")
            ActionButtonView(action: { /* Show/hide comments logic */ }, label: "Show/hide comments", systemImage: "text.bubble")
        }
    }
}

// MARK: - Danger Zone Section
struct DangerZoneView: View {
    @ObservedObject var boardVM: BoardViewModel
    var board: Board
    @State private var showDeleteAllCardsAlert = false
    @State private var showDeleteBoardAlert = false
    
    var body: some View {
        Section(header: Text("Danger zone").foregroundColor(.red)) {
            ActionButtonView(action: { /* Reset votes logic */ }, label: "Reset all votes", systemImage: "arrow.counterclockwise")
            ActionButtonView(action: { /* Archive board logic */ }, label: "Archive board", systemImage: "archivebox")

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
        isAuthorVisible: .constant(false),
        isDateVisible: .constant(true),
        board: Board(
            id: UUID(),
            name: "Sample Board",
            deviceID: "SampleDeviceID",
            participants: ["SampleDeviceID"]
        )
    )
}

