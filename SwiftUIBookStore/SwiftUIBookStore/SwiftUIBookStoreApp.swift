//
//  SwiftUIBookStoreApp.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct SwiftUIBookStoreApp: App {
    var body: some Scene {
        WindowGroup {
            BookDetailView(store: Store(initialState: BookDetailFeature.State(bookDetail: .mock(), bookInfoList: [])) {
                let environment = BookAppEnvironment(bookListAPIClient: .liveValue, bookDetailAPIClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
                BookDetailFeature(environment: environment)
            })
        }
    }
}
