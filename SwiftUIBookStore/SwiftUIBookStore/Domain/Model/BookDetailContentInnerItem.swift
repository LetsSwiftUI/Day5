//
//  BookDetailContentInnerItem.swift
//  SwiftUIBookStore
//
//  Created by 이보라 on 7/10/24.
//

import Foundation

/// 책 상세 내용 테이블 셀 모델
struct BookDetailContentInnerItem: Codable, Hashable, Identifiable {
    var id = UUID()
    
    let image: String?
    
    let title: String?
    
    let price: String?
    
    let isbn13: String?
    
    init(image: String, title: String, price: String, isbn13: String) {
        self.image = image
        self.title = title
        self.price = price
        self.isbn13 = isbn13
    }
    
}
