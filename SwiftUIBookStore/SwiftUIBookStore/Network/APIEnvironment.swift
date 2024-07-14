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
}

struct BookDetailContentAppEnvironment {
    var apiClient: BookSearchAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
