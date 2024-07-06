//
//  BookDetailContentView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailContentView: View {
    // 메모 : Q. StoreOf 와 Store 차이 ?
    // public typealias StoreOf<R: Reducer> = Store<R.State, R.Action>
    // 즉 상태와 액션을 같이 사용하여 reducer 목적인 애플리케이션 state 로직을 변경함
    var store: StoreOf<BookDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                BookDetailView(store: store)
            }
        }
    }
}
