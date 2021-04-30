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

internal final class DropView: UIView {
    required init(drop: Drop) {
        self.drop = drop
        super.init(frame: .zero)

        backgroundColor = .secondarySystemBackground
        addSubview(stackView)

        let constraints = createLayoutConstraints(for: drop)
        NSLayoutConstraint.activate(constraints)
        configureViews(for: drop)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override var frame: CGRect {
        didSet { layer.cornerRadius = cornerRadius(for: frame) }
    }

    override var bounds: CGRect {
        didSet { layer.cornerRadius = cornerRadius(for: frame) }
    }

    let drop: Drop

    func createLayoutConstraints(for drop: Drop) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        constraints += [
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ]

        constraints += [
            button.heightAnchor.constraint(equalToConstant: 35),
            button.widthAnchor.constraint(equalToConstant: 35)
        ]

        var insets = UIEdgeInsets(top: 7.5, left: 12.5, bottom: 7.5, right: 12.5)

        if drop.icon == nil {
            insets.left = 40
        }

        if drop.action?.icon == nil {
            insets.right = 40
        }

        if drop.subtitle == nil && (drop.icon == nil || drop.action?.icon == nil) {
            insets.top = 12.5
            insets.bottom = 12.5
        }

        if drop.icon == nil && drop.action?.icon == nil {
            insets.left = 50
            insets.right = 50
            if drop.subtitle == nil {
                insets.top = 12.5
                insets.bottom = 12.5
            }
        }

        constraints += [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]

        return constraints
    }

    func configureViews(for drop: Drop) {
        clipsToBounds = true

        titleLabel.text = drop.title

        subtitleLabel.text = drop.subtitle
        subtitleLabel.isHidden = drop.subtitle == nil

        imageView.layer.cornerRadius = 12.5
        imageView.image = drop.icon
        imageView.isHidden = drop.icon == nil

        button.layer.cornerRadius = 17.5
        button.setImage(drop.action?.icon, for: .normal)
        button.isHidden = drop.action?.icon == nil

        if let action = drop.action, action.icon == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
            addGestureRecognizer(tap)
        }
    }

    @objc
    func didTapButton() {
        drop.action?.handler()
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.font = bold(for: .preferredFont(forTextStyle: .subheadline))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.tintColor = .secondaryLabel
        return view
    }()

    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.clipsToBounds = true
        button.backgroundColor = .link
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        return button
    }()

    lazy var labelsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()

    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, labelsStackView, button])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        if drop.icon != nil && drop.action?.icon != nil {
            view.spacing = 20
        } else {
            view.spacing = 15
        }
        return view
    }()

    func bold(for font: UIFont) -> UIFont {
        guard let descriptor = font.fontDescriptor.withSymbolicTraits(.traitBold) else { return font }
        return UIFont(descriptor: descriptor, size: font.pointSize)
    }

    func cornerRadius(for rect: CGRect) -> CGFloat {
        return min(rect.width, rect.height) / 2
    }
}
