//
//  BookDetailView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailView: View {
    var store: StoreOf<BookDetailFeature>
//    @ObservedObject var viewStore: ViewStoreOf<BookDetailFeature>
//    
//    init(store: StoreOf<BookDetailFeature>) {
//        self.store = store
//        self.viewStore = ViewStore(self.store, observe: { $0 })
//    }
    
    var body: some View {
        // WithViewStore는 Store를 ViewStore로 변경
        // Q) Store vs ViewStore?
        // @dynamicMemberLookup Store<State, Action>
        // @dynamicMemberLookup ViewStore<ViewState, ViewAction>: ObservableObject
        
        //WithViewStore(self.store, observe: { $0 }) { viewStore in
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(store.bookDetail.title ?? "책 정보 없음")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    if let imageString = store.bookDetail.image,
                       let imageUrl = URL(string: imageString) {
                        AsyncImageView(url: imageUrl)
                            .frame(height: 200)
                    }
                    
                    HStack(spacing: 10) {
                        Text(store.bookDetail.rating ?? "-")
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(store.bookDetail.price ?? "-")
                            .fontWeight(.bold)
                    }
                    
                    VStack {
                        ForEach(store.bookInfoList) { item in
                            BookDetailInnerView(title: item.category, content: item.content ?? "정보 없음")
                            Spacer().frame(height: 10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        
                    }) {
                        Text("Free eBook")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Text(store.bookDetail.desc ?? "-")
                        .padding(.horizontal)
                }
                .padding()
            }
        }
        .onAppear {
            store.send(.fetchDetails(BookDetail_API.Request(isbn13: store.isbn13 ?? "")))
        }
        //}
        
    }
}
