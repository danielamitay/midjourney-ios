//
//  CookieStepsView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

struct CookieStepsView: View {
    var body: some View {
        VStack(spacing: 30) {
            CookieStep(
                imageResource: .cookieStep1,
                title: "Open Chrome",
                description: "In the Chrome toolbar, go to View > Developer"
            )
            CookieStep(
                imageResource: .cookieStep2,
                title: "Open Developer Tools",
                description: "Select \"Developer Tools\" from the menu. The tools will open at the bottom of the window."
            )
            CookieStep(
                imageResource: .cookieStep3,
                title: "Open Network Tab",
                description: "In the \"Network\" Tab, filter for midjourney.com."
            )
            CookieStep(
                imageResource: .cookieStep4,
                title: "Find Cookie Header",
                description: "Select one of the api requests, and find the \"Cookie\" header. This is the value to copy!"
            )
            Color.clear
                .frame(height: 0)
        }
    }
}

struct CookieStep: View {
    let imageResource: ImageResource
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                HStack {
                    Text(title)
                        .font(Font.DMSans.bold(size: 16))
                    Spacer()
                }
                HStack {
                    Text(description)
                    Spacer()
                }
            }
            .padding(.horizontal, 5)

            Image(imageResource)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .mask {
                    RoundedRectangle(cornerRadius: 10)
                }
                .shadow(radius: 5)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                }
        }
        .padding(.horizontal, 12)
        .font(Font.DMSans.regular(size: 14))
        .foregroundStyle(.standardText)
        .multilineTextAlignment(.leading)
    }
}


#Preview {
    ScrollView {
        CookieStepsView()
    }
    .scrollIndicators(.hidden)
    .background(.gray.opacity(0.25))
}
