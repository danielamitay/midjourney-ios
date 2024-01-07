//
//  LandingView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var controller: SystemController

    @State private var cookieAuthSheet = false
    @State private var discordAuthSheet = false

    var body: some View {
        VStack {
            Spacer()
            Image(.midjourneyLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .padding(.bottom, -20)
                .padding(.top, 20)
            Text("Midjourney")
                .font(Font.DMSans.medium(size: 28))
                .padding(.bottom, 44)

            Spacer()

            authBar
                .frame(height: 62)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.menu)
                        .stroke(.white.opacity(0.25), lineWidth: 1)
                        .compositingGroup()
                        .shadow(radius: 6, y: 3)
                }
                .padding(.horizontal, 12)
                .font(Font.DMSans.semiBold(size: 15))
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                LandingBackground()
                Color.background
                    .opacity(0.9)
                    .ignoresSafeArea()
            }
        }
        .font(Font.DMSans.regular(size: 14))
        .sheet(isPresented: $discordAuthSheet, content: {
            NavigationStack {
                AuthWebView { result in
                    discordAuthSheet.toggle()
                    switch result {
                    case .success(let cookie):
                        controller.setCookie(cookie)
                    case .failure(_):
                        break
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("Discord Auth")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            discordAuthSheet.toggle()
                        }
                    }
                }
            }
            .ignoresSafeArea()
        })
        .sheet(isPresented: $cookieAuthSheet, content: {
            NavigationStack {
                CookieAuthView { cookie in
                    cookieAuthSheet.toggle()
                    controller.setCookie(cookie)
                }
                .navigationTitle("Cookie Auth")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            cookieAuthSheet.toggle()
                        }
                    }
                }
            }
            .ignoresSafeArea()
        })
    }

    var authBar: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.discord)
                .stroke(.white.opacity(0.2), lineWidth: 1)
                .onTapGesture {
                    discordAuthSheet.toggle()
                }
                .overlay {
                    HStack(spacing: 5) {
                        Image(.discordIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                        Text("Discord Auth")
                    }
                    .foregroundStyle(.white)
                }
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.menu)
                .onTapGesture {
                    cookieAuthSheet.toggle()
                }
                .overlay {
                    HStack(spacing: 5) {
                        Image(.cookieIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                        Text("Cookie Auth")
                    }
                    .foregroundStyle(Color.deselectedText)
                }
        }
        .padding(8)
    }
}

#Preview {
    LandingView()
}
