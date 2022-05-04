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

final class PresenterTests: XCTestCase {
  func testInitializer() {
    let drop = Drop(title: "Hello world!")
    let delegate = TestAnimatorDelegate()
    let presenter = Presenter(drop: drop, delegate: delegate)

    XCTAssertEqual(presenter.drop, drop)
    XCTAssert(presenter.view is DropView)
    XCTAssertEqual((presenter.view as? DropView)?.drop, drop)
    XCTAssertNotNil(presenter.viewController.value)
    XCTAssertEqual(presenter.animator.position, drop.position)
    XCTAssert(presenter.animator.delegate === delegate)
    XCTAssertEqual(presenter.context.view, presenter.view)
    XCTAssertEqual(presenter.context.container, presenter.maskingView)
  }

  func testInstall() {
    let drop = Drop(title: "Hello world!")
    let delegate = TestAnimatorDelegate()
    let presenter = Presenter(drop: drop, delegate: delegate)
    presenter.install()

    guard let containerView = presenter.viewController.value?.view else {
      XCTFail("Unable to get view")
      return
    }

    XCTAssertFalse(presenter.maskingView.translatesAutoresizingMaskIntoConstraints)
    XCTAssertEqual(containerView.subviews[0], presenter.maskingView)
    XCTAssertEqual(presenter.maskingView.superview, containerView)

    let expectedConstraints: [NSLayoutConstraint] = [
      presenter.maskingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      presenter.maskingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      presenter.maskingView.topAnchor.constraint(equalTo: containerView.topAnchor),
      presenter.maskingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ]

    for (actual, expected) in zip(presenter.maskingView.constraints, expectedConstraints) {
      XCTAssertEqual(actual, expected)
    }
  }

  func testShow() {
    let drop = Drop(title: "Hello world!")
    let delegate = TestAnimatorDelegate()
    let presenter = Presenter(drop: drop, delegate: delegate)

    let exp = expectation(description: "Completion called")
    presenter.show { _ in
      exp.fulfill()
    }
    waitForExpectations(timeout: 2)
  }

  func testHide() {
    func hide(animated: Bool) {
      let drop = Drop(title: "Hello world!")
      let delegate = TestAnimatorDelegate()
      let presenter = Presenter(drop: drop, delegate: delegate)

      let exp = expectation(description: "Completion called")
      presenter.hide(animated: false) { _ in
        if presenter.maskingView.superview == nil && presenter.viewController.value?.window == nil {
          exp.fulfill()
        }
      }
      waitForExpectations(timeout: animated ? 2.0 : 0.1)
    }

    hide(animated: true)
    hide(animated: false)
  }
}
