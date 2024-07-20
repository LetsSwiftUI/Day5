//
//  APIEnvironment.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

extension DependencyValues {
    var bookSearchAppEnvironment: BookSearchAPIClient {
        get { self [BookSearchAPIClient.self] }
        set { self [BookSearchAPIClient.self] = newValue }
    }
    
    var bookDetailAppEnvironment: BookDetailAPIClient {
        get { self [BookDetailAPIClient.self] }
        set { self [BookDetailAPIClient.self] = newValue }
    }
}
