//
//  ContentView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 14.03.25.
//

import SwiftUI

// 🧭 Das ist der Einstiegspunkt der App – hier wird gesteuert, welcher Tab aktiv ist.
struct ContentView: View {
    @State private var selectedTab: TabEnum = .home
    @Namespace private var animation
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        ZStack(alignment: .bottom) {
            // 📱 Die jeweilige View zum aktiven Tab wird angezeigt
            selectedTab.tabView(viewModel: viewModel)
                .ignoresSafeArea()

            // 🧩 Custom TabBar
            HStack(spacing: 0) {
                ForEach(TabEnum.allCases) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                // 🎨 Hintergrund + leichter Shadow + Outline für die TabBar
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("colorbuttons"))
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: -4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
                    .blur(radius: 0.2)
            )
            .padding(.horizontal, 15)
            .padding(.bottom, 5)
        }
    }

    // 🔘 Ein einzelner Tab-Button
    @ViewBuilder
    private func tabButton(for tab: TabEnum) -> some View {
        let isSelected = selectedTab == tab

        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color("colorelements"))
                            .matchedGeometryEffect(id: "circle", in: animation)
                            .frame(width: 48, height: 48)
                            .shadow(color: Color("colorelements").opacity(0.4), radius: 6, y: 4)
                    }

                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Color.white.opacity(0.75))
                }

                Text(tab.title)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white : Color.white.opacity(0.75))
                    .padding(.top, 2)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
