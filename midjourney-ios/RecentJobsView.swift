//
//  RecentJobsView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/20/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct RecentJobsView: View {
    let client: Midjourney

    struct RecentJobsColumn: Identifiable {
        let id: String = UUID().uuidString
        let jobs: [Midjourney.RecentJob]
    }

    @State var recentJobColumns: [RecentJobsColumn] = []

    private let gridCount: Int = 2
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            HStack(spacing: 15) {
                Text("Explore")
                    .bold()
                    .foregroundStyle(.standardText)
                Text("Likes")
                    .opacity(0.7)
                    .bold()
                    .foregroundStyle(.deselectedText)
                Spacer()
            }
            .padding(.horizontal, 27)
            .frame(height: 60)

            VStack {
                if recentJobColumns.isEmpty {
                    HStack(alignment: .top, spacing: gridPadding) {
                        ForEach(0..<gridCount, id: \.self) { column in
                            LazyVStack(spacing: gridPadding, content: {
                                ForEach(0..<25, id: \.self) { _ in
                                    let aspectRatio = Double.random(in: 0.5...1.5)
                                    Color.loading
                                        .aspectRatio(aspectRatio, contentMode: .fit)
                                }
                            })
                        }
                    }
                }
                HStack(alignment: .top, spacing: gridPadding) {
                    ForEach(recentJobColumns) { column in
                        LazyVStack(spacing: gridPadding, content: {
                            ForEach(column.jobs) { job in
                                let aspectRatio = (CGFloat(job.width) / CGFloat(job.height))
                                Color.loading
                                    .aspectRatio(aspectRatio, contentMode: .fit)
                                    .overlay {
                                        KFImage.url(job.imageUrl)
                                            .resizable()
                                            .loadDiskFileSynchronously()
                                            .fade(duration: 0.25)
                                    }
                            }
                        })
                    }
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .padding(gridPadding)
        }
        .onAppear {
            client.recentJobs { result in
                withAnimation {
                    onResult(result)
                }
            }
        }
    }

    func onResult(_ result: Result<[Midjourney.RecentJob], Error>) {
        switch result {
        case .success(let jobs):
            var distributedArrays = Array(repeating: [Midjourney.RecentJob](), count: gridCount)
            var heights = Array(repeating: CGFloat(0), count: gridCount)

            for job in jobs {
                // Find the index of the array with the smallest total height
                if let minHeightIndex = heights.firstIndex(of: heights.min() ?? 0) {
                    distributedArrays[minHeightIndex].append(job)
                    heights[minHeightIndex] += (CGFloat(job.height) / CGFloat(job.width))
                }
            }

            recentJobColumns = distributedArrays.compactMap { jobs in
                return RecentJobsColumn(jobs: jobs)
            }
        case .failure(_):
            break
        }
    }
}

extension RecentJobsView {
    var columns: [GridItem] {
        var returnValue: [GridItem] = []
        for _ in 0..<gridCount {
            returnValue.append(.init(.flexible(), spacing: gridPadding))
        }
        return returnValue
    }
}

extension Midjourney.RecentJob {
    var imageUrl: URL {
        return URL(string: "https://cdn.midjourney.com/\(parent_id)/0_\(parent_grid)_384_N.webp?method=shortest&qst=6&quality=50")!
    }
}

}
