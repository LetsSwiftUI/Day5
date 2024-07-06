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

// 메모 : Q. DependencyKey 란?
extension BookDetailAPIClient: DependencyKey {
    
    static let liveValue = BookDetailAPIClient(
        fetchDetails: { request in
            guard let url = URL(string: BaseURL.url + BookDetail_API.path) else {
                throw APIError.networkError
            }
            
            // 메모 : Q. withCheckedThrowingContinuation란 ?
            // Swift의 비동기 프로그래밍 모델에서 사용되는 함수로, withCheckedContinuation 확장 버전.
            // async throws 에 유용하게 사용
            // 성공 시 continuation.resume(returning:) , 실패 시 continuation.resume(throwing:)
            // 비동기 작업 실패 중
            return try await withCheckedThrowingContinuation { continuation in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        //continuation.resume(returning: .failure(.etcError(error: error)))
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
