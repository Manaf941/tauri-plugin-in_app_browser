use serde::de::DeserializeOwned;
use tauri::{plugin::PluginApi, AppHandle, Runtime};

use crate::models::*;

pub fn init<R: Runtime, C: DeserializeOwned>(
  app: &AppHandle<R>,
  _api: PluginApi<R, C>,
) -> crate::Result<InAppBrowser<R>> {
  Ok(InAppBrowser(app.clone()))
}

/// Access to the in-app-browser APIs.
pub struct InAppBrowser<R: Runtime>(AppHandle<R>);

impl<R: Runtime> InAppBrowser<R> {
  pub fn open_safari(&self, _payload: OpenSafariRequest) -> crate::Result<OpenSafariResponse> {
    Err(crate::Error::UnsupportedPlatformError)
    // Ok(OpenSafariResponse {})
  }

  pub fn close_safari(&self, _payload: CloseSafariRequest) -> crate::Result<CloseSafariResponse> {
    Err(crate::Error::UnsupportedPlatformError)
    // Ok(CloseSafariResponse {})
  }
}

impl<R: Runtime> InAppBrowser<R> {
  pub fn open_chrome(&self, _payload: OpenChromeRequest) -> crate::Result<OpenChromeResponse> {
    Err(crate::Error::UnsupportedPlatformError)
    // Ok(OpenSafariResponse {})
  }
}
