//
//  BookDetailContentView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookSearchView: View {
    @Bindable var store: StoreOf<BookSearchFeature>
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                ForEach(store.bookInfoList) { item in
                    BookSearchItemView(image: item.image ?? "", title: item.title ?? "", price: item.price ?? "", isbn13: item.isbn13 ?? "")
                        .onTapGesture {
                            store.send(.selectBookTap(isbn13: item.isbn13 ?? ""))
                        }
                    Spacer().frame(height: 10)
                }
            }
            .searchable(text: $store.searchText)
            .navigationTitle("BookSearch")
        } destination: { store in
            BookDetailView(store: store)
        }
        
    }
}
