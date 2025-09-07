//
//  FlameRatingView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 02.04.25.
//

import SwiftUI

// 🔥 Zeigt eine Bewertung mit Flammen (für z. B. „Spice Level“)
struct FlameRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            // 🔁 Loop über 1 bis 5 für die 5 möglichen Flammen
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "flame.fill" : "flame")
                    .foregroundColor(.red)
                    .onTapGesture {
                        // ✅ Bei Tap: Rating setzen
                        rating = index
                    }
            }
        }
    }
}

#Preview {
    // Vorschau mit initialem Rating = 0
    FlameRatingView(rating: .constant(0))
}
