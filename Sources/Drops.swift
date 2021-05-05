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

typealias AnimationCompletion = (_ completed: Bool) -> Void

private let sharedInstance = Drops()

public final class Drops {
    private func show(drop: Drop) {
        let presenter = Presenter(drop: drop, delegate: self)
        enqueue(presenter: presenter)
    }

    private let dispatchQueue = DispatchQueue(label: "com.omaralbeik.drops")
    private var queue: [Presenter] = []

    private var current: Presenter? {
        didSet {
            guard oldValue != nil else { return }
            let delayTime = DispatchTime.now() + 0.5
            dispatchQueue.asyncAfter(deadline: delayTime) { [weak self] in
                self?.dequeueNext()
            }
        }
    }

    private weak var autohideToken: Presenter?

    private func enqueue(presenter: Presenter) {
        queue.append(presenter)
        dequeueNext()
    }

    private func hide(presenter: Presenter) {
        if presenter == current {
            hideCurrent()
        } else {
            queue = queue.filter { $0 != presenter }
        }
    }

    private func hideCurrent(animated: Bool = true) {
        guard let current = current, !current.isHiding else { return }
        DispatchQueue.main.async {
            current.hide(animated: animated) { [weak self] completed in
                guard completed, let self = self else { return }
                self.dispatchQueue.sync {
                    guard self.current === current else { return }
                    self.current = nil
                }
            }
        }
    }

    private func dequeueNext() {
        guard current == nil, !queue.isEmpty else { return }
        current = queue.removeFirst()
        autohideToken = current

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let current = self.current else { return }

            current.show { completed in
                guard completed else {
                    self.dispatchQueue.sync {
                        self.hide(presenter: current)
                    }
                    return
                }
                if current === self.autohideToken {
                    self.queueAutoHide()
                }
            }
        }
    }

    private func queueAutoHide() {
        guard let current = current else { return }
        autohideToken = current
        let delayTime = DispatchTime.now() + current.drop.duration.value
        dispatchQueue.asyncAfter(deadline: delayTime) { [weak self] in
            if self?.autohideToken !== current { return }
            self?.hide(presenter: current)
        }
    }

    private func hideAll() {
        dispatchQueue.sync {
            queue.removeAll()
            hideCurrent()
        }
    }
}

extension Drops: AnimatorDelegate {
    func hide(animator: Animator) {
        dispatchQueue.sync { [weak self] in
            guard let presenter = self?.presenter(forAnimator: animator) else { return }
            self?.hide(presenter: presenter)
        }
    }

    func panStarted(animator: Animator) {
        autohideToken = nil
    }

    func panEnded(animator: Animator) {
        queueAutoHide()
    }

    private func presenter(forAnimator animator: Animator) -> Presenter? {
        if let current = current, animator === current.animator {
            return current
        }
        return queue.first { $0.animator === animator }
    }
}

public extension Drops {
    static func show(_ drop: Drop) {
        sharedInstance.show(drop: drop)
    }

    static func hideAll() {
        sharedInstance.hideAll()
    }

    static func hideCurrent() {
        sharedInstance.hideCurrent()
    }
}
