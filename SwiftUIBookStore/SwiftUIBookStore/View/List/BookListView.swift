//
//  BookListView.swift
//  SwiftUIBookStore
//
//  Created by Chaewon on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

struct BookListView: View {
    let store: StoreOf<BookListFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    SearchBar(text: viewStore.binding(
                        get: \.searchQuery,
                        send: BookListFeature.Action.searchQueryChanged
                    ))
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(viewStore.books) { book in
                                NavigationLink(value: book.id) {
                                        BookCellView(book: book)
                                            .onTapGesture {
                                                viewStore.send(.bookTapped(book))
                                            }
                                            .padding([.horizontal, .top])
                                    }
                                .onTapGesture {
                                    viewStore.send(.bookTapped(book))
                                }
                                
                            }

                            if viewStore.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                                .padding()
                            } else {
                                Button(action: {
                                    viewStore.send(.loadMoreBooks)
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Load More")
                                        Spacer()
                                    }
                                }
                                .padding()
                                .disabled(viewStore.books.isEmpty || viewStore.books.count >= (viewStore.totalBooks ?? 0))
                            }
                        }
                        .padding(.bottom) // 리스트 맨 아래 여백 추가
                    }
                }
                .navigationTitle("Books")
                .onAppear {
                    viewStore.send(.fetchBooks(Book_API.Request(query: "mongo", page: 1)))
                }
                .navigationDestination(
                    for: String.self) { bookID in
                        IfLetStore(
                            self.store.scope(
                                state: \.selectedBookDetail,
                                action: BookListFeature.Action.bookDetail
                            ),
                            then: BookDetailView.init(store:)
                        )
                    }
                
            }
        }
    }
}

#Preview {
    BookListView(store: Store(initialState: BookListFeature.State(), reducer: {
        let environment = BookAppEnvironment(bookListAPIClient: .liveValue, bookDetailAPIClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
        BookListFeature(environment: environment)
    }))
}
