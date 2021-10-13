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

final class DropsTests: XCTestCase {
    func testShow() {
        let drops = Drops()

        let drop1 = Drop(title: "Test 1", duration: .seconds(1))
        drops.show(drop1)

        let exp1 = expectation(description: "First Drops is presented")
        DispatchQueue.main.async {
            if drops.current != nil {
                exp1.fulfill()
            }
        }

        let exp2 = expectation(description: "First Drops is hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if drops.current == nil {
                exp2.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testStaticShow() {
        let drop1 = Drop(title: "Test 1", duration: .seconds(1))
        Drops.show(drop1)

        let exp1 = expectation(description: "First Drops is presented")
        DispatchQueue.main.async {
            if Drops.shared.current != nil {
                exp1.fulfill()
            }
        }

        let exp2 = expectation(description: "First Drops is hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if Drops.shared.current == nil {
                exp2.fulfill()
            }
        }

        waitForExpectations(timeout: 3)
    }

    func testDropsAreQueued() {
        let drops = Drops()
        (0..<5)
            .map { Drop(title: "\($0)", duration: .seconds(0.5)) }
            .forEach(drops.show)

        let exp1 = expectation(description: "All Drops are hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if drops.queue.count == 5-1 {
                exp1.fulfill()
            }
        }

        let exp2 = expectation(description: "All Drops are hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if drops.queue.isEmpty {
                exp2.fulfill()
            }
        }

        waitForExpectations(timeout: 4)
    }

    func testStaticDropsAreQueued() {
        (0..<5)
            .map { Drop(title: "\($0)", duration: .seconds(0.5)) }
            .forEach(Drops.show)

        let exp1 = expectation(description: "All Drops are hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if Drops.shared.queue.count == 5-1 {
                exp1.fulfill()
            }
        }

        let exp2 = expectation(description: "All Drops are hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if Drops.shared.queue.isEmpty {
                exp2.fulfill()
            }
        }

        waitForExpectations(timeout: 4)
    }

    func testHideAll() {
        let drops = Drops()

        (0..<10)
            .map { Drop(title: "\($0)", duration: .seconds(0.1)) }
            .forEach(drops.show)

        drops.hideAll()

        XCTAssert(drops.queue.isEmpty)
    }

    func testStaticHideAll() {
        (0..<10)
            .map { Drop(title: "\($0)", duration: .seconds(0.1)) }
            .forEach(Drops.show)

        Drops.hideAll()

        XCTAssert(Drops.shared.queue.isEmpty)
    }

    func testHandlers() {
        let drops = Drops(delayBetweenDrops: 0)
        let expectedDrop = Drop(title: "Hello world!", duration: .seconds(0.1))

        let willShowDropExp = expectation(description: "willShowDrop is called")
        let didShowDropExp = expectation(description: "didShowDrop is called")
        let willDismissDropExp = expectation(description: "willDismissDrop is called")
        let didDismissDropExp = expectation(description: "didDismissDrop is called")

        drops.willShowDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            willShowDropExp.fulfill()
        }

        drops.didShowDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            didShowDropExp.fulfill()
        }

        drops.willDismissDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            willDismissDropExp.fulfill()
        }

        drops.didDismissDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            didDismissDropExp.fulfill()
        }

        drops.show(expectedDrop)

        waitForExpectations(timeout: 1)
    }

    func testStaticHandlers() {
        let expectedDrop = Drop(title: "Hello world!", duration: .seconds(0.1))

        let willShowDropExp = expectation(description: "willShowDrop is called")
        let didShowDropExp = expectation(description: "didShowDrop is called")
        let willDismissDropExp = expectation(description: "willDismissDrop is called")
        let didDismissDropExp = expectation(description: "didDismissDrop is called")

        Drops.willShowDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            willShowDropExp.fulfill()
        }

        Drops.didShowDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            didShowDropExp.fulfill()
        }

        Drops.willDismissDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            willDismissDropExp.fulfill()
        }

        Drops.didDismissDrop = { drop in
            XCTAssertEqual(drop, expectedDrop)
            didDismissDropExp.fulfill()
        }

        Drops.show(expectedDrop)

        waitForExpectations(timeout: 1)
    }

    func testStaticHandlersSettersAndGetters() {
        Drops.willShowDrop = { _ in }
        XCTAssertNotNil(Drops.shared.willShowDrop)
        Drops.willShowDrop = nil
        XCTAssertNil(Drops.shared.willShowDrop)

        Drops.didShowDrop = { _ in }
        XCTAssertNotNil(Drops.shared.didShowDrop)
        Drops.didShowDrop = nil
        XCTAssertNil(Drops.shared.didShowDrop)

        Drops.willDismissDrop = { _ in }
        XCTAssertNotNil(Drops.shared.willDismissDrop)
        Drops.willDismissDrop = nil
        XCTAssertNil(Drops.shared.willDismissDrop)

        Drops.didDismissDrop = { _ in }
        XCTAssertNotNil(Drops.shared.didDismissDrop)
        Drops.didDismissDrop = nil
        XCTAssertNil(Drops.shared.didDismissDrop)

        Drops.shared.willShowDrop = { _ in }
        XCTAssertNotNil(Drops.willShowDrop)
        Drops.shared.willShowDrop = nil
        XCTAssertNil(Drops.willShowDrop)

        Drops.shared.didShowDrop = { _ in }
        XCTAssertNotNil(Drops.didShowDrop)
        Drops.shared.didShowDrop = nil
        XCTAssertNil(Drops.didShowDrop)

        Drops.shared.willDismissDrop = { _ in }
        XCTAssertNotNil(Drops.willDismissDrop)
        Drops.shared.willDismissDrop = nil
        XCTAssertNil(Drops.willDismissDrop)

        Drops.shared.didDismissDrop = { _ in }
        XCTAssertNotNil(Drops.didDismissDrop)
        Drops.shared.didDismissDrop = nil
        XCTAssertNil(Drops.didDismissDrop)
    }
}
