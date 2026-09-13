// The same timeline drives the camera, impact, particles and final composition.
  export const INTRO_SECONDS = 5.5;
export const IMPACT_SECONDS = 1.3;
export const FINAL_PITCH = 0.86;
export const FINAL_DEPTH = -4.6;

export function smoothstep(start, end, value) {
  const t = Math.max(0, Math.min(1, (value - start) / (end - start)));
  return t * t * (3 - 2 * t);
}

export function getCameraPose(seconds) {
  const t = Math.max(0, Math.min(INTRO_SECONDS, seconds));
  const afterImpact = Math.max(0, t - IMPACT_SECONDS);
  const falling = t < IMPACT_SECONDS;
  const settle = smoothstep(3.8, INTRO_SECONDS, t);
  const turn = smoothstep(1.55, 4.7, t);
  // Gravity in air; continuous entry velocity, then strong underwater drag.
  const entrySpeed = 7.2 / IMPACT_SECONDS;
  const drag = entrySpeed / -FINAL_DEPTH;
  const depth = falling
    ? 3.6 * (1 - (t / IMPACT_SECONDS) ** 2)
    : FINAL_DEPTH * (1 - Math.exp(-drag * afterImpact));
  const impact = falling ? 0 : Math.exp(-afterImpact * 6.5) * Math.sin(afterImpact * 25);
  const sway = falling ? 0 : Math.sin(afterImpact * 4.8) * Math.exp(-afterImpact * 1.1) * (1 - settle);
  return {
    x: 0.14 * Math.sin(t * 0.9) * (1 - settle),
    y: depth * (1 - settle) + FINAL_DEPTH * settle,
    z: -0.28 * Math.min(t, 3.8),
    pitch: -0.24 + (FINAL_PITCH + 0.24) * turn + impact * 0.07 * (1 - settle) + sway * 0.06,
    roll: falling ? -0.21 * (t / IMPACT_SECONDS) ** 2 : (-0.21 * Math.exp(-afterImpact * 1.7) + sway * 0.12) * (1 - settle),
    yaw: 0.025 * Math.sin(t * 1.4) * (1 - settle),
    fov: 58 + 6 * smoothstep(0.45, IMPACT_SECONDS, t) * (1 - smoothstep(1.5, 3.5, t)),
    impact: Math.exp(-afterImpact * 3.8) * smoothstep(IMPACT_SECONDS - 0.08, IMPACT_SECONDS + 0.03, t) * (1 - settle),
    particles: smoothstep(1.25, 1.6, t) * (1 - smoothstep(3.9, INTRO_SECONDS, t)),
    finalBlend: smoothstep(4.7, INTRO_SECONDS, t)
  };
}
