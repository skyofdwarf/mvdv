// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    internal enum Home {
      /// Home
      internal static let title = Strings.tr("Common", "home.title")
    }
    internal enum Profile {
      /// Profile
      internal static let title = Strings.tr("Common", "profile.title")
    }
    internal enum Search {
      /// Search
      internal static let title = Strings.tr("Common", "search.title")
    }
    internal enum Upcoming {
      /// Upcoming
      internal static let title = Strings.tr("Common", "upcoming.title")
    }
  }
  internal enum Home {
    internal enum Section {
      internal enum Genres {
        /// Genres
        internal static let title = Strings.tr("Home", "section.genres.title")
      }
      internal enum Keywords {
        /// Keywords
        internal static let title = Strings.tr("Home", "section.keywords.title")
      }
      internal enum Lastest {
        /// Lastest
        internal static let title = Strings.tr("Home", "section.lastest.title")
      }
      internal enum NowPlaying {
        /// Now Playing
        internal static let title = Strings.tr("Home", "section.now-playing.title")
      }
      internal enum Popular {
        /// Popular
        internal static let title = Strings.tr("Home", "section.popular.title")
      }
      internal enum TopReated {
        /// Top Rated
        internal static let title = Strings.tr("Home", "section.top-reated.title")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
