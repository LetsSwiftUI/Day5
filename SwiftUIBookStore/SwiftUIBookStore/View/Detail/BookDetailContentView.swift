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
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding([.leading, .trailing, .bottom], 10)
                    .onChange(of: searchText) { oldValue, newValue in
                        store.send(.fetchDetails(Book_API.Request(query: newValue, page: nil)))
                    }
                ScrollView {
                    ForEach(store.bookInfoList) { item in
                        BookDetailContentInnerView(image: item.image ?? "", title: item.title ?? "", price: item.price ?? "", isbn13: item.isbn13 ?? "")
                            .onTapGesture {
                                store.send(.selectBookTap(isbn13: item.isbn13 ?? ""))
                            }
                        
                    }
                }
            }
        }.sheet(item: $store.scope(state: \.selectBook, action: \.selectBook)) { bookDetailStore in
            NavigationStack {
               BookDetailView(store: bookDetailStore)
            }
        }
        
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Explore the Collection", text: $text)
            Image(systemName: "magnifyingglass")
        }
        .padding()
        .border(.secondary, width: 1)
        .foregroundColor(.secondary)
    }
}
