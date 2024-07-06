//
//  AsyncImageView.swift
//  SwiftUIBookStore
//
//  Created by DY on 7/5/24.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var uiImage: UIImage?
    let url: URL?
    
    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    // TODO: 이미지가 없을 경우 이미지가 없다는 기본 이미지 넣기
    private func loadImage() {
        guard let url = url else { return }
        
        Task {
            if let data = try? await fetchImageData(from: url),
               let uiImage = UIImage(data: data) {
                self.uiImage = uiImage
            }
        }
    }
    
    private func fetchImageData(from url: URL) async throws -> Data? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
}
