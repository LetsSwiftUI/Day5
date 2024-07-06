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
