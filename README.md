# Drops 💧

A µFramework for showing alerts like the one used when copying from pasteboard or connecting Apple pencil.

![Demo](Assets/demo.gif)

---

![CI](https://github.com/omaralbeik/Drops/workflows/Drops/badge.svg)
[![codecov](https://codecov.io/gh/omaralbeik/Drops/branch/main/graph/badge.svg?token=399UQIKSLR)](https://codecov.io/gh/omaralbeik/Drops)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)

## Features / Todos

- [x] iOS 11+
- [x] UIKit/SwiftUI support
- [x] Light/dark mode
- [x] Show with custom duration
- [x] Show from top or buttom of screen
- [x] Interactive dismissal
- [x] Queue multiple drops
- [x] Add basic CI with Github Actions
- [ ] VoiceOver support
- [ ] Accessibility checkup
- [ ] Add more tests

---

## Usage

1. Create a drop:

```swift
let drop = Drop(title: "Title", subtitle: "Subtitle")
```

2. Show it:

```swift
Drops.show(drop)
```

Read the [docs](https://omaralbeik.github.io/Drops) for more usage options.

---

## Example Projects

- Run the `SwiftUIExample` target to see how Drops works in SwiftUI applications.
- Run the `UIKitExample` target to see how Drops works in UIKit applications.

![Example](Assets/example.png)

---

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code.

1. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/omaralbeik/Drops.git", from: "0.5.0")
]
```

2. Build your project:

```sh
$ swift build
```

---

## Thanks

Special thanks to [SwiftKickMobile team](https://github.com/SwiftKickMobile) for creating [SwiftMessages](https://github.com/SwiftKickMobile/SwiftMessages), this project was heavily inspired by their work.

---

## License

Drops is released under the MIT license. See [LICENSE](LICENSE) for more information.
