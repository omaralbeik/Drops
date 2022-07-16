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
    XCTAssertEqual(drop.titleNumberOfLines, 1)
    XCTAssertNil(drop.subtitle)
    XCTAssertEqual(drop.subtitleNumberOfLines, 1)
    XCTAssertNil(drop.icon)
    XCTAssertNil(drop.action)
    XCTAssertEqual(drop.position, .top)
    XCTAssertEqual(drop.duration, .recommended)
    XCTAssertEqual(drop.accessibility.message, "Hello world")
  }

  func testExpressiblesInitializer() {
    let drop1: Drop = "Hello world"
    XCTAssertEqual(drop1.title, "Hello world")
    XCTAssertEqual(drop1.position, .top)
    XCTAssertEqual(drop1.duration, .recommended)
    XCTAssertEqual(drop1.accessibility.message, "Hello world")

    let drop2 = Drop(title: "Hello world", duration: 5.0, accessibility: "Alert: Hello world")
    XCTAssertEqual(drop2.title, "Hello world")
    XCTAssertEqual(drop2.duration.value, 5.0)
    XCTAssertEqual(drop2.accessibility.message, "Alert: Hello world")
  }

  func testInitializer() {
    let icon = UIImage(systemName: "drop")
    let dismissIcon = UIImage(systemName: "xmark")
    let action = Drop.Action(icon: dismissIcon) { }
    let drop = Drop(
      title: "Hello world",
      titleNumberOfLines: 3,
      subtitle: "I'm a drop!",
      subtitleNumberOfLines: 0,
      icon: icon,
      action: action,
      position: .bottom,
      duration: .seconds(1)
    )
    XCTAssertEqual(drop.title, "Hello world")
    XCTAssertEqual(drop.titleNumberOfLines, 3)
    XCTAssertEqual(drop.subtitle, "I'm a drop!")
    XCTAssertEqual(drop.subtitleNumberOfLines, 0)
    XCTAssertEqual(drop.icon, icon)
    XCTAssertEqual(drop.action?.icon, dismissIcon)
    XCTAssertEqual(drop.position, .bottom)
    XCTAssertEqual(drop.duration, .seconds(1))
    XCTAssertEqual(drop.accessibility.message, "Hello world, I'm a drop!")
  }

  func testDurationValue() {
    XCTAssertEqual(Drop.Duration.recommended.value, 2)
    XCTAssertEqual(Drop.Duration.seconds(1).value, 1)
  }
}
