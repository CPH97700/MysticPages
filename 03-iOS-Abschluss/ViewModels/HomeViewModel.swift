//
//  HomeViewModel.swift
//  03-iOS-Abschluss
//
//  Erstellt von Isabell Philippi am 12.03.25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class HomeViewModel: ObservableObject {

    // 🔮 UI-Zustände und Daten
    @Published var selectedGenre: String = "Wähle ein Genre"
    @Published var isLoading: Bool = false
    @Published var revealedBook: GoogleBook? = nil
    @Published var showConfetti: Bool = false
    @Published var flipped: Bool = false

    // 📚 Bücherlisten
    @Published var favoriteBooks: [GoogleBook] = []
    @Published var toReadBooks: [GoogleBook] = []
    @Published var readBooks: [GoogleBook] = []

    // 🖼 Gespeicherte Bilder zu Büchern (Key: Book ID)
    @Published var bookImages: [String: Data] = [:]

    // 🎯 Auswahlmöglichkeiten für Genres
    let genres = ["Fantasy", "Dark Romance", "Young Adult"]

    // 🔗 Verbindung zu Firestore
    private let db = Firestore.firestore()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "unknownUser"
    }

    // MARK: - Genre auswählen & Buch anzeigen

    func selectGenre(_ genre: String) {
        // Genre festlegen + UI resetten
        selectedGenre = genre
        revealedBook = nil
        isLoading = true
        flipped = false
        showConfetti = false

        // Warte 2 Sekunden → dann Buch anzeigen
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await revealBook(for: genre)
        }
    }

    func revealBook(for genre: String) async {
        // Genre in Suchbegriff für Google Books API umwandeln
        let mappedQuery: String
        switch genre {
        case "Dark Romance": mappedQuery = "dark+romance"
        case "Young Adult": mappedQuery = "young+adult+fantasy"
        case "Fantasy": mappedQuery = "fantasy+romance"
        default: mappedQuery = genre
        }

        let startIndex = Int.random(in: 0...40)
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=\(mappedQuery)&langRestrict=de&printType=books&orderBy=relevance&maxResults=40&startIndex=\(startIndex)"

        guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encoded) else {
            print("❌ Ungültige URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(GoogleBookResponse.self, from: data)

            let validBooks = decoded.items
                .map { GoogleBook(from: $0) }
                .filter { $0.thumbnailURL != nil && !$0.title.isEmpty }

            // 📖 Zufälliges Buch mit Bild auswählen
            if let randomBook = validBooks.randomElement() {
                withAnimation(.easeInOut(duration: 0.6)) {
                    revealedBook = randomBook
                    isLoading = false
                }

                // Animation + Konfetti anzeigen
                try? await Task.sleep(nanoseconds: 300_000_000)
                withAnimation(.easeInOut(duration: 0.6)) {
                    flipped = true
                    showConfetti = true
                }

                try? await Task.sleep(nanoseconds: 3_000_000_000)
                withAnimation {
                    showConfetti = false
                }

            } else {
                print("⚠️ Keine passenden Bücher mit Bildern gefunden.")
                withAnimation {
                    isLoading = false
                    revealedBook = nil
                    flipped = false
                }
            }
        } catch {
            print("❌ API-Fehler: \(error.localizedDescription)")
            withAnimation {
                isLoading = false
                revealedBook = nil
            }
        }
    }

    // Buch liken & speichern

    func likeBook(_ book: GoogleBook) {
        if !toReadBooks.contains(where: { $0.title == book.title }) {
            toReadBooks.append(book)

            // 📸 Coverbild automatisch speichern
            if let url = book.thumbnailURL {
                Task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        await MainActor.run {
                            self.bookImages[book.id] = data
                            self.saveBookToToReadList(book)
                        }
                    } catch {
                        print("❌ Fehler beim Laden des Covers: \(error.localizedDescription)")
                        self.saveBookToToReadList(book) // trotzdem speichern
                    }
                }
            } else {
                saveBookToToReadList(book)
            }

            print("📚 Buch zur To-Read-Liste hinzugefügt: \(book.title)")
        }
    }


    // Buch in Firestore speichern
    private func saveBookToToReadList(_ book: GoogleBook) {
        let id = UUID().uuidString
        let title = book.title
        let author = book.author.first
        let genre = selectedGenre.lowercased()
        let imageDataString = bookImages[book.id]?.base64EncodedString() ?? ""

        let bookData: [String: Any] = [
            "id": id,
            "title": title,
            "author": author ?? "Unknown Author",
            "categories": genre,
            "imageData": imageDataString
        ]

        db.collection("users")
            .document(userId)
            .collection("toReadBooks")
            .document(id)
            .setData(bookData) { error in
                if let error = error {
                    print("❌ Fehler beim Speichern in Leseliste: \(error.localizedDescription)")
                } else {
                    print("✅ Buch zur Leseliste in Firestore gespeichert")
                }
            }
    }

    // Buch disliken

    func dislikeBook() async {
        guard selectedGenre != "Wähle ein Genre" else { return }
        await revealBook(for: selectedGenre)
    }

    // Bücherlisten verwalten

    func addToReadBook(_ book: GoogleBook) {
        guard !toReadBooks.contains(where: { $0.title == book.title }) else { return }
        toReadBooks.append(book)
    }

    func markAsRead(_ book: GoogleBook) {
        guard let index = toReadBooks.firstIndex(where: { $0.title == book.title }) else { return }
        toReadBooks.remove(at: index)
        readBooks.append(book)
    }

    func removeFromRead(_ book: GoogleBook) {
        readBooks.removeAll(where: { $0.title == book.title })
    }

    func removeFromToRead(_ book: GoogleBook) {
        toReadBooks.removeAll(where: { $0.title == book.title })
    }

    // Bilddaten abrufen

    func imageDataForBook(_ book: GoogleBook) -> Data? {
        let key = book.id
        return bookImages[key]
    }
}
