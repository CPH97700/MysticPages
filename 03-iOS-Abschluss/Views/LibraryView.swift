//
//  LibraryView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 28.03.25.
//

// 📚 Mein virtuelles Bücherregal
// Zeigt gelesene Bücher als schöne Buchrücken im Regal – egal ob manuell eingetragen oder automatisch aus der App übernommen.
// Nutzer*innen können Bücher manuell hinzufügen, bestehende Bücher bearbeiten oder sich durch ihr Lesejournal scrollen.
// Das Regal wird in Reihen angezeigt, und jedes Buch zeigt Cover oder Platzhalter – modern & übersichtlich.
// Die Detailansicht zur Bewertung oder Notizen öffnet sich über ein Sheet.

// 📚 Mein virtuelles Bücherregal
// Sections hinzugefügt:
// - Section 1: Bewertete Bücher (manuell oder über Bewertungssheet hinzugefügt)
// - Section 2: Gelesene Bücher (aus GoogleBooks übernommen und geliked)
// Logik bleibt unverändert – nur visuelle und strukturelle Ergänzungen.

import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LibraryView: View {
    @ObservedObject var viewModel: HomeViewModel
    @StateObject var ratedBooksVM = RatedBooksViewModel()
    @StateObject var toReadVM = ToReadBooksViewModel()

    @State private var selectedBook: GoogleBook?
    @State private var showManualEntry: Bool = false

    var body: some View {
        ZStack {
            Color.clear.appBackground()

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 32) {
                    HStack {
                        Text("Mein Bücherregal")
                            .shelfHeaderStyle()
                        Spacer()
                        Button(action: {
                            showManualEntry = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .shelfAddButtonStyle()
                        }
                    }

                    if ratedBooksVM.books.isEmpty && viewModel.readBooks.isEmpty {
                        Text("Du hast noch keine Bücher im Regal 📚")
                            .shelfEmptyTextStyle()
                    } else {
                        // 🟣 Section für bewertete Bücher (manuell eingetragen oder aus BookRatingView)
                        if !ratedBooksVM.books.isEmpty {
                            Text("⭐️ Bewertete Bücher")
                                .font(.headline)
                                .padding(.horizontal)
                                .foregroundColor(.colorelements) // Farbe aus Designsystem

                            ForEach(shelfRowsRated(), id: \.[0].id) { row in
                                VStack(spacing: 0) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(alignment: .bottom, spacing: 12) {
                                            ForEach(row, id: \.id) { ratedBook in
                                                NavigationLink(destination: BookRatingViewEditor(book: ratedBook, viewModel: ratedBooksVM)) {
                                                    if let imageData = ratedBook.imageData,
                                                       let uiImage = UIImage(data: imageData) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(8)
                                                            .shadow(radius: 4)
                                                    } else {
                                                        Rectangle()
                                                            .fill(Color.gray.opacity(0.2))
                                                            .frame(width: 100, height: 150)
                                                            .overlay(
                                                                Image(systemName: "book")
                                                                    .font(.largeTitle)
                                                                    .foregroundColor(.gray)
                                                            )
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    Rectangle().shelfBaseStyle()
                                }
                            }
                        }

                        // 🔵 Section für gelesene & gelikete Bücher (GoogleBook)
                        if !viewModel.readBooks.isEmpty {
                            Text("📘 Gelesene Bücher")
                                .font(.headline)
                                .padding(.horizontal)
                                .foregroundColor(.colorelements)

                            ForEach(shelfRowsGoogle(), id: \.[0].id) { row in
                                VStack(spacing: 0) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(alignment: .bottom, spacing: 12) {
                                            ForEach(row, id: \.id) { book in
                                                Button {
                                                    withAnimation {
                                                        selectedBook = book
                                                    }
                                                } label: {
                                                    if let imageData = viewModel.imageDataForBook(book),
                                                       let uiImage = UIImage(data: imageData) {
                                                        Image(uiImage: uiImage)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 100, height: 150)
                                                            .cornerRadius(8)
                                                            .shadow(radius: 4)
                                                    } else {
                                                        AsyncImage(url: book.thumbnailURL) { phase in
                                                            switch phase {
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 100, height: 150)
                                                                    .cornerRadius(8)
                                                                    .shadow(radius: 4)
                                                            default:
                                                                Rectangle()
                                                                    .fill(Color.gray.opacity(0.2))
                                                                    .frame(width: 100, height: 150)
                                                                    .overlay(
                                                                        Image(systemName: "book")
                                                                            .font(.largeTitle)
                                                                            .foregroundColor(.gray)
                                                                    )
                                                            }
                                                        }
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    Rectangle().shelfBaseStyle()
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }

        // Sheet für BookRatingView bei GoogleBook
        .sheet(item: $selectedBook) { book in
            BookRatingView(
                initialId: UUID().uuidString,
                initialTitle: book.title,
                initialAuthor: book.author.first ?? "",
                initialCategory: Genre(rawValue: book.categories?.first ?? "") ?? .fantasy,
                initialImageData: viewModel.imageDataForBook(book),
                isManualEntry: false,
                onSave: { ratedBook in
                    ratedBooksVM.addBook(ratedBook)
                },
                onAddToToRead: { toReadBook in
                    toReadVM.addToReadBook(toReadBook)
                }
            )
        }

        // Sheet für manuelles Hinzufügen eines Buchs
        .sheet(isPresented: $showManualEntry) {
            BookRatingView(
                initialId: UUID().uuidString,
                initialTitle: "",
                initialAuthor: "",
                initialCategory: .fantasy,
                initialImageData: nil,
                isManualEntry: true,
                onSave: { ratedBook in
                    ratedBooksVM.addBook(ratedBook)
                },
                onAddToToRead: { toReadBook in
                    toReadVM.addToReadBook(toReadBook)
                }
            )
        }

        .onAppear {
            ratedBooksVM.loadBooks()
        }
    }

    private func shelfRowsGoogle() -> [[GoogleBook]] {
        let books = viewModel.readBooks
        return stride(from: 0, to: books.count, by: 8).map {
            Array(books[$0..<min($0 + 8, books.count)])
        }
    }

    private func shelfRowsRated() -> [[RatedBook]] {
        let books = ratedBooksVM.books
        return stride(from: 0, to: books.count, by: 8).map {
            Array(books[$0..<min($0 + 8, books.count)])
        }
    }
}


#Preview {
    let viewModel = HomeViewModel()
    viewModel.readBooks = [
        GoogleBook(title: "Der dunkle Turm", author: ["Stephen King"], description: "Fantasyklassiker", thumbnailURL: nil, categories: ["fantasy"]),
        GoogleBook(title: "Verliebt in der Dämmerung", author: ["Jasmin Black"], description: "Dark Romance", thumbnailURL: nil, categories: ["dark romance"])
    ]

    let sampleRatedBook = RatedBook(
        id: UUID().uuidString,
        title: "Blood & Ash",
        author: "Jennifer L. Armentrout",
        categories: .darkRomance,
        rating: 5,
        spiceRating: 4,
        note: "Sehr spannend und spicy!",
        imageData: nil
    )

    let ratedBooksVM = RatedBooksViewModel()
    ratedBooksVM.books = [sampleRatedBook]

    let toReadBooksVM = ToReadBooksViewModel()

    return LibraryView(viewModel: viewModel)
        .environmentObject(ratedBooksVM)
        .environmentObject(toReadBooksVM)
}

