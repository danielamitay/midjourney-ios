//
//  LandingView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject private var controller: SystemController

    @State private var cookie: String = ""
    @State private var validCookie: Bool = false
    @FocusState private var cookieFieldIsFocused: Bool

    private let gridCount: Int = 2
    private let gridPadding: CGFloat = 3
    private let gridCorners: CGFloat = 3

    var body: some View {
        VStack {
            Text("Midjourney")
                .font(.system(size: 28))
                .bold()
                .padding(.top, 20)
            Spacer()
            HStack {
                Text("Paste your cookie here:")
                Spacer()
            }
            .padding(.horizontal, 8)

            HStack {
                Spacer()
                TextField(
                    """
                    _ga=GA123.123...;
                    __Host-Midjourney.AuthUserToken=eyAbC...;
                    __Host-Midjourney.AuthUserToken.sig=eyAbC...;
                    __Host-Midjourney.AuthUser=eyAbC...;
                    """,
                    text: $cookie,
                    axis: .vertical
                )
                .focused($cookieFieldIsFocused)
                .onChange(of: cookie, {
                    if cookie.hasSuffix("\n") {
                        cookie.removeLast()
                        cookieFieldIsFocused = false
                        if cookie.isValidCookieFormat {

                        }
                    }
                })
                .font(.system(size: 14))
                .submitLabel(.go)
                .lineLimit(5...5)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.menu)
                        .stroke(.menuBorder, lineWidth: 2)
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button(cookieButtonText) {
                    setCookie()
                }
                .disabled(!cookie.isValidCookieFormat)
            }
            .padding(.horizontal, 12)
            Spacer()
        }
        .padding(.horizontal, 12)
        .background {
            Color.background
                .ignoresSafeArea()
                .onTapGesture {
                    cookieFieldIsFocused = false
                }
        }
    }

    func setCookie() {
        cookieFieldIsFocused = false
        guard cookie.isValidCookieFormat else { return }
        controller.setCookie(cookie)
    }

    var cookieButtonText: String {
        if cookie.isEmpty {
            return "No cookie detected"
        } else if !cookie.isValidCookieFormat {
            return "Invalid cookie or format"
        } else {
            return "Use cookie"
        }
    }
}

extension String {
    var isValidCookieFormat: Bool {
        var cookieKeyValuePairs = [String: String]()
        let keyValueStrings = components(separatedBy: "; ")
        for pair in keyValueStrings {
            let elements = pair.components(separatedBy: "=")
            if elements.count == 2 {
                let key = elements[0]
                let value = elements[1]
                cookieKeyValuePairs[key] = value
            }
        }
        // We expect a minimum set of key/value pairs in the cookie string
        let expectedCookieKeys = [
            "__Host-Midjourney.AuthUserToken",
            "__Host-Midjourney.AuthUserToken.sig",
            "__Host-Midjourney.AuthUser"
        ]
        return expectedCookieKeys.allSatisfy(cookieKeyValuePairs.keys.contains)
    }
}

#Preview {
    LandingView()
}