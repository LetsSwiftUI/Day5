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
            // 이 mock data를 fetch 받은 데이터로 교체해보자.
            BookDetailView(store: Store(initialState: BookDetailFeature.State(bookDetail: .mock(), bookInfoList: [])) {
                
                // 외부와의 통신을 위해 생성하는 environment 객체 -> 큐를 지정하는 부분이 흥미롭다.
                // environment 선언, 사용법에 대해 추후 더 자세히 살펴봐야겠다.
                let environment = BookDetailAppEnvironment(apiClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
                BookDetailFeature(environment: environment)
            })
            
            /*
             store 주입 방법에 대한 고민..
             WindowGroup {
               SpeechRecognitionView(
                 store: Store(initialState: SpeechRecognition.State()) {
                   SpeechRecognition()._printChanges()
                 }
               )
             }
            */
        }
    }
}
