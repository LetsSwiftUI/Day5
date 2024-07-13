//
//  APIEnvironment.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

extension DependencyValues {
    
    var newApiClient: BookNewAPIClient {
        get { self[BookNewAPIClient.self] }
        set { self[BookNewAPIClient.self] = newValue }
    }
    
    var searchApiClient: BookSearchAPIClient {
        get { self[BookSearchAPIClient.self] }
        set { self[BookSearchAPIClient.self] = newValue }
    }
    
    var detailApiClient: BookDetailAPIClient {
        get { self[BookDetailAPIClient.self] }
        set { self[BookDetailAPIClient.self] = newValue }
    }
    
}
