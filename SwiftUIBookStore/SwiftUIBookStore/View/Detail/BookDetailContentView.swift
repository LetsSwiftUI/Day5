//
//  BookDetailContentView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailContentView: View {
    var store: StoreOf<BookDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                BookDetailView(store: store)
            }
        }
    }
}
