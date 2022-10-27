// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    /// Common.strings
    ///   MVDV
    /// 
    ///   Created by YEONGJUNG KIM on 2022/01/21.
    internal static let appName = Strings.tr("Common", "app-name", fallback: "ㅁㅂㄷㅂ")
    /// Authenticated
    internal static let authenticated = Strings.tr("Common", "authenticated", fallback: "Authenticated")
    /// Authenticated already
    internal static let authenticatedAlready = Strings.tr("Common", "Authenticated already", fallback: "Authenticated already")
    /// Log in to the Movie Database (TMDB)
    internal static let bindAccount = Strings.tr("Common", "Bind Account", fallback: "Log in to the Movie Database (TMDB)")
    /// Favorited
    internal static let favorited = Strings.tr("Common", "Favorited", fallback: "Favorited")
    /// Configuration unavailable
    internal static let noConfigurations = Strings.tr("Common", "No configurations", fallback: "Configuration unavailable")
    /// Not authenticated yet
    internal static let notAuthenticatedYet = Strings.tr("Common", "Not authenticated yet", fallback: "Not authenticated yet")
    /// Unauthenticated
    internal static let unauthenticated = Strings.tr("Common", "unauthenticated", fallback: "Unauthenticated")
    /// Unbind account
    internal static let unbindAccount = Strings.tr("Common", "Unbind Account", fallback: "Unbind account")
    /// Unfavorited
    internal static let unfavorited = Strings.tr("Common", "Unfavorited", fallback: "Unfavorited")
    internal enum Alert {
      /// Cancel
      internal static let cancel = Strings.tr("Common", "alert.cancel", fallback: "Cancel")
      /// Ok
      internal static let ok = Strings.tr("Common", "alert.ok", fallback: "Ok")
      /// MVDV
      internal static let title = Strings.tr("Common", "alert.title", fallback: "MVDV")
    }
    internal enum Favorites {
      /// Favorites
      internal static let title = Strings.tr("Common", "favorites.title", fallback: "Favorites")
    }
    internal enum Home {
      /// Home
      internal static let title = Strings.tr("Common", "home.title", fallback: "Home")
    }
    internal enum Profile {
      /// Profile
      internal static let title = Strings.tr("Common", "profile.title", fallback: "Profile")
    }
    internal enum Search {
      /// Search
      internal static let title = Strings.tr("Common", "search.title", fallback: "Search")
    }
    internal enum Upcoming {
      /// Upcoming
      internal static let title = Strings.tr("Common", "upcoming.title", fallback: "Upcoming")
    }
  }
  internal enum Favorites {
    internal enum Section {
      /// Favorites.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/10/16.
      internal static let favorites = Strings.tr("Favorites", "section.favorites", fallback: "Favorites")
    }
  }
  internal enum Home {
    internal enum Section {
      /// Genres
      internal static let genres = Strings.tr("Home", "section.genres", fallback: "Genres")
      /// Keywords
      internal static let keywords = Strings.tr("Home", "section.keywords", fallback: "Keywords")
      /// Home.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/01/21.
      internal static let lastest = Strings.tr("Home", "section.lastest", fallback: "Lastest")
      /// Now Playing
      internal static let nowPlaying = Strings.tr("Home", "section.now-playing", fallback: "Now Playing")
      /// Popular
      internal static let popular = Strings.tr("Home", "section.popular", fallback: "Popular")
      /// Top Rated
      internal static let topReated = Strings.tr("Home", "section.top-reated", fallback: "Top Rated")
      /// Trending
      internal static let trending = Strings.tr("Home", "section.trending", fallback: "Trending")
    }
  }
  internal enum Main {
    }
  internal enum MovieDetails {
    internal enum Section {
      /// MovieDetails.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/10/16.
      internal static let detail = Strings.tr("MovieDetails", "section.detail", fallback: "Details")
      /// Similar movies
      internal static let similar = Strings.tr("MovieDetails", "section.similar", fallback: "Similar movies")
    }
  }
  internal enum Profile {
    /// https://www.themoviedb.org
    internal static let mvdv = Strings.tr("Profile", "mvdv", fallback: "https://www.themoviedb.org")
    /// ㅁㅂㄷㅂ is powered by TMDB
    internal static let powered = Strings.tr("Profile", "powered", fallback: "ㅁㅂㄷㅂ is powered by TMDB")
    internal enum Menu {
      /// Favorites
      internal static let favorites = Strings.tr("Profile", "menu.favorites", fallback: "Favorites")
      /// Version
      internal static let version = Strings.tr("Profile", "menu.version", fallback: "Version")
    }
    internal enum Section {
      /// Menu
      internal static let menu = Strings.tr("Profile", "section.menu", fallback: "Menu")
      /// TMDB powered
      internal static let powered = Strings.tr("Profile", "section.powered", fallback: "TMDB powered")
      /// Profile.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/09/28.
      internal static let profile = Strings.tr("Profile", "section.profile", fallback: "Profile")
    }
  }
  internal enum Search {
    /// Search your movie
    internal static let placeholder = Strings.tr("Search", "placeholder", fallback: "Search your movie")
    internal enum Section {
      /// Search.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/01/21.
      internal static let movies = Strings.tr("Search", "section.movies", fallback: "Movies")
    }
  }
  internal enum Upcoming {
    internal enum Section {
      /// Upcoming.strings
      ///   MVDV
      /// 
      ///   Created by YEONGJUNG KIM on 2022/01/21.
      internal static let upcoming = Strings.tr("Upcoming", "section.upcoming", fallback: "Upcoming")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
