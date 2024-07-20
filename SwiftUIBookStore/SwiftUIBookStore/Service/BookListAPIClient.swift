//
//  BookListAPIClient.swift
//  SwiftUIBookStore
//
//  Created by Chaewon on 7/13/24.
//

import Foundation
import ComposableArchitecture

struct BookListAPIClient {
    var fetchLists: (Book_API.Request) async throws -> Result<Book_API.Response, APIError>
}

extension BookListAPIClient: DependencyKey {
    static let liveValue = BookListAPIClient { request in
        guard let url = URL(string: BaseURL.url + Book_API.path + request.query) else {
            throw APIError.networkError
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(returning: .failure(.etcError(error: error)))
                    return
                }
                
                guard let data = data else {
                    continuation.resume(returning: .failure(.dataError))
                    return
                }
                
                do {
                    let bookListResponse = try JSONDecoder().decode(Book_API.Response.self, from: data)
                    continuation.resume(returning: .success(bookListResponse))
                } catch {
                    continuation.resume(returning: .failure(.decodingError))
                }
            }.resume()
        }
    }
}
