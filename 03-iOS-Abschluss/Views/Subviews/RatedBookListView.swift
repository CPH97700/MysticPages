//
//  RatedBooksListView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI

// 📚 Diese View zeigt alle Bücher an, die ich bewertet habe
struct RatedBooksListView: View {
    @StateObject var viewModel = RatedBooksViewModel()
    
    var body: some View {
        NavigationView {
            List {
                // 📖 Durch alle bewerteten Bücher iterieren
                ForEach(viewModel.books) { book in
                    // 👉 Beim Tippen gelangt man zur Bearbeitungs-Ansicht
                    NavigationLink(destination: BookRatingViewEditor(book: book, viewModel: viewModel)) {
                        Text(book.title)
                    }
                }
                // 🗑 Bücher können gelöscht werden
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let book = viewModel.books[index]
                        viewModel.deleteBook(book)
                    }
                }
            }
            .navigationTitle("Meine Bewertungen") // 🏷 Überschrift in der Navigation
            .onAppear {
                viewModel.loadBooks() // 🔄 Beim Öffnen: Bewertungen aus Firestore laden
            }
        }
    }
}

#Preview {
    RatedBooksListView()
}
