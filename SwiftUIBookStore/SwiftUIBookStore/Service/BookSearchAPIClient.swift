//
//  BookDetailContentAPIClient.swift
//  SwiftUIBookStore
//
//  Created by 이보라 on 7/14/24.
//

import Foundation
import ComposableArchitecture

struct BookSearchAPIClient {
    var fetchSearch: (Book_API.Request) async throws ->
        Result<Book_API.Response, APIError>
}

extension BookSearchAPIClient: DependencyKey {
    static let liveValue = BookSearchAPIClient(
        fetchSearch: { request in
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
                        let bookDetailContentResponse = try JSONDecoder().decode(Book_API.Response.self, from: data)
                        continuation.resume(returning: .success(bookDetailContentResponse))
                    } catch {
                        continuation.resume(returning: .failure(.decodingError))
                    }
                }.resume()
            }
            
        }
    )
}
