/* =====================================================================
   Feed Refiner for LinkedIn — Popup controller (popup.js)
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
    hideJobs: false,
    hideComposer: false,
    aiDetector: false,
    spamDetector: false,
    commentSilencer: false,
    tldrSummarizer: true,
    timeBudgetEnabled: false,
    dailyPostLimit: 30,
  };

  // Selecting a preset seeds sensible sidebar defaults for that layout.
  // De-clutter toggles (promoted/vanity/jobs/composer) are preserved.
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
  const limitInput = document.getElementById('dailyPostLimit');
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
    if (limitInput) limitInput.value = state.dailyPostLimit;
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

  if (limitInput) {
    const commitLimit = () => {
      let n = parseInt(limitInput.value, 10);
      if (isNaN(n)) n = DEFAULT_STATE.dailyPostLimit;
      n = Math.min(999, Math.max(1, n));
      limitInput.value = n;
      if (n === state.dailyPostLimit) return;
      state = { ...state, dailyPostLimit: n };
      persistAndBroadcast();
    };
    limitInput.addEventListener('change', commitLimit);
    limitInput.addEventListener('blur', commitLimit);
  }

  /* -------------- Time Budget counter (reset) --------------- */
  const BUDGET_KEY = 'lbfBudget';
  const budgetCountEl = document.getElementById('budgetCount');
  const resetBtn = document.getElementById('resetCounter');

  function todayStr() {
    const d = new Date();
    const m = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return d.getFullYear() + '-' + m + '-' + day;
  }

  // Reflect today's live post count in the popup.
  function renderCount() {
    if (!budgetCountEl) return;
    chrome.storage.local.get(BUDGET_KEY, (result) => {
      const b = result && result[BUDGET_KEY];
      const fresh = b && b.date === todayStr();
      budgetCountEl.textContent = fresh ? Number(b.count) || 0 : 0;
    });
  }

  if (resetBtn) {
    resetBtn.addEventListener('click', () => {
      // Zero today's counter (and any override bonus) so counting starts fresh.
      const fresh = { date: todayStr(), count: 0, bonus: 0 };
      chrome.storage.local.set({ [BUDGET_KEY]: fresh }, () => {
        renderCount();
        flashStatus('Counter reset');
      });
    });
  }

  // Keep the displayed count in sync if the content script updates it.
  chrome.storage.onChanged.addListener((changes, area) => {
    if (area === 'local' && changes[BUDGET_KEY]) renderCount();
  });

  /* ----------------------- Init ---------------------------- */
  chrome.storage.local.get(STORAGE_KEY, (result) => {
    const saved = (result && result[STORAGE_KEY]) || {};
    state = { ...DEFAULT_STATE, ...saved };
    render();
  });
  renderCount();
})();
