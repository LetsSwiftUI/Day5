//
//  BookDetailInnerItem.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/6/24.
//

import Foundation

/// 책 상세 내용 테이블 셀 모델
struct BookDetailInnerItem: Codable, Hashable, Identifiable {
    var id = UUID()
    /// 분류
    let category: String
    /// 내용
    let content: String?
    
    init(type: BookInnerCategoryType, content: String?) {
        self.category = type.value
        self.content = content
    }
    
    init(category: String, content: String?) {
        self.category = category
        self.content = content
    }
}

extension BookDetailInnerItem: EntityResponseProtocol {
    
    static func null() -> BookDetailInnerItem {
        return .init(type: .unknown, content: nil)
    }
    
    static func empty() -> BookDetailInnerItem {
        return .init(category: "", content: "")
    }
    
    static func mock() -> BookDetailInnerItem {
        return .init(category: "Mock", content: "Mock")
    }
    
}
