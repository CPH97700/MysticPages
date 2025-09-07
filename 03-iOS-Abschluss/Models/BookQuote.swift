//
//  BookQuote.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 08.04.25.
//

import Foundation

struct BookQuote: Identifiable, Codable {
    var id: String
    var quote: String
    var bookTitle: String
    var author: String
}
