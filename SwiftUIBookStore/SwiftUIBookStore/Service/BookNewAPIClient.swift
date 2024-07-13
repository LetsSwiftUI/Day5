//
//  BookNewAPIClient.swift
//  SwiftUIBookStore
//
//  Created by Dayeun Seong on 7/13/24.
//

import Foundation
import ComposableArchitecture

struct BookNewAPIClient {
    var fetchNewBookInfoList: (BookNew_API.Request) async throws -> Result<BookNew_API.Response, APIError>
}

extension BookNewAPIClient: DependencyKey {
    
    static let liveValue = BookNewAPIClient(fetchNewBookInfoList: { request in
        guard let url = URL(string: BaseURL.url + BookNew_API.endPoint) else { throw APIError.networkError }
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
                
                print("DEBUG: response Data = \(data)")
                
                do {
                    let response = try JSONDecoder().decode(BookNew_API.Response.self, from: data)
                    continuation.resume(returning: .success(response))
                } catch {
                    continuation.resume(returning: .failure(.decodingError))
                }
            }.resume()
        }
    })
}
