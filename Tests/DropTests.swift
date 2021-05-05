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

import XCTest
@testable import Drops

final class DropTests: XCTestCase {
    func testDefaultInitializer() {
        let drop = Drop(title: "Hello world")
        XCTAssertEqual(drop.title, "Hello world")
        XCTAssertNil(drop.subtitle)
        XCTAssertNil(drop.icon)
        XCTAssertNil(drop.action)
    }

    @available(iOS 13.0, *)
    func testInitializer() {
        let icon = UIImage(systemName: "drop")
        let dismissIcon = UIImage(systemName: "xmark")
        let action = Drop.Action(icon: dismissIcon) { }
        let drop = Drop(title: "Hello world", subtitle: "I'm a drop!", icon: icon, action: action)
        XCTAssertEqual(drop.title, "Hello world")
        XCTAssertEqual(drop.subtitle, "I'm a drop!")
        XCTAssertEqual(drop.icon, icon)
        XCTAssertEqual(drop.action?.icon, dismissIcon)
    }
}
