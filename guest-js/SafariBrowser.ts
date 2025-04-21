import { close_safari, safari_events, SafariClosedEventPayload } from "."

export default class SafariBrowser extends EventTarget {
    safari_id: number
    closed: boolean = false
    constructor(safari_id: number) {
        super()
        this.safari_id = safari_id
        
        const safari_closed_listener = (ev: any) => {
            const detail: SafariClosedEventPayload = ev?.detail
            if (detail.id !== this.safari_id) return
            
            safari_events.removeEventListener("safari_closed", safari_closed_listener)
            this.closed = true
            this.dispatchEvent(new CustomEvent("close"))
        }
        safari_events.addEventListener("safari_closed", safari_closed_listener)
    }

    async close() {
        return await close_safari({ id: this.safari_id })
    }
}