//
//  UserRepository.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

//
//  UserRepository.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import Foundation

// Klasse kümmert sich um Login & Registrierung
class UserRepository {
    
    // Zugriff auf mein Firebase-Setup
    private let firebaseManager = FirebaseManager.shared
    
    // Verweis auf die "users"-Sammlung in Firestore (für spätere Speicherung)
    private let userRef = FirebaseManager.shared.database.collection("users")
    
    // Registrierung mit E-Mail, Passwort und Benutzername
    func registerUserWithEmail(email: String , password: String, username: String) async throws {
        do {
            print("Starte Registrierung bei Firebase Auth")
            
            // Erstellt neuen Benutzer in Firebase Auth
            let authResult = try await firebaseManager.auth.createUser(withEmail: email, password: password)
            
            // Gibt User-ID zur Kontrolle aus
            print("User created: \(authResult.user.uid)")
            
            // Optional: Später könnte man hier auch den Username speichern
        } catch {
            // Gibt Fehler in der Konsole aus
            print("Fehler in registerUserWithEmail: \(error.localizedDescription)")
            throw error // wirf den Fehler weiter
        }
    }
    
    // Login mit E-Mail und Passwort
    func loginUserWithEmail(email: String, password: String) async throws {
        // Versucht den Benutzer bei Firebase anzumelden
        try await firebaseManager.auth.signIn(withEmail: email, password: password)
    }
}
