//
//  SettingsViewModel.swift
//  03-iOS-Abschluss
//
//  Created von Isabell Philippi am 12.03.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoadingUser = true
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    private var userId: String {
        Auth.auth().currentUser?.uid ?? "unknownUser"
    }
    
    init() {
        fetchUser()
    }

    // 🔄 Holt aktuelle Nutzerdaten aus Firestore
    func fetchUser() {
        guard let currentUser = Auth.auth().currentUser else {
            self.errorMessage = "Der Benutzer konnte nicht geladen werden."
            self.isLoadingUser = false
            return
        }

        db.collection("users").document(userId).getDocument { snapshot, error in
            self.isLoadingUser = false
            if let error = error {
                self.errorMessage = "Fehler beim Laden des Benutzers: \(error.localizedDescription)"
                return
            }

            if let data = snapshot?.data() {
                let user = User(
                    id: currentUser.uid,
                    email: data["E-mail"] as? String ?? "",
                    username: data["Username"] as? String ?? "",
                    profileImageData: Data(base64Encoded: data["profileImageData"] as? String ?? "")
                )
                self.user = user
            } else {
                self.errorMessage = "Der Benutzer konnte nicht gefunden werden."
            }
        }
    }

    // ✏️ Benutzernamen ändern und speichern
    func updateUsername(_ newName: String) async {
        guard var user = user else { return }
        user.username = newName
        await save(user)
    }

    // 📸 Neues Profilbild speichern
    func updateProfileImage(_ data: Data) async {
        guard var user = user else {
            self.errorMessage = "❌ Es gab ein Problem, Ihren Profil zu speichern."
            return
        }

        user.profileImageData = data
        await save(user)
    }

    // 💾 Speichert aktualisierte Benutzerdaten in Firestore
    private func save(_ user: User) async {
        guard let userId = user.id else {
            self.errorMessage = "❌ Benutzer ID fehlt, bitte authentifizieren Sie sich erneut."
            return
        }

        let userData: [String: Any] = [
            "email": user.email,
            "username": user.username,
            "profileImageData": user.profileImageData?.base64EncodedString() ?? ""
        ]

        do {
            try await db.collection("users").document(userId).setData(userData, merge: true)
            self.user = user
            print("✅ Benutzerprofil gespeichert")
        } catch {
            self.errorMessage = "❌ Fehler beim Speichern des Benutzers: \(error.localizedDescription)"
        }
    }

    // 🔓 Nutzer ausloggen
    func logOut() {
        try? Auth.auth().signOut()
    }

    // 🗑 Benutzerkonto inkl. Firestore-Daten löschen
    func deleteUser() {
        guard let currentUser = Auth.auth().currentUser else {
            self.errorMessage = "Benutzer ist nicht authentifiziert"
            return
        }

        db.collection("user").document(currentUser.uid).delete { error in
            if error != nil {
                self.errorMessage = "Fehler beim Löschen des Users"
                return
            }

            currentUser.delete { error in
                if error != nil {
                    self.errorMessage = "Fehler beim Löschen des Accounts"
                } else {
                    self.user = nil
                    self.errorMessage = "Account erfolgreich gelöscht"

                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("Fehler beim Abmelden des Nutzers")
                    }
                }
            }
        }
    }
}
