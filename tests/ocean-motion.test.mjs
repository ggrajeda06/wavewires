import test from 'node:test';
import assert from 'node:assert/strict';
import { getCameraPose, INTRO_SECONDS, IMPACT_SECONDS, FINAL_DEPTH, FINAL_PITCH } from '../web/js/ocean-motion.js';

test('camera accelerates toward the surface, crosses it and slows underwater', () => {
  const velocity = t => (getCameraPose(t + 0.0001).y - getCameraPose(t - 0.0001).y) / 0.0002;
  assert(getCameraPose(0).y > 0);
  assert(Math.abs(getCameraPose(IMPACT_SECONDS).y) < 1e-8);
  assert(getCameraPose(IMPACT_SECONDS + 0.1).y < 0);
  assert(Math.abs(velocity(1.1)) > Math.abs(velocity(0.3)));
  assert(Math.abs(velocity(2.5)) < Math.abs(velocity(1.5)));
  assert(Math.abs(velocity(IMPACT_SECONDS - 0.001) - velocity(IMPACT_SECONDS + 0.001)) < 0.02);
});

test('camera remains finite, descends monotonically and never spins completely', () => {
  let previousDepth = Infinity;
  for (let t = 0; t <= INTRO_SECONDS; t += 1 / 144) {
    const pose = getCameraPose(t);
    assert(Object.values(pose).every(Number.isFinite));
    assert(pose.y <= previousDepth + 1e-8);
    assert(Math.abs(pose.roll) <= 0.211);
    previousDepth = pose.y;
  }
});

test('natural completion and skipping land in one stationary pose', () => {
  const final = getCameraPose(INTRO_SECONDS);
  assert.equal(final.y, FINAL_DEPTH);
  assert(Math.abs(final.pitch - FINAL_PITCH) < 1e-10);
  assert(Math.abs(final.roll) < 1e-10);
  assert(Math.abs(final.yaw) < 1e-10);
  assert.equal(final.impact, 0);
  assert.equal(final.particles, 0);
  assert.equal(final.finalBlend, 1);
  assert.deepEqual(getCameraPose(100), final);
  assert.deepEqual(getCameraPose(-1), getCameraPose(0));
});
