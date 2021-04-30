# Drops

A µFramework for showing iOS 13 like alerts

![Demo](Assets/demo.gif)

---

## Features / Todos

- [x] Light/dark mode
- [ ] Interactive dismissal
- [ ] Add accessibility
- [ ] Show with custome duration
- [ ] Queue multiple drops
- [ ] Add tests

---

## Usage

1. Create a drop:

```swift
let drop = Drop(title: "Title", subtitle: "Subtitle")
```

2. Present it from a view controller:

```swift
present(drop: drop)
```

---

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code.

1. Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/omaralbeik/drops.git", from: "0.1.0")
]
```

2. Build your project:

```sh
$ swift build
```

---

## License

Drops is released under the MIT license. See [LICENSE](LICENSE) for more information.
