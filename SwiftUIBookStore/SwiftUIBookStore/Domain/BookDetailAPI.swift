//
//  BookDetailAPI.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

/// API 모델 - 책 정보 상세 조회
struct BookDetail_API: Codable {
    
    static let path = "books/"
    
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
        
        init() {
            self.error = nil
            self.title = nil
            self.subtitle = nil
            self.authors = nil
            self.publisher = nil
            self.language = nil
            self.isbn10 = nil
            self.isbn13 = nil
            self.pages = nil
            self.year = nil
            self.rating = nil
            self.desc = nil
            self.price = nil
            self.image = nil
            self.url = nil
            self.pdf = nil
        }
        
        init(error: String?, title: String?, subtitle: String?, authors: String?, publisher: String?, language: String?, isbn10: String?, isbn13: String?, pages: String?, year: String?, rating: String?, desc: String?, price: String?, image: String?, url: String?, pdf: [String : String]?) {
            self.error = error
            self.title = title
            self.subtitle = subtitle
            self.authors = authors
            self.publisher = publisher
            self.language = language
            self.isbn10 = isbn10
            self.isbn13 = isbn13
            self.pages = pages
            self.year = year
            self.rating = rating
            self.desc = desc
            self.price = price
            self.image = image
            self.url = url
            self.pdf = pdf
        }
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
    
//    static func detail(isbs13: String) -> Self {
//        return .init(error: <#T##String?#>, title: <#T##String?#>, subtitle: <#T##String?#>, authors: <#T##String?#>, publisher: <#T##String?#>, language: <#T##String?#>, isbn10: <#T##String?#>, isbn13: <#T##String?#>, pages: <#T##String?#>, year: <#T##String?#>, rating: <#T##String?#>, desc: <#T##String?#>, price: <#T##String?#>, image: <#T##String?#>, url: <#T##String?#>, pdf: <#T##[String : String]?#>)
//    }
    
}
