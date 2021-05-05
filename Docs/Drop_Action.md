# Drop.Action

An object representing a drop action.

``` swift
public struct Action 
```

## Initializers

### `init(icon:handler:)`

Create a new action.

``` swift
public init(icon: UIImage? = nil, handler: @escaping () -> Void) 
```

#### Parameters

  - icon: Optional icon image.
  - handler: Handler to be called when the drop is tapped.

## Properties

### `icon`

Icon.

``` swift
public var icon: UIImage?
```

### `handler`

Handler.

``` swift
public var handler: () -> Void
```
