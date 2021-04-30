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

internal final class DropViewController: UIViewController {
    required init(drop: Drop) {
        dropView = DropView(drop: drop)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        let view = PassthroughView(frame: UIScreen.main.bounds)
        view.tappedHander = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(dropView)

        dropView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            dropView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            dropView.leadingAnchor.constraint(greaterThanOrEqualTo: safeArea.leadingAnchor, constant: 20),
            dropView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            dropView.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -20)
        ])

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handlePan))
        swipe.direction = .up
        dropView.addGestureRecognizer(swipe)
    }

    let dropView: DropView

    @objc
    func handlePan(sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
}
