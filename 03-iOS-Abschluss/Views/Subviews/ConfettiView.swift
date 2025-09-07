//
//  ConfettiView.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 24.03.25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false   // 🎉 Steuert, ob Konfetti animiert werden

    var body: some View {
        ZStack {
            // 💫 Erzeugt mehrere Konfetti-Kreise
            ForEach(0..<30, id: \.self) { i in
                ConfettiCircleView(index: i, animate: animate)
            }
        }
        .ignoresSafeArea() // 🌌 Konfetti darf über Bildschirmränder hinausfliegen
        .onAppear {
            animate = true // 🚀 Startet die Animation beim Erscheinen
        }
    }
}

#Preview {
    ConfettiView()
}
