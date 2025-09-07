//
//  LibraryViewModel.swift
//  03-iOS-Abschluss
//
//  Erstellt von Isabell Philippi am 05.04.25.
//

import Foundation
import SwiftUI

class LibraryViewModel: ObservableObject {
    
    // 📚 Liste der bewerteten Bücher
    @Published var ratedBooks: [RatedBook] = [] {
        didSet {
            // ⚠️ Sobald sich die Liste ändert → speichern
            saveBooks()
        }
    }
    
    // 🔑 Speicher-Schlüssel für UserDefaults
    private let saveKey = "ratedBooks"
    
    init() {
        // 📥 Lade Bücher beim Starten der App
        loadBooks()
    }
    
    // 📌 Neues Buch hinzufügen
    func addBook(_ book: RatedBook) {
        ratedBooks.append(book)
    }
    
    // 💾 Bücher lokal speichern
    private func saveBooks() {
        if let data = try? JSONEncoder().encode(ratedBooks) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    // 📤 Bücher wiederherstellen beim Starten
    func loadBooks() {
        if let saveData = UserDefaults.standard.data(forKey: saveKey) {
            let decoded = try? JSONDecoder().decode([RatedBook].self, from: saveData)
            ratedBooks = decoded ?? []
        }
    }
}
