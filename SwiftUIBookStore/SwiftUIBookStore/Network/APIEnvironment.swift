//
//  APIEnvironment.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookAppEnvironment {
    var bookListAPIClient: BookListAPIClient
    var bookDetailAPIClient: BookDetailAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}
