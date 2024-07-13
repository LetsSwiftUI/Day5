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
            BookSearchView(store: Store(initialState: BookSearchFeature.State()) {
                let environment = BookSearchAppEnvironment(searchApiClient: .liveValue,
                                                           newApiClient: .liveValue,
                                                           mainQueue: .main.eraseToAnyScheduler())
                BookSearchFeature(environment: environment)
                    ._printChanges()
            })
        }
    }
}
