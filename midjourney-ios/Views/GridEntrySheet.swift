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

    var parsedCommand: ParsedCommand {
        return ParsedCommand(full_command: gridEntry.job.full_command)
    }

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
                    HStack {
                        Text(parsedCommand.prompt)
                            .foregroundStyle(.white)
                            .font(Font.DMSans.regular(size: 14))
                        Spacer()
                    }
                    let parameters = Array(parsedCommand.parameters).sorted { $0.key < $1.key }
                    if parameters.count > 0 {
                        HStack {
                            ForEach(parameters, id: \.key) { key, value in
                                HStack(spacing: 2) {
                                    Text(key)
                                        .foregroundStyle(.white.opacity(0.75))
                                    Text(value)
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
    let prompt: String
    let parameters: [String: String]
}

extension ParsedCommand {
    init(full_command: String) {
        let components = full_command.components(separatedBy: "--")
        self.prompt = components.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        var parameters: [String: String] = [:]
        components.dropFirst().forEach { component in
            let pair = component.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
            if pair.count == 2 {
                let key = String(pair[0]).trimmingCharacters(in: .whitespacesAndNewlines)
                let value = String(pair[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                parameters[key] = value
            }
        }
        self.parameters = parameters
    }
}

/*
#Preview {
    GridEntrySheet()
}
*/
