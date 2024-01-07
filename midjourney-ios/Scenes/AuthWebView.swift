//
//  AuthWebView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 1/6/24.
//

import SwiftUI
import WebKit

struct AuthWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let onComplete: (Result<String, Error>) -> Void
    private var webView: WKWebView

    init(_ onComplete: @escaping (Result<String, Error>) -> Void) {
        self.onComplete = onComplete
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        self.webView = WKWebView(frame: .zero, configuration: configuration)
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: "https://www.midjourney.com/explore") {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: AuthWebView
        private var webViews: [WKWebView] = []
        private var autoSignInTimer: Timer? = nil

        enum AuthError: Error {
            case denied
        }

        init(_ parent: AuthWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                if (url != "https://www.midjourney.com/explore"
                    && url != "https://www.midjourney.com/home?callbackUrl=%2Fexplore") {
                    autoSignInTimer?.invalidate()
                }
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                if (url == "https://www.midjourney.com/home?callbackUrl=%2Fexplore"
                    || url == "https://www.midjourney.com/explore") {
                    webView.disableAnimations()
                    autoSignInTimer?.invalidate()
                    autoSignInTimer = .scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak webView] _ in
                        webView?.selectSignInButton()
                    })
                } else if url.starts(with: "https://www.midjourney.com/__/auth/handler?code=") {
                    webView.configuration.processPool = .init()
                    for delay in 1...5 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                            if let url = URL(string: "https://www.midjourney.com/explore") {
                                let request = URLRequest(url: url)
                                webView.load(request)
                            }
                        }
                    }
                } else if url.starts(with: "https://www.midjourney.com/__/auth/handler?error=") {
                    self.parent.onComplete(.failure(AuthError.denied))
                }
            }

            let httpCookieStore = webView.configuration.websiteDataStore.httpCookieStore
            httpCookieStore.getAllCookies { cookies in
                let mjCookieString = cookies
                    .filter { $0.domain.contains("www.midjourney.com") }
                    .reduce(into: [:]) { $0[$1.name] = $1.value }
                    .map { "\($0)=\($1)" }
                    .joined(separator: "; ")
                if !mjCookieString.isEmpty {
                    self.parent.onComplete(.success(mjCookieString))
                }
            }
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.onComplete(.failure(error))
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                let popupWebView = WKWebView(frame: .zero, configuration: configuration)
                popupWebView.navigationDelegate = self
                popupWebView.uiDelegate = self
                parent.webView.addSubview(popupWebView)
                popupWebView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    popupWebView.topAnchor.constraint(equalTo: parent.webView.topAnchor),
                    popupWebView.bottomAnchor.constraint(equalTo: parent.webView.bottomAnchor),
                    popupWebView.leadingAnchor.constraint(equalTo: parent.webView.leadingAnchor),
                    popupWebView.trailingAnchor.constraint(equalTo: parent.webView.trailingAnchor)
                ])
                self.webViews.append(popupWebView)
                return popupWebView
            }
            return nil
        }
    }
}

fileprivate extension WKWebView {
    func disableAnimations() {
        let js = """
        // Disable CSS Animations and Transitions
        var css = '* { animation: none !important; transition: none !important; }',
            head = document.head || document.getElementsByTagName('head')[0],
            style = document.createElement('style');
        style.type = 'text/css';
        style.appendChild(document.createTextNode(css));
        head.appendChild(style);

        // Clear JavaScript Intervals and Timeouts
        var highestIntervalId = setInterval(() => {});
        for (var i = 0; i < highestIntervalId; i++) {
            clearInterval(i);
        }

        var highestTimeoutId = setTimeout(() => {});
        for (var i = 0; i < highestTimeoutId; i++) {
            clearTimeout(i);
        }
        """
        evaluateJavaScript(js)
    }

    func selectSignInButton() {
        let js = """
        var spans = document.querySelectorAll('button span');
        var didClick = false;
        for (var i = 0; i < spans.length; i++) {
            if (spans[i].textContent.trim() === 'Sign In') {
                spans[i].parentNode.click();
                didClick = true;
                break;
            }
        }
        didClick;
        """
        evaluateJavaScript(js)
    }
}

#Preview {
    AuthWebView { result in
        switch result {
        case .success(let success):
            print("cookie: \(success)")
        case .failure(let failure):
            print("failure: \(failure)")
        }
    }
}
