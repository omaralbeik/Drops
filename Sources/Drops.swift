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

/// A shared class used to show and hide drops.
public final class Drops {

    // MARK: - Static

    static let shared = Drops()

    /// Show a drop.
    /// - Parameter drop: `Drop` to show.
    public static func show(_ drop: Drop) {
        shared.show(drop)
    }

    /// Hide currently shown drop.
    public static func hideCurrent() {
        shared.hideCurrent()
    }

    /// Hide all drops.
    public static func hideAll() {
        shared.hideAll()
    }

    // MARK: - Instance

    /// Create a new instance with a custom delay between drops.
    /// - Parameter delayBetweenDrops: Delay between drops in seconds. Defaults to `0.5 seconds`.
    public init(delayBetweenDrops: TimeInterval = 0.5) {
        self.delayBetweenDrops = delayBetweenDrops
    }

    /// Show a drop.
    /// - Parameter drop: `Drop` to show.
    public func show(_ drop: Drop) {
        DispatchQueue.main.async {
            let presenter = Presenter(drop: drop, delegate: self)
            self.enqueue(presenter: presenter)
        }
    }

    /// Hide currently shown drop.
    public func hideCurrent() {
        guard let current = current, !current.isHiding else { return }
        DispatchQueue.main.async {
            current.hide(animated: true) { [weak self] completed in
                guard completed, let self = self else { return }
                self.dispatchQueue.sync {
                    guard self.current === current else { return }
                    self.current = nil
                }
            }
        }
    }

    /// Hide all drops.
    public func hideAll() {
        dispatchQueue.sync {
            queue.removeAll()
            hideCurrent()
        }
    }

    // MARK: - Helpers

    let delayBetweenDrops: TimeInterval

    let dispatchQueue = DispatchQueue(label: "com.omaralbeik.drops")
    var queue: [Presenter] = []

    var current: Presenter? {
        didSet {
            guard oldValue != nil else { return }
            let delayTime = DispatchTime.now() + delayBetweenDrops
            dispatchQueue.asyncAfter(deadline: delayTime) { [weak self] in
                self?.dequeueNext()
            }
        }
    }

    weak var autohideToken: Presenter?

    func enqueue(presenter: Presenter) {
        queue.append(presenter)
        dequeueNext()
    }

    func hide(presenter: Presenter) {
        if presenter == current {
            hideCurrent()
        } else {
            queue = queue.filter { $0 != presenter }
        }
    }

    func dequeueNext() {
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

    func queueAutoHide() {
        guard let current = current else { return }
        autohideToken = current
        let delayTime = DispatchTime.now() + current.drop.duration.value
        dispatchQueue.asyncAfter(deadline: delayTime) { [weak self] in
            if self?.autohideToken !== current { return }
            self?.hide(presenter: current)
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
