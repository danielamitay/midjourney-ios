//
//  LandingView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import SwiftUI
import UIKit

struct LandingView: View {
    @EnvironmentObject private var controller: SystemController
    @Environment(\.colorScheme) var colorScheme

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
                .font(.DMSans.medium(size: 28))
            Text("mobile")
                .doubleUp(offset: (1.0 / UIScreen.main.scale))
                .foregroundStyle(.selectedText)
                .font(Font.FGNoel.regular(size: 22))
                .padding(.bottom, 44)
                .offset(x: 72, y: -2)
                .rotationEffect(.degrees(-10))

            Spacer()

            VStack(spacing: 10) {
                discordButton

                cookieButton
            }
            .compositingGroup()
            .shadow(radius: 6, y: 3)
            .padding(.horizontal, 36)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                LandingBackground()
                Color.background
                    .opacity(colorScheme == .dark ? 0.8 : 0.95)
                    .ignoresSafeArea()
            }
        }
        .font(.DMSans.regular(size: 14))
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                            VStack {
                                Text("Log In with Discord")
                                    .font(.headline)
                                Text("The app will never get access to your credentials")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.secondary)
                            }
                        }
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
                .navigationTitle("Cookie Authentication")
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

    var discordButton: some View {
        Button(action: {
            discordAuthSheet.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(.discord)
                .stroke(.white.opacity(0.1), lineWidth: 1)
                .overlay {
                    HStack(spacing: 10) {
                        Image(.discordIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                        Text("Log In with Discord")
                    }
                    .foregroundStyle(.white)
                }
                .frame(height: 52)
                .font(.DMSans.semiBold(size: 17))
        })
    }

    var cookieButton: some View {
        Button(action: {
            cookieAuthSheet.toggle()
        }, label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(.menu)
                .stroke(.white.opacity(0.1), lineWidth: 1)
                .overlay {
                    HStack(spacing: 8) {
                        Image(.cookieIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18)
                        Text("Use cookie authentication\nfrom a desktop browser")
                    }
                    .foregroundStyle(Color.primary.opacity(0.75))
                }
                .frame(height: 52)
                .font(.DMSans.semiBold(size: 12))
        })
    }
}

#Preview {
    LandingView()
}
