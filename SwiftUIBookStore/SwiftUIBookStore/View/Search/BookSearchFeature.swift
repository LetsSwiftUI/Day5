//
//  BookSearchFeature.swift
//  SwiftUIBookStore
//
//  Created by Dayeun Seong on 7/13/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct BookSearchFeature {
    
    @ObservableState
    struct State: Equatable {
        var bookResponse: [BookInfo] = []
        var total: Int = 0
        var offset: Int = 0
        var page: Int = 0
        
        var searchKeyword = ""
        var selectBookIsbn = ""
        var isLoading: Bool = false
        var errorMessage: String? = nil
        /// 메모 : @Present 란?
        @Presents var detailView: BookDetailFeature.State?
    }
    
    enum Action {
        /// 검색어 있을 떄는 검색어로 검색, 검색어 없을 때는 신규책 검색
        case fetchLoadBooks
        /// 신규 책 검색 (검색어 없을 때)
        case fetchNewBookList
        /// 검색된 책 페이징 요청
        case fetchSearchList
        /// 신규 책 응답처리
        case fetchNewResponse(Result<BookNew_API.Response, APIError>)
        /// 책 목록 응답 처리
        case fetchSearchResponse(Result<Book_API.Response, APIError>)
        /// 책 선택
        case selectBook(book: BookInfo)
        /// 책 상세 페이지 이동
        case presentDetailPage(PresentationAction<BookDetailFeature.Action>)
    }
    
    var environment: BookSearchAppEnvironment
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchLoadBooks:
                return state.searchKeyword.isEmpty ? .send(.fetchNewBookList) : .send(.fetchSearchList)
                
            case .fetchNewBookList:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.newApiClient.fetchNewBookInfoList(.init())
                    await send(.fetchNewResponse(result))
                }
                
            case .fetchSearchList:
                let searchRequest = Book_API.Request(query: state.searchKeyword, page: state.offset)
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.searchApiClient.fetchSearchBookInfoList(searchRequest)
                    await send(.fetchSearchResponse(result))
                }
                
            case let .fetchNewResponse(.success(response)):
                state.isLoading = false
                state.total = Int(response.total ?? "0") ?? 0
                state.bookResponse = response.books ?? []
                return .none
                
            case let .fetchNewResponse(.failure(error)):
                state.total = 0
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case let.fetchSearchResponse(.success(response)):
                state.isLoading = false
                state.total = Int(response.total ?? "0") ?? 0
                state.bookResponse = response.books ?? []
                return .none
                
            case let .fetchSearchResponse(.failure(error)):
                state.total = 0
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .selectBook(let book):
                state.selectBookIsbn = book.isbn13 ?? ""
                return .none
                
//            case .presentDetailPage(.presented()):
//                state.detailView = nil
//                return .none
                
            case .presentDetailPage(_):
                return .none
            }
        }
        .ifLet(\.$detailView, action: \.presentDetailPage) {
            BookDetailFeature(environment: BookDetailAppEnvironment(apiClient: .liveValue, mainQueue: .main.eraseToAnyScheduler()))
        }
    }
    
}

struct BookSearchAppEnvironment {
    var searchApiClient: BookSearchAPIClient
    var newApiClient: BookNewAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

