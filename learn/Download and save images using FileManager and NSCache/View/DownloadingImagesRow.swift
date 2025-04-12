//
//  DownloadingImagesRow.swift
//  learn
//
//  Created by Dostan Turlybek on 12.04.2025.
//

import SwiftUI

#Preview {
    DownloadingImagesRow(model: PhotoModel(
        albumId: 1,
        id: 1,
        title: "accusamus beatae ad facilis cum similique qui sun",
        url: "https://via.placeholder.com/600/92c952",
        thumbnailUrl: "https://via.placeholder.com/150/92c952"))
}

struct DownloadingImagesRow: View {
    let model: PhotoModel
    var body: some View {
        HStack{
            DownloadingImageView(url: model.url, key: "\(model.id)")
                .frame(width: 70, height: 70)
                
            VStack{
                Text(model.title)
                    .font(.headline)
                
                Text(model.url)
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}
