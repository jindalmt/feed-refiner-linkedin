/* =====================================================================
   LinkedIn Beautifier — Popup controller (popup.js)
   ---------------------------------------------------------------------
   - Loads persisted state and reflects it in the UI.
   - On any change: writes to chrome.storage.local and broadcasts a live
     "LBF_STATE_UPDATE" message to the active LinkedIn feed tab.
   ===================================================================== */

(() => {
  'use strict';

  const STORAGE_KEY = 'lbfState';
  const FEED_URL_MATCH = 'https://www.linkedin.com/feed/';

  const DEFAULT_STATE = {
    mode: 'classic',
    hideLeft: false,
    hideRight: false,
    hidePromoted: false,
    hideVanity: false,
    killMessaging: false,
  };

  // Selecting a preset seeds sensible sidebar defaults for that layout.
  // De-clutter toggles (promoted/vanity/messaging) are preserved.
  const PRESET_SEEDS = {
    zen: { hideLeft: true, hideRight: true },
    executive: { hideLeft: false, hideRight: true },
    classic: { hideLeft: false, hideRight: false },
  };

  let state = { ...DEFAULT_STATE };

  const presetCards = Array.from(document.querySelectorAll('.preset-card'));
  const toggles = Array.from(
    document.querySelectorAll('.toggle-list input[type="checkbox"]')
  );
  const statusEl = document.getElementById('status');

  /* ----------------------- Rendering ----------------------- */
  function render() {
    presetCards.forEach((card) => {
      const active = card.dataset.mode === state.mode;
      card.setAttribute('aria-checked', String(active));
    });
    toggles.forEach((input) => {
      input.checked = !!state[input.dataset.key];
    });
  }

  let statusTimer;
  function flashStatus(text) {
    if (!statusEl) return;
    statusEl.textContent = text;
    statusEl.classList.add('show');
    clearTimeout(statusTimer);
    statusTimer = setTimeout(() => statusEl.classList.remove('show'), 1200);
  }

  /* ----------------------- Persistence --------------------- */
  function persistAndBroadcast() {
    chrome.storage.local.set({ [STORAGE_KEY]: state }, () => {
      broadcast();
      flashStatus('Saved');
    });
  }

  function broadcast() {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      const tab = tabs && tabs[0];
      if (!tab || !tab.id) return;
      if (!tab.url || tab.url.indexOf(FEED_URL_MATCH) !== 0) return;
      chrome.tabs.sendMessage(
        tab.id,
        { type: 'LBF_STATE_UPDATE', state },
        () => {
          // Swallow "no receiver" errors when the content script isn't ready.
          void chrome.runtime.lastError;
        }
      );
    });
  }

  /* ----------------------- Events -------------------------- */
  presetCards.forEach((card) => {
    card.addEventListener('click', () => {
      const mode = card.dataset.mode;
      if (!PRESET_SEEDS[mode]) return;
      state = { ...state, mode, ...PRESET_SEEDS[mode] };
      render();
      persistAndBroadcast();
    });
  });

  toggles.forEach((input) => {
    input.addEventListener('change', () => {
      state = { ...state, [input.dataset.key]: input.checked };
      render();
      persistAndBroadcast();
    });
  });

  /* ----------------------- Init ---------------------------- */
  chrome.storage.local.get(STORAGE_KEY, (result) => {
    const saved = (result && result[STORAGE_KEY]) || {};
    state = { ...DEFAULT_STATE, ...saved };
    render();
  });
})();
