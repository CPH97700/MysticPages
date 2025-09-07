//
//  ExtensionShape.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 10.04.25.
//

import Foundation
import SwiftUI

// Erweiterung für Shape → hier style ich Formen wie Karten, Buttons, Regale etc.
extension Shape {
    
    // Rückseite einer Buchkarte (z. B. bei Flip-Animation)
    func bookCardBackStyle() -> some View {
        self
            .fill(
                LinearGradient( // Farbverlauf von oben links nach unten rechts
                    gradient: Gradient(colors: [
                        Color("colorbuttons").opacity(0.9),
                        Color("colorquotes").opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                              )
            )
            .cornerRadius(30) // schön abgerundet
            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8) // sanfter Schatten
    }
    
    // Hintergrund für Genre-Buttons (ändert sich je nach Auswahl)
    func genreButtonContainerStyle(isSelected: Bool) -> some View {
        self
            .padding()
            .background( // Hintergrundfarbe abhängig vom Auswahlstatus
                isSelected ?
                Color.purple.opacity(0.25) :
                    Color.white.opacity(0.1)
            )
            .cornerRadius(DesignSystem.cornerRadius)
            .overlay( // Rahmen nur wenn ausgewählt
                RoundedRectangle(cornerRadius: DesignSystem.cornerRadius)
                    .stroke(isSelected ? Color.purple : Color.clear, lineWidth: 1)
            )
            .shadow(color: isSelected ? Color.purple.opacity(0.3) : .clear, radius: 6)
    }
    
    // Basis eines Bücherregals → sieht aus wie ein Holzbrett
    func shelfBaseStyle() -> some View {
        self
            .fill(Color(red: 181/255, green: 136/255, blue: 99/255)) // Holzfarbe
            .frame(height: 14) // flach wie ein Brett
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1) // dezenter Schatten darunter
    }
}
