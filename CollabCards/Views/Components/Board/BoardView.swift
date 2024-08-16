//
//  BoardView.swift
//  CollabCards
//
//  Created by FFK on 26.07.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCrashlytics

struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var cardVM = CardViewModel()
    @StateObject var boardVM = BoardViewModel()
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var isPaused = true
    @State private var isLoading = true
    @State private var cardToEdit: Card? = nil
    @State private var board: Board?
    @State private var timerValue: Int = 15 * 60
    @State private var showAlert = false
    @State private var isAuthorVisible = true
    @State private var isDateVisible = false
    @State private var isHideCards = false
    @State private var isMoveCardsDisabled = false
    @State private var isAddEditCardsDisabled = false

    var boardID: UUID
    var username: String
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                if let board = board {
                    VStack {
                        HStack(spacing: 20) {
                            Button(action: {
                                dismiss()
                                Crashlytics.log("Back button pressed, dismissing BoardView.")
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 20) {
                                Text(board.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                HStack {
                                    Text(timerString(from: TimeInterval(timerValue)))
                                        .foregroundColor(.white)
                                        .onReceive(timer) { _ in
                                            handleTimerTick()
                                        }
                                    HStack {
                                        Button(action: {
                                            toggleTimerPause()
                                        }) {
                                            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                                .foregroundColor(.white)
                                        }
                                        .disabled(board.isExpired ?? false)
                                        
                                        Button(action: {
                                            resetTimer()
                                        }) {
                                            Image(systemName: "stop.fill")
                                                .foregroundColor(.white)
                                        }
                                        .disabled(board.isExpired ?? false)

                                    }
                                }
                            }
                            Spacer()
                            NavigationLink(destination: SettingsView(
                                hideCards: $isHideCards,
                                isAuthorVisible: $isAuthorVisible,
                                isDateVisible: $isDateVisible,
                                isMoveCardsDisabled: $isMoveCardsDisabled,
                                isAddEditCardsDisabled: $isAddEditCardsDisabled,
                                board: board,
                                onDismiss: {
                                    toggleTimerPause()
                                }
                            )
                            .onAppear {
                                toggleTimerPause() // Timer'ı durdur SettingsView açıldığında
                            }) {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                            }
                            .disabled(board.isExpired ?? false)
                        }
                        .padding()
                        .background(Color.blue)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            VStack {
                                Text("Went Well")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 8)
                                ScrollView(.vertical, showsIndicators: false) {
                                    CardColumnView(
                                        cards: $cardVM.cards,
                                        allCards: $cardVM.cards,
                                        statusFilter: "went well",
                                        cardVM: cardVM,
                                        onEdit: { card in
                                            cardToEdit = card
                                            showEditSheet = true
                                            Crashlytics.log("Editing card with id: \(String(describing: card.id))")
                                        },
                                        onDelete: { card in
                                            cardVM.deleteCard(card, from: boardID.uuidString)
                                            Crashlytics.log("Deleted card with id: \(String(describing: card.id))")
                                        },
                                        boardID: boardID.uuidString,
                                        board: board,
                                        isAuthorVisible: isAuthorVisible,
                                        isDateVisible: isDateVisible,
                                        isAddEditCardsDisabled: isAddEditCardsDisabled,
                                        isMoveCardsDisabled: isMoveCardsDisabled
                                    )
                                    .blur(radius: board.hideCards ? 5 : 0)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            
                            VStack {
                                Text("To Improve")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 8)
                                ScrollView(.vertical, showsIndicators: false) {
                                    CardColumnView(
                                        cards: $cardVM.cards,
                                        allCards: $cardVM.cards,
                                        statusFilter: "to improve",
                                        cardVM: cardVM,
                                        onEdit: { card in
                                            cardToEdit = card
                                            showEditSheet = true
                                            Crashlytics.log("Editing card with id: \(String(describing: card.id))")
                                        },
                                        onDelete: { card in
                                            cardVM.deleteCard(card, from: boardID.uuidString)
                                            Crashlytics.log("Deleted card with id: \(String(describing: card.id))")
                                        },
                                        boardID: boardID.uuidString,
                                        board: board,
                                        isAuthorVisible: isAuthorVisible,
                                        isDateVisible: isDateVisible,
                                        isAddEditCardsDisabled: isAddEditCardsDisabled,
                                        isMoveCardsDisabled: isMoveCardsDisabled
                                    )
                                    .blur(radius: board.hideCards ? 5 : 0)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            
                            VStack {
                                Text("Action Items")
                                    .font(.title2)
                                    .bold()
                                    .padding(.bottom, 8)
                                ScrollView(.vertical, showsIndicators: false) {
                                    CardColumnView(
                                        cards: $cardVM.cards,
                                        allCards: $cardVM.cards,
                                        statusFilter: "action items",
                                        cardVM: cardVM,
                                        onEdit: { card in
                                            cardToEdit = card
                                            showEditSheet = true
                                            Crashlytics.log("Editing card with id: \(String(describing: card.id))")
                                        },
                                        onDelete: { card in
                                            cardVM.deleteCard(card, from: boardID.uuidString)
                                            Crashlytics.log("Deleted card with id: \(String(describing: card.id))")
                                        },
                                        boardID: boardID.uuidString,
                                        board: board,
                                        isAuthorVisible: isAuthorVisible,
                                        isDateVisible: isDateVisible,
                                        isAddEditCardsDisabled: isAddEditCardsDisabled,
                                        isMoveCardsDisabled: isMoveCardsDisabled
                                    )
                                    .blur(radius: board.hideCards ? 5 : 0)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                        }
                        .padding(.horizontal)
                    }
                    Button(action: {
                        if timerValue > 0 {
                            showAddSheet.toggle()
                            Crashlytics.log("Add card button pressed.")
                        } else {
                            Crashlytics.log("Ready all cards button pressed.")
                        }
                    }) {
                        Text(timerValue > 0 ? "Add Card" : "Ready All Cards")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(board.isExpired ?? false || isAddEditCardsDisabled)

                } else if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .onAppear {
                        loadBoard()
                        Crashlytics.log("BoardView loading board with ID: \(boardID.uuidString)")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                if let board = board {
                    AddCardView(cardVM: cardVM, boardID: boardID.uuidString, boardUsername: username)
                }
            }
            .sheet(isPresented: $showEditSheet) {
                if let card = cardToEdit, let board = board {
                    EditCardView(
                        card: .constant(card),
                        title: .constant(card.title),
                        status: .constant(card.status),
                        cardVM: cardVM,
                        onSave: { updatedCard in
                            if let index = cardVM.cards.firstIndex(where: { $0.id == card.id }) {
                                cardVM.cards[index] = updatedCard
                                cardVM.editCard(updatedCard, in: boardID.uuidString)
                                Crashlytics.log("Card edited with id: \(String(describing: card.id))")
                            }
                            cardToEdit = nil
                            showEditSheet = false
                        },
                        boardID: boardID.uuidString,
                        boardUsername: username
                    )
                }
            }
            .onAppear {
                cardVM.fetchCards(for: boardID.uuidString)
                loadBoard()
                boardVM.fetchBoardWithRealtimeUpdates(boardID: boardID) { fetchedBoard in
                    if let fetchedBoard = fetchedBoard {
                        self.isDateVisible = fetchedBoard.isDateVisible ?? false
                        self.isHideCards = fetchedBoard.hideCards
                        self.isMoveCardsDisabled = fetchedBoard.isMoveCardsDisabled ?? false
                        self.isAddEditCardsDisabled = fetchedBoard.isAddEditCardsDisabled ?? false
                    }
                }
            }
            .onDisappear {
                timer.upstream.connect().cancel()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text("It will switch off automatically after the last 1 minute."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func handleTimerTick() {
        if !isPaused {
            if timerValue > 0 {
                timerValue -= 1
                boardVM.updateTimerInFirestore(boardID: boardID, timerValue: timerValue)
                if timerValue == 60 {
                    showAlert = true
                }
            } else {
                Crashlytics.log("Timer reached zero.")
                isPaused = true
                boardVM.updateTimerStatusInFirestore(boardID: boardID, isPaused: isPaused)
                boardVM.setBoardExpired(boardID: boardID)
                dismiss()
            }
        }
    }
    
    private func toggleTimerPause() {
        isPaused.toggle()
        boardVM.updateTimerStatusInFirestore(boardID: boardID, isPaused: isPaused)
        Crashlytics.log(isPaused ? "Timer paused." : "Timer resumed.")
    }
    
    private func resetTimer() {
        timerValue = board?.timerValue ?? 15 * 60
        isPaused = true
        boardVM.updateTimerStatusInFirestore(boardID: boardID, isPaused: isPaused)
        Crashlytics.log("Timer reset to initial duration.")
    }
    
    private func loadBoard() {
        boardVM.fetchBoardWithRealtimeUpdates(boardID: boardID) { fetchedBoard in
            if let fetchedBoard = fetchedBoard {
                self.board = fetchedBoard
                self.isDateVisible = fetchedBoard.isDateVisible ?? false
                self.isHideCards = fetchedBoard.hideCards
                self.isMoveCardsDisabled = fetchedBoard.isMoveCardsDisabled ?? false
                self.isAddEditCardsDisabled = fetchedBoard.isAddEditCardsDisabled ?? false
                if let timerValue = fetchedBoard.timerValue {
                    self.timerValue = timerValue
                }
                if let isPaused = fetchedBoard.isPaused {
                    self.isPaused = isPaused
                }
                if let isExpired = fetchedBoard.isExpired {
                    self.board?.isExpired = isExpired
                }
                Crashlytics.log("Board loaded with ID: \(fetchedBoard.id.uuidString)")
            } else {
                Crashlytics.log("Failed to load board with ID: \(boardID.uuidString)")
            }
            self.isLoading = false
        }
    }
}

func timerString(from timeInterval: TimeInterval) -> String {
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

#Preview {
    BoardView(boardID: UUID(), username: "FFK")
}

