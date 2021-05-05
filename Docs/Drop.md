# Drop

An object representing a drop.

``` swift
public struct Drop 
```

## Initializers

### `init(title:subtitle:icon:action:style:duration:)`

Create a new drop.

``` swift
public init(
        title: String,
        subtitle: String? = nil,
        icon: UIImage? = nil,
        action: Action? = nil,
        style: Style = .top,
        duration: Duration = .recommended
    ) 
```

#### Parameters

  - title: Title.
  - subtitle: Optional subtitle. Defaults to `nil`.
  - icon: Optional icon.
  - action: Optional action.
  - style: Style. Defaults to `Drop.Style.top`.
  - duration: Duration. Defaults to `Drop.Duration.recommended`.

## Properties

### `title`

Title.

``` swift
public var title: String
```

### `subtitle`

Subtitle.

``` swift
public var subtitle: String?
```

### `icon`

Icon.

``` swift
public var icon: UIImage?
```

### `action`

Action.

``` swift
public var action: Action?
```

### `style`

Style.

``` swift
public var style: Style
```

### `duration`

Duration.

``` swift
public var duration: Duration
```
