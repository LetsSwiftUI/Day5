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
    
    var body: some View {
    // store -> viewStore로 바꾸어줌
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            GeometryReader { geometry in
                WithPerceptionTracking{
                    let isbn13 = viewStore.bookDetail.isbn13
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
                    
                        List {
                            ForEach(viewStore.bookInfoList) { item in
                                BookDetailInnerView(title: item.category, content: item.content ?? "정보 없음")
                            }
                        }
                        .listStyle(.plain)
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
                    .overlay (
                        VStack {
                            if viewStore.isLoading {
                                ZStack {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    .onAppear {
                        if let isbn13Value = isbn13 {
                            viewStore.send(.fetchDetails(BookDetail_API.Request(isbn13: isbn13Value)))
                        }
                    }
                }
                .navigationBarHidden(true)
            } // geometry reader end
        } // view store end
    }// body end
}
