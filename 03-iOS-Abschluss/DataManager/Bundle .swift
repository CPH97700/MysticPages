//
//  Bundle .swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 08.04.25.
//


import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        // 1. Datei suchen
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("❌ Datei \(file) nicht im Bundle gefunden.")
        }

        // 2. Inhalt laden
        guard let data = try? Data(contentsOf: url) else {
            fatalError("❌ Datei \(file) konnte nicht geladen werden.")
        }

        // 3. JSON dekodieren
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("❌ Datei \(file) konnte nicht dekodiert werden.")
        }

        return loaded
    }
}
