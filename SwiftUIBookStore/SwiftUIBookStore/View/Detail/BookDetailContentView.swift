//
//  BookDetailContentView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailContentView: View {
    @Bindable var store: StoreOf<BookDetailContentFeature>
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(store.bookInfoList) { item in
                        BookDetailContentInnerView(image: item.image ?? "", title: item.title ?? "", price: item.price ?? "", isbn13: item.isbn13 ?? "")
                            .onTapGesture {
                                store.send(.selectBookTap(isbn13: item.isbn13 ?? ""))
                            }
                        Spacer().frame(height: 10)
                        
                    }
                }
            }
            .searchable(text: $store.searchText)
            .navigationTitle("BookSearch")
        }
        .fullScreenCover(item: $store.scope(state: \.selectBook, action: \.selectBook)) { bookDetailStore in
            NavigationStack {
               BookDetailView(store: bookDetailStore)
            }
        }
        
    }
}
