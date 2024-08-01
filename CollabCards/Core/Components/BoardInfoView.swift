//
//  BoardInfoView.swift
//  CollabCards
//
//  Created by FFK on 31.07.2024.
//

import SwiftUI
import SwiftData
import EFQRCode

struct BoardInfoView: View {
    var board: Board
    
    var qrCode: UIImage? {
        let generator = EFQRCodeGenerator(content: board.id.uuidString)
        if let cgImage = generator.generate() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Board Information")
                .font(.title)
                .padding()
            
            if let qrCodeImage = qrCode {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
            Text("Board ID: \(board.id.uuidString)")
                .font(.body)
                .foregroundColor(.gray)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BoardInfoView(board: Board(id: UUID(), name: "Örnek Board"))
        .modelContainer(for: Board.self)
}
