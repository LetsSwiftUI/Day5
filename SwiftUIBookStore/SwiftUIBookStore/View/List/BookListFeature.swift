//
//  BookListFeature.swift
//  SwiftUIBookStore
//
//  Created by 정유진 on 7/13/24.
//

import ComposableArchitecture

@Reducer
struct BookListFeature {
    @Reducer(state: .equatable) // Reducer 가 Equatable을 따름 (다른 state도 있음 ex.codable)
    enum Path {
        case bookDetail(BookDetailFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var books: [BookInfo]
        var searchText: String = ""
        var page: Int = -1
        var path = StackState<Path.State>() // 하위 path의 state
    }
    
    enum Action {
        case fetchNewBooks
        case setBooks(Result<[BookInfo]?, APIError>)
        case goBackToScreen(id: StackElementID)
        case detailButtonTapped(isbn13: String)
        case searchTextChanged(String)
        case path(StackActionOf<Path>) // 하위 path의 action
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
                
            case let .goBackToScreen(id):
                state.path.pop(to: id)
                return .none
                
            case let .detailButtonTapped(isbn13):
                state.path.append(.bookDetail(BookDetailFeature.State(isbn13: isbn13)))
                return .none
                
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
                
            // 이 action은 하위 뷰에서 forward 된 action을 받기 위함
            case let .path(action):
                print(action)
                return .none
            }
            
        }
        .forEach(\.path, action: \.path)
    }
}

