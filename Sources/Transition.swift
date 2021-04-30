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

internal final class Transition: NSObject {
    enum Operation {
        case present
        case dismiss
    }

    var operation: Operation = .present

    let duration: TimeInterval = 0.75

    var presentedConstraints: [NSLayoutConstraint] = []
    var dismissedConstraints: [NSLayoutConstraint] = []

    lazy var animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.85, animations: nil)
}

extension Transition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .present:
            present(using: transitionContext)
        case .dismiss:
            dismiss(using: transitionContext)
        }
    }

    func constraints(dropView: UIView, containerView: UIView, operation: Operation) -> [NSLayoutConstraint] {
        var constraints = [
            dropView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dropView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]

        switch operation {
        case .present:
            constraints += [
                dropView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dropView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ]
        case .dismiss:
            constraints += [
                dropView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -100),
                dropView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ]
        }

        return constraints
    }

    func present(using context: UIViewControllerContextTransitioning) {
        guard let presentedView = context.view(forKey: .to) else {
            context.completeTransition(false)
            return
        }

        let container = context.containerView

        container.addSubview(presentedView)
        presentedView.translatesAutoresizingMaskIntoConstraints = false

        presentedConstraints = constraints(dropView: presentedView, containerView: container, operation: .present)
        dismissedConstraints = constraints(dropView: presentedView, containerView: container, operation: .dismiss)

        NSLayoutConstraint.activate(dismissedConstraints)

        context.containerView.setNeedsLayout()
        context.containerView.layoutIfNeeded()

        NSLayoutConstraint.deactivate(dismissedConstraints)
        NSLayoutConstraint.activate(presentedConstraints)

        presentedView.alpha = 0

        animator.addAnimations { [weak presentedView] in
            presentedView?.alpha = 1
        }

        animator.addAnimations { [weak context] in
            context?.containerView.setNeedsLayout()
            context?.containerView.layoutIfNeeded()
        }

        animator.addCompletion { [weak context] position in
            context?.completeTransition(position == .end)
        }

        animator.startAnimation()
    }

    func dismiss(using context: UIViewControllerContextTransitioning) {
        NSLayoutConstraint.deactivate(presentedConstraints)
        NSLayoutConstraint.activate(dismissedConstraints)

        let presentedView = context.view(forKey: .from)
        animator.addAnimations { [weak presentedView] in
            presentedView?.alpha = 0
        }

        animator.addAnimations { [weak context] in
            context?.containerView.setNeedsLayout()
            context?.containerView.layoutIfNeeded()
        }

        animator.addCompletion { [weak context] position in
            context?.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
}
