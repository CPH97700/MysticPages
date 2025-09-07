//
//  BookRatingViewEditor.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI

struct BookRatingViewEditor: View {
    @Environment(\.dismiss) var dismiss
    @State var book: RatedBook
    @ObservedObject var viewModel: RatedBooksViewModel
    @StateObject var toReadVM = ToReadBooksViewModel()

    var body: some View {
        BookRatingView(
            initialId: book.id,
            initialTitle: book.title,
            initialAuthor: book.author,
            initialCategory: book.categories,
            initialImageData: book.imageData,
            initialRating: book.rating,
            initialSpiceRating: book.spiceRating ?? 0,
            initialNote: book.note,
            isManualEntry: true,
            
            // ✅ Buch speichern & schließen
            onSave: { updatedBook in
                viewModel.updateBook(updatedBook)
                dismiss()
            },
            
            // 📚 Optional: Buch zur To-Read-Liste hinzufügen
            onAddToToRead: { book in
                toReadVM.addToReadBook(book)
            }
        )
        .toolbar {
            // 🗑️ Löschen in der Toolbar
            Button("Löschen", role: .destructive) {
                viewModel.deleteBook(book)
                dismiss()
            }
        }
    }
}

#Preview {
    let placeholderImage = UIImage(systemName: "book")!
    let imageData = placeholderImage.pngData()

    let sampleBook = RatedBook(
        id: UUID().uuidString,
        title: "Nightshade Academy",
        author: "Raven Black",
        categories: .darkRomance,
        rating: 5,
        spiceRating: 4,
        note: "So spicy! 😍",
        imageData: imageData
    )

    let viewModel = RatedBooksViewModel()
    viewModel.books = [sampleBook]

    return BookRatingViewEditor(book: sampleBook, viewModel: viewModel)
}
