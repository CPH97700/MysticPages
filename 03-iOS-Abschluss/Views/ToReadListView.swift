//
//  ToReadView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 28.03.25.
//

// 📖 Leseliste-View
// Zeigt Bücher, die man noch lesen möchte – liebevoll gestaltet im Kachelstil.
// Cover, Titel und Autor werden angezeigt. Fehlt ein Cover, wird es automatisch nachgeladen.
// Der Hintergrund, die Karten und die Typografie folgen dem Designsystem der App.
// Diese View lädt beim Öffnen alle gespeicherten Bücher aus der Leseliste (Firestore oder lokal).

import SwiftUI

struct ToReadListView: View {
    @ObservedObject var viewModel = ToReadBooksViewModel()  // 📚 ViewModel für Leseliste

    // 📐 Zwei Spalten für schöne Grid-Darstellung
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            if viewModel.books.isEmpty {
                // 📭 Leerer Zustand
                VStack(spacing: 16) {
                    Text("Keine Bücher vorhanden")
                        .dsEmptyStateText()
                }
                .padding(.top, 60)
            } else {
                // 🧱 Bücheranzeige im Grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(viewModel.books.enumerated()), id: \.element.id) { index, book in
                        VStack(spacing: 10) {
                            // 📷 Coverbild anzeigen oder laden
                            if let imageData = book.imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .dsBookImage()
                            } else {
                                dsPlaceholderImage()
                                    .onAppear {
                                        viewModel.fetchCoverImage(for: book) { data in
                                            guard let data = data else { return }
                                            Task {
                                                await MainActor.run {
                                                    // 📥 Bilddaten lokal speichern & UI updaten
                                                    viewModel.books[index].imageData = data
                                                    viewModel.updateImageData(for: book.id, data: data)
                                                }
                                            }
                                        }
                                    }
                            }

                            // 🏷️ Titel & Autor
                            Text(book.title)
                                .dsTitleText()
                                .lineLimit(2)

                            Text(book.author)
                                .dsSubtitleText()
                        }
                        .dsCardStyle()
                    }
                }
                .padding()
            }
        }
        .dsBackground()                         // 🎨 App-Hintergrund
        .onAppear {
            viewModel.loadBooks()               // 📦 Bücher beim Öffnen laden
        }
        .navigationTitle("Meine Leseliste")     // 📚 Navigationstitel
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    class MockToReadBooksViewModel: ToReadBooksViewModel {
        override init() {
            super.init()
            self.books = [
                ToReadBook(
                    id: UUID().uuidString,
                    title: "Das Lied der Krähen",
                    author: "Leigh Bardugo",
                    categories: .fantasy,
                    imageData: nil
                ),
                ToReadBook(
                    id: UUID().uuidString,
                    title: "Fourth Wing",
                    author: "Rebecca Yarros",
                    categories: .darkRomance,
                    imageData: nil
                )
            ]
        }

        override func loadBooks() {
            
        }
    }

    return NavigationView {
        ToReadListView(viewModel: MockToReadBooksViewModel())
    }
}
