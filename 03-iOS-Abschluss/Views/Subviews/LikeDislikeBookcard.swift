//
//  LikeDislikeBookcard.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 26.03.25.
//

import SwiftUI

// 📚 Kombinierte View mit Buchkarte + Like-/Dislike-Buttons
struct LikeDislikeBookcard: View {
    let book: GoogleBook
    let flipped: Bool
    let likeAction: () -> Void
    let dislikeAction: () -> Void
    @Binding var showSaveConfirmation: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 24) {
                
                // ❌ Dislike-Button links
                Button(action: dislikeAction) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 52, height: 52)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }

                // 📖 Buchkarte + Titel & Autor zentriert
                VStack(spacing: 10) {
                    BookCardView(book: book, flipped: flipped)
                        .frame(width: geometry.size.width * 0.5)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 6)

                    VStack(spacing: 4) {
                        Text(book.title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                            .truncationMode(.tail)

                        if let author = book.author.first {
                            Text("von \(author)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: geometry.size.width * 0.5)
                }

                // ❤️ Like-Button rechts
                Button(action: {
                    likeAction()
                    showSaveConfirmation = true
                }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.pink)
                        .frame(width: 52, height: 52)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
        }
        .frame(height: 370)
        .transition(.scale.combined(with: .opacity))
    }
}

// MARK: - Vorschau mit Dummybuch + Alert bei Like
#Preview {
    struct LikeDislikeBookcardPreviewWrapper: View {
        @State private var showSaveConfirmation = false

        var body: some View {
            let dummyBook = GoogleBook(
                title: "Das Reich der sieben Höfe – Dornen und Rosen",
                author: ["Sarah J. Maas"],
                description: "Eine epische Fantasy-Saga voller Spannung und Liebe.",
                thumbnailURL: URL(string: "https://books.google.com/books/content?id=abc123&printsec=frontcover&img=1&zoom=1&source=gbs_api")
            )

            VStack {
                LikeDislikeBookcard(
                    book: dummyBook,
                    flipped: false,
                    likeAction: {
                        print("✅ Liked")
                        showSaveConfirmation = true
                    },
                    dislikeAction: {
                        print("❌ Disliked")
                    },
                    showSaveConfirmation: $showSaveConfirmation
                )
            }
            .alert("Buch gespeichert!", isPresented: $showSaveConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("„\(dummyBook.title)“ wurde zu deiner Leseliste hinzugefügt.")
            }
            .padding()
        }
    }

    return LikeDislikeBookcardPreviewWrapper()
}
