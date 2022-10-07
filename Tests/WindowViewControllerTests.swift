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

#if os(iOS)
import XCTest
@testable import Drops

final class WindowViewControllerTests: XCTestCase {
  func testInitializer() {
    let viewController = WindowViewController()

    XCTAssert(viewController.view is PassthroughView)
    XCTAssert(viewController.window is PassthroughWindow)

    XCTAssertNil(WindowViewController(coder: NSCoder()))
  }

  func testPreferredStatusBarStyle() {
    let viewController = WindowViewController()
    XCTAssertEqual(viewController.preferredStatusBarStyle, .default)
  }

  func testInstall() {
    let viewController = WindowViewController()
    viewController.install()

    XCTAssertEqual(viewController.window?.frame, UIScreen.main.bounds)
    XCTAssertEqual(viewController.window?.isHidden, false)
  }

  func testUninstall() {
    let viewController = WindowViewController()
    viewController.uninstall()

    XCTAssertNil(viewController.window)
  }

  func testTopViewController() {
    let navController = UINavigationController()
    XCTAssertEqual(navController.top, navController.topViewController)

    let splitController = UISplitViewController()
    let controller = UIViewController()
    splitController.viewControllers = [controller]
    XCTAssertEqual(splitController.top, controller)

    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [controller]
    tabBarController.selectedIndex = 0
    XCTAssertEqual(tabBarController.top, controller)

    XCTAssertEqual(controller.top, controller)
  }
}
#endif
