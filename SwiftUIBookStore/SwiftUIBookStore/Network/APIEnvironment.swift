//
//  APIEnvironment.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailAppEnvironment {
    var apiClient: BookDetailAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    // 필요하면 이 쪽에 Client를 추가하는 방식으로 구현?
}

@DependencyClient
struct BookStore {
    var newBooks: @Sendable () async throws -> Result<[BookInfo]?, APIError>
}

extension BookStore: DependencyKey {
    static var liveValue: Self {
        return Self(
            newBooks: {
                guard let url = URL(string: BaseURL.url + "/new") else {
                    throw APIError.networkError
                }
                
                return try await withCheckedThrowingContinuation { continuation in
                    URLSession.shared.dataTask(with: url) { data, res, err in
                        if let err = err {
                            continuation
                                .resume(returning: .failure(.etcError(error: err)))
                        }
                        
                        guard let data = data else {
                            continuation
                                .resume(returning: .failure(.dataError))
                            return
                        }
                        
                        do {
                           let response =
                            try JSONDecoder()
                                .decode(Book_API.Response.self, from: data)
                            continuation
                                .resume(returning: .success(response.books))
                        } catch {
                            continuation.resume(returning: .failure(.decodingError))
                        }
                    }.resume()
                    
                }
                
            }
        )
    }
}

extension DependencyValues {
    var bookStore: BookStore {
        get { self[BookStore.self]}
        set { self[BookStore.self] = newValue}
    }
}
