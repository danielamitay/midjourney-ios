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
    @State var selectedImage: Midjourney.Job.Image? = nil

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            VStack {
                if gridSections.isEmpty {
                    sectionHeader(title: "Loading...")

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
                    sectionHeader(title: section.title ?? "")

                    LazyVGrid(columns: columns, spacing: gridPadding) {
                        ForEach(section.entries) { entry in
                            Color.loading
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    let image = entry.image
                                    let imageUrl = image.webpImageUrl(size: .medium)
                                    KFImage.url(URL(string: imageUrl))
                                        .resizable()
                                        .loadDiskFileSynchronously()
                                        .fade(duration: 0.25)
                                        .aspectRatio(contentMode: .fill)
                                        .onTapGesture {
                                            selectedImage = image
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
        }
        .refreshable {
            // No error handling :'(
            try? await fetchJobsAsync()
        }
        .sheet(item: $selectedImage) { image in
            JobImageView(image: image, placeholderSize: .medium)
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

    func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(Font.DMSans.semiBold(size: 16))
                .foregroundStyle(.standardText)
            Spacer()
        }
        .padding(.horizontal, 27)
        .frame(height: 50)
        .padding(.top, 10)
    }

    func fetchJobsAsync() async throws {
        guard let myUserId else { return }
        let jobs = try await client.userJobsAsync(myUserId)
        let gridEntries = GridEntry.entriesForJobs(jobs)
        gridSections = GridSection.gridEntriesSectionedByDate(gridEntries)
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

extension Midjourney {
    func userJobsAsync(_ userId: String, cursor: String? = nil, pageSize: Int = 1000) async throws -> [Job] {
        return try await withCheckedThrowingContinuation { continuation in
            userJobs(userId, cursor: cursor, pageSize: pageSize) { result in
                continuation.resume(with: result)
            }
        }
    }

    func userInfoAsync() async throws -> UserInfo {
        return try await withCheckedThrowingContinuation { continuation in
            userInfo() { result in
                continuation.resume(with: result)
            }
        }
    }
}

#Preview {
    MyJobsView(
        client: .init(cookie: PreviewCookie.value)
    )
}
