//
//  AsyncImageView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?
    var height: CGFloat?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
        .frame(height: height)
    }
    
}
