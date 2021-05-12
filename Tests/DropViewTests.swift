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

final class DropViewTests: XCTestCase {
    func testInitializer() {
        let drop = Drop(title: "Test")
        let view = DropView(drop: drop)
        XCTAssertEqual(view.drop, drop)

        if #available(iOS 13.0, *) {
            XCTAssertEqual(view.backgroundColor, .secondarySystemBackground)
        } else {
            XCTAssertEqual(view.backgroundColor, .white)
        }

        XCTAssertFalse(view.constraints.isEmpty)
        XCTAssertFalse(view.subviews.isEmpty)

        XCTAssertNil(DropView(coder: NSCoder()))
    }

    func testLayoutConstraintsForTitle() {
        let drop = Drop(title: "Title")
        let view = DropView(drop: drop)

        let created = view.createLayoutConstraints(for: drop)
        let expected: [NSLayoutConstraint] = [
            view.imageView.heightAnchor.constraint(equalToConstant: 25),
            view.imageView.widthAnchor.constraint(equalToConstant: 25),
            view.button.heightAnchor.constraint(equalToConstant: 35),
            view.button.widthAnchor.constraint(equalToConstant: 35),
            view.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.stackView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 15),
            view.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ]

        XCTAssertEqual(created.count, expected.count)

        zip(created, expected)
            .forEach { created, expected in
                XCTAssertEqual(created.constant, expected.constant)
                XCTAssertEqual(created.multiplier, expected.multiplier)
            }
    }

    func testLayoutConstraintsForTitleAndSubtitle() {
        let drop = Drop(title: "Title", subtitle: "Subtitle")
        let view = DropView(drop: drop)

        let created = view.createLayoutConstraints(for: drop)
        let expected: [NSLayoutConstraint] = [
            view.imageView.heightAnchor.constraint(equalToConstant: 25),
            view.imageView.widthAnchor.constraint(equalToConstant: 25),
            view.button.heightAnchor.constraint(equalToConstant: 35),
            view.button.widthAnchor.constraint(equalToConstant: 35),
            view.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            view.stackView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 7.5),
            view.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7.5)
        ]

        XCTAssertEqual(created.count, expected.count)

        zip(created, expected)
            .forEach { created, expected in
                XCTAssertEqual(created.constant, expected.constant)
                XCTAssertEqual(created.multiplier, expected.multiplier)
            }
    }

    func testLayoutConstraintsForTitleAndAction() {
        let drop = Drop(title: "Title", action: .init(icon: UIImage(), handler: {}))
        let view = DropView(drop: drop)

        let created = view.createLayoutConstraints(for: drop)
        let expected: [NSLayoutConstraint] = [
            view.imageView.heightAnchor.constraint(equalToConstant: 25),
            view.imageView.widthAnchor.constraint(equalToConstant: 25),
            view.button.heightAnchor.constraint(equalToConstant: 35),
            view.button.widthAnchor.constraint(equalToConstant: 35),
            view.stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            view.stackView.topAnchor.constraint(equalTo: view.safeArea.topAnchor, constant: 10),
            view.stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            view.stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ]

        XCTAssertEqual(created.count, expected.count)

        zip(created, expected)
            .forEach { created, expected in
                XCTAssertEqual(created.constant, expected.constant)
                XCTAssertEqual(created.multiplier, expected.multiplier)
            }
    }

    func testTapGestureAddedWhenActionWithNoIcon() {
        let drop = Drop(title: "Title", action: .init(handler: {}))
        let view = DropView(drop: drop)
        XCTAssertEqual(view.gestureRecognizers?.count, 1)
        XCTAssert(view.gestureRecognizers?.first is UITapGestureRecognizer)
    }

    func testViewCornerRadius() {
        let drop = Drop(title: "Title")
        let view = DropView(drop: drop)
        view.bounds = .init(x: 0, y: 0, width: 300, height: 100)

        let imageView = RoundImageView()
        imageView.bounds = .init(x: 0, y: 0, width: 40, height: 40)
        XCTAssertEqual(imageView.layer.cornerRadius, 20)

        let button = RoundButton()
        button.bounds = .init(x: 0, y: 0, width: 40, height: 40)
        XCTAssertEqual(button.layer.cornerRadius, 20)
    }

    func testStackViewSpacing() {
        let drop1 = Drop(title: "Title")
        let view1 = DropView(drop: drop1)
        XCTAssertEqual(view1.stackView.spacing, 15)

        let drop2 = Drop(title: "Title", icon: UIImage(), action: .init(icon: UIImage(), handler: {}))
        let view2 = DropView(drop: drop2)
        XCTAssertEqual(view2.stackView.spacing, 20)

    }

    func testActionIsCalledWhenButtonIsTapped() {
        let exp = expectation(description: "Completion called with true")

        let drop = Drop(title: "Title", action: .init(icon: UIImage(), handler: {
            exp.fulfill()
        }))

        let view = DropView(drop: drop)
        view.didTapButton()

        waitForExpectations(timeout: 1)
    }
}

extension Drop: Equatable {
    public static func == (lhs: Drop, rhs: Drop) -> Bool {
        return lhs.title == rhs.title
    }
}
