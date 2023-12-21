//
//  MyJobsView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/20/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct MyJobsView: View {
    let client: Midjourney
    let userId: String

    @State var myJobs: [Midjourney.MyJob] = []

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            HStack {
                Text("Today")
                    .bold()
                    .foregroundStyle(.standardText)
                Spacer()
            }
            .padding(.horizontal, 27)
            .frame(height: 60)

            VStack {
                if myJobs.isEmpty {
                    LazyVGrid(columns: columns, spacing: gridPadding) {
                        ForEach(0..<100) { _ in
                            Color.loading
                                .aspectRatio(1, contentMode: .fit)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: gridCorners)
                        )
                    }
                }
                LazyVGrid(columns: columns, spacing: gridPadding) {
                    ForEach(myJobs) { job in
                        Color.loading
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                KFImage.url(job.imageUrl)
                                    .resizable()
                                    .loadDiskFileSynchronously()
                                    .fade(duration: 0.25)
                                    .aspectRatio(contentMode: .fill)
                            }
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: gridCorners)
                    )
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .padding(gridPadding)
        }
        .onAppear {
            client.myJobs(userId: userId) { result in
                withAnimation {
                    self.onResult(result)
                }
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

extension MyJobsView {
    var columns: [GridItem] {
        var returnValue: [GridItem] = []
        for _ in 0..<gridCount {
            returnValue.append(.init(.flexible(), spacing: gridPadding))
        }
        return returnValue
    }
}

extension Midjourney.MyJob {
    var imageUrl: URL {
        return URL(string: "https://cdn.midjourney.com/\(id)/0_0_384_N.webp?method=shortest&qst=6&quality=50")!
    }
}

#Preview {
    MyJobsView(
        client: .init(cookie: ""),
        userId: ""
    )
}
