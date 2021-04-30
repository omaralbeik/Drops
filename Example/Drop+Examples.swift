//
//  Drop+Examples.swift
//  Example
//
//  Created by Omar Albeik on 30/04/2021.
//

import UIKit
import Drops

extension Drop {
    static let title = Drop(title: "Hello World!")

    static let titleSubtitle = Drop(title: "Hello World!", subtitle: "I'm a drop with subtitle")

    static let titleSubtitleIcon = Drop(
        title: "Hello World!",
        subtitle: "I'm a drop with subtitle!",
        icon: UIImage(systemName: "drop.fill")
    )

    static let titleAction = Drop(
        title: "Loading Failed",
        action: .init(
            icon: UIImage(systemName: "arrow.triangle.2.circlepath"),
            handler: {
                print("action tapped")
            }
        )
    )

    static let titleSubtitleAction = Drop(
        title: "New Message",
        subtitle: "Hey, how are you?",
        action: .init(
            icon: UIImage(systemName: "arrowshape.turn.up.backward.fill"),
            handler: {
                print("action tapped")
            }
        )
    )
}
