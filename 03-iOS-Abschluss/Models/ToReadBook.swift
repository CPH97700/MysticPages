//
//  ToReadBook.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 08.04.25.
//

import Foundation

struct ToReadBook: Identifiable, Codable, Hashable {
    
    let id: String
    let title: String
    let author: String
    let categories: Genre
    var imageData: Data?
}
