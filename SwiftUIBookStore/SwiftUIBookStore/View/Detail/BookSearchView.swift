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
                ForEach(store.bookDetail.books!, id: \.self) { item in
                    HStack {
                        if let imageString = item.image,
                           let imageUrl = URL(string: imageString) {
                            AsyncImageView(url: imageUrl, height: 100)
                        }
                        VStack(alignment: .leading) {
                            Text(item.title ?? "")
                                .fontWeight(.bold)
                                .lineLimit(2)
                            Text(item.subtitle ?? "")
                                .lineLimit(2)
                                .padding([.top, .bottom], 10)
                            
                            Text(item.isbn13 ?? "")
                        }
                        Text(item.price ?? "")
                    }
                    .padding(10)
                    .onTapGesture {
                        store.send(.selectBookTap(isbn13: item.isbn13 ?? ""))
                    }
                }
            }
            .searchable(text: $store.searchText)
            .navigationTitle("BookSearch")
        } destination: { store in
            switch store.case {
            case .selectBook(let store):
                BookDetailView(store: store)
            }
        }
        
    }
}
