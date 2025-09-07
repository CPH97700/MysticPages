//
//  FirebaseError.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

//
//  FirebaseError.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 03.04.25.
//

import Foundation

// Eigene Fehlertypen für die Firebase Authentifizierung
// → vereinfacht die Fehlerbehandlung in der App
enum FirebaseError: String, Error {
    
    // Wenn ein Benutzer nicht gefunden wird (z. B. falsche Mail)
    case userNotFound = "User not found"
    
    // Wenn der Benutzer schon registriert ist
    case userAlreadyExists = ""
}
