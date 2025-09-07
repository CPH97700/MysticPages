//
//  ToReadBooksViewModel.swift
//  03-iOS-Abschluss
//
//  Created von Isabell Philippi am 08.04.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ToReadBooksViewModel: ObservableObject {
    @Published var books: [ToReadBook] = []

    private let db = Firestore.firestore()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "unknownUser"
    }

    // 📥 Holt alle To-Read-Bücher aus Firestore
    func loadBooks() {
        db.collection("users")
            .document(userId)
            .collection("toReadBooks")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Fehler beim Laden: \(error.localizedDescription)")
                    return
                }

                self.books = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    print("📘 Buch geladen: \(data)")

                    let genreString = (data["categories"] as? String ?? "").lowercased()
                    let genre = Genre(rawValue: genreString) ?? .fantasy

                    return ToReadBook(
                        id: data["id"] as? String ?? UUID().uuidString,
                        title: data["title"] as? String ?? "",
                        author: data["author"] as? String ?? "",
                        categories: genre,
                        imageData: Data(base64Encoded: data["imageData"] as? String ?? "")
                    )
                } ?? []
            }
    }

    // ➕ Fügt ein neues Buch zur To-Read-Liste hinzu
    func addToReadBook(_ book: ToReadBook) {
        let bookData: [String: Any] = [
            "id": book.id,
            "title": book.title,
            "author": book.author,
            "categories": book.categories.rawValue,
            "imageData": book.imageData?.base64EncodedString() ?? ""
        ]

        db.collection("users")
            .document(userId)
            .collection("toReadBooks")
            .addDocument(data: bookData) { error in
                if let error = error {
                    print("❌ Fehler beim Speichern: \(error.localizedDescription)")
                } else {
                    print("✅ To-Read Buch gespeichert")
                    self.loadBooks()
                }
            }
    }

    // 🌐 Holt ein Cover-Bild über die Google Books API
    func fetchCoverImage(for book: ToReadBook, completion: @escaping (Data?) -> Void) {
        let query = book.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=intitle:\(query)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,
                  let result = try? JSONDecoder().decode(GoogleBooksResponse.self, from: data),
                  let imageUrlString = result.items.first?.volumeInfo.imageLinks?.thumbnail,
                  let imageUrl = URL(string: imageUrlString.replacingOccurrences(of: "http://", with: "https://")) else {
                completion(nil)
                return
            }

            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                completion(data)
            }.resume()
        }.resume()
    }

    // 📸 Speichert das Coverbild im Firestore (als Base64)
    func updateImageData(for bookId: String, data: Data) {
        let base64String = data.base64EncodedString()

        db.collection("users")
            .document(userId)
            .collection("toReadBooks")
            .document(bookId)
            .updateData(["imageData": base64String]) { error in
                if let error = error {
                    print("❌ Fehler beim Aktualisieren des Bildes: \(error.localizedDescription)")
                } else {
                    print("✅ Bild erfolgreich in Firestore aktualisiert für Buch \(bookId)")
                }
            }
    }

    // 🗑 Löscht ein Buch aus der To-Read-Liste
    func deleteBook(_ book: ToReadBook) {
        db.collection("users")
            .document(userId)
            .collection("toReadBooks")
            .document(book.id)
            .delete { error in
                if let error = error {
                    print("❌ Fehler beim Löschen: \(error.localizedDescription)")
                } else {
                    print("✅ To-Read Buch gelöscht")
                    self.loadBooks()
                }
            }
    }

    // 🔍 Modell für die API-Datenstruktur (Google Books)
    struct GoogleBooksResponse: Decodable {
        let items: [GoogleBookItem]
    }

    struct GoogleBookItem: Decodable {
        let volumeInfo: VolumeInfo
    }

    struct VolumeInfo: Decodable {
        let imageLinks: ImageLinks?
    }

    struct ImageLinks: Decodable {
        let thumbnail: String?
    }
}
