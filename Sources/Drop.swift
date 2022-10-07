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

#if os(iOS)
import UIKit

/// An object representing a drop.
@available(iOSApplicationExtension, unavailable)
public struct Drop: ExpressibleByStringLiteral {
  /// Create a new drop.
  /// - Parameters:
  ///   - title: Title.
  ///   - titleNumberOfLines: Maximum number of lines that `title` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - subtitle: Optional subtitle. Defaults to `nil`.
  ///   - subtitleNumberOfLines: Maximum number of lines that `subtitle` can occupy. Defaults to `1`.
  ///   A value of 0 means no limit.
  ///   - icon: Optional icon.
  ///   - action: Optional action.
  ///   - position: Position. Defaults to `Drop.Position.top`.
  ///   - duration: Duration. Defaults to `Drop.Duration.recommended`.
  ///   - accessibility: Accessibility options. Defaults to `nil` which will use "title, subtitle" as its message.
  public init(
    title: String,
    titleNumberOfLines: Int = 1,
    subtitle: String? = nil,
    subtitleNumberOfLines: Int = 1,
    icon: UIImage? = nil,
    action: Action? = nil,
    position: Position = .top,
    duration: Duration = .recommended,
    accessibility: Accessibility? = nil
  ) {
    self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
    self.titleNumberOfLines = titleNumberOfLines
    if let subtitle = subtitle?.trimmingCharacters(in: .whitespacesAndNewlines), !subtitle.isEmpty {
      self.subtitle = subtitle
    }
    self.subtitleNumberOfLines = subtitleNumberOfLines
    self.icon = icon
    self.action = action
    self.position = position
    self.duration = duration
    self.accessibility = accessibility
    ?? .init(message: [title, subtitle].compactMap { $0 }.joined(separator: ", "))
  }

  /// Create a new accessibility object.
  /// - Parameter message: Message to be announced when the drop is shown. Defaults to drop's "title, subtitle"
  public init(stringLiteral title: String) {
    self.title = title
    titleNumberOfLines = 1
    subtitleNumberOfLines = 1
    position = .top
    duration = .recommended
    accessibility = .init(message: title)
  }

  /// Title.
  public var title: String

  /// Maximum number of lines that `title` can occupy. A value of 0 means no limit.
  public var titleNumberOfLines: Int

  /// Subtitle.
  public var subtitle: String?

  /// Maximum number of lines that `subtitle` can occupy. A value of 0 means no limit.
  public var subtitleNumberOfLines: Int

  /// Icon.
  public var icon: UIImage?

  /// Action.
  public var action: Action?

  /// Position.
  public var position: Position

  /// Duration.
  public var duration: Duration

  /// Accessibility.
  public var accessibility: Accessibility
}

public extension Drop {
  /// An enum representing drop presentation position.
  enum Position: Equatable {
    /// Drop is presented from top.
    case top
    /// Drop is presented from bottom.
    case bottom
  }
}

public extension Drop {
  /// An enum representing a drop duration on screen.
  enum Duration: Equatable, ExpressibleByFloatLiteral {
    /// Hides the drop after 2.0 seconds.
    case recommended
    /// Hides the drop after the specified number of seconds.
    case seconds(TimeInterval)

    /// Create a new duration object.
    /// - Parameter value: Duration in seconds
    public init(floatLiteral value: TimeInterval) {
      self = .seconds(value)
    }

    internal var value: TimeInterval {
      switch self {
      case .recommended:
        return 2.0
      case let .seconds(custom):
        return abs(custom)
      }
    }
  }
}

public extension Drop {
  /// An object representing a drop action.
  struct Action {
    /// Create a new action.
    /// - Parameters:
    ///   - icon: Optional icon image.
    ///   - handler: Handler to be called when the drop is tapped.
    public init(icon: UIImage? = nil, handler: @escaping () -> Void) {
      self.icon = icon
      self.handler = handler
    }

    /// Icon.
    public var icon: UIImage?

    /// Handler.
    public var handler: () -> Void
  }
}

public extension Drop {
  /// An object representing accessibility options.
  struct Accessibility: ExpressibleByStringLiteral {
    /// Create a new accessibility object.
    /// - Parameter message: Message to be announced when the drop is shown. Defaults to drop's "title, subtitle"
    public init(message: String) {
      self.message = message
    }

    /// Create a new accessibility object.
    /// - Parameter message: Message to be announced when the drop is shown. Defaults to drop's "title, subtitle"
    public init(stringLiteral message: String) {
      self.message = message
    }

    /// Accessibility message to be announced when the drop is shown.
    public let message: String
  }
}
#endif
