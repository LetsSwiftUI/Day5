//
//  BookListFeature.swift
//  SwiftUIBookStore
//
//  Created by Chaewon on 7/13/24.
//

import ComposableArchitecture

@Reducer
struct BookListFeature {
    
    @ObservableState
    struct State: Equatable {
        var books: [BookInfo] = []
        var searchQuery: String = ""
        var currentPage: Int = 1
        var totalBooks: Int?
        var isLoading: Bool = false
        var errorMessage: String?
        var selectedBookDetail: BookDetailFeature.State?
        var selectedBookID: String?
    }
    
    enum Action {
        case fetchBooks(Book_API.Request)
        case booksResponse(Result<Book_API.Response, APIError>)
        case searchQueryChanged(String)
        case loadMoreBooks
        case bookTapped(BookInfo)
        case bookDetail(BookDetailFeature.Action)
        case selectBook(String?)
    }
    
    var environment: BookAppEnvironment
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchBooks(let request):
                print("DEBUG: API 요청 > request = \(request)")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.bookListAPIClient.fetchLists(request)
                    await send(.booksResponse(result))
                }
                
            case let .booksResponse(.success(response)):
                print("DEBUG: API 결과 > response = \(response)")
                state.isLoading = false
                if let books = response.books {
                    state.books.append(contentsOf: books)
                }
                if let total = response.total, let totalInt = Int(total) {
                    state.totalBooks = totalInt
                }
                return .none
                
            case let .booksResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            
            case let .searchQueryChanged(query):
                state.searchQuery = query
                state.books = []
                state.currentPage = 1
                return .send(.fetchBooks(Book_API.Request(query: query, page: state.currentPage)))
                
            case .loadMoreBooks:
                if let totalBooks = state.totalBooks, state.books.count < totalBooks {
                    state.currentPage += 1
                    return .send(.fetchBooks(Book_API.Request(query: state.searchQuery, page: state.currentPage)))
                }
                return .none
                
            case let .bookTapped(book):
                state.selectedBookDetail = BookDetailFeature.State(bookDetail: .null(), bookInfoList: [])
                state.selectedBookID = book.id
                return .send(.bookDetail(.fetchDetails(BookDetail_API.Request(isbn13: book.isbn13!))))
                
            case let .bookDetail(action):
                return .none
                
            case let .selectBook(bookID):
                state.selectedBookID = bookID
                return .none

            default:
                return .none
            }
        }
    }
}
