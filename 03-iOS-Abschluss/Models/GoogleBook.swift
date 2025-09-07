//
//  Book.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 12.03.25.
//

import Foundation

struct GoogleBook: Identifiable, Hashable {
    let id: String
    let title: String
    let author: [String]
    let description: String
    let thumbnailURL: URL?
    let categories: [String]?
    
    
    init(from item: GoogleBookItem) {
        let title = item.volumeInfo.title ?? "Kein Titel"
        let author = item.volumeInfo.authors ?? ["Unbekannter Autor"]
        
        self.id = "\(title)-\(author.first ?? "")"
        self.title = title
        self.author = author
        self.description = item.volumeInfo.description ?? ""
        self.categories = item.volumeInfo.categories ?? []
        
        if let urlString = item.volumeInfo.imageLinks?.thumbnail?
            .replacingOccurrences(of: "http://", with: "https://") {
            self.thumbnailURL = URL(string: urlString)
        } else {
            self.thumbnailURL = nil
        }
    }
    
    init(title: String, author: [String], description: String, thumbnailURL: URL?, categories: [String]? = ["defaultGenre"] ) {
        self.id = "\(title)-\(author.first ?? "")"
        self.title = title
        self.author = author
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.categories = categories
    }
}


struct GoogleBookResponse: Codable {
    let items: [GoogleBookItem]
}

struct GoogleBookItem: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    let categories: [String]?
}

struct ImageLinks: Codable {
    let thumbnail: String?
}
