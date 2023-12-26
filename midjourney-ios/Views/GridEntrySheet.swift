//
//  GridEntrySheet.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/26/23.
//

import SwiftUI

import Midjourney

struct GridEntrySheet: View {
    let gridEntry: GridEntry
    var placeholderSize: Midjourney.Job.Image.Size? = nil

    @State private var captionVisible = true

    var body: some View {
        ZStack {
            JobImageView(image: gridEntry.image, placeholderSize: placeholderSize)
                .onTapGesture {
                    withAnimation {
                        captionVisible.toggle()
                    }
                }
            VStack {
                Spacer()
                HStack {
                    Text(gridEntry.job.full_command)
                        .foregroundStyle(.white)
                        .font(Font.DMSans.regular(size: 14))
                        .padding(.bottom, 10)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .background {
                    LinearGradient(colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.4),
                        Color.black.opacity(0.5)
                    ], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                }
                .opacity(captionVisible ? 1.0 : 0.0)
            }
        }
    }
}

/*
#Preview {
    GridEntrySheet()
}
*/
