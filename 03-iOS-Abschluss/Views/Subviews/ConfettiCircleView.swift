//
//  ConfettiCircleView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 24.03.25.
//

import SwiftUI

struct ConfettiCircleView: View {
    let index: Int       // 🎯 Reihenfolge der Animation
    let animate: Bool    // 🔄 Startet die Animation

    var body: some View {
        // 📍 Position zufällig, wenn animiert wird — sonst startet oben
        let xPos = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        let yPos = animate ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : -10

        Circle()
            .fill(randomColor())
            .frame(width: 8, height: 8)
            .position(x: xPos, y: yPos)
            .animation(
                .interpolatingSpring(stiffness: 20, damping: 5)
                    .delay(Double(index) * 0.02), // 🕒 Verzögerung pro Kreis
                value: animate
            )
    }

    /// 🎨 Gibt eine zufällige Farbe für das Konfetti zurück
    func randomColor() -> Color {
        let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
        return colors.randomElement() ?? .purple
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.1).ignoresSafeArea()
        ConfettiCircleView(index: 5, animate: true)
    }
}
