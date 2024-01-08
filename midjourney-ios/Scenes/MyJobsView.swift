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

    @State var myUserId: String? = nil
    @State var gridSections: [GridSection] = []
    @State var selectedEntry: GridEntry? = nil

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            VStack {
                if gridSections.isEmpty {
                    GridSectionHeader(title: "Loading...")

                    LazyVGrid(columns: columns, spacing: gridPadding) {
                        ForEach(0..<100) { _ in
                            Color.loading
                                .aspectRatio(1, contentMode: .fit)
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: gridCorners)
                        )
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
                ForEach(gridSections) { section in
                    GridSectionHeader(title: section.title ?? "")

                    LazyVGrid(columns: columns, spacing: gridPadding) {
                        ForEach(section.entries) { entry in
                            Color.loading
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    let imageUrl = entry.image.webpImageUrl(size: .medium)
                                    KFImage.url(URL(string: imageUrl))
                                        .resizable()
                                        .loadDiskFileSynchronously()
                                        .fade(duration: 0.25)
                                        .aspectRatio(contentMode: .fill)
                                        .onTapGesture {
                                            selectedEntry = entry
                                        }
                                }
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: gridCorners)
                        )
                        .contentShape(Rectangle())
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
            }
            .padding(gridPadding)
            .padding(.horizontal, gridPadding)
        }
        .refreshable {
            // No error handling :'(
            try? await fetchJobsAsync()
        }
        .sheet(item: $selectedEntry) { entry in
            GridEntrySheet(gridEntry: entry, placeholderSize: .medium)
        }
        .onAppear {
            Task {
                // No error handling :'(
                if let userInfo = try? await client.userInfoAsync() {
                    myUserId = userInfo.user_id
                }
            }
        }
        .onChange(of: myUserId) {
            if myUserId != nil {
                Task {
                    // No error handling :'(
                    try? await fetchJobsAsync()
                }
            }
        }
    }

    func fetchJobsAsync() async throws {
        guard let myUserId else { return }
        let jobs = try await client.userJobsAsync(myUserId)
        let gridEntries = GridEntry.entriesForJobs(jobs)
        withAnimation {
            gridSections = GridSection.gridEntriesSectionedByDate(gridEntries)
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

#Preview {
    MyJobsView(
        client: .init(cookie: PreviewCookie.value)
    )
}
