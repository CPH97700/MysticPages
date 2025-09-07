//
//  _3_iOS_AbschlussApp.swift
//  03-iOS-Abschluss
//
//  Created by Gordon Lucas on 10.03.25.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth

@main
struct MysticPages: App {
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
            
        }
    }
}

