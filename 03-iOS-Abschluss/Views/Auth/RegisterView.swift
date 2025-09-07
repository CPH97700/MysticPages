//
//  RegisterView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI

struct RegisterView: View {
    // 🧠 ViewModel kümmert sich um Registrierung
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            // 🌈 Hintergrund mit App-Design
            Color.clear.appBackground()

            VStack(spacing: 32) {
                Spacer()

                // ✨ App-Logo oben – klein, aber wichtig für Wiedererkennung
                Image("appicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top)
                    .shadow(radius: 4)

                // 📝 Überschrift für neue Nutzer
                Text("Registrieren")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(DesignSystem.Colors.icons)
                    .padding(.bottom, 12)

                // 🧾 Eingabefelder: Username, Email, Passwort
                VStack(spacing: 18) {
                    TextField("Username", text: $viewModel.username)
                        .appTextfieldStyle()

                    TextField("Email", text: $viewModel.email)
                        .appTextfieldStyle()

                    SecureField("Password", text: $viewModel.password)
                        .appTextfieldStyle()
                }
                .padding(.horizontal)

                // 🚀 Button zum Registrieren + Umschalten zu Login
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.registerWithEmail()
                    }) {
                        Text("Register")
                            .primaryActionButtonStyle()
                    }

                    Button(action: {
                        viewModel.showRegister.toggle()
                    }) {
                        Text("Hast du bereits ein Account?")
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
    RegisterView(viewModel: AuthViewModel())
}
