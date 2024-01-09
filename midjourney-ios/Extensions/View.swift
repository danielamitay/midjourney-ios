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
