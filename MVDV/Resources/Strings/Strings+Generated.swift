// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    internal enum Title {
      /// Home
      internal static let home = Strings.tr("Common", "title.home")
      /// Profile
      internal static let profile = Strings.tr("Common", "title.profile")
      /// Search
      internal static let search = Strings.tr("Common", "title.search")
      /// Upcoming
      internal static let upcoming = Strings.tr("Common", "title.upcoming")
    }
  }
  internal enum Home {
    internal enum Section {
      internal enum Title {
        /// Genres
        internal static let genres = Strings.tr("Home", "section.title.genres")
        /// Keywords
        internal static let keywords = Strings.tr("Home", "section.title.keywords")
        /// Lastest
        internal static let lastest = Strings.tr("Home", "section.title.lastest")
        /// Now Playing
        internal static let nowPlaying = Strings.tr("Home", "section.title.now-playing")
        /// Popular
        internal static let popular = Strings.tr("Home", "section.title.popular")
        /// Top Rated
        internal static let topReated = Strings.tr("Home", "section.title.top-reated")
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
