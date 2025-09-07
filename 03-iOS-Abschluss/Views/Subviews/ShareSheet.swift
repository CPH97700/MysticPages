//
//  ShareSheet.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 08.04.25.
//

import SwiftUI
import UIKit

// 📤 Mit dieser kleinen Komponente kann ich Inhalte aus meiner App teilen
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any] // Was geteilt werden soll (z. B. Text oder Bilder)
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // 📱 Das ist das native iOS-Teilen-Menü
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // ⚙️ Wird in meinem Fall nicht benötigt
    }
}
