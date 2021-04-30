//
//  Drops
//
//  Copyright (c) 2021-Present Omar Albeik - https://github.com/omaralbeik
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

/// An object representing a drop.
public struct Drop {
    /// An object representing a drop action.
    public struct Action {
        /// Create a new action.
        /// - Parameters:
        ///   - icon: optional icon image.
        ///   - handler: handler to be called when the drop is tapped.
        public init(icon: UIImage? = nil, handler: @escaping () -> Void) {
            self.icon = icon
            self.handler = handler
        }

        internal let icon: UIImage?
        internal let handler: () -> Void
    }

    /// Create a new drop.
    /// - Parameters:
    ///   - title: Title.
    ///   - subtitle: Optional subtitle. Default to `nil`.
    ///   - icon: Optional icon.
    ///   - action: Optional action.
    public init(title: String, subtitle: String? = nil, icon: UIImage? = nil, action: Action? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.action = action
    }

    public let title: String
    public let subtitle: String?
    public let icon: UIImage?
    public let action: Action?
}
