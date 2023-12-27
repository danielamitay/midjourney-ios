//
//  JobImageView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/22/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct JobImageView: View {
    let image: Midjourney.Job.Image
    var placeholderSize: Midjourney.Job.Image.Size? = nil

    var body: some View {
        Color.black
            .overlay {
                let imageUrl = image.webpImageUrl(size: .full)
                KFImage.url(URL(string: imageUrl))
                    .resizable()
                    .loadDiskFileSynchronously()
                    .placeholder {
                        if let placeholderSize {
                            let imageUrl = image.webpImageUrl(size: placeholderSize)
                            KFImage.url(URL(string: imageUrl))
                                .resizable()
                                .loadDiskFileSynchronously()
                        } else {
                            Color.clear
                        }
                    }
                    .fade(duration: placeholderSize == nil ? 0.25 : 0.0)
                    .aspectRatio(image.aspectRatio, contentMode: .fit)
                    .background {
                        Color.loading
                            .padding(2)
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 12)
                    }
                    .padding(11)
            }
            .background {
                Color.black
                    .ignoresSafeArea()
            }
    }
}

#Preview {
    JobImageView(image: .init(
        id: "636cd2f4-8b46-41b8-983a-44cdd6aea774",
        parent_id: "c54ad25d-b7b4-478c-826a-3441a568c86d",
        parent_grid: 0,
        width: 928,
        height: 1312
    ))
}
