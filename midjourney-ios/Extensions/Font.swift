//
//  Font.swift
//  midjourney-ios
//
//  Created by Daniel Amitay on 12/25/23.
//

import SwiftUI


extension Font {
    struct DMSans {
        private init() {}

        static func regular(size: CGFloat) -> Font {
            return .custom("DMSans-Regular", size: size)
        }

        static func medium(size: CGFloat) -> Font {
            return .custom("DMSans-Medium", size: size)
        }

        static func semiBold(size: CGFloat) -> Font {
            return .custom("DMSans-SemiBold", size: size)
        }

        static func bold(size: CGFloat) -> Font {
            return .custom("DMSans-Bold", size: size)
        }

        static func thin(size: CGFloat) -> Font {
            return .custom("DMSans-Thin", size: size)
        }

        static func light(size: CGFloat) -> Font {
            return .custom("DMSans-Light", size: size)
        }

        static func italic(size: CGFloat) -> Font {
            return .custom("DMSans-Italic", size: size)
        }
    }

    struct FGNoel {
        private init() {}

        static func regular(size: CGFloat) -> Font {
            return .custom("FGNoelW00-Regular", size: size)
        }
    }
}
