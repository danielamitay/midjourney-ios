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

    @State var currentPage = 0
    @State var isFetching = false
    @State var recentJobs: [Midjourney.Job] = []
    @State var selectedEntry: GridEntry? = nil

    private let gridCount: Int = 2
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            GridSectionHeader(title: "Explore")
                .padding(gridPadding)
                .padding(.horizontal, gridPadding)
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
                                                selectedEntry = GridEntry(job: job, image: image)
                                            }
                                    }
                            }
                            Color.clear
                                .frame(height: 1, alignment: .bottom)
                                .onAppear {
                                    fetchJobs()
                                }
                                .id(currentPage)
                        })
                    }
                }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .contentShape(Rectangle())
            .padding(gridPadding)
            .padding(.horizontal, gridPadding)
        }
        .sheet(item: $selectedEntry) { entry in
            GridEntrySheet(gridEntry: entry, placeholderSize: .large)
        }
        .onAppear {
            fetchJobs()
        }
    }

    func fetchJobs() {
        guard isFetching == false else { return }
        isFetching = true
        client.recentJobs(page: currentPage) { result in
            onResult(result)
        }
    }

    func onResult(_ result: Result<[Midjourney.Job], Error>) {
        switch result {
        case .success(let jobs):
            let shouldAnimate = currentPage == 0
            isFetching = false
            currentPage += 1
            recentJobs.append(contentsOf: jobs)
            if shouldAnimate {
                withAnimation {
                    recentJobs.append(contentsOf: jobs)
                }
            } else {
                recentJobs.append(contentsOf: jobs)
            }
        case .failure(_):
            break
        }
    }

    var recentJobColumns: [JobsColumn] {
        return JobsColumn.columnsForJobs(recentJobs, columnCount: gridCount)
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
