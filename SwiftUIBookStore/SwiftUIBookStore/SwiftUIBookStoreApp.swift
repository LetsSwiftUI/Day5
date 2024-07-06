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
            //BookDetailView는 Store를 통해 상태를 관리
            BookDetailView(store: Store(initialState: BookDetailFeature.State(bookDetail: .mock(), bookInfoList: [])) {
                //BookDetailAppEnvironment 환경설정
                let environment = BookDetailAppEnvironment(apiClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
                BookDetailFeature(environment: environment)
            })
        }
    }
}
