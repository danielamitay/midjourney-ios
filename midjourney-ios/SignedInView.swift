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
            Color.gray
                .opacity(0.5)
                .ignoresSafeArea()
                .opacity(selectedTab == .explore ? 1.0 : 0.0)

            MyJobsView(client: client, userId: userId)
                .opacity(selectedTab == .myImages ? 1.0 : 0.0)

            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                    .frame(height: 62)
                    .padding(.horizontal, 12)
                    .overlay {
                        HStack {
                            Button("Explore") {
                                selectedTab = .explore
                            }
                            Button("My Images") {
                                selectedTab = .myImages
                            }
                        }
                    }
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
