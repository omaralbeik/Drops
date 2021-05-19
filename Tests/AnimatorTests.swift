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

final class AnimatorTests: XCTestCase {
    func testInitializer() {
        let position = Drop.Position.bottom
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: position, delegate: delegate)

        XCTAssertEqual(animator.position, position)
        XCTAssert(animator.delegate === delegate)
    }

    func testInstall() {
        func install(position: Drop.Position) {
            let delegate = TestAnimatorDelegate()
            let animator = Animator(position: position, delegate: delegate)

            let view = UIView()
            let container = UIView()
            let context = AnimationContext(view: view, container: container)

            animator.install(context: context)

            XCTAssertEqual(animator.context?.view, view)
            XCTAssertEqual(animator.context?.container, container)

            XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
            XCTAssertEqual(container.subviews[0], view)
            XCTAssertEqual(view.superview, container)

            var expectedConstraints: [NSLayoutConstraint] = [
                view.centerXAnchor.constraint(equalTo: container.safeArea.centerXAnchor),
                view.leadingAnchor.constraint(greaterThanOrEqualTo: container.safeArea.leadingAnchor, constant: 20),
                view.trailingAnchor.constraint(lessThanOrEqualTo: container.safeArea.trailingAnchor, constant: -20),
                view.topAnchor.constraint(equalTo: container.safeArea.topAnchor, constant: animator.bounceOffset)
            ]

            switch position {
            case .top:
                expectedConstraints += [
                ]
            case .bottom:
                expectedConstraints += [
                    view.bottomAnchor.constraint(
                        equalTo: container.safeArea.bottomAnchor,
                        constant: -animator.bounceOffset
                    )
                ]
            }

            for (actual, expected) in zip(view.constraints, expectedConstraints) {
                XCTAssertEqual(actual, expected)
            }

            let animationDistance = view.frame.height

            switch position {
            case .top:
                XCTAssertEqual(view.transform, CGAffineTransform(translationX: 0, y: -animationDistance))
            case .bottom:
                XCTAssertEqual(view.transform, CGAffineTransform(translationX: 0, y: animationDistance))
            }
        }

        install(position: .top)
        install(position: .bottom)
    }

    func testShowWithCompletionBeforeCallingInstall() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)

        let exp = expectation(description: "Completion called with false")
        animator.show { completed in
            if !completed {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testShowWithCompletion() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)

        let view = UIView()
        let container = UIView()
        let context = AnimationContext(view: view, container: container)

        animator.install(context: context)

        let exp = expectation(description: "Completion called")
        animator.show { _ in
            if view.alpha == 1 && view.transform == .identity {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testShow() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)

        let view = UIView()
        let container = UIView()
        let context = AnimationContext(view: view, container: container)

        let exp = expectation(description: "Completion called")
        animator.show(context: context) { _ in
            if view.alpha == 1 && view.transform == .identity {
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 2)
    }

    func testHide() {
        func hide(position: Drop.Position) {
            let delegate = TestAnimatorDelegate()
            let animator = Animator(position: position, delegate: delegate)

            let view = UIView()
            let container = UIView()
            let context = AnimationContext(view: view, container: container)

            let exp = expectation(description: "Completion called")
            animator.hide(context: context) { _ in
                if view.alpha == 0 {
                    exp.fulfill()
                }
            }
            waitForExpectations(timeout: 2)
        }

        hide(position: .top)
        hide(position: .bottom)
    }

    func testPanChangedWhenHeightIsZero() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)
        let state = Animator.PanState()
        XCTAssertEqual(state, animator.panChanged(current: state, view: .init(), velocity: .zero, translation: .zero))
    }

    func testPanChanged() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)
        let state = Animator.PanState()
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 100, height: 100)))
        let changedState = animator.panChanged(
            current: state,
            view: view,
            velocity: .init(x: 5, y: 5),
            translation: .init(x: 25, y: 25)
        )

        XCTAssertEqual(changedState.closing, true)
        XCTAssertEqual(changedState.closeSpeed, -5)
        XCTAssertEqual(changedState.closePercent, -0.26, accuracy: 0.99)
        XCTAssertEqual(changedState.panTranslationY, -25)
    }

    func testPanEnded() {
        let delegate = TestAnimatorDelegate()
        let animator = Animator(position: .top, delegate: delegate)

        var state = Animator.PanState()
        var endedState = animator.panEnded(current: state)
        XCTAssertEqual(endedState, state)

        state.closeSpeed = 800
        endedState = animator.panEnded(current: state)
        XCTAssertNil(endedState)

        state = .init()
        state.closePercent = 0.5
        endedState = animator.panEnded(current: state)
        XCTAssertNil(endedState)

        state = .init()
        state.panTranslationY = 80
        endedState = animator.panEnded(current: state)
        XCTAssertNil(endedState)
    }
}
