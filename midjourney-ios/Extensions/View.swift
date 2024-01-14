//
//  View.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 1/8/24.
//

import SwiftUI

extension View {
    func doubleUp(_ edges: Edge.Set = .all, offset: CGFloat = 1) -> some View {
        ZStack {
            self
            if edges.contains(.leading) {
                self.offset(x: -offset)
            }
            if edges.contains(.trailing) {
                self.offset(x: offset)
            }
            if edges.contains(.top) {
                self.offset(y: -offset)
            }
            if edges.contains(.bottom) {
                self.offset(y: offset)
            }
        }
    }
}

extension View {
    func takeSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeModifier(size))
    }
}

fileprivate struct SizeModifier: ViewModifier {

    @Binding var size: CGSize

    init(_ size: Binding<CGSize>) {
        _size = size
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { preference in
                self.size = preference
            }
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    typealias V = CGSize
    static var defaultValue: V = .zero
    static func reduce(value: inout V, nextValue: () -> V) {
        value = nextValue()
    }
}
