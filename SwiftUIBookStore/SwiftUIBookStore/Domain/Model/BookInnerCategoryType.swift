//
//  BookInnerCategoryType.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

/// 책 상세 내용 목록 타입
enum BookInnerCategoryType: Int {
    case language = 0
    case pages
    case year
    case isbn13
    case isbn10
    case authors
    case publisher
    case unknown
    
    var value: String {
        switch self {
        case .language: "language"
        case .pages: "pages"
        case .year: "year"
        case .isbn13: "isbn13"
        case .isbn10: "isbn10"
        case .authors: "authors"
        case .publisher: "publisher"
        case .unknown: "알 수 없음"
        }
    }
}
