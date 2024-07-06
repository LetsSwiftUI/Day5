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
    
    // 필요하면 이 쪽에 Client를 추가하는 방식으로 구현?
}
