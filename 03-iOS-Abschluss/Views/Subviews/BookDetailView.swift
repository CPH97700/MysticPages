//
//  BookDetailView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 28.03.25.
//

import SwiftUI

struct BookDetailView: View {
    let book: GoogleBook

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 📚 Buchcover mit Lade-Handling
                AsyncImage(url: book.thumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.top)
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 250)
                            .cornerRadius(12)
                            .padding(.top)
                    }
                }

                // 📝 Titel & Autor zentriert
                VStack(spacing: 4) {
                    Text(book.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text("von \(book.author.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // 📖 Beschreibung mit Hintergrundkarte
                VStack(alignment: .leading, spacing: 12) {
                    Text("Beschreibung")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(book.description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            .padding(.bottom, 32)
        }
        .background(Color.clear.appBackground()) // 🎨 App-Hintergrund verwenden
    }
}

#Preview {
    let sampleBook = GoogleBook(
        title: "Die Schattenprinzessin",
        author: ["Isabell Night"],
        description: "Ein düster-romantisches Abenteuer voller Magie, Geheimnisse und dunkler Versuchung.",
        thumbnailURL: URL(string: "https://example.com/cover.jpg")
    )
    
    return BookDetailView(book: sampleBook)
}
