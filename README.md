# Drops 💧

A µFramework for showing alerts like the one used when copying from pasteboard or connecting Apple pencil.

![Demo](https://raw.githubusercontent.com/omaralbeik/Drops/main/Assets/demo.gif)

---

[![CI](https://github.com/omaralbeik/Drops/workflows/Drops/badge.svg)](https://github.com/omaralbeik/Drops/actions)
[![codecov](https://codecov.io/gh/omaralbeik/Drops/branch/main/graph/badge.svg?token=399UQIKSLR)](https://codecov.io/gh/omaralbeik/Drops)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fomaralbeik%2FDrops%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/omaralbeik/Drops)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fomaralbeik%2FDrops%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/omaralbeik/Drops)
## Features

- iOS 13+
- Can be used in SwiftUI and UIKit applications
- Light/Dark modes
- Interactive dismissal
- Queue to show consecutive drops
- Support dynamic font sizing
- Support announcing title and subtitle via VoiceOver
- Show from top or bottom of screen

---

## Usage

1. Create a drop:

```swift
let drop: Drop = "Title Only"
```

```swift
let drop = Drop(title: "Title Only")
```

```swift
let drop = Drop(title: "Title", subtitle: "Subtitle")
```

```swift
let drop = Drop(title: "Title", subtitle: "Subtitle", duration: 5.0)
```

```swift
let drop = Drop(
    title: "Title",
    subtitle: "Subtitle",
    icon: UIImage(systemName: "star.fill"),
    action: .init {
        print("Drop tapped")
        Drops.hideCurrent()
    },
    position: .bottom,
    duration: 5.0,
    accessibility: "Alert: Title, Subtitle"
)
```

2. Show it:

```swift
Drops.show("Title")
```

```swift
Drops.show(drop)
```

###### SwiftUI
```swift
import SwiftUI
import Drops

struct ContentView: View {
    var body: some View {
        Button("Show Drop") {
            Drops.show(drop)
        }
    }
}
```

###### UIKit
```swift
import UIKit
import Drops

class ViewController: UIViewController {
    let drops = Drops(delayBetweenDrops: 1.0)

    func showDrop() {
        drops.show(drop)
    }
}
```

Read the [docs](https://omaralbeik.github.io/Drops) for more usage options.

---

## Example Projects

- Run the `SwiftUIExample` target to see how Drops works in SwiftUI applications.
- Run the `UIKitExample` target to see how Drops works in UIKit applications.

![Example](https://raw.githubusercontent.com/omaralbeik/Drops/main/Assets/example.png)

---

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code.

1. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/omaralbeik/Drops.git", from: "1.7.0")
]
```

2. Build your project:

```sh
$ swift build
```

### CocoaPods

To integrate Drops into your Xcode project using [CocoaPods](https://cocoapods.org), specify it in your Podfile:

```rb
pod 'Drops', :git => 'https://github.com/omaralbeik/Drops.git', :tag => '1.7.0'
```

### Carthage

To integrate Drops into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your Cartfile:

```
github "omaralbeik/Drops" ~> 1.7.0
```

### Manually

Add the [Sources](https://github.com/omaralbeik/Drops/tree/main/Sources) folder to your Xcode project.

---

## Thanks

Special thanks to [SwiftKickMobile team](https://github.com/SwiftKickMobile) for creating [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages), this project was heavily inspired by their work.

---

## License

Drops is released under the MIT license. See [LICENSE](https://github.com/omaralbeik/Drops/blob/main/LICENSE) for more information.
