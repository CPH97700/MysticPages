//
//  ExtensionImage.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 10.04.25.
//



import Foundation
import SwiftUI

// Erweiterung für Image → hier style ich meine Buchbilder zentral
extension Image {
    
    // Style für große Buchcover (z. B. in der Detailansicht)
    func bookImageStyle(height: CGFloat = 220) -> some View {
        self
            .resizable() // Bild skalierbar
            .scaledToFit() // passt sich proportional an
            .frame(height: height) // Höhe fixiert
            .cornerRadius(DesignSystem.cornerRadius) // runde Ecken
            .shadow(color: DesignSystem.Colors.icons.opacity(0.3), radius: 12, x: 0, y: 6) // leichter Schatten
    }

    // Style für Vorschaubilder (z. B. bei Upload oder Galerie)
    func imagePreviewStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .cornerRadius(DesignSystem.cornerRadius - 4)
            .shadow(color: DesignSystem.cardShadow, radius: 6, x: 0, y: 4)
    }

    // Style für kompakte Buchcover, z. B. in der BookCard
    func dsBookImage(height: CGFloat = 180) -> some View {
        self
            .resizable()
            .scaledToFill() // füllt den kompletten Rahmen
            .frame(height: height)
            .clipped() // überschüssige Teile werden abgeschnitten
            .cornerRadius(DesignSystem.cornerRadius)
    }
}
