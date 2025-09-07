//
//  LoginView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI

struct LoginView: View {
    // 👤 ViewModel regelt Authentifizierung
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            // 🎨 Hintergrund im App-Style (LinearGradient)
            Color.clear.appBackground()

            VStack(spacing: 32) {
                Spacer()

                // 🧙‍♀️ Logo der App – gibt gleich visuelle Wiedererkennung
                Image("appicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding(.top)
                    .shadow(radius: 4)
                    .cornerRadius(20)

                // 👋 Begrüßung
                Text("Willkommen zurück")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(DesignSystem.Colors.icons)
                    .padding(.bottom, 12)

                // ✏️ Eingabefelder für Login
                VStack(spacing: 18) {
                    TextField("Email", text: $viewModel.email)
                        .appTextfieldStyle()

                    SecureField("Password", text: $viewModel.password)
                        .appTextfieldStyle()
                }
                .padding(.horizontal)

                // 🔐 Login-Button & Option zum Registrieren
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.loginWithEmail()
                    }) {
                        Text("Login")
                            .primaryActionButtonStyle()
                    }

                    Button(action: {
                        viewModel.showRegister.toggle()
                    }) {
                        Text("Noch kein Account?")
                            .font(.footnote)
                            .foregroundColor(DesignSystem.Colors.buttons)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
