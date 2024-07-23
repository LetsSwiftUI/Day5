//
//  BookListView.swift
//  SwiftUIBookStore
//
//  Created by 정유진 on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct BookListView: View {
    @Bindable var store: StoreOf<BookListFeature>
    
    @ViewBuilder func bookRow(proxy:GeometryProxy, book: BookInfo) -> some View {
        VStack {
            HStack {
                if let imageURLString = book.image,
                   let imageURL = URL(string: imageURLString) {
                    AsyncImageView(url: imageURL)
                        .frame(width: proxy.size.width*0.2)
                }
                
                VStack(alignment: .leading) {
                    if let title = book.title {
                        Text(title)
                        
                    }
                    
                    if let subTitle = book.subtitle {
                        Text(subTitle)
                        
                    }
                    
                    if let isbn13 = book.isbn13 {
                        Text(isbn13)
                            .font(.footnote)
                    }
                }
                
                VStack {
                    if let price = book.price {
                        Text(price)
                    }
                }
                
            } // hstack end
            .frame(height: proxy.size.height * 0.1)
            .foregroundStyle(.black)
            Divider()
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            GeometryReader { proxy in
                WithPerceptionTracking {
                    VStack {
                        // book list
                        ScrollView {
                            ForEach(store.books, id: \.hashValue) { book in
                                Button(action: {
                                    if let isbn13 = book.isbn13 {
                                        store.send(.detailButtonTapped(isbn13: isbn13))
                                    }
                                }) {
                                    bookRow(proxy: proxy, book: book)
                                }
                                
                                if let isbn13 = book.isbn13 {
                                    NavigationLink(state: BookListFeature.Path.State.bookDetail(BookDetailFeature.State(isbn13: isbn13))) {
                                        bookRow(proxy: proxy, book: book)
                                    }
                                }
                                    
                                
                            }
                        } // scroll view end
                    } // vstack end
                    .onAppear {
                        store.send(.fetchNewBooks)
                    }
                }
            } // geometry reader end
        } destination: { store in
            // NavigationLink에서 Feature.Path.State.bookDetail이라고 명시해줬기 때문에 여기에서 알아서 store를 주입해줄 수 있는건가? (action은 따로 명시해주지 않았지만..)
            switch store.case {
            case .bookDetail(let store): BookDetailView(store: store)
            default: Text("unknown destination")
            }
        }
        .searchable(text: $store.searchText.sending(\.searchTextChanged))
    }
}

#Preview {
    BookListView(store: Store(initialState: BookListFeature.State(books: [BookInfo(
        title: "title",
        subtitle: "subtitle",
        isbn13: "13",
        price: "00000",
        image: "",
        url: "")])){
        BookListFeature()
    })
}
