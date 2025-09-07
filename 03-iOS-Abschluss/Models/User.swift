//
//  User.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID
    var id: String?
    var email: String
    var username: String
    var creationDate: Date = Date()
    var profileImageData: Data?
    
    init(id: String?, email: String, username: String, profileImageData: Data?) {
        self.id = id
        self.email = email
        self.username = username
        self.profileImageData = profileImageData
        self.creationDate = Date()
    }

}


