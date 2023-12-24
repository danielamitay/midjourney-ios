//
//  SystemView.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/24/23.
//

import SwiftUI

struct SystemView: View {
    @StateObject var controller = SystemController()

    var body: some View {
        if let client = controller.mjClient {
            HomeView(client: client, userId: UserDefaults.standard.userId)
        } else {
            Color.blue
                .ignoresSafeArea()
        }
    }
}

#Preview {
    SystemView()
}
