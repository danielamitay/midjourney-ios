//
//  HomeView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/20/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct HomeView: View {
    let client: Midjourney

    @EnvironmentObject private var controller: SystemController

    @State var selectedTab: HomeTab = .explore
    @State var alphaClient: Midjourney.Alpha? = nil
    @State var webSocket: WebSocket? = nil

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            RecentJobsView(client: client)
                .opacity(selectedTab == .explore ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .explore ? 0.0 : -50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .explore)

            MyJobsView(client: client, webSocket: webSocket)
                .opacity(selectedTab == .myImages ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .myImages ? 0.0 : 50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .myImages)

            HomeMenuView(selectedTab: $selectedTab, alphaClient: alphaClient)
        }
        .onAppear {
            Task {
                if let alpha = try? await client.alphaClientAsync() {
                    alphaClient = alpha
                    webSocket = alpha.createWebSocket()
                    webSocket?.connect()

                    if let queue = try? await alpha.userQueueAsync() {
                        let runningJobIds = queue.running_all
                        for jobId in runningJobIds {
                            webSocket?.subscribeToJob(jobId)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(
        client: .init(cookie: PreviewCookie.value)
    )
}
