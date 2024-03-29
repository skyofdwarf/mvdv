//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 4 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `tmdb-color-primary-dark-blue`.
    static let tmdbColorPrimaryDarkBlue = Rswift.ColorResource(bundle: R.hostingBundle, name: "tmdb-color-primary-dark-blue")
    /// Color `tmdb-color-secondary-light-blue`.
    static let tmdbColorSecondaryLightBlue = Rswift.ColorResource(bundle: R.hostingBundle, name: "tmdb-color-secondary-light-blue")
    /// Color `tmdb-color-tertiary-light-green`.
    static let tmdbColorTertiaryLightGreen = Rswift.ColorResource(bundle: R.hostingBundle, name: "tmdb-color-tertiary-light-green")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "tmdb-color-primary-dark-blue", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func tmdbColorPrimaryDarkBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.tmdbColorPrimaryDarkBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "tmdb-color-secondary-light-blue", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func tmdbColorSecondaryLightBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.tmdbColorSecondaryLightBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "tmdb-color-tertiary-light-green", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func tmdbColorTertiaryLightGreen(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.tmdbColorTertiaryLightGreen, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "tmdb-color-primary-dark-blue", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func tmdbColorPrimaryDarkBlue(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.tmdbColorPrimaryDarkBlue.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "tmdb-color-secondary-light-blue", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func tmdbColorSecondaryLightBlue(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.tmdbColorSecondaryLightBlue.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "tmdb-color-tertiary-light-green", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func tmdbColorTertiaryLightGreen(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.tmdbColorTertiaryLightGreen.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 5 images.
  struct image {
    /// Image `tmdb-logo-alt-long-blue`.
    static let tmdbLogoAltLongBlue = Rswift.ImageResource(bundle: R.hostingBundle, name: "tmdb-logo-alt-long-blue")
    /// Image `tmdb-logo-alt-short-blue`.
    static let tmdbLogoAltShortBlue = Rswift.ImageResource(bundle: R.hostingBundle, name: "tmdb-logo-alt-short-blue")
    /// Image `tmdb-logo-primary-full`.
    static let tmdbLogoPrimaryFull = Rswift.ImageResource(bundle: R.hostingBundle, name: "tmdb-logo-primary-full")
    /// Image `tmdb-logo-primary-long-blue`.
    static let tmdbLogoPrimaryLongBlue = Rswift.ImageResource(bundle: R.hostingBundle, name: "tmdb-logo-primary-long-blue")
    /// Image `tmdb-logo-primary-short-blue`.
    static let tmdbLogoPrimaryShortBlue = Rswift.ImageResource(bundle: R.hostingBundle, name: "tmdb-logo-primary-short-blue")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tmdb-logo-alt-long-blue", bundle: ..., traitCollection: ...)`
    static func tmdbLogoAltLongBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tmdbLogoAltLongBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tmdb-logo-alt-short-blue", bundle: ..., traitCollection: ...)`
    static func tmdbLogoAltShortBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tmdbLogoAltShortBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tmdb-logo-primary-full", bundle: ..., traitCollection: ...)`
    static func tmdbLogoPrimaryFull(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tmdbLogoPrimaryFull, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tmdb-logo-primary-long-blue", bundle: ..., traitCollection: ...)`
    static func tmdbLogoPrimaryLongBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tmdbLogoPrimaryLongBlue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "tmdb-logo-primary-short-blue", bundle: ..., traitCollection: ...)`
    static func tmdbLogoPrimaryShortBlue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tmdbLogoPrimaryShortBlue, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "tmdb-logo-alt-long-blue", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'tmdb-logo-alt-long-blue' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
          if UIKit.UIColor(named: "tmdb-color-tertiary-light-green", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Color named 'tmdb-color-tertiary-light-green' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
