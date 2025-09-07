//
//  QuotesView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

// 💬 Zitate-View
// Zeigt täglich ein zufälliges Lieblingszitat aus einem Buch – perfekt zum Inspirieren, Schmunzeln oder Teilen!
// Nutzer*innen können durch Würfeln ein neues Zitat entdecken oder es direkt teilen.
// Das Design passt zum Notizbuch-Stil der App mit weichen Hintergründen und animiertem Übergang.
// Der View verwendet ein eigenes ViewModel, das ein lokales Zitat lädt.

import SwiftUI
import SwiftData

struct LocalQuoteOfTheDayView: View {
    @StateObject private var viewModel = LocalQuoteOfTheDayViewModel()   // 💡 ViewModel für die Zitatlogik
    @State private var showShareSheet = false                             // 📤 Zeigt das Teilen-Sheet

    var body: some View {
        ZStack {
            Color.clear.appBackground()  // 🎨 App-Design-Hintergrund

            VStack(spacing: 24) {
                if let quote = viewModel.quoteOfTheDay {
                    // 📖 Zitat-Anzeige
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Zitat des Tages")
                            .quoteTitleStyle()

                        Text("\"\(quote.quote)\"")
                            .quoteContentStyle()
                            .transition(.opacity.combined(with: .scale))
                            .id(quote.id)

                        (
                            Text("– \(quote.author), ") +
                            Text(quote.bookTitle).italic()
                        )
                        .quoteAuthorStyle()
                    }
                    .animation(.easeInOut(duration: 0.4), value: quote.id)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 6)
                    .transition(.opacity)

                    // 🎲 Würfeln & 📤 Teilen
                    HStack(spacing: 16) {
                        Button {
                            viewModel.shuffleQuote()
                        } label: {
                            Label("Würfeln", systemImage: "arrow.triangle.2.circlepath")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }

                        Button {
                            showShareSheet = true
                        } label: {
                            Label("Teilen", systemImage: "square.and.arrow.up")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                    }
                    .padding(.top, 8)

                } else {
                    // ⏳ Ladeanzeige
                    ProgressView("Lade Zitat...")
                }
            }
            .padding()
        }
        .onAppear {
            // 📥 Zitat beim Öffnen laden
            viewModel.loadQuoteOfTheDay()
        }
        .sheet(isPresented: $showShareSheet) {
            // 📤 Share-Sheet für Zitat
            if let quote = viewModel.quoteOfTheDay {
                ShareSheet(items: ["\"\(quote.quote)\" – \(quote.author), \(quote.bookTitle)"])
            }
        }
    }
}

#Preview {
    let mockViewModel = LocalQuoteOfTheDayViewModel()
    mockViewModel.quoteOfTheDay = BookQuote(
        id: "001",
        quote: "I would burn the world for you.",
        bookTitle: "Fourth Wing",
        author: "Rebecca Yarros"
    )

    return LocalQuoteOfTheDayView()
        .environmentObject(mockViewModel)
}
