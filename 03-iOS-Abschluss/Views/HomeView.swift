//
//  HomeView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var showSheet: Bool = false
    @State private var showSaveConfirmation: Bool = false
    @State private var animateBook: Bool = false
    @Namespace private var genreAnimation

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .appBackground()
                    .ignoresSafeArea()

                VStack(spacing: 10) {
                    // 📚 Titel & Untertitel
                    VStack(spacing: 6) {
                        Text("Blind Date mit einem Buch")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        Text("Finde dein nächstes Leseabenteuer")
                            .font(.title3)
                            .foregroundColor(.colorbackground)
                            .bold()
                    }
                    .padding(.top, 20)

                    // 🎯 Genre-Auswahl
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.genres, id: \.self) { genre in
                                genreButton(for: genre)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                    }

                    // 📦 Buchanzeige
                    Group {
                        if viewModel.isLoading {
                            Spacer()
                            loadingView
                            Spacer()
                        } else if let book = viewModel.revealedBook {
                            Spacer()

                            LikeDislikeBookcard(
                                book: book,
                                flipped: viewModel.flipped,
                                likeAction: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        viewModel.likeBook(book)
                                        showSaveConfirmation = true
                                    }
                                },
                                dislikeAction: {
                                    Task {
                                        await viewModel.dislikeBook()
                                    }
                                },
                                showSaveConfirmation: $showSaveConfirmation
                            )
                            .offset(y: -30)
                            .opacity(animateBook ? 1 : 0)
                            .offset(y: animateBook ? 0 : 100)
                            .animation(.easeOut(duration: 0.4), value: animateBook)
                            .onTapGesture {
                                showSheet = true
                            }
                            .onAppear { animateBook = true }
                            .onChange(of: viewModel.revealedBook) { _ in
                                animateBook = false
                                Task {
                                    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 Sekunden
                                    await MainActor.run {
                                        animateBook = true
                                    }
                                }
                            }

                            Spacer(minLength: 90)
                        } else {
                            Spacer()
                            Text("Noch kein Genre? Dein Blind Date ist schon ganz aufgeregt!")
                                .font(DesignSystem.Fonts.subheadline)
                                .foregroundColor(.color)
                                .bold()
                            Spacer()
                        }
                    }
                }
                .padding()

                if viewModel.showConfetti {
                    ConfettiView()
                        .animatedOverlay(true)
                }
            }
            .navigationBarHidden(true)
            .alert("Buch gespeichert!", isPresented: $showSaveConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("\"\(viewModel.revealedBook?.title ?? "Ein Buch")\" wurde zu deiner Leseliste hinzugefügt.")
            }
            .sheet(isPresented: $showSheet) {
                if let book = viewModel.revealedBook {
                    BookDetailView(book: book)
                }
            }
        }
    }

    // Ladeanzeige
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: DesignSystem.Colors.icons))

            Text("Ein Buch tippt nervös seine Bio ...")
                .font(DesignSystem.Fonts.subheadline)
                .foregroundColor(.secondary)
        }
    }

    // 🎯 Genre-Button mit Icon & Farbverlauf
    @ViewBuilder
    private func genreButton(for genre: String) -> some View {
        let isSelected = viewModel.selectedGenre == genre
        let gradient = genreGradient(for: genre)
        let emoji = genreEmoji(for: genre)

        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                viewModel.selectGenre(genre)
            }
        }) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(gradient)
                        .matchedGeometryEffect(id: "genreBackground", in: genreAnimation)
                        .frame(height: 40)
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                }

                HStack(spacing: 8) {
                    Text(emoji)
                    Text(genre)
                        .fontWeight(.semibold)
                }
                .foregroundColor(isSelected ? .white : .primary.opacity(0.7))
                .padding(.horizontal, 18)
                .frame(height: 40)
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .buttonStyle(.plain)
    }

    private func genreEmoji(for genre: String) -> String {
        switch genre {
        case "Fantasy": return "🧝"
        case "Dark Romance": return "❤️‍🔥"
        case "Young Adult": return "📘"
        default: return "📚"
        }
    }

    private func genreGradient(for genre: String) -> LinearGradient {
        switch genre {
        case "Fantasy":
            return LinearGradient(colors: [Color.purple.opacity(0.4), Color.purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Dark Romance":
            return LinearGradient(colors: [Color.red.opacity(0.4), Color.red.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case "Young Adult":
            return LinearGradient(colors: [Color.blue.opacity(0.4), Color.blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.15)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}


#Preview {
    HomeView()
}
