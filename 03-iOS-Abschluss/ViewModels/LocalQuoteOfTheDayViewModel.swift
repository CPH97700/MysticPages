//
//  LocalQuoteOfTheDayViewModel.swift
//  03-iOS-Abschluss
//
//  Erstellt von Isabell Philippi am 08.04.25.
//

import Foundation
import SwiftData

class LocalQuoteOfTheDayViewModel: ObservableObject {
    
    // 🧠 Das aktuelle Zitat für heute
    @Published var quoteOfTheDay: BookQuote?
    
    // ❤️ Ist das aktuelle Zitat als Favorit markiert?
    @Published var isFavorite: Bool = false

    // 📚 Alle verfügbaren Zitate aus der JSON-Datei im Bundle
    private let quotes: [BookQuote] = Bundle.main.decode("quotes.json")
    
    // 🔑 Schlüssel für die gespeicherten Favoriten
    private let favoriteKey = "favoriteQuotes"
    
    // 🗓 Dynamischer Schlüssel für das Tageszitat (jeden Tag anders)
    private var cacheKey: String {
        let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        return "local_quote_\(dateString)"
    }

    // 📥 Lade das Zitat des Tages (ggf. aus dem Cache)
    func loadQuoteOfTheDay() {
        if let cachedData = UserDefaults.standard.data(forKey: cacheKey),
           let cachedQuote = try? JSONDecoder().decode(BookQuote.self, from: cachedData) {
            self.quoteOfTheDay = cachedQuote
            self.checkIfFavorite()
            return
        }

        // 🎲 Wenn nichts im Cache ist: Neues zufälliges Zitat
        shuffleQuote()
    }

    // 🔁 Neues Zitat ziehen (und lokal speichern)
    func shuffleQuote() {
        guard !quotes.isEmpty else { return }
        let newQuote = quotes.randomElement()!
        quoteOfTheDay = newQuote
        isFavorite = false

        if let encoded = try? JSONEncoder().encode(newQuote) {
            UserDefaults.standard.set(encoded, forKey: cacheKey)
        }
    }

    // ⭐️ Aktuelles Zitat als Favorit markieren oder entfernen
    func markAsFavorite() {
        guard let quote = quoteOfTheDay else { return }

        var saved = UserDefaults.standard.stringArray(forKey: favoriteKey) ?? []
        if saved.contains(quote.id) {
            saved.removeAll { $0 == quote.id }
            isFavorite = false
        } else {
            saved.append(quote.id)
            isFavorite = true
        }
        UserDefaults.standard.set(saved, forKey: favoriteKey)
    }

    // ✅ Prüfen, ob das aktuelle Zitat ein Favorit ist
    func checkIfFavorite() {
        guard let quote = quoteOfTheDay else { return }
        let saved = UserDefaults.standard.stringArray(forKey: favoriteKey) ?? []
        isFavorite = saved.contains(quote.id)
    }
}
