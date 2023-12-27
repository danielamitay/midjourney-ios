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
                VStack {
                    let parsedCommand = gridEntry.job.parsedCommand
                    HStack {
                        Text(parsedCommand.prompt)
                            .foregroundStyle(.white)
                            .font(Font.DMSans.regular(size: 14))
                        Spacer()
                    }
                    if parsedCommand.parameters.count > 0 {
                        HStack {
                            ForEach(parsedCommand.parameters) { parameter in
                                HStack(spacing: 2) {
                                    Text(parameter.name)
                                        .foregroundStyle(.white.opacity(0.75))
                                    Text(parameter.value)
                                        .foregroundStyle(.white)
                                }
                                .font(Font.DMSans.medium(size: 14))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.white.opacity(0.1))
                                }
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 10)
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

struct ParsedCommand {
    struct Parameter: Identifiable {
        var id: String {
            return "--\(name) \(value)"
        }
        let name: String
        let value: String
    }
    let prompt: String
    let parameters: [Parameter]
}

/*
#Preview {
    GridEntrySheet()
}
*/
