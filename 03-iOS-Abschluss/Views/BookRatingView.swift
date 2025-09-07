//
//  BookRatingView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import SwiftUI
import PhotosUI

// 📚 Diese View habe ich gebaut, damit Nutzer Bücher bewerten, ein Cover hinzufügen und Notizen machen können.
struct BookRatingView: View {
    // Initialwerte (z. B. beim Bearbeiten vorbelegen)
    var initialId: String = UUID().uuidString
    var initialTitle: String = ""
    var initialAuthor: String = ""
    var initialCategory: Genre = .fantasy
    var initialImageData: Data? = nil
    var initialRating: Int = 0
    var initialSpiceRating: Int = 0
    var initialNote: String = ""
    var isManualEntry: Bool = true

    var onSave: (RatedBook) -> Void
    var onAddToToRead: (ToReadBook) -> Void

    @Environment(\.dismiss) private var dismiss

    // States für Felder & UI-Logik
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var category: Genre = .fantasy
    @State private var rating: Int = 0
    @State private var spiceRating: Int = 0
    @State private var notes: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    @State private var editingNote: Bool = false
    @State private var edtingSpiceRating: Bool = false
    @State private var editingRating: Bool = false

    var body: some View {
        List {
            // 🧾 Abschnitt für Titel, Autor & Genre
            Section(header: Text("Buchdetails").sectionHeaderStyle()) {
                TextField("Titel", text: $title).customTextFieldStyle()
                TextField("Autor", text: $author).customTextFieldStyle()

                if isManualEntry {
                    Picker("Genre", selection: $category) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            Text(genre.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                } else {
                    Text("Genre: \(category.rawValue)")
                        .foregroundColor(.secondary)
                }
            }
            .sectionCardStyle()

            // ⭐️ Abschnitt für Bewertung (Sterne + ggf. Spice)
            Section(header: Text("Bewertung").sectionHeaderStyle()) {
                if editingRating {
                    VStack(alignment: .leading) {
                        StarRatingView(rating: $rating)
                        if category == .darkRomance {
                            FlameRatingView(rating: $spiceRating)
                        }
                    }
                } else {
                    HStack {
                        Text("Sternebewertung")
                        Spacer()
                        StarRatingView(rating: $rating)
                    }
                    if category == .darkRomance {
                        HStack {
                            Text("Spice Rating")
                            Spacer()
                            FlameRatingView(rating: $spiceRating)
                        }
                    }
                }

                Button {
                    editingRating.toggle()
                } label: {
                    Label(editingRating ? "Bewertung speichern" : "Bewertung bearbeiten", systemImage: "pencil")
                }
                .plainActionButtonStyle()
            }
            .sectionCardStyle()

            // 📝 Abschnitt für Notizen
            Section(header: Text("Notizen").sectionHeaderStyle()) {
                if editingNote {
                    TextEditor(text: $notes).noteTextEditorStyle()
                } else {
                    Text(notes.isEmpty ? "keine notizen vorhanden" : notes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                }

                Button {
                    editingNote.toggle()
                } label: {
                    Label(editingNote ? "Fertig" : "Notizen bearbeiten", systemImage: "pencil")
                }
                .plainActionButtonStyle()
            }
            .sectionCardStyle()

            // 🖼 Abschnitt für Cover
            Section(header: Text("Cover Foto").sectionHeaderStyle()) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage).imagePreviewStyle()
                    } else {
                        Label("Foto auswählen", systemImage: "photo")
                            .foregroundColor(Color("coloricons"))
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            imageData = data
                        }
                    }
                }

                // 💾 Speichern-Button
                Button("Speichern") {
                    let ratedBook = RatedBook(
                        id: initialId,
                        title: title.isEmpty ? "Unbekannter Titel" : title,
                        author: author.isEmpty ? "Unbekannter Autor" : author,
                        categories: category,
                        rating: rating,
                        spiceRating: category == .darkRomance ? spiceRating : nil,
                        note: notes,
                        imageData: imageData
                    )

                    onSave(ratedBook)
                    dismiss()
                }
                .primaryActionButtonStyle()
            }
            .sectionCardStyle()
        }
        .navigationTitle("Buch bewerten")
        .onAppear {
            // ✨ Initialwerte übernehmen
            title = initialTitle
            author = initialAuthor
            category = initialCategory
            imageData = initialImageData
            rating = initialRating
            spiceRating = initialSpiceRating
            notes = initialNote
        }
    }
}

#Preview {
    BookRatingView(
        initialTitle: "Vorschau-Buch",
        initialAuthor: "Isabell",
        initialCategory: .fantasy,
        initialImageData: nil,
        initialRating: 4,
        initialNote: "Schönes Buch",
        isManualEntry: true,
        onSave: { book in
            print("Preview: Bewertetes Buch gespeichert → \(book)")
        },
        onAddToToRead: { toReadBook in
            print("Preview: Buch zur To-Read-Liste hinzugefügt → \(toReadBook)")
        }
    )
}
