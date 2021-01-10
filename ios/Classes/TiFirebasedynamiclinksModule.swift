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
  }

  /// To be called in the "continueuseractivity" event
  @objc(handleUniversalLink:)
  func handleUniversalLink(args: [Any]) {
    guard let webpageURLString = args.first as? String, let webPage = URL(string: webpageURLString) else {
      fatalError("Invalid parameter")
    }

    DynamicLinks.dynamicLinks().handleUniversalLink(webPage) { (dynamicLink, error) in
      guard let dynamicLink = dynamicLink else { return }
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
    }
  }

  /// To be called in the "handleurl" event
  @objc(fetchDynamicLinkFromCustomURLSchemeURL:)
  func fetchDynamicLinkFromCustomURLSchemeURL(args: [Any]) -> Bool {
    guard let customSchemeURLString = args.first as? String, let customSchemeURL = URL(string: customSchemeURLString) else {
      fatalError("Invalid parameter")
    }

    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: customSchemeURL) {
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
      return true
    }

    return false
  }
}
