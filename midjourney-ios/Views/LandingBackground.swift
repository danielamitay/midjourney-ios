//
//  LandingBackground.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct LandingBackground: View {

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .top) {
                    VStack {
                        ForEach(0..<5000, id: \.self) { i in
                            Color.clear
                                .frame(height: 1)
                                .id(i)
                        }
                    }
                    VStack {
                        HStack(alignment: .top, spacing: gridPadding) {
                            ForEach(jobsColumns) { column in
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
                                            }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .padding(gridPadding)
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }

    var jobs: [Midjourney.Job] {
        if let asset = NSDataAsset(name: "LandingJobs") {
            if let jobs = try? JSONDecoder().decode([Midjourney.Job].self, from: asset.data) {
                return jobs
            }
        }
        return []
    }

    var jobsColumns: [JobsColumn] {
        return JobsColumn.columnsForJobs(jobs, columnCount: gridCount)
    }
}

#Preview {
    LandingBackground()
}
