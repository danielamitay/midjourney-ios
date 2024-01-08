//
//  HomeMenuView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

import SmoothGradient

enum HomeTab {
    case explore
    case myImages
}

struct HomeMenuView: View {
    @Binding var selectedTab: HomeTab

    @EnvironmentObject private var controller: SystemController

    @State private var menuExpanded = false
    @State private var appIconName = UIApplication.shared.alternateIconName

    var body: some View {
        ZStack {
            gradientBackground
            tabBar
        }
    }

    var gradientBackground: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                LinearGradient(
                    gradient: .smooth(
                        from: Color.background,
                        to: Color.background.opacity(0),
                        curve: .easeInOut
                    ),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 80)
                Color.background
                    .frame(height: 20 + geometry.safeAreaInsets.bottom)
            }
            .ignoresSafeArea()
        }
    }

    var tabBar: some View {
        VStack(spacing: 0) {
            if menuExpanded {
                LinearGradient(
                    gradient: .smooth(
                        from: Color.background,
                        to: Color.background.opacity(0.8),
                        curve: .easeInOut
                    ),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    menuExpanded.toggle()
                }
                VStack {
                    appIconRow
                    menuButton(title: "Sign Out")
                        .onTapGesture {
                            controller.clearCookie()
                        }
                }
                .padding(12)
                .padding(.bottom, 12)
                .background(Color.background)
            } else {
                Spacer()
            }
            HStack(spacing: 0) {
                Button {
                    menuExpanded.toggle()
                } label: {
                    Spacer()
                    Spacer()
                    VStack(spacing: 5) {
                        Image(menuExpanded ? .closeIcon : .menuIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Menu")
                    }
                    Spacer()
                }
                .foregroundStyle(Color.deselectedText)

                let exploreButtonColor = selectedTab == .explore ? Color.selectedText : Color.deselectedText
                Button {
                    selectedTab = .explore
                    menuExpanded = false
                } label: {
                    Spacer()
                    VStack(spacing: 5) {
                        Image(.compassIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Explore")
                    }
                    Spacer()
                }
                .foregroundStyle(exploreButtonColor)

                let myImagesButtonColor = selectedTab == .myImages ? Color.selectedText : Color.deselectedText
                Button {
                    selectedTab = .myImages
                    menuExpanded = false
                } label: {
                    Spacer()
                    VStack(spacing: 5) {
                        Image(.photoIcon)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Gallery")
                    }
                    Spacer()
                    Spacer()
                }
                .foregroundStyle(myImagesButtonColor)
            }
            .background(menuExpanded ? Color.background : nil)
        }
        .font(Font.DMSans.medium(size: 12))
    }

    var appIconRow: some View {
        HStack {
            Text("App Icon")
            Spacer()
            appIcon(name: nil)
            appIcon(name: "AppIconDark")
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.loading.opacity(0.5))
                .stroke(.loading, lineWidth: 1)
        }
    }

    func appIcon(name: String?) -> some View {
        let selected = appIconName == name
        return Image(uiImage: UIImage(named: name ?? "AppIcon") ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .mask {
                RoundedRectangle(cornerRadius: 5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(selected ? Color.selectedText : Color.menuBorder, lineWidth: selected ? 2 : 1)
            }
            .onTapGesture {
                UIApplication.shared.setAlternateIconName(name)
                appIconName = name
            }
    }

    func menuButton(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(.loading.opacity(0.5))
                .stroke(.loading, lineWidth: 1)
        }
    }
}

#Preview {
    HomeMenuView(selectedTab: .constant(.explore))
        .background(Color.gray)
}
