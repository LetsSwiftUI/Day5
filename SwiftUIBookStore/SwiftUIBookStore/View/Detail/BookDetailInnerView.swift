//
//  BookDetailInnerView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/6/24.
//

import SwiftUI

/// 책 상세 내용 목록 셀
struct BookDetailInnerView: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 12, weight: .bold))
            Spacer()
            Text(content)
                .font(.system(size: 12, weight: .regular))
        }
    }
}
