//
//  BookCellView.swift
//  SwiftUIBookStore
//
//  Created by Chaewon on 7/13/24.
//

import SwiftUI

struct BookCellView: View {
    let book: BookInfo
    
    var body: some View {
        HStack {
            if let imageUrlString = book.image, let imageUrl = URL(string: imageUrlString) {
                AsyncImageView(url: imageUrl)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title ?? "제목 없음")
                    .font(.headline)
                Text(book.subtitle ?? "부제 없음")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(book.isbn13 ?? "ISBN 없음")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(book.price ?? "-")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}
