//
//  BookDetailAPIClient.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation
import ComposableArchitecture

struct BookDetailAPIClient {
    var fetchDetails: (BookDetail_API.Request) async throws -> Result<BookDetail_API.Response, APIError>
}

extension BookDetailAPIClient: DependencyKey {
    static let liveValue = BookDetailAPIClient(
        fetchDetails: { request in
            guard let url = URL(string: BaseURL.url + BookDetail_API.path + request.isbn13) else {
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
                        let bookDetailResponse = try JSONDecoder().decode(BookDetail_API.Response.self, from: data)
                        continuation.resume(returning: .success(bookDetailResponse))
                    } catch {
                        continuation.resume(returning: .failure(.decodingError))
                    }
                }.resume()
            }
        }
    )
}
