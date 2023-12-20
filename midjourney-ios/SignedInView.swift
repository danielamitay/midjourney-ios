//
//  SignedInView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/20/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct SignedInView: View {
    let client: Midjourney
    let userId: String

    @State var myJobs: [Midjourney.MyJob] = []

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var columns: [GridItem] {
        var returnValue: [GridItem] = []
        for _ in 0..<gridCount {
            returnValue.append(.init(.flexible(), spacing: gridPadding))
        }
        return returnValue
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: gridPadding) {
                ForEach(myJobs) { job in
                    Color(white: 0.913)
                        .aspectRatio(1, contentMode: .fit)
                        .overlay {
                            KFImage.url(job.imageUrl)
                                .resizable()
                                .loadDiskFileSynchronously()
                                .fade(duration: 0.25)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .disabled(true)
                        }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: gridCorners)
                )
            }
            .padding(gridPadding)
        }
        .onAppear {
            client.myJobs(userId: userId) { result in
                self.onResult(result)
            }
        }
    }

    func onResult(_ result: Result<[Midjourney.MyJob], Error>) {
        switch result {
        case .success(let success):
            myJobs = success
        case .failure(_):
            myJobs = []
        }
    }
}

extension Midjourney.MyJob {
    var imageUrl: URL {
        return URL(string: "https://cdn.midjourney.com/\(id)/0_0_384_N.webp?method=shortest&qst=6&quality=50")!
    }
}

#Preview {
    SignedInView(
        client: .init(cookie: ""),
        userId: ""
    )
}
