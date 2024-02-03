//
//  SystemController.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import Combine
import Foundation

import Midjourney

class SystemController: ObservableObject {
    @Published private(set) var mjClient: Midjourney? = nil
    @Published private var cookie: String? = UserDefaults.standard.string(forKey: "mj_cookie") {
        didSet {
            UserDefaults.standard.setValue(cookie, forKey: "mj_cookie")
            if let cookie, !cookie.isEmpty {
                mjClient = Midjourney(cookie: cookie)
            } else {
                mjClient = nil
            }
        }
    }

    init() {
        if let cookie, !cookie.isEmpty {
            mjClient = Midjourney(cookie: cookie)
        }
    }

    func setCookie(_ cookie: String?) {
        self.cookie = cookie
    }

    // TODO: (Damitay) Probably worth distinguishing a 401 logout
    func clearCookie() {
        self.cookie = nil
    }
}
