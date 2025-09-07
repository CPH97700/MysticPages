//
//  BookCardView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import SwiftUI

struct BookCardView: View {
    let book: GoogleBook
    let flipped: Bool

    var body: some View {
        ZStack {
            // 🃏 Rückseite der Karte – sichtbar, wenn nicht geflippt
            backView
                .opacity(flipped ? 0.0 : 1.0)
                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // 📘 Vorderseite mit Buchcover & Infos – erscheint beim Flip
            frontView
                .opacity(flipped ? 1.0 : 0.0)
                .rotation3DEffect(.degrees(flipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .bookCardContainerStyle()
        .animation(.easeInOut(duration: 0.5), value: flipped) // 🎬 Smooth Flip-Animation
    }

    // 📘 Vorderseite mit Cover, Titel & Autor
    var frontView: some View {
        VStack(spacing: 14) {
            if let url = book.thumbnailURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // ⏳ Ladeanzeige
                    case .success(let image):
                        image.bookImageStyle() // 📚 Gestyltes Buchcover
                    default:
                        Image(systemName: "book.closed")
                            .font(.largeTitle)
                            .frame(height: 200)
                            .foregroundColor(.gray)
                    }
                }
            }

            VStack(spacing: 4) {
                Text(book.title)
                    .textStyleTitle()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(maxWidth: 160)

                Text("von \(book.author.joined(separator: ", "))")
                    .textStyleAuthor()
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: 160)
            }
        }
        .bookCardFrontStyle()
    }

    // 🎭 Rückseite mit Fragezeichen
    var backView: some View {
        RoundedRectangle(cornerRadius: 30)
            .bookCardBackStyle()
            .overlay(
                Image(systemName: "questionmark.app.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.9))
            )
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8)
    }
}

#Preview {
    let dummyBook = GoogleBook(
        title: "Das Reich der sieben Höfe – Dornen und Rosen",
        author: ["Sarah J. Maas"],
        description: "Eine epische Fantasy-Saga voller Spannung und Liebe.",
        thumbnailURL: URL(string: "https://books.google.com/books/content?id=abc123&printsec=frontcover&img=1&zoom=1&source=gbs_api")
    )

    return VStack {
        BookCardView(book: dummyBook, flipped: true)
        BookCardView(book: dummyBook, flipped: false)
    }
}
