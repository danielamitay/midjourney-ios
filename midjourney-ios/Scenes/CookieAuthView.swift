//
//  CookieAuthView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 1/7/24.
//

import SwiftUI

struct CookieAuthView: View {
    let onCookie: (String) -> Void

    @State private var cookie: String = ""
    @FocusState private var cookieFieldIsFocused: Bool

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Paste your Midjourney web cookie here:")
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.top, 20)

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
                                setCookie()
                            }
                        }
                    })
                    .font(Font.DMSans.regular(size: 14))
                    .submitLabel(.go)
                    .lineLimit(5...5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                }
                HStack {
                    if !PreviewCookie.value.isEmpty && !cookie.isValidCookieFormat {
                        Button("Paste Test Cookie") {
                            cookie = PreviewCookie.value
                        }
                        .foregroundStyle(.green)
                    }
                    Spacer()
                    Button(cookieButtonText) {
                        setCookie()
                    }
                    .disabled(!cookie.isValidCookieFormat)
                }
                .padding(.horizontal, 12)

                Spacer()

                Text("How to find your cookie:")
                    .font(Font.DMSans.medium(size: 14))
                    .padding(15)

                CookieStepsView()

                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .shadow(color: .background, radius: 1)
        .padding(.horizontal, 12)
        .background {
            Color.background
                .opacity(0.95)
                .ignoresSafeArea()
                .onTapGesture {
                    cookieFieldIsFocused = false
                }
        }
        .font(Font.DMSans.regular(size: 14))
    }

    func setCookie() {
        cookieFieldIsFocused = false
        guard cookie.isValidCookieFormat else { return }
        onCookie(cookie)
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
    CookieAuthView { cookie in
        print("Cookie: \(cookie)")
    }
}
