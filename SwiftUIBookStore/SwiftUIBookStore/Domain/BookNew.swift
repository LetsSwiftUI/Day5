//
//  BookNew.swift
//  SwiftUIBookStore
//
//  Created by Dayeun Seong on 7/13/24.
//

import Foundation

/// API 모델 - 책 신규 목록
struct BookNew_API: Codable {
    
    static let endPoint = "new"
    
    struct Request: Codable {
        
    }
    
    struct Response: Codable {
        let total: String?
        let books: [BookInfo]?
    }
    
    struct Path: Codable {
        
    }
    
}
