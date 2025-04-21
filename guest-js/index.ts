import { invoke } from '@tauri-apps/api/core'

export interface OpenSafariRequest {
    url: string,
    entersReaderIfAvailable?: boolean,
    barCollapsingEnabled?: boolean,
    preferredControlTintColor?: string,
    preferredBarTintColor?: string,
    modalPresentationStyle?: string,
    modalTransitionStyle?: string,
    modalPresentationCapturesStatusBarAppearance?: boolean
}
export async function open_safari(request: OpenSafariRequest): Promise<null> {
    return await invoke<null>('plugin:in-app-browser|open_safari', {
        payload: request
    })
}

export interface OpenChromeRequest {
    url: string,
    toolbarColor?: string,
    secondaryToolbarColor?: string
}

export async function open_chrome(request: OpenChromeRequest): Promise<null> {
    return await invoke<null>('plugin:in-app-browser|open_chrome', {
        payload: request
    })
}
