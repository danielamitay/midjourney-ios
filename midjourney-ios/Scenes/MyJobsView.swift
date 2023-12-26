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
    @State var myJobs: [Midjourney.Job] = []
    @State var selectedImage: Midjourney.Job.Image? = nil

    private let gridCount: Int = 4
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        ScrollView {
            HStack {
                Text("Today")
                    .font(Font.DMSans.semiBold(size: 16))
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
                                let image = job.images.first!
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
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
            .padding(gridPadding)
        }
        .sheet(item: $selectedImage) { image in
            JobImageView(image: image, placeholderSize: .medium)
        }
        .onAppear {
            client.userInfo { result in
                self.onUserInfoResult(result)
            }
        }
        .onChange(of: myUserId) {
            if myUserId != nil {
                fetchJobs()
            }
        }
    }

    func fetchJobs() {
        guard let myUserId else { return }
        client.userJobs(myUserId) { result in
            withAnimation {
                self.onJobsResult(result)
            }
        }
    }

    func onUserInfoResult(_ result: Result<Midjourney.UserInfo, Error>) {
        switch result {
        case .success(let success):
            myUserId = success.user_id
        case .failure(_):
            myJobs = []
        }
    }

    func onJobsResult(_ result: Result<[Midjourney.Job], Error>) {
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

#Preview {
    MyJobsView(
        client: .init(cookie: PreviewCookie.value)
    )
}
