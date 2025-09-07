//
//  FirebaseService.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    let database = Firestore.firestore()
    let auth = Auth.auth()
    var userID: String? { auth.currentUser?.uid }
    
    
}
