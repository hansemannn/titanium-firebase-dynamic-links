//
//  TiFirebasedynamiclinksModule.swift
//  titanium-firebase-dynamic-links
//
//  Created by Hans Knoechel
//  Copyright (c) 2021 Your Company. All rights reserved.
//

import UIKit
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
  
  override func _configure() {
    TiApp().registerApplicationDelegate(self)
  }
  
  override func _destroy() {
    TiApp().unregisterApplicationDelegate(self)
  }
}

extension TiFirebasedynamiclinksModule: UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    if let properties = TiApp.tiAppProperties(), let customURLScheme = properties["scheme"] as? String {
      FirebaseOptions.defaultOptions()?.deepLinkURLScheme = customURLScheme
    }

    return true
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
      guard let dynamicLink = dynamicLink else { return }
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
    }

    return handled
  }
  
  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
      self.fireEvent("deeplink", with: ["url": dynamicLink.url!.absoluteString, "matchType": dynamicLink.matchType.rawValue])
      return true
    }
    return false
  }
}
