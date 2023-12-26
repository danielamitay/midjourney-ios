//
//  GridSectionHeader.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

struct GridSectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(Font.DMSans.semiBold(size: 16))
                .foregroundStyle(.standardText)
            Spacer()
        }
        .padding(.horizontal, 27)
        .frame(height: 50)
        .padding(.top, 10)
    }
}

#Preview {
    VStack {
        GridSectionHeader(title: "Explore")
        GridSectionHeader(title: "Loading...")
        GridSectionHeader(title: "Today")
    }
}
