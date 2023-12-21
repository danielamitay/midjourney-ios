//
//  SignedInView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/20/23.
//

import SwiftUI

import Kingfisher
import Midjourney

struct SignedInView: View {
    let client: Midjourney
    let userId: String

    enum Tab {
        case explore
        case myImages
    }

    @State var selectedTab: Tab = .explore
    @State var myJobs: [Midjourney.MyJob] = []

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            Color.gray
                .opacity(0.25)
                .ignoresSafeArea()
                .opacity(selectedTab == .explore ? 1.0 : 0.0)

            MyJobsView(client: client, userId: userId)
                .opacity(selectedTab == .myImages ? 1.0 : 0.0)

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

#Preview {
    SignedInView(
        client: .init(cookie: ""),
        userId: ""
    )
}
