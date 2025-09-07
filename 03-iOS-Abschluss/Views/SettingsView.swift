//
//  SettingsView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

// ⚙️ Einstellungen-View
// Ermöglicht Nutzer*innen, ihr Profilbild anzupassen, den Namen und die Mail zu sehen und sich auszuloggen.
// Zusätzlich kann das Nutzerkonto gelöscht werden – direkt über Firebase Auth.
// Das Design ist an das restliche App-Design angepasst: modern, rund, weich und benutzerfreundlich.

import SwiftUI
import PhotosUI
import FirebaseAuth

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()           // ✅ ViewModel einbinden

    @State private var username: String = "username"                   // 🧑 Aktueller Nutzername
    @State private var email: String = "E-mail"                        // 📧 Nutzer-Mail
    @State private var showImagePicker = false                         // 🖼 Steuert Bilderauswahl-Button
    @State private var profileImage: UIImage?                          // 📷 Ausgewähltes Profilbild
    @State private var imageItem: PhotosPickerItem?                    // 🔄 Bilddaten von der Auswahl

    var body: some View {
        ZStack {
            Color.clear.appBackground()  // 🎨 App-Hintergrund

            VStack(spacing: 28) {
                // 🏷️ Überschrift
                Text("Einstellungen")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                        .first ?? 44)
                    .padding(.horizontal)

                // 👤 Profilbereich
                VStack(spacing: 10) {
                    ZStack(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $imageItem, matching: .images) {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 3))
                                    .shadow(radius: 8)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 130, height: 130)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 48))
                                            .foregroundColor(.white.opacity(0.7))
                                    )
                                    .shadow(radius: 6)
                            }
                        }

                        // ➕ Button zum neuen Bild auswählen
                        Button {
                            showImagePicker = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 26))
                                .foregroundColor(.accentColor)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 30, height: 30)
                                )
                                .offset(x: -5, y: -5)
                        }
                    }
                    // 📥 Bilddaten bei Auswahl laden
                    .onChange(of: imageItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = uiImage
                            }
                        }
                    }

                    // 🧾 Nutzerinfos
                    Text(username)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)

                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Passwort: ••••••")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider().padding(.horizontal)

                // 🚪 Logout & 🗑 Account löschen
                VStack(spacing: 14) {
                    Button(action: {
                        viewModel.logOut()  // ✅ Funktionierender Logout
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.85))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button(action: {
                        deleteUser()
                    }) {
                        Label("Nutzer löschen", systemImage: "trash")
                            .font(.subheadline.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.bottom, 16)
        }
    }

    // 🗑 Nutzerkonto löschen über Firebase Auth
    func deleteUser() {
        guard let currentUser = Auth.auth().currentUser else {
            print("Benutzer ist nicht authentifiziert.")
            return
        }

        currentUser.delete { error in
            if let error = error {
                print("Fehler beim Löschen des Benutzers: \(error.localizedDescription)")
            } else {
                print("Benutzer erfolgreich gelöscht.")
                // 🔁 Hier könnte zur LoginView navigiert werden
            }
        }
    }
}

#Preview {
    SettingsView()
}
