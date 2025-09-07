//
//  RatedBooksViewModel.swift
//  03-iOS-Abschluss
//
//  Created von Isabell Philippi am 02.04.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class RatedBooksViewModel: ObservableObject {
    @Published var books: [RatedBook] = []

    // 📦 Zugriff auf Firestore-Datenbank
    private let db = Firestore.firestore()
    
    // 🔐 Aktuelle Nutzer-ID aus Firebase
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "unknownUser"
    }

    /// 📥 Lädt alle gespeicherten Bewertungen aus Firestore
    func loadBooks() {
        db.collection("users")
            .document(userId)
            .collection("ratedBooks")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Fehler beim Laden der Bewertungen: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let fetchedBooks: [RatedBook] = documents.compactMap { doc in
                    let data = doc.data()

                    return RatedBook(
                        id: data["id"] as? String ?? UUID().uuidString,
                        title: data["title"] as? String ?? "",
                        author: data["author"] as? String ?? "",
                        categories: Genre(rawValue: data["categories"] as? String ?? "") ?? .fantasy,
                        rating: data["rating"] as? Int ?? 0,
                        spiceRating: data["spiceRating"] as? Int,
                        note: data["note"] as? String ?? "",
                        imageData: Data(base64Encoded: data["imageData"] as? String ?? "")
                    )
                }

                DispatchQueue.main.async {
                    self.books = fetchedBooks
                }
            }
    }

    /// 📝 Fügt ein bewertetes Buch hinzu und speichert es in Firestore
    func addBook(_ book: RatedBook) {
        let bookData: [String: Any] = [
            "id": book.id,
            "title": book.title,
            "author": book.author,
            "categories": book.categories.rawValue,
            "rating": book.rating,
            "spiceRating": book.spiceRating ?? 0,
            "note": book.note,
            "imageData": book.imageData?.base64EncodedString() ?? ""
        ]

        db.collection("users")
            .document(userId)
            .collection("ratedBooks")
            .document(book.id)
            .setData(bookData) { error in
                if let error = error {
                    print("❌ Fehler beim Speichern des Buches: \(error.localizedDescription)")
                } else {
                    print("✅ Bewertung gespeichert: \(book.title)")
                    self.loadBooks()
                }
            }
    }

    /// ✏️ Aktualisiert ein Buch (gleich wie `addBook`, weil Firestore-Dokument-ID gleich bleibt)
    func updateBook(_ book: RatedBook) {
        addBook(book)
    }

    /// 🗑 Löscht ein Buch aus Firestore
    func deleteBook(_ book: RatedBook) {
        db.collection("users")
            .document(userId)
            .collection("ratedBooks")
            .document(book.id)
            .delete { error in
                if let error = error {
                    print("❌ Fehler beim Löschen: \(error.localizedDescription)")
                } else {
                    print("✅ Bewertung gelöscht: \(book.title)")
                    self.loadBooks()
                }
            }
    }
}
