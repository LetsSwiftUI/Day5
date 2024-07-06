//
//  BookAPI.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

/// API 모델 - 책 목록 조회
struct Book_API: Codable {
    
    static let path = "search/"
    
    struct Request: Codable {
        let query: String
        let page: Int?
    }
    
    struct Response: Codable, Hashable {
        let error: String?
        let total: String?
        let page: String?
        let books: [BookInfo]?
    }
    
}

extension Book_API.Response: EntityResponseProtocol {
    
    static func null() -> Self {
        return .init(error: nil, total: nil, page: nil, books: nil)
    }
    
    static func empty() -> Self {
        return .init(error: "", total: "", page: "", books: [])
    }
    
    static func mock() -> Self {
        return .init(error: "Mock", total: "Mock", page: "0", books: [.mock(), .mock(), .mock()])
    }
    
}

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
        return .init(title: "Mock", subtitle: "Mock", isbn13: "0000", price: "Mock", image: nil, url: nil)
    }
}
