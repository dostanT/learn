//
//  DownLoadingImageView.swift
//  learn
//
//  Created by Dostan Turlybek on 12.04.2025.
//
import SwiftUI

struct DownloadingImageView: View {
    
    @StateObject var loader: ImageLoadingViewModel
    
    init(url: String, key: String) {
        _loader = StateObject(wrappedValue: ImageLoadingViewModel(url: /*url*/ "data:image/png;base64,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", key: key))
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
            }
        }
    }
}


