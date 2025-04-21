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
export interface OpenSafariResponse {
    id: number,
}
export async function open_safari(request: OpenSafariRequest): Promise<OpenSafariResponse> {
    return await invoke<OpenSafariResponse>('plugin:in-app-browser|open_safari', {
        payload: request
    })
}

export interface CloseSafariRequest {
    id: number
}
export interface CloseSafariResponse {}
export async function close_safari(request: CloseSafariRequest): Promise<CloseSafariResponse> {
    return await invoke<CloseSafariResponse>('plugin:in-app-browser|close_safari', {
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
