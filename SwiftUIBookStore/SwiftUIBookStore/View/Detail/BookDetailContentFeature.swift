//
//  BookDetailContentFeature.swift
//  SwiftUIBookStore
//
//  Created by 이보라 on 7/10/24.
//

import ComposableArchitecture

@Reducer
struct BookDetailContentFeature {
    
    //@ObservableState로 상태 변경 시 관찰 가능
    @ObservableState
    struct State: Equatable {
        var bookDetail: Book_API.Response = .mock()
        var bookInfoList: [BookDetailContentInnerItem] = []
        var isLoading: Bool = false
        var errorMessage: String?
        
        var searchText = ""
        @Presents var selectBook: BookDetailFeature.State?
    }
    
    enum Action: BindableAction {
        ///binding
        /// searchText - 책 검색 정보 API 요청
        case binding(BindingAction<State>)
        
        /// 책 검색 정보 API 응답 처리
        case fetchDetailsResponse(Result<Book_API.Response, APIError>)
        
        case selectBook(PresentationAction<BookDetailFeature.Action>)
        case selectBookTap(isbn13: String)
    }
    
    var environment: BookDetailContentAppEnvironment
    
    //API 요청 및 응답처리, UI 상호작용 등을 처리
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
                //searchText - API 요청 시작, 로딩을 true, 오류메시지 초기화
                //Q) searchText가 2번씩 들어옴
            case .binding(\.searchText):
                print("DEBUG: API 요청 > request = \(state.searchText)")
                let searchRequest = Book_API.Request(query: state.searchText, page: nil)
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.apiClient.fetchSearch(searchRequest)
                    await send(.fetchDetailsResponse(result))
                }
            // .binding은 .binding(\.searchText) 아래에 위치 - 위에 존재하면 binding에 걸려서 바로 return 됨
            case .binding:
                return .none
                //API 응답 성공 시, 로딩 false, 책 상세 정보 업데이트
                //createBookInfoList()로 책 정보 리스트 생성
            case let .fetchDetailsResponse(.success(details)):
                print("DEBUG: API 결과 > details = \(details)")
                state.isLoading = false
                state.bookDetail = details
                state.bookInfoList = createBookInfoList(response: details)
                return .none
                //API 응답 실패 시, 로딩 false, 오류메시지 업데이트
            case let .fetchDetailsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
                
            case .selectBook:
                return .none
                
            case .selectBookTap(let isbn13):
                state.selectBook = BookDetailFeature.State(isbn13: isbn13)
                return .none
            }
            
        }
        //Q).ifLet이란?
        .ifLet(\.$selectBook, action: \.selectBook) {
            let environment = BookDetailAppEnvironment(apiClient: .liveValue, mainQueue: .main.eraseToAnyScheduler())
            BookDetailFeature(environment: environment)
        }
        
    }
    
    private func createBookInfoList(response: Book_API.Response) -> [BookDetailContentInnerItem] {
        var infoList: [BookDetailContentInnerItem] = []
        
        guard let books = response.books else {
            return []
        }
        
        for i in 0..<books.count {
            infoList.append(.init(image: books[i].image ?? "", title: books[i].title ?? "", price: books[i].price ?? "", isbn13: books[i].isbn13 ?? ""))
        }
        
        return infoList
    }
    
}
