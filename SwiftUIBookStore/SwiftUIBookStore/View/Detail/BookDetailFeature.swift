//
//  BookDetailFeature.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import ComposableArchitecture

@Reducer
struct BookDetailFeature {
    
    // 메모 : Reducer -> State -> View
    @ObservableState
    struct State: Equatable {
        var bookDetail: BookDetail_API.Response
        var bookInfoList: [BookDetailInnerItem]
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    // 메모 : View -> Action -> Reducer
    enum Action {
        /// 책 상세 정보 API 요청
        case fetchDetails(BookDetail_API.Request)
        /// 책 상세 정보 API 응답 처리
        case fetchDetailsResponse(Result<BookDetail_API.Response, APIError>)
        /// 뒤로가기 버튼
        case backButtonTapped
        /// pdf 다운로드 버튼
        case pdfButtonTapped
    }
    
    // 메모 : Reducer -> Environment -> Effect
    var environment: BookDetailAppEnvironment
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                // TODO: 책 목록 화면으로 이동
                return .none
            case .fetchDetails(let request):
                print("DEBUG: API 요청 > request = \(request)")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.apiClient.fetchDetails(request)
                    await send(.fetchDetailsResponse(result))
                }
            case let .fetchDetailsResponse(.success(details)):
                print("DEBUG: API 결과 > details = \(details)")
                state.isLoading = false
                state.bookDetail = details
                state.bookInfoList = createBookInfoList(response: details)
                return .none
            case let .fetchDetailsResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            default:
                // TODO: PDF 다운로드
                return .none
            }
        }
    }
    
    private func createBookInfoList(response: BookDetail_API.Response) -> [BookDetailInnerItem] {
        var infoList: [BookDetailInnerItem] = []
        
        infoList.append(.init(type: .authors, content: response.authors))
        infoList.append(.init(type: .isbn10, content: response.isbn10))
        infoList.append(.init(type: .isbn13, content: response.isbn13))
        infoList.append(.init(type: .language, content: response.language))
        infoList.append(.init(type: .pages, content: response.pages))
        infoList.append(.init(type: .publisher, content: response.publisher))
        infoList.append(.init(type: .year, content: response.year))
        
        return infoList
    }
    
}
