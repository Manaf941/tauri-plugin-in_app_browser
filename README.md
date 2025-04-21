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
        "in-app-browser:allow-open-safari"
    ]
}

```

## `index.ts`
```ts
import { open_safari } from 'tauri-plugin-in-app-browser-api'

await open_safari({
    url: "https://google.com",

    // Color should be in rgba format, such as `#rrggbbaa`
    preferredControlTintColor: "#ff0000ff"
})

// Available Options
interface OpenSafariRequest {
    url: string,
    entersReaderIfAvailable?: boolean,
    barCollapsingEnabled?: boolean,

    
    preferredControlTintColor?: string,

    // https://developer.apple.com/documentation/uikit/uimodalpresentationstyle
    // you'll likely want fullScreen and pageSheet
    modalPresentationStyle?: string,

    // https://developer.apple.com/documentation/uikit/uimodaltransitionstyle
    // you'll likely want coverVertical, maybe even crossDissolve
    modalTransitionStyle?: string,

    modalPresentationCapturesStatusBarAppearance?: boolean
}
```

# Design Choices
1. I've chosen to not make a platform-agnostic code to have full control over styling and behavior.
2. I needed to use `SFSafariViewController` to use Apple Pay through a dynamic merchant (Not available through PassKit). As such, I did not implement `WKWebView`