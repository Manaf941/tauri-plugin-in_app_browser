<script>
    import Greet from './lib/Greet.svelte'
    import { open_safari, init_in_app_browser, open_chrome, safari_events } from 'tauri-plugin-in-app-browser-api'

    init_in_app_browser()

	let response = ''

	function updateResponse(returnValue) {
		response += `[${new Date().toLocaleTimeString()}] ` + (typeof returnValue === 'string' ? returnValue : JSON.stringify(returnValue)) + '<br>'
	}

    async function open_safari_browser() {
        try {
            const browser = await open_safari({
                url: "https://google.com",
                modalPresentationStyle: "pageSheet"
            })
            
            if (!browser) return
            updateResponse("Browser Launched with id " + browser.safari_id)

            browser.addEventListener("close", () => {
                updateResponse("Browser Closed !")
            })

            setTimeout(() => {
                browser.close()
            }, 2000)
        } catch(err) {
            updateResponse(err)
        }
    }

    function open_chrome_browser() {
        open_chrome({
        url: "https://google.com",
        })
        .then(updateResponse)
        .catch(updateResponse)
    }
</script>

<main class="container">
  <h1>Welcome to Tauri!</h1>

  <div class="row">
    <a href="https://vite.dev" target="_blank">
      <img src="/vite.svg" class="logo vite" alt="Vite Logo" />
    </a>
    <a href="https://tauri.app" target="_blank">
      <img src="/tauri.svg" class="logo tauri" alt="Tauri Logo" />
    </a>
    <a href="https://svelte.dev" target="_blank">
      <img src="/svelte.svg" class="logo svelte" alt="Svelte Logo" />
    </a>
  </div>

  <p>Click on the Tauri, Vite, and Svelte logos to learn more.</p>

  <div class="row">
    <Greet />
  </div>

  <div>
    <button on:click={open_safari_browser}
      >Open Google.com (SFSafariViewController)</button
    >
    <button on:click={open_chrome_browser}
      >Open Google.com (Chrome Custom Tabs)</button
    >
    <div>{@html response}</div>
  </div>
</main>

<style>
  .logo.vite:hover {
    filter: drop-shadow(0 0 2em #747bff);
  }

  .logo.svelte:hover {
    filter: drop-shadow(0 0 2em #ff3e00);
  }
</style>
