import { invoke } from '@tauri-apps/api/core'
import SafariBrowser from './SafariBrowser'
import { addPluginListener } from './utils'

export const PLUGIN_NAME = "in-app-browser"

export interface SafariClosedEventPayload {
    id: number,
}

export const safari_events = new EventTarget()
export async function init_in_app_browser() {
    await addPluginListener(
        PLUGIN_NAME,
        "safari_closed",
        (payload: SafariClosedEventPayload) => {
            safari_events.dispatchEvent(
                new CustomEvent("safari_closed", { detail: payload })
            )
        }
    )
}

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
export async function open_safari(request: OpenSafariRequest): Promise<SafariBrowser> {
    const response = await invoke<OpenSafariResponse>(`plugin:${PLUGIN_NAME}|open_safari`, {
        payload: request
    })

    return new SafariBrowser(response.id)
}

export interface CloseSafariRequest {
    id: number
}
export interface CloseSafariResponse {}
export async function close_safari(request: CloseSafariRequest): Promise<CloseSafariResponse> {
    return await invoke<CloseSafariResponse>(`plugin:${PLUGIN_NAME}|close_safari`, {
        payload: request
    })
}

export interface OpenChromeRequest {
    url: string,
    toolbarColor?: string,
    secondaryToolbarColor?: string
}

export async function open_chrome(request: OpenChromeRequest): Promise<null> {
    return await invoke<null>(`plugin:${PLUGIN_NAME}|open_chrome`, {
        payload: request
    })
}
