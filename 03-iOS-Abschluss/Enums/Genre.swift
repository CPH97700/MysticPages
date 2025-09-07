//
//  Genre.swift
//  03-iOS-Abschluss
//
//  Created by Isabell Philippi on 02.04.25.
//

import Foundation

enum Genre: String, Codable, CaseIterable, Identifiable {
    case fantasy = "Fantasy"
    case darkRomance = "Dark Romance"
    case youngAdult = "Young Adult"
    
    var id: String { self.rawValue }
        

    }
    

