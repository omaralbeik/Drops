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
import UIKit

internal final class Presenter: NSObject {
  init(drop: Drop, delegate: AnimatorDelegate) {
    self.drop = drop
    view = DropView(drop: drop)
    viewController = .init(value: WindowViewController())
    animator = Animator(position: drop.position, delegate: delegate)
    context = AnimationContext(view: view, container: maskingView)
  }

  let drop: Drop
  let animator: Animator
  var isHiding = false

  func show(completion: @escaping AnimationCompletion) {
    install()
    animator.show(context: context) { [weak self] completed in
      if let drop = self?.drop {
        self?.announcementAccessibilityMessage(for: drop)
      }
      completion(completed)
    }
  }

  func hide(animated: Bool, completion: @escaping AnimationCompletion) {
    isHiding = true
    let action = { [weak self] in
      self?.viewController.value?.uninstall()
      self?.maskingView.removeFromSuperview()
      completion(true)
    }
    guard animated else {
      action()
      return
    }
    animator.hide(context: context) { _ in
      action()
    }
  }

  let maskingView = PassthroughView()
  let view: UIView
  let viewController: Weak<WindowViewController>
  let context: AnimationContext

  func install() {
    guard let container = viewController.value else { return }
    guard let containerView = container.view else { return }

    container.install()

    maskingView.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(maskingView)

    NSLayoutConstraint.activate([
      maskingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      maskingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      maskingView.topAnchor.constraint(equalTo: containerView.topAnchor),
      maskingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])

    containerView.layoutIfNeeded()
  }

  func announcementAccessibilityMessage(for drop: Drop) {
    UIAccessibility.post(
      notification: UIAccessibility.Notification.announcement,
      argument: drop.accessibility.message
    )
  }
}
#endif
