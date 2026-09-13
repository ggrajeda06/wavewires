(() => {
  'use strict';
  const rendererURL = new URL('ocean-renderer.js', document.currentScript.src).href;
  const canvas = document.getElementById('ocean-canvas');
  const shell = document.querySelector('.login-shell');
  const skip = document.getElementById('skip-intro');
  const hint = document.getElementById('intro-hint');
  const motion = document.getElementById('toggle-motion');
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  const returningFromLogout = new URLSearchParams(window.location.search).get('logout') === '1';
  let ocean;
  let duration = 5.5;
  let introTime = 0;
  let ambientTime = 0;
  let previousTime = 0;
  let frame = 0;
  let loadingDeadline = 0;
  let initializing = false;
  let finished = false;
  let failed = false;
  let paused = false;
  let heldEnter = false;
  let swallowClicksUntil = 0;
  let slowFrames = 0;
  let resolutionScale = 1;

  function updateMotionButton() {
    motion.hidden = !ocean || failed || reducedMotion.matches || !finished;
    motion.setAttribute('aria-pressed', String(paused));
    motion.innerHTML = paused ? 'Reanudar ambiente <span aria-hidden="true">▷</span>' : 'Pausar ambiente <span aria-hidden="true">Ⅱ</span>';
  }

  function finishIntro(focus = false) {
    finished = true;
    introTime = duration;
    skip.hidden = true;
    hint.hidden = true;
    // Render the destination before revealing any interactive controls.
    if (ocean && !failed && !reducedMotion.matches) draw();
    document.body.classList.remove('is-diving');
    shell.inert = false;
    updateMotionButton();
    if (focus) document.getElementById('username').focus({ preventScroll: true });
  }

  function beginIntro() {
    finished = false;
    introTime = 0;
    previousTime = 0;
    paused = false;
    document.body.classList.add('is-diving');
    shell.inert = true;
    skip.hidden = false;
    hint.hidden = false;
    updateMotionButton();
  }

  function fallback(error) {
    if (failed) return;
    failed = true;
    clearTimeout(loadingDeadline);
    cancelAnimationFrame(frame);
    canvas.classList.remove('is-ready');
    if (ocean) { ocean.dispose(); ocean = undefined; }
    finishIntro();
    if (error) console.warn('WaveWires: using the static ocean background.', error);
  }

  function draw() {
    try { ocean.draw(introTime, ambientTime); }
    catch (error) { fallback(error); }
  }

  function tick(now) {
    if (!ocean || failed || paused || reducedMotion.matches || document.hidden) return;
    const delta = previousTime ? Math.max(0, now - previousTime) : 0;
    previousTime = now;
    ambientTime += delta / 1000;
    if (!finished) introTime = Math.min(duration, introTime + delta / 1000);
    if (!finished && introTime >= duration) finishIntro();
    else draw();
    if (failed) return;
    if (delta > 28) slowFrames++;
    else slowFrames = Math.max(0, slowFrames - 1);
    if (slowFrames > 45 && resolutionScale > 0.55) {
      resolutionScale = Math.max(0.55, resolutionScale * 0.8);
      slowFrames = 0;
      resize();
    }
    frame = requestAnimationFrame(tick);
  }

  function resume() {
    cancelAnimationFrame(frame);
    previousTime = 0;
    if (ocean && !failed && !paused && !reducedMotion.matches && !document.hidden) frame = requestAnimationFrame(tick);
  }

  function resize() {
    if (!ocean || failed) return;
    try {
      ocean.resize(canvas.clientWidth, canvas.clientHeight, resolutionScale);
      if (!reducedMotion.matches) draw();
    } catch (error) { fallback(error); }
  }

  function consume(event) {
    event.preventDefault();
    event.stopImmediatePropagation();
  }

  // Capture the original event before enabling the form, including synthesized touch clicks.
  window.addEventListener('pointerdown', event => {
    // A second click must not even focus a newly revealed control before its click is consumed.
    if (event.button === 0 && performance.now() < swallowClicksUntil) consume(event);
  }, true);
  window.addEventListener('click', event => {
    if (event.button !== 0) return;
    if (performance.now() < swallowClicksUntil) { consume(event); return; }
    if (finished) return;
    consume(event);
    swallowClicksUntil = performance.now() + 350;
    finishIntro(true);
  }, true);
  window.addEventListener('keydown', event => {
    if (event.key !== 'Enter' || event.isComposing) return;
    if (!finished || heldEnter) {
      consume(event);
      heldEnter = true;
      if (!finished) finishIntro(true);
    }
  }, true);
  window.addEventListener('keyup', event => {
    if (event.key === 'Enter' && heldEnter) { consume(event); heldEnter = false; }
  }, true);
  window.addEventListener('blur', () => { heldEnter = false; });
  motion.addEventListener('click', () => {
    paused = !paused;
    updateMotionButton();
    resume();
  });
  document.addEventListener('visibilitychange', resume);
  window.addEventListener('resize', resize);
  window.addEventListener('pagehide', () => cancelAnimationFrame(frame));
  window.addEventListener('pageshow', event => {
    if (!event.persisted) return;
    heldEnter = false;
    swallowClicksUntil = 0;
    if (ocean && !failed && !reducedMotion.matches) {
      if (returningFromLogout) finishIntro();
      else beginIntro();
      draw();
      resume();
    }
    else finishIntro();
  });
  canvas.addEventListener('webglcontextlost', event => {
    event.preventDefault();
    fallback();
  });
  reducedMotion.addEventListener('change', () => {
    if (reducedMotion.matches) {
      cancelAnimationFrame(frame);
      canvas.classList.remove('is-ready');
      finishIntro();
    } else if (!failed) {
      if (ocean) {
        resize();
        canvas.classList.add('is-ready');
        updateMotionButton();
        resume();
      } else initialize();
    }
  });

  async function initialize() {
    if (initializing || ocean || failed || reducedMotion.matches) return;
    initializing = true;
    // Module/texture loading is independent of the intro duration.
    loadingDeadline = window.setTimeout(() => { if (!ocean) finishIntro(); }, 1800);
    try {
      const module = await import(rendererURL);
      duration = module.INTRO_SECONDS;
      if (finished) introTime = duration;
      const instance = await module.createOceanRenderer(canvas);
      if (failed) { instance.dispose(); return; }
      ocean = instance;
      clearTimeout(loadingDeadline);
      resize();
      if (failed) return;
      if (!reducedMotion.matches) canvas.classList.add('is-ready');
      updateMotionButton();
      resume();
    } catch (error) { fallback(error); }
    finally { initializing = false; }
  }

  if (reducedMotion.matches) finishIntro();
  else {
    if (returningFromLogout) finishIntro();
    else beginIntro();
    initialize();
  }
})();
