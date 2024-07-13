//
//  BookDetailAPI.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

/// API 모델 - 책 정보 상세 조회
struct BookDetail_API: Codable {
    
    static let endPoint = "books/"
    
    struct Request: Codable {
        let isbn13: String
    }
    
    struct Response: Codable, Hashable {
        let error: String?
        let title: String?
        let subtitle: String?
        let authors: String?
        let publisher: String?
        let language: String?
        let isbn10: String?
        let isbn13: String?
        let pages: String?
        let year: String?
        let rating: String?
        let desc: String?
        let price: String?
        let image: String?
        let url: String?
        let pdf: [String: String]?
    }
    
}

extension BookDetail_API.Response: EntityResponseProtocol {
    
    static func ==(rhs: Self, lhs: Self) -> Bool {
        return rhs.title == lhs.title && rhs.authors == lhs.authors && rhs.isbn13 == lhs.isbn13 && rhs.url == lhs.url
    }
    
    static func null() -> Self {
        return .init(error: nil, title: nil, subtitle: nil, authors: nil, publisher: nil, language: nil, isbn10: nil, isbn13: nil, pages: nil, year: nil, rating: nil, desc: nil, price: nil, image: nil, url: nil, pdf: nil)
    }
    
    static func empty() -> Self {
        return .init(error: "", title: "", subtitle: "", authors: "", publisher: "", language: "", isbn10: "", isbn13: "", pages: "", year: "", rating: "", desc: "", price: "", image: "", url: "", pdf: [:])
    }
    
    /// isbn 9781617294136 = pdf Test
    static func mock() -> Self {
        return .init(error: "0",
                     title: "Mock",
                     subtitle: "Mock",
                     authors: "Mock",
                     publisher: "Mock",
                     language: "Mock",
                     isbn10: "Mock",
                     isbn13: "9781617294136",
                     pages: "Mock",
                     year: "Mock",
                     rating: "Mock",
                     desc: "Mock",
                     price: "Mock",
                     image: "https://itbook.store/img/books/9781617294136.png",
                     url: "https://itbook.store/books/9781617294136",
                     pdf: [
                        "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
                        "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
                     ])
    }
    
}
