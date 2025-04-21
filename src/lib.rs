use tauri::{
  plugin::{Builder, TauriPlugin},
  Manager, Runtime,
};

pub use models::*;

#[cfg(desktop)]
mod desktop;
#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{Error, Result};

#[cfg(desktop)]
use desktop::InAppBrowser;
#[cfg(mobile)]
use mobile::InAppBrowser;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the in-app-browser APIs.
pub trait InAppBrowserExt<R: Runtime> {
  fn in_app_browser(&self) -> &InAppBrowser<R>;
}

impl<R: Runtime, T: Manager<R>> crate::InAppBrowserExt<R> for T {
  fn in_app_browser(&self) -> &InAppBrowser<R> {
    self.state::<InAppBrowser<R>>().inner()
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("in-app-browser")
    .invoke_handler(tauri::generate_handler![commands::open_safari, commands::open_chrome])
    .setup(|app, api| {
      #[cfg(mobile)]
      let in_app_browser = mobile::init(app, api)?;
      #[cfg(desktop)]
      let in_app_browser = desktop::init(app, api)?;
      app.manage(in_app_browser);
      Ok(())
    })
    .build()
}
