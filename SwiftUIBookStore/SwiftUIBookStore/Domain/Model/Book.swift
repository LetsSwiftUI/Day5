//
//  Book.swift
//  SwiftUIBookStore
//
//  Created by 정유진 on 7/13/24.
//

import Foundation

struct Book: Codable, Equatable {
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}
