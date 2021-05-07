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
        drops.show(drop: drop1)

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

    func testDropsAreQueued() {
        let drops = Drops()
        (0..<5)
            .map { Drop(title: "\($0)", duration: .seconds(0.1)) }
            .forEach(drops.show)

        XCTAssertEqual(drops.queue.count, 5-1)

        let exp = expectation(description: "All Drops are hidden")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if drops.queue.isEmpty {
                exp.fulfill()
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
}
