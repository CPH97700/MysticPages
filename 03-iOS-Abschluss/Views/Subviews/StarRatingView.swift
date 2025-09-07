//
//  StarRatingView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 02.04.25.
//

import SwiftUI

// ⭐️ Diese View ist meine Sternebewertung für Bücher
struct StarRatingView: View {
    @Binding var rating: Int // Die Bewertung wird von außen übergeben und gesteuert

    var body: some View {
        HStack {
            // 5 Sterne anzeigen, je nach Wert entweder gefüllt oder leer
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index // Beim Antippen wird der Wert aktualisiert
                    }
            }
        }
    }
}

#Preview {
    StarRatingView(rating: .constant(0)) // 📱 Beispielansicht mit 0 Sternen
}
