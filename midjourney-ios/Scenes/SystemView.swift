//
//  SystemView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import SwiftUI

struct SystemView: View {
    @StateObject private var controller = SystemController()

    var body: some View {
        Group {
            if let client = controller.mjClient {
                HomeView(client: client, userId: UserDefaults.standard.userId)
            } else {
                LandingView()
            }
        }
        .environmentObject(controller)
    }
}

#Preview {
    SystemView()
}
