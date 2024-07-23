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
            GeometryReader { geometry in
                WithPerceptionTracking{
                    let isbn13 = store.isbn13
                    VStack(alignment: .center, spacing: 20) {
                        Text(store.bookDetail.title ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    
                        if let imageString = store.bookDetail.image,
                           let imageUrl = URL(string: imageString) {
                            let imageHeight = (geometry.size.height - geometry.safeAreaInsets.top - geometry.safeAreaInsets.bottom) / 2.5
                            AsyncImageView(url: imageUrl)
                                .frame(width: geometry.size.width - 100*2, height: imageHeight)
                                .frame(height: 200)
                        }
                    
                        HStack(spacing: 10) {
                            Text(store.bookDetail.rating ?? "-")
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(store.bookDetail.price ?? "-")
                                .fontWeight(.bold)
                        }
                    
                        List {
                            ForEach(store.bookInfoList) { item in
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
                        
                        Text(store.bookDetail.desc ?? "-")
                            .padding(.horizontal)
                    }
                    .padding()
                    .overlay (
                        VStack {
                            if store.isLoading {
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    ProgressView()
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    .onAppear {
                        store.send(.fetchDetails(BookDetail_API.Request(isbn13: isbn13)))
                    }
                }
            } // geometry reader end
    }// body end
}
