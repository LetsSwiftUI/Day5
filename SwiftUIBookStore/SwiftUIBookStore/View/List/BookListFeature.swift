//
//  BookListFeature.swift
//  SwiftUIBookStore
//
//  Created by 정유진 on 7/13/24.
//

import ComposableArchitecture

@Reducer
struct BookListFeature {
    
    @ObservableState
    struct State: Equatable {
        var books: [BookInfo]
    }
    
    enum Action {
        case fetchNewBooks
        case setBooks(Result<[BookInfo]?, APIError>)
    }
    
    @Dependency(\.bookStore) var bookStore
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchNewBooks:
                return .run { send in
                    let result = try await bookStore.newBooks()
                    await send(.setBooks(result))
                }
                
            case let .setBooks(.success(books)):
                if let books = books {
                    state.books = books
                }
                return .none
                
            case let .setBooks(.failure(err)):
                // error alert
                print(err)
                return .none
            }
            
        }
    }

}

