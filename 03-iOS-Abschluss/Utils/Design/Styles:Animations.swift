//
//  Styles:Animations.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 10.04.25.
//

import Foundation
import SwiftUI

extension View {

    // Effekt: Karte dreht sich bei Flip (z. B. bei Buchkarten)
    func threeDCardEffect(flipped: Bool) -> some View {
        self
            .rotation3DEffect(
                .degrees(flipped ? 180 : 0), // 180° bei "flipped"
                axis: (x: 0, y: 1, z: 0)     // Rotation um Y-Achse
            )
            .animation(.easeInOut(duration: 0.5), value: flipped)
    }

    // Effekt: kleines Scale-In beim Tippen für visuelles Feedback
    func subtleScaleEffect(onTap: Bool) -> some View {
        self
            .scaleEffect(onTap ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: onTap)
    }

    // Overlay-Animation mit sanfter Ein-/Ausblendung
    func animatedOverlay(_ condition: Bool) -> some View {
        self
            .transition(.opacity)
            .zIndex(condition ? 1 : 0)
    }
}
