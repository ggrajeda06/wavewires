// Run against a running Tomcat. Playwright is a development-only dependency.
const { chromium } = require(process.env.PLAYWRIGHT_MODULE || 'playwright');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const os = require('node:os');
const base = (process.env.LOGIN_BASE_URL || 'http://localhost:8080').replace(/\/$/, '');
const output = process.env.LOGIN_QA_OUTPUT || path.join(os.tmpdir(), 'wavewires-login-3d-qa');
fs.mkdirSync(output, { recursive: true });

async function controlledPage(browser, options = {}) {
  const page = await browser.newPage({ viewport: { width: 1440, height: 900 }, ...options });
  page.on('pageerror', error => { page.testErrors.push(error.message); });
  page.testErrors = [];
  await page.addInitScript(() => {
    let id = 0;
    const pending = new Map();
    window.requestAnimationFrame = callback => { pending.set(++id, callback); return id; };
    window.cancelAnimationFrame = key => pending.delete(key);
    window.__introTest = {
      step(time) { const calls = [...pending.values()]; pending.clear(); calls.forEach(callback => callback(time)); },
      pending() { return pending.size; }
    };
  });
  return page;
}
async function load(page) {
  await page.goto(base + '/login.jsp');
  await page.locator('#ocean-canvas.is-ready').waitFor();
  assert.equal(await page.locator('.login-shell').evaluate(el => el.inert), true);
  await page.evaluate(() => window.__introTest.step(100));
}
async function advance(page, seconds) {
  await page.evaluate(t => window.__introTest.step(100 + t * 1000), seconds);
}
async function assertFormReady(page) {
  assert.equal(await page.locator('.login-shell').evaluate(el => el.inert), false);
  assert.equal(await page.locator('#skip-intro').isVisible(), false);
  assert.equal(await page.locator('#intro-hint').isVisible(), false);
  assert.equal(await page.locator('#login-error').innerText(), '');
  assert.equal(new URL(page.url()).pathname, '/login.jsp');
  assert.deepEqual(page.testErrors, []);
}

(async () => {
  const browser = await chromium.launch({ channel: process.env.LOGIN_BROWSER || 'chrome', headless: true });
  try {
    const page = await controlledPage(browser);
    await load(page);
    for (const seconds of [0, 0.8, 1.3, 1.55, 2.4, 3.8, 4.8, 5.5]) {
      if (seconds) await advance(page, seconds);
      if (seconds === 5.5) await page.waitForTimeout(650);
      await page.screenshot({ path: path.join(output, `desktop-${seconds}.png`) });
    }
    await assertFormReady(page);
    await page.getByRole('button', { name: 'Pausar ambiente' }).click();
    assert.equal(await page.evaluate(() => window.__introTest.pending()), 0);
    await page.getByRole('button', { name: 'Reanudar ambiente' }).click();
    assert.equal(await page.evaluate(() => window.__introTest.pending()), 1);
    console.log('PASS complete timeline and pause/resume');

    for (const seconds of [0.4, 1.4, 3.0, 5.0]) {
      for (const gesture of ['enter', 'click', 'button']) {
        await load(page);
        await advance(page, seconds);
        if (gesture === 'enter') {
          await page.keyboard.down('Enter');
          await page.keyboard.down('Enter');
          await page.keyboard.down('Enter');
          await page.keyboard.up('Enter');
        } else if (gesture === 'button') {
          await page.getByRole('button', { name: 'Omitir intro' }).click();
        } else {
          // Click directly where the submit button is going to appear.
          const box = await page.locator('[type="submit"]').boundingBox();
          await page.mouse.dblclick(box.x + box.width / 2, box.y + box.height / 2, { delay: 70 });
        }
        await assertFormReady(page);
        assert.equal(await page.locator('#username').evaluate(el => document.activeElement === el), true, `focus after ${gesture} at ${seconds}s`);
      }
    }
    console.log('PASS Enter, held Enter, button and double click in all phases');

    const mobile = await controlledPage(browser, { viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    for (const seconds of [0.4, 1.4, 3.0, 5.0]) {
      await load(mobile);
      await advance(mobile, seconds);
      if (seconds === 1.4) await mobile.screenshot({ path: path.join(output, 'mobile-impact.png') });
      await mobile.touchscreen.tap(180, 440);
      await assertFormReady(mobile);
    }
    await mobile.waitForTimeout(650);
    assert.equal(await mobile.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true);
    await mobile.screenshot({ path: path.join(output, 'mobile-final.png'), fullPage: true });
    await mobile.setViewportSize({ width: 320, height: 568 });
    assert.equal(await mobile.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true);
    console.log('PASS touch omission and mobile layout');

    for (const [user, route] of Object.entries({ ' ADMINISTRADOR ': '/Administrador/admin_resumen.jsp', networkoperator: '/NetworkOperator/index.jsp', supervisor: '/Supervisor/supervisor_home.jsp', maintence: '/Maintence/MC_template.jsp' })) {
      await load(page);
      await page.keyboard.press('Enter');
      await page.locator('#username').fill(user);
      await page.locator('#password').fill('123');
      await Promise.all([page.waitForURL(base + route), page.locator('#password').press('Enter')]);
      await page.getByRole('link', { name: 'Cerrar sesión', exact: true }).click();
      await page.waitForURL(base + '/login.jsp?logout=1');
      await assertFormReady(page);
      await page.locator('#ocean-canvas.is-ready').waitFor();
      await assertFormReady(page);
      await page.reload();
      await assertFormReady(page);
      await page.locator('#ocean-canvas.is-ready').waitFor();
      await page.goto(base + route);
      await page.goBack();
      await assertFormReady(page);
      // Exercise the BFCache restoration branch even when automation disables BFCache.
      await page.evaluate(() => window.dispatchEvent(new PageTransitionEvent('pageshow', { persisted: true })));
      await assertFormReady(page);
      await page.getByRole('button', { name: 'Pausar ambiente' }).waitFor();
      console.log('PASS login and logout', user.trim());
    }

    await page.emulateMedia({ reducedMotion: 'reduce' });
    await assertFormReady(page);
    assert.equal(await page.locator('#ocean-canvas').evaluate(el => el.classList.contains('is-ready')), false);
    await page.emulateMedia({ reducedMotion: 'no-preference' });
    await page.locator('#ocean-canvas.is-ready').waitFor();
    const reduced = await controlledPage(browser, { reducedMotion: 'reduce' });
    await reduced.goto(base + '/login.jsp');
    await assertFormReady(reduced);
    await reduced.emulateMedia({ reducedMotion: 'no-preference' });
    await reduced.locator('#ocean-canvas.is-ready').waitFor();
    await assertFormReady(reduced);
    console.log('PASS reduced motion on initial load and live changes');

    await page.evaluate(() => document.getElementById('ocean-canvas').getContext('webgl2').getExtension('WEBGL_lose_context').loseContext());
    await page.waitForFunction(() => !document.getElementById('ocean-canvas').classList.contains('is-ready'), undefined, { polling: 50 });
    await assertFormReady(page);
    for (const failure of ['module', 'texture', 'context']) {
      const broken = await controlledPage(browser);
      if (failure === 'context') await broken.addInitScript(() => {
        const original = HTMLCanvasElement.prototype.getContext;
        HTMLCanvasElement.prototype.getContext = function(type, ...args) { return type.startsWith('webgl') ? null : original.call(this, type, ...args); };
      });
      else await broken.route(failure === 'module' ? '**/three.module.min.js' : '**/assets/login/underwater.png', route => route.abort());
      await broken.goto(base + '/login.jsp');
      await broken.waitForFunction(() => !document.querySelector('.login-shell').inert, undefined, { polling: 50 });
      await assertFormReady(broken);
      await broken.close();
    }
    console.log('PASS missing modules/textures and unavailable/lost WebGL');

    for (const skipDuringLoad of [false, true]) {
      const slow = await controlledPage(browser);
      await slow.route('**/ocean-renderer.js', async route => {
        await new Promise(resolve => setTimeout(resolve, 2600));
        await route.continue();
      });
      await slow.goto(base + '/login.jsp', { waitUntil: 'domcontentloaded' });
      if (skipDuringLoad) await slow.keyboard.press('Enter');
      await slow.waitForFunction(() => !document.querySelector('.login-shell').inert, undefined, { polling: 50, timeout: 2300 });
      await assertFormReady(slow);
      await slow.locator('#ocean-canvas.is-ready').waitFor();
      await assertFormReady(slow);
      await slow.close();
    }
    console.log('PASS delayed loading and omission before resources are ready');
    await mobile.close();
    await reduced.close();
    await page.close();
    console.log('ALL CHECKS PASSED. Screenshots:', output);
  } finally { await browser.close(); }
})().catch(error => { console.error(error); process.exitCode = 1; });
