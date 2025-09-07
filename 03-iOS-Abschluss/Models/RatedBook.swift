//
//  RatedBook.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 02.04.25.
//

import Foundation

struct RatedBook: Identifiable, Codable, Equatable, Hashable {
    var id = String()
    var title: String
    var author: String
    var categories: Genre
    var rating: Int
    var spiceRating: Int?
    var note: String
    var imageData: Data?
    
}

