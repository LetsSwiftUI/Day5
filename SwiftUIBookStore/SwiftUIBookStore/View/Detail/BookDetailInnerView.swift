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
                .fontWeight(.bold)
            Spacer()
            Text(content)
        }
    }
}
