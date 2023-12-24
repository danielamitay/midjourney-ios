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
    let userId: String

    enum Tab {
        case explore
        case myImages
    }

    @State var selectedTab: Tab = .explore

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            RecentJobsView(client: client)
                .opacity(selectedTab == .explore ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .explore ? 0.0 : -50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .explore)

            MyJobsView(client: client, userId: userId)
                .opacity(selectedTab == .myImages ? 1.0 : 0.0)
                .safeAreaPadding(.bottom, 70)
                .offset(x: selectedTab == .myImages ? 0.0 : 50)
                .animation(.easeOut(duration: 0.2), value: selectedTab == .myImages)

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(.menu)
                    .stroke(.menuBorder, lineWidth: 1)
                    .frame(height: 62)
                    .overlay {
                        HStack {
                            Color.clear
                                .aspectRatio(1, contentMode: .fit)
                                .overlay {
                                    Image(.menuIcon)
                                        .foregroundStyle(.standardText)
                                }
                            let exploreButtonColor = selectedTab == .explore ? Color.selectedText.opacity(0.1) : Color.menu
                            let exploreTextColor = selectedTab == .explore ? Color.selectedText : Color.deselectedText
                            RoundedRectangle(cornerRadius: 8)
                                .fill(exploreButtonColor)
                                .stroke(exploreButtonColor.opacity(0.1), lineWidth: 1)
                                .onTapGesture {
                                    selectedTab = .explore
                                }
                                .overlay {
                                    HStack(spacing: 5) {
                                        Image(.compassIcon)
                                        Text("Explore")
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(exploreTextColor)
                                }
                            let myImagesButtonColor = selectedTab == .myImages ? Color.selectedText.opacity(0.1) : Color.menu
                            let myImagesTextColor = selectedTab == .myImages ? Color.selectedText : Color.deselectedText
                            RoundedRectangle(cornerRadius: 8)
                                .fill(myImagesButtonColor)
                                .stroke(myImagesButtonColor, lineWidth: 1)
                                .onTapGesture {
                                    selectedTab = .myImages
                                }
                                .overlay {
                                    HStack(spacing: 2) {
                                        Image(.photoIcon)
                                        Text("My Images")
                                            .font(.system(size: 15))
                                            .fontWeight(.medium)
                                    }
                                    .foregroundStyle(myImagesTextColor)
                                }
                        }
                        .padding(8)
                    }
                    .padding(.horizontal, 12)
            }
        }
    }
}

extension UserDefaults {
    var cookie: String {
        return self.string(forKey: "cookie") ?? ""
    }
    var userId: String {
        return self.string(forKey: "userId") ?? ""
    }
}

#Preview {
    HomeView(
        client: .init(cookie: UserDefaults.standard.cookie),
        userId: UserDefaults.standard.userId
    )
}
