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
        let jobs: [Midjourney.Job]
    }

    @State var recentJobColumns: [RecentJobsColumn] = []
    @State var selectedImage: Midjourney.Job.Image? = nil

    private let gridCount: Int = 2
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            GridSectionHeader(title: "Explore")
                .padding(gridPadding)
                .padding(.bottom, -gridPadding * 2)
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
                                        let image = job.images.first!
                                        let imageUrl = image.webpImageUrl(size: .large)
                                        KFImage.url(URL(string: imageUrl))
                                            .resizable()
                                            .loadDiskFileSynchronously()
                                            .fade(duration: 0.25)
                                            .onTapGesture {
                                                selectedImage = image
                                            }
                                    }
                            }
                        })
                    }
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .contentShape(Rectangle())
            .padding(gridPadding)
        }
        .sheet(item: $selectedImage) { image in
            JobImageView(image: image, placeholderSize: .large)
        }
        .onAppear {
            client.recentJobs { result in
                withAnimation {
                    onResult(result)
                }
            }
        }
    }

    func onResult(_ result: Result<[Midjourney.Job], Error>) {
        switch result {
        case .success(let jobs):
            var distributedArrays = Array(repeating: [Midjourney.Job](), count: gridCount)
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

#Preview {
    RecentJobsView(
        client: .init(cookie: PreviewCookie.value)
    )
}
