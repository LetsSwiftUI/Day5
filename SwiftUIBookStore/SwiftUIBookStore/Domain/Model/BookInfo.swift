//
//  BookDetailContentInnerItem.swift
//  SwiftUIBookStore
//
//  Created by 이보라 on 7/10/24.
//

import Foundation

/// 책 정보
struct BookInfo: Codable, Hashable {
    let title: String?
    let subtitle: String?
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.title == rhs.title && lhs.isbn13 == rhs.isbn13 && lhs.url == rhs.url
    }
    
    static func mock() -> Self {
        return .init(title: "Practical MongoDB", subtitle: "Architecting, Developing, and Administering MongoDB", isbn13: "9781484206485", price: "$32.04", image: "https://itbook.store/img/books/9781484206485.png", url: nil)
    }
}
