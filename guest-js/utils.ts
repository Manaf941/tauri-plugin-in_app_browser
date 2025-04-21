import { Channel, invoke, PluginListener } from "@tauri-apps/api/core";

// Tauri is broken, it should be register_listener and not registerListener
// as they've made it in their addPluginListener utils
export async function addPluginListener(plugin: string, event: string, cb: (payload: any) => void) {
    const handler = new Channel(cb)

    await invoke(
        `plugin:${plugin}|register_listener`,
        {
            event: event,
            handler: handler
        },
    )

    return new PluginListener(plugin, event, handler.id)
}