//
//  BookListView.swift
//  SwiftUIBookStore
//
//  Created by 정유진 on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct BookListView: View {
    var store: StoreOf<BookListFeature>
    
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
    
    @ViewBuilder var detailView: some View {
        BookDetailView(store: Store(initialState: BookDetailFeature.State(bookDetail: .mock(), bookInfoList: [])) {
            
            // 외부와의 통신을 위해 생성하는 environment 객체 -> 큐를 지정하는 부분이 흥미롭다.
            // environment 선언, 사용법에 대해 추후 더 자세히 살펴봐야겠다.
            let environment = BookDetailAppEnvironment(apiClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
            BookDetailFeature(environment: environment)
        })
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                WithPerceptionTracking {
                    VStack {
                        
                        VStack {
                            Text("search bar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                        .border(.black)
                        
                        // book list
                        ScrollView {
                            ForEach(store.books, id: \.hashValue) { book in
                                NavigationLink(destination: detailView) {
                                    bookRow(proxy: proxy, book: book)
                                }
                            }
                        } // scroll view end
                    } // vstack end
                    .onAppear {
                        store.send(.fetchNewBooks)
                    }
                }
            } // geometry reader end
        }
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
