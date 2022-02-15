// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    /// ㅁㅂㄷㅂ
    internal static let appName = Strings.tr("Common", "app-name")
    internal enum Alert {
      /// Cancel
      internal static let cancel = Strings.tr("Common", "alert.cancel")
      /// Ok
      internal static let ok = Strings.tr("Common", "alert.ok")
      /// MVDV
      internal static let title = Strings.tr("Common", "alert.title")
    }
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
