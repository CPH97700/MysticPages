//
//  DiaryView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import SwiftUI

// 📝 Hier verwalte ich mein Buch-Tagebuch: To-Read & Gelesene Bücher
struct DiaryView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var selectedBook: GoogleBook?

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 🔁 Navigation oben: Zum Regal oder zur To-Read-Liste
                    HStack(spacing: 16) {
                        NavigationLink(destination: LibraryView(viewModel: viewModel)) {
                            Label("Zum Bücherregal", systemImage: "books.vertical")
                                .libraryButtonStyle()
                        }

                        Spacer()

                        NavigationLink(destination: ToReadListView()) {
                            Label("Zur Leseliste", systemImage: "book")
                                .toReadButtonStyle()
                        }
                    }
                    .padding(.horizontal)

                    // 📚 Bereich: Noch zu lesen
                    if !viewModel.toReadBooks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("To Read")
                                .sectionHeaderStyle()
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                ForEach(viewModel.toReadBooks, id: \.id) { book in
                                    DiaryCardView(
                                        book: book,
                                        buttonTitle: "✓ Gelesen"
                                    ) {
                                        // ✅ Als gelesen markieren
                                        viewModel.markAsRead(book)
                                    } onTap: {
                                        selectedBook = book
                                    }
                                }
                            }
                        }
                        .sectionCardStyle()
                        .padding(.horizontal)
                    }

                    // 📘 Bereich: Bereits gelesen
                    if !viewModel.readBooks.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mein Bücherregal")
                                .sectionHeaderStyle()
                                .padding(.horizontal)

                            VStack(spacing: 12) {
                                ForEach(viewModel.readBooks, id: \.id) { book in
                                    DiaryCardView(
                                        book: book,
                                        buttonTitle: "🗑 Entfernen"
                                    ) {
                                        // 🗑 Buch aus Gelesen entfernen
                                        viewModel.removeFromRead(book)
                                    } onTap: {
                                        selectedBook = book
                                    }
                                }
                            }
                        }
                        .sectionCardStyle()
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .appBackground()
            .navigationTitle("📖 Mein Tagebuch")
            .sheet(item: $selectedBook) { book in
                // 🔍 Bei Tap auf Buch: Detailansicht anzeigen
                BookDetailView(book: book)
            }
        }
    }
}

#Preview {
    let viewModel = HomeViewModel()
    let sampleBook = GoogleBook(
        title: "Example Book",
        author: ["Author Name"],
        description: "Sample description.",
        thumbnailURL: nil
    )
    viewModel.toReadBooks.append(sampleBook)
    viewModel.readBooks.append(sampleBook)
    return DiaryView(viewModel: viewModel)
}
