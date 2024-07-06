//
//  APIError.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import Foundation

enum APIError: Error {
    case dataError
    case decodingError
    case networkError
    case etcError(error: Error)
}
