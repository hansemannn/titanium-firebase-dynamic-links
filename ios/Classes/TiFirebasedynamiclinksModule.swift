//
//  TiFirebasedynamiclinksModule.swift
//  titanium-firebase-dynamic-links
//
//  Created by Hans Knoechel
//  Copyright (c) 2021 Your Company. All rights reserved.
//

import TitaniumKit
import FirebaseCore
import FirebaseDynamicLinks

@objc(TiFirebasedynamiclinksModule)
class TiFirebasedynamiclinksModule: TiModule {

  func moduleGUID() -> String {
    return "694c1765-74aa-466d-9a06-d013f506f88f"
  }

  override func moduleId() -> String! {
    return "ti.firebasedynamiclinks"
  }

  /// To be called as soon as possible
  @objc(setCustomURLScheme:)
  func setCustomURLScheme(customURLScheme: String) {
    FirebaseOptions.defaultOptions()?.deepLinkURLScheme = customURLScheme
    NSLog("[WARN] deepLinkURLScheme = %@ set successfully!", customURLScheme)
  }

  /// To be called in the "continueuseractivity" event
  @objc(handleUniversalLink:)
  func handleUniversalLink(args: [Any]) {
    NSLog("[WARN] handleUniversalLink: %@", args)

    guard let webpageURLString = args.first as? String, let webPage = URL(string: webpageURLString) else {
      NSLog("[ERROR] handleUniversalLink - invalid parameter")
      fatalError("Invalid parameter")
    }

    let handled = DynamicLinks.dynamicLinks().handleUniversalLink(webPage) { (dynamicLink, error) in
      guard let dynamicLink = dynamicLink else {
        NSLog("[ERROR] handleUniversalLink - dynamicLink not available - error = %@", error?.localizedDescription ?? "Unknown error")
        self.fireEvent("deeplink", with: ["success": false, "error": error?.localizedDescription ?? "Unknown error"])
        return
      }

      NSLog("[WARN] handleUniversalLink - found dynamic link: %@", dynamicLink.url?.absoluteString ?? "Unknown url")
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
    }
    
    NSLog("[WARN] handleUniversalLink - handled: %li", handled)
  }

  /// To be called in the "handleurl" event
  @objc(fetchDynamicLinkFromCustomURLSchemeURL:)
  func fetchDynamicLinkFromCustomURLSchemeURL(args: [Any]) -> Bool {
    NSLog("[WARN] fetchDynamicLinkFromCustomURLSchemeURL - 1 - %@", args)

    guard let customSchemeURLString = args.first as? String, let customSchemeURL = URL(string: customSchemeURLString) else {
      NSLog("[ERROR] fetchDynamicLinkFromCustomURLSchemeURL - invalid parameter")
      fatalError("Invalid parameter")
    }

    NSLog("[WARN] fetchDynamicLinkFromCustomURLSchemeURL - 1")

    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: customSchemeURL) {
      NSLog("[WARN] fetchDynamicLinkFromCustomURLSchemeURL - found dynamic link: %@", dynamicLink.url?.absoluteString ?? "Unknown url")
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
      return true
    } else {
      NSLog("[ERROR] fetchDynamicLinkFromCustomURLSchemeURL - dynamicLink not available")
    }

    return false
  }
}
