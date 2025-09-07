//
//  DesignSystem.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 10.04.25.
//

import Foundation
import SwiftUI

// DesignSystem = alles was mit Farben, Schriften und Ecken zu tun hat, ist hier drin
struct DesignSystem {
    
    // Farben, die ich in Assets angelegt hab
    struct Colors {
        static let background = Color("colorbackground") // Hintergrundfarbe (z. B. für Screens)
        static let buttons = Color("colorbuttons")       // Für Buttons (Login, Register etc.)
        static let elements = Color("colorelements")     // Für wichtige UI-Elemente (z. B. Titel)
        static let icons = Color("coloricons")           // Für Icons und kleinere Texte
        static let quotes = Color("colorquotes")         // Extra Farbe für Zitate
        static let section = Color("colorsection")       // Karten, Abschnitte etc.
    }
    
    // Schriften, damit die App überall gleich aussieht
    struct Fonts {
        static let sectionHeader = Font.system(.title3, design: .rounded).weight(.semibold)
        static let body = Font.system(.body, design: .rounded)
        static let subheadline = Font.system(.subheadline, design: .rounded)
        static let headline = Font.system(.headline, design: .rounded)
    }
    
    // Standardwerte, damit alles schön abgerundet aussieht
    static let cornerRadius: CGFloat = 16              // Abgerundete Ecken (z. B. bei Cards)
    static let shadowRadius: CGFloat = 6               // Schatten für Tiefe
    static let cardShadow = Color.black.opacity(0.16)  // Farbe vom Schatten
}

// Hintergrund-Verlauf, den ich als Standard für alle Views nehme
extension LinearGradient {
    static let appBackground = LinearGradient(
        gradient: Gradient(colors: [
            DesignSystem.Colors.background.opacity(0.95), // oben dunkler
            DesignSystem.Colors.section.opacity(0.2)      // unten heller
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
