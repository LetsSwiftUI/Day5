//
//  BookSearchView.swift
//  SwiftUIBookStore
//
//  Created by Dayeun Seong on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct BookSearchView: View {
    @Bindable var store: StoreOf<BookSearchFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                NavigationView {
                    List(viewStore.bookResponse) { (book: BookInfo) in
                        HStack {
                            if let imageString = book.image,
                               let imageUrl = URL(string: imageString) {
                                AsyncImageView(url: imageUrl)
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(8)
                                    .padding(.trailing, 10)
                            }
                            VStack(alignment: .leading) {
                                Text(book.title ?? "-")
                                    .font(.headline)
                                    .lineLimit(2)
                                Text(book.subtitle ?? "-")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                Text(book.isbn13 ?? "-")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(book.price ?? "-")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 5)
                            }
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            viewStore.send(.selectBook(book: book))
                        }
                    }
                    /// ios 15이상
                    .searchable(text: viewStore.binding(get: \.searchKeyword, send: .fetchSearchList))
                    .navigationTitle("Books")
                    .onAppear { // 테이블뷰(list) 마지막 하단 아이템 출력 시 호출되는 메소드
                        viewStore.send(.fetchLoadBooks)
                    }
                }
            }
            .fullScreenCover(
                item: $store.scope(state: \.detailView, action: \.presentDetailPage)
            ) { detailStore in
                NavigationStack {
                    BookDetailView(store: detailStore)
                }
            }
        }
    }
}
 
