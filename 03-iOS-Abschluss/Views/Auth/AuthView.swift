//
//  AuthView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI

struct AuthView: View {
    // 🔐 Unser ViewModel kümmert sich um Login/Logout/Registrierung
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        // ✅ Wenn der User eingeloggt ist → direkt in die App (ContentView)
        if viewModel.isUserLoggedIn {
            ContentView()
        } else {
            // 🔁 Wenn der User nicht eingeloggt ist:
            // 📥 entweder Login-Ansicht ...
            // 🆕 ... oder die Registrierungsansicht, je nachdem was getoggelt ist
            if viewModel.showRegister {
                RegisterView(viewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    AuthView()
}
