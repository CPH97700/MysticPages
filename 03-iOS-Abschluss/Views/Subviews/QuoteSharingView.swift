//
//  QuoteSharingView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 08.04.25.
//

import SwiftUI

// 📚 Diese View zeigt ein Zitat und ermöglicht das Teilen per ShareSheet
struct QuoteSharingView: View {
    @State private var showShareSheet = false

    // ✨ Beispiel-Zitat
    let quote = "„I would burn the world for you.“"
    let author = "Rebecca Yarros"
    let book = "Fourth Wing"

    var body: some View {
        VStack(spacing: 20) {
            // 📝 Zitat im Fokus
            Text(quote)
                .italic()
                .font(.title3)
                .multilineTextAlignment(.center)

            // 👩‍💼 Autor + Buchtitel
            Text("– \(author), *\(book)*")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            // 🔗 Teilen-Button
            Button(action: {
                showShareSheet = true
            }) {
                Label("Teilen", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .padding()
        // 📤 ShareSheet wird angezeigt, wenn Button getappt
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["\(quote) – \(author), \(book)"])
        }
    }
}

#Preview {
    QuoteSharingView()
}
