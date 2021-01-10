/**
 * This file was auto-generated by the Titanium Module SDK helper for Android
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-present by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 *
 */

package ti.firebasedynamiclinks

import android.net.Uri

import com.google.firebase.dynamiclinks.FirebaseDynamicLinks

import org.appcelerator.kroll.KrollDict
import org.appcelerator.kroll.KrollFunction
import org.appcelerator.kroll.KrollModule
import org.appcelerator.kroll.annotations.Kroll
import org.appcelerator.kroll.common.Log
import org.appcelerator.titanium.TiApplication


@Kroll.module(name = "TitaniumFirebaseDynamicLinks", id = "ti.firebasedynamiclinks")
class TitaniumFirebaseDynamicLinksModule: KrollModule() {

	companion object {
		private const val LCAT = "TitaniumFirebaseDynamicLinksModule"
	}

	@Kroll.method
	fun handleDeepLink(callback: KrollFunction) {
		val currentActivity = TiApplication.getInstance().rootOrCurrentActivity

		FirebaseDynamicLinks.getInstance()
			.getDynamicLink(currentActivity.intent)
			.addOnSuccessListener(currentActivity) { pendingDynamicLinkData ->
				val event = KrollDict()

				// Get deep link from result (may be null if no link is found)
				var deepLink: Uri?
				if (pendingDynamicLinkData != null) {
					deepLink = pendingDynamicLinkData.link
					event["success"] = true
					event["deepLink"] = deepLink.toString()
				} else{
					event["success"] = false
					event["error"] = "No deep link found"
				}

				callback.callAsync(krollObject, event)
			}
			.addOnFailureListener(currentActivity) { e ->
				Log.e(LCAT, "getDynamicLink:onFailure", e)

				val event = KrollDict()
				event["success"] = false
				event["error"] = e.localizedMessage

				callback.callAsync(krollObject, event)
			}
	}
}
