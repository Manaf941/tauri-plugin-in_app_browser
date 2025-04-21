# Tauri Plugin in_app_browser
> [!CAUTION]
> This was a plugin primarily made for myself. I've made it open-source so that other people could use it, but I'm not willing to document everything. If you do need some help / clarification / changes, you can contact me on Discord / Twitter: `manaf941` / `manaaaaaaaf`

# Usage
## `src-tauri/src/lib.rs`
```rs
#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        // this line initializes the plugin
        .plugin(tauri_plugin_in_app_browser::init())
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

## `src-tauri/capabilities/default.json`
```json
{
    "permissions": [
        "in-app-browser:default",
        "in-app-browser:allow-open-safari",
        "in-app-browser:allow-close-safari",
        "in-app-browser:allow-open-chrome"
    ]
}

```

## `index.ts`
```ts
import { open_safari, open_chrome } from 'tauri-plugin-in-app-browser-api'

// iOS
const browser = await open_safari({
    // See guest-js/index.ts for available options
    url: "https://google.com",

    // Color should be in rgba format, such as `#rrggbbaa`
    preferredControlTintColor: "#ff0000ff"
})

browser.addEventListener("close", () => {
    // browser closed (either by the user or by browser.close())
})

// after some time, force the user to close safari
await browser.close()

// Android
const browser = await open_chrome({
    // See guest-js/index.ts for available options
    url: "https://google.com"
})
```

> [!WARNING]
> On iOS, if you set `modalPresentationStyle` to `fullScreen`, your application might get paused. Any timeout to browser.call won't be ran.

# Design Choices
1. I've chosen to not make platform-agnostic code to have full control over desired styling and behavior.
2. I needed to use `SFSafariViewController` to use Apple Pay through a dynamic merchant (Not available through PassKit). As such, I did not implement `WKWebView`. You can probably already do this with Tauri already though