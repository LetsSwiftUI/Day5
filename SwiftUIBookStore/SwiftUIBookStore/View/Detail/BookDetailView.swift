//
//  BookDetailView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI
import ComposableArchitecture

struct BookDetailView: View {
    var store: StoreOf<BookDetailFeature> //TCA Strore 사용하여 상태, 동작 관리
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            //Store 상태 구독, ViewStore -> 상태 및 액션
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Text(viewStore.bookDetail.title ?? "책 정보 없음")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        if let imageString = viewStore.bookDetail.image,
                           let imageUrl = URL(string: imageString) {
                            let imageHeight = (geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom) / 2.5
                            AsyncImageView(url: imageUrl)
                                .frame(width: geometry.size.width - 100*2, height: imageHeight)
                                .frame(height: 200)
                        }
                        
                        HStack(spacing: 10) {
                            Text(viewStore.bookDetail.rating ?? "-")
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(viewStore.bookDetail.price ?? "-")
                                .fontWeight(.bold)
                        }
                        
                        VStack {
                            //viewStore.bookInfoList는 Store로 전달
                            ForEach(viewStore.bookInfoList) { item in
                                BookDetailInnerView(title: item.category, content: item.content ?? "정보 없음")
                                Spacer().frame(height: 10)
                            }
                        }
                        
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
                        
                        Text(viewStore.bookDetail.desc ?? "-")
                            .padding(.horizontal)
                    }
                    .padding()
                }
                .onAppear {
                    viewStore.send(.fetchDetails(BookDetail_API.Request(isbn13: "9781491954249")))
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: .constant(viewStore.errorMessage != nil), content: {
                Alert(title: Text("Error"), message: Text(viewStore.errorMessage ?? ""), dismissButton: .default(Text("OK")))
            })
        }
        
    }
}

