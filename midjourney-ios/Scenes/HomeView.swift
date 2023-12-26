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

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            RecentJobsView(client: client)
                .opacity(selectedTab == .explore ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .explore ? 0.0 : -50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .explore)

            MyJobsView(client: client)
                .opacity(selectedTab == .myImages ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .myImages ? 0.0 : 50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .myImages)

            HomeMenuView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    HomeView(
        client: .init(cookie: PreviewCookie.value)
    )
}
