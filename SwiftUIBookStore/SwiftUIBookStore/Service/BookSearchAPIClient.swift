//
//  BookSearchAPIClient.swift
//  SwiftUIBookStore
//
//  Created by Dayeun Seong on 7/13/24.
//

import Foundation
import ComposableArchitecture

struct BookSearchAPIClient {
    var fetchSearchBookInfoList: (_ request: Book_API.Request) async throws -> Result<Book_API.Response, APIError>
}

extension BookSearchAPIClient: DependencyKey {
    
    static let liveValue = BookSearchAPIClient(fetchSearchBookInfoList: { request in
        let page = "/\(request.page ?? 0)"
        
        guard let url = URL(string: BaseURL.url + Book_API.endPoint + request.query + page) else { throw APIError.networkError }
        print("DEBUG: API Request url = \(url)")
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data else {
                    continuation.resume(returning: .failure(.dataError))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(Book_API.Response.self, from: data)
                    continuation.resume(returning: .success(response))
                } catch {
                    continuation.resume(returning: .failure(.decodingError))
                }
            }.resume()
        }
    })
}
