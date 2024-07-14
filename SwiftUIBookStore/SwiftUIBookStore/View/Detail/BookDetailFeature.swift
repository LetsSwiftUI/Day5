//
//  BookDetailFeature.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import ComposableArchitecture

@Reducer
struct BookDetailFeature {
    
    //@ObservableState로 상태 변경 시 관찰 가능
    @ObservableState
    struct State: Equatable {
        //Q).mock()일때 이전 이미지 mock값때문에 새로운 이미지가 안들어옴..
        var bookDetail: BookDetail_API.Response = .null()
        var bookInfoList: [BookDetailInnerItem] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var isbn13: String?
    }
    
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
    
    var environment: BookDetailAppEnvironment
    
    //API 요청 및 응답처리, UI 상호작용 등을 처리
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                // TODO: 책 목록 화면으로 이동
                return .none
            //API 요청 시작, 로딩을 true, 오류메시지 초기화
            case .fetchDetails(let request):
                print("DEBUG: API 요청 > request = \(request)")
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { send in
                    let result = try await environment.apiClient.fetchDetails(request)
                    await send(.fetchDetailsResponse(result))
                }
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
