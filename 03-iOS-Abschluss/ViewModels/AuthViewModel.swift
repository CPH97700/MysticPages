//
//  AuthViewModel.swift
//  03-iOS-Abschluss
//
//  Erstellt von Isabell Philippi am 03.04.25.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {

    // 🧾 Aktuell eingeloggter User
    @Published var user: FirebaseAuth.User?

    // ✏️ Eingabefelder
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""

    // ⚠️ Fehlertext bei Login/Register
    @Published var errorText: String = ""

    // 🔄 Zeigt, ob RegisterView aktiv ist
    @Published var showRegister: Bool = false

    // ✅ Nutzer eingeloggt oder nicht
    var isUserLoggedIn: Bool {
        user != nil
    }

    // 🔗 Firebase Zugriff
    private let auth = Auth.auth()
    private let userRepo = UserRepository()

    // 🧠 Listener für Auth-Status
    private var listener: NSObjectProtocol?

    // MARK: - Init

    init() {
        // Beobachtet Änderungen beim Login-Zustand
        self.listener = auth.addStateDidChangeListener { auth, user in
            self.user = user
        }
    }

    // MARK: - Deinit

    deinit {
        // Listener wieder entfernen
        listener = nil
    }

    // MARK: - Registrierung

    func registerWithEmail() {
        print("Register wird ausgeführt")
        Task {
            do {
                // Nutzer registrieren
                try await userRepo.registerUserWithEmail(email: email, password: password, username: username)
            } catch {
                // Fehlerbehandlung: bekannte oder unbekannte Fehler anzeigen
                if let fireError = error as? FirebaseError {
                    errorText = fireError.rawValue
                } else {
                    errorText = error.localizedDescription
                }
            }
        }
    }


    func loginWithEmail() {
        print("Login wird ausgeführt")
        Task {
            do {
                // Login über Repository
                try await userRepo.loginUserWithEmail(email: email, password: password)
                print("login erfolgreich")
            } catch {
                // Fehler behandeln
                if let fireError = error as? FirebaseError {
                    errorText = fireError.rawValue
                } else {
                    errorText = error.localizedDescription
                }
            }
        }
    }
}
