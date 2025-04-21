package ch.manaf.tauri_plugins.in_app_browser

import android.app.Activity
import android.content.Intent
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import app.tauri.annotation.Command
import app.tauri.annotation.InvokeArg
import app.tauri.annotation.TauriPlugin
import app.tauri.plugin.JSObject
import app.tauri.plugin.Plugin
import app.tauri.plugin.Invoke

@InvokeArg
class OpenChromeArgs {
  var url: String? = null
  var toolbarColor: String? = null
  var secondaryToolbarColor: String? = null
}

@TauriPlugin
class InAppBrowserPlugin(private val activity: Activity): Plugin(activity) {
    @Command
    fun open_chrome(invoke: Invoke) {
        val args = invoke.parseArgs(OpenChromeArgs::class.java)
        val url = args.url
        if (url.isNullOrBlank()) {
            invoke.reject("Invalid URL")
            return
        }

        val builder = CustomTabsIntent.Builder()

        // Set toolbar color if provided
        args.toolbarColor?.let {
            try {
                builder.setToolbarColor(android.graphics.Color.parseColor(it))
            } catch (e: Exception) {
                invoke.reject("Invalid toolbarColor: $it")
                return
            }
        }

        // Set secondary toolbar color if provided
        args.secondaryToolbarColor?.let {
            try {
                builder.setSecondaryToolbarColor(android.graphics.Color.parseColor(it))
            } catch (e: Exception) {
                invoke.reject("Invalid secondaryToolbarColor: $it")
                return
            }
        }

        val customTabsIntent = builder.build()
        try {
            customTabsIntent.launchUrl(activity, Uri.parse(url))
            invoke.resolve(JSObject())
        } catch (e: Exception) {
            invoke.reject("Failed to launch Chrome Custom Tab: ${e.message}")
        }
    }
}
