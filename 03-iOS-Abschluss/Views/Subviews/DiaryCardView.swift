//
//  DiaryCardView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 28.03.25.
//

import SwiftUI

struct DiaryCardView: View {
    let book: GoogleBook
    let buttonTitle: String
    let onButtonTap: () -> Void
    let onTap: () -> Void

    var body: some View {
        HStack {
            // 📚 Buchtitel & Autor
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(.primary)

                if let author = book.author.first {
                    Text(author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // ✅ Button z. B. für "Gelesen"
            Button(action: onButtonTap) {
                Text(buttonTitle)
                    .font(.caption)
                    .padding(6)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground)) // 🎨 Hintergrundfarbe im Systemstil
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onTapGesture {
            onTap() // 👆 Tapping auf die Karte z. B. für Details
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DiaryCardView(
        book: GoogleBook(
            title: "Die Schattenchroniken",
            author: ["Luna Schwarz"],
            description: "Eine düstere Reise durch verborgene Welten.",
            thumbnailURL: nil
        ),
        buttonTitle: "✓ Gelesen",
        onButtonTap: {
            print("Gelesen gedrückt")
        },
        onTap: {
            print("Card angetippt")
        }
    )
    .padding()
}
