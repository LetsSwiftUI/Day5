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
        let total: String?
        let page: String?
        let books: [BookInfo]?
    }
    
}

extension Book_API.Response: EntityResponseProtocol {
    
    static func null() -> Self {
        return .init(total: nil, page: nil, books: nil)
    }
    
    static func empty() -> Self {
        return .init(total: "", page: "", books: [])
    }
    
    static func mock() -> Self {
        return .init(total: "Mock", page: "0", books: [.mock(), .mock(), .mock()])
    }
    
}
