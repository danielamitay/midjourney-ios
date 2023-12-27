//
//  HomeMenuView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

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
        VStack {
            Spacer()
            VStack {
                if menuExpanded {
                    VStack {
                        appIconRow
                        menuButton(title: "Sign Out")
                            .onTapGesture {
                                controller.clearCookie()
                            }
                    }
                    .padding(10)
                    .padding(.bottom, -12)
                }
                tabBar
                    .frame(height: 62)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.menu)
                    .stroke(.menuBorder, lineWidth: 1)
                    .compositingGroup()
                    .shadow(radius: 6, y: 3)
            }
            .padding(.horizontal, 12)
            .font(Font.DMSans.semiBold(size: 15))
        }
        .background {
            if menuExpanded {
                Color.clear
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        menuExpanded.toggle()
                    }
            }
        }
    }

    var tabBar: some View {
        HStack {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    Image(menuExpanded ? .closeIcon : .menuIcon)
                        .foregroundStyle(.standardText)
                }
                .onTapGesture {
                    menuExpanded.toggle()
                }
            let exploreButtonColor = selectedTab == .explore ? Color.selectedText.opacity(0.1) : Color.menu
            let exploreTextColor = selectedTab == .explore ? Color.selectedText : Color.deselectedText
            RoundedRectangle(cornerRadius: 8)
                .fill(exploreButtonColor)
                .stroke(exploreButtonColor, lineWidth: 1)
                .onTapGesture {
                    selectedTab = .explore
                    menuExpanded = false
                }
                .overlay {
                    HStack(spacing: 5) {
                        Image(.compassIcon)
                        Text("Explore")
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
                    menuExpanded = false
                }
                .overlay {
                    HStack(spacing: 2) {
                        Image(.photoIcon)
                        Text("My Images")
                    }
                    .foregroundStyle(myImagesTextColor)
                }
        }
        .padding(8)
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
        .background(Color.background)
}
