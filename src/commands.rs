use tauri::{AppHandle, command, Runtime};

use crate::models::*;
use crate::Result;
use crate::InAppBrowserExt;

#[command]
pub(crate) async fn open_safari<R: Runtime>(
    app: AppHandle<R>,
    payload: OpenSafariRequest,
) -> Result<OpenSafariResponse> {
    app.in_app_browser().open_safari(payload)
}

#[command]
pub(crate) async fn open_chrome<R: Runtime>(
    app: AppHandle<R>,
    payload: OpenChromeRequest,
) -> Result<OpenChromeResponse> {
    app.in_app_browser().open_chrome(payload)
}
