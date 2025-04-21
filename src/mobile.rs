use serde::de::DeserializeOwned;
use tauri::{
  plugin::{PluginApi, PluginHandle},
  AppHandle, Runtime,
};

use crate::models::*;

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_in_app_browser);

// initializes the Kotlin or Swift plugin classes
pub fn init<R: Runtime, C: DeserializeOwned>(
  _app: &AppHandle<R>,
  api: PluginApi<R, C>,
) -> crate::Result<InAppBrowser<R>> {
  #[cfg(target_os = "android")]
  let handle = api.register_android_plugin("ch.manaf.tauri_plugins.in_app_browser", "InAppBrowserPlugin")?;
  #[cfg(target_os = "ios")]
  let handle = api.register_ios_plugin(init_plugin_in_app_browser)?;
  Ok(InAppBrowser(handle))
}

/// Access to the in-app-browser APIs.
pub struct InAppBrowser<R: Runtime>(PluginHandle<R>);

impl<R: Runtime> InAppBrowser<R> {
  pub fn open_safari(&self, payload: OpenSafariRequest) -> crate::Result<OpenSafariResponse> {
    #[cfg(target_os = "android")]
    return Err(crate::Error::UnsupportedPlatformError);
    #[cfg(target_os = "ios")]
    return self
      .0
      .run_mobile_plugin("open_safari", payload)
      .map_err(Into::into);
  }

  pub fn open_chrome(&self, payload: OpenChromeRequest) -> crate::Result<OpenChromeResponse> {
    #[cfg(target_os = "ios")]
    return Err(crate::Error::UnsupportedPlatformError);
    #[cfg(target_os = "android")]
    return self
      .0
      .run_mobile_plugin("open_chrome", payload)
      .map_err(Into::into);
  }
}
