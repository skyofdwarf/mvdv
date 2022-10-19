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
    /// Authenticated
    internal static let authenticated = Strings.tr("Common", "authenticated")
    /// Authenticated already
    internal static let authenticatedAlready = Strings.tr("Common", "Authenticated already")
    /// Log in to the Movie Database (TMDB)
    internal static let bindAccount = Strings.tr("Common", "Bind Account")
    /// Favorited
    internal static let favorited = Strings.tr("Common", "Favorited")
    /// Configuration unavailable
    internal static let noConfigurations = Strings.tr("Common", "No configurations")
    /// Not authenticated yet
    internal static let notAuthenticatedYet = Strings.tr("Common", "Not authenticated yet")
    /// Unauthenticated
    internal static let unauthenticated = Strings.tr("Common", "unauthenticated")
    /// Unbind account
    internal static let unbindAccount = Strings.tr("Common", "Unbind Account")
    /// Unfavorited
    internal static let unfavorited = Strings.tr("Common", "Unfavorited")
    internal enum Alert {
      /// Cancel
      internal static let cancel = Strings.tr("Common", "alert.cancel")
      /// Ok
      internal static let ok = Strings.tr("Common", "alert.ok")
      /// MVDV
      internal static let title = Strings.tr("Common", "alert.title")
    }
    internal enum Favorites {
      /// Favorites
      internal static let title = Strings.tr("Common", "favorites.title")
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
  internal enum Favorites {
    internal enum Section {
      /// Favorites
      internal static let favorites = Strings.tr("Favorites", "section.favorites")
    }
  }
  internal enum Home {
    internal enum Section {
      /// Genres
      internal static let genres = Strings.tr("Home", "section.genres")
      /// Keywords
      internal static let keywords = Strings.tr("Home", "section.keywords")
      /// Lastest
      internal static let lastest = Strings.tr("Home", "section.lastest")
      /// Now Playing
      internal static let nowPlaying = Strings.tr("Home", "section.now-playing")
      /// Popular
      internal static let popular = Strings.tr("Home", "section.popular")
      /// Top Rated
      internal static let topReated = Strings.tr("Home", "section.top-reated")
      /// Trending
      internal static let trending = Strings.tr("Home", "section.trending")
    }
  }
  internal enum Main {
  }
  internal enum MovieDetails {
    internal enum Section {
      /// Details
      internal static let detail = Strings.tr("MovieDetails", "section.detail")
      /// Similar movies
      internal static let similar = Strings.tr("MovieDetails", "section.similar")
    }
  }
  internal enum Profile {
    /// https://www.themoviedb.org
    internal static let mvdv = Strings.tr("Profile", "mvdv")
    /// ㅁㅂㄷㅂ is powered by TMDB
    internal static let powered = Strings.tr("Profile", "powered")
    internal enum Menu {
      /// Favorites
      internal static let favorites = Strings.tr("Profile", "menu.favorites")
      /// Version
      internal static let version = Strings.tr("Profile", "menu.version")
    }
    internal enum Section {
      /// Menu
      internal static let menu = Strings.tr("Profile", "section.menu")
      /// TMDB powered
      internal static let powered = Strings.tr("Profile", "section.powered")
      /// Profile
      internal static let profile = Strings.tr("Profile", "section.profile")
    }
  }
  internal enum Search {
    /// Search your movie
    internal static let placeholder = Strings.tr("Search", "placeholder")
    internal enum Section {
      /// Movies
      internal static let movies = Strings.tr("Search", "section.movies")
    }
  }
  internal enum Upcoming {
    internal enum Section {
      /// Upcoming
      internal static let upcoming = Strings.tr("Upcoming", "section.upcoming")
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
