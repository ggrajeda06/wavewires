(() => {
  'use strict';
  const canvas = document.getElementById('ocean-canvas');
  const shell = document.querySelector('.login-shell');
  const skip = document.getElementById('skip-intro');
  const motion = document.getElementById('toggle-motion');
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  const INTRO_MS = 2000;
  let gl;
  let program;
  let frame = 0;
  let ready = false;
  let failed = false;
  let introDone = false;
  let paused = false;
  let introTime = 0;
  let sceneTime = 0;
  let previousTime = 0;
  let slowFrames = 0;
  let resolutionScale = 1;
  let uniforms;
  const textures = [];

  function revealForm(moveFocus = false) {
    introDone = true;
    introTime = INTRO_MS;
    document.body.classList.remove('is-diving');
    shell.inert = false;
    skip.hidden = true;
    motion.hidden = !ready || failed || reducedMotion.matches;
    if (moveFocus) document.getElementById('username').focus({ preventScroll: true });
  }

  function staticFallback() {
    failed = true;
    ready = false;
    cancelAnimationFrame(frame);
    canvas.classList.remove('is-ready');
    revealForm();
    // A static CSS image is always underneath the optional renderer.
    if (gl && !gl.isContextLost()) {
      textures.forEach((texture) => gl.deleteTexture(texture));
      if (program) gl.deleteProgram(program);
    }
  }

  if (reducedMotion.matches) {
    revealForm();
    return;
  }
  document.body.classList.add('is-diving');
  shell.inert = true;
  skip.hidden = false;
  // Slow/missing assets must never leave the form hidden.
  const loadingDeadline = window.setTimeout(() => {
    if (!ready) { revealForm(); }
  }, 1800);

  const vertexSource = `
    attribute vec2 a_position;
    varying vec2 v_uv;
    void main() {
      v_uv = a_position * 0.5 + 0.5;
      gl_Position = vec4(a_position, 0.0, 1.0);
    }
  `;
  const fragmentSource = `
    precision mediump float;
    varying vec2 v_uv;
    uniform sampler2D u_underwater;
    uniform sampler2D u_surface;
    uniform vec2 u_resolution;
    uniform vec2 u_imageAspect;
    uniform float u_time;
    uniform float u_progress;

    vec2 cover(vec2 uv, float imageAspect) {
      float aspect = u_resolution.x / u_resolution.y;
      vec2 scale = vec2(min(aspect / imageAspect, 1.0), min(imageAspect / aspect, 1.0));
      return (uv - 0.5) * scale + 0.5;
    }
    float hash(float n) { return fract(sin(n * 127.1) * 4375.5453); }
    void main() {
      vec2 uv = vec2(v_uv.x, 1.0 - v_uv.y);
      float t = u_time;
      float p = u_progress;
      float descent = smoothstep(0.28, 1.0, p);
      float wavePhase = t * 0.62;
      float wave = sin(uv.x * 15.0 + wavePhase) * cos(uv.y * 12.0 - wavePhase * 0.7);
      float line = mix(1.2, -0.25, smoothstep(0.18, 0.67, p));
      line += sin(uv.x * 11.0 + t * 2.2) * 0.025 + sin(uv.x * 25.0 - t * 1.3) * 0.008;
      float boundary = exp(-abs(uv.y - line) * 50.0);
      float submerged = smoothstep(line - 0.025, line + 0.025, uv.y);

      vec2 waterUV = cover(uv, u_imageAspect.x);
      float tilt = sin(descent * 3.14159) * 0.025;
      mat2 rotation = mat2(cos(tilt), -sin(tilt), sin(tilt), cos(tilt));
      waterUV = rotation * (waterUV - vec2(0.5, 0.25)) / mix(1.17, 1.025, descent) + vec2(0.5, 0.25);
      float surfaceWeight = 1.0 - smoothstep(0.05, 0.85, waterUV.y);
      vec2 ripple = vec2(
        sin(waterUV.y * 27.0 + wavePhase) + sin(waterUV.x * 36.0 - wavePhase * 0.8) * 0.35,
        cos(waterUV.x * 23.0 + wavePhase * 0.75) + sin(waterUV.y * 35.0 - wavePhase) * 0.3
      ) * (0.0009 + surfaceWeight * 0.0026);
      waterUV += ripple;
      waterUV.y += boundary * 0.045 * wave;
      vec3 underwater = texture2D(u_underwater, clamp(waterUV, 0.002, 0.998)).rgb;

      // Ray position and shimmer share the same phase as the surface refraction.
      vec2 sunVector = waterUV - vec2(0.64 + sin(wavePhase * 0.5) * 0.005, 0.045);
      float angle = atan(sunVector.x, max(sunVector.y, 0.025));
      float shafts = pow(max(0.0, sin(angle * 32.0 + sin(wavePhase) * 0.75)), 12.0);
      shafts += pow(max(0.0, sin(angle * 51.0 - wavePhase * 0.5)), 20.0) * 0.35;
      float rayFalloff = smoothstep(0.04, 0.24, waterUV.y) * (1.0 - smoothstep(0.3, 1.2, length(sunVector)));
      underwater += vec3(0.22, 0.64, 0.8) * shafts * rayFalloff * 0.095;
      underwater *= 1.0 + wave * surfaceWeight * 0.038;

      vec2 aboveUV = cover(uv, u_imageAspect.y);
      aboveUV = (aboveUV - 0.5) / (1.0 + p * 0.1) + 0.5;
      aboveUV.y -= p * 0.05;
      aboveUV += vec2(wave * 0.0015, boundary * wave * 0.055);
      vec3 above = texture2D(u_surface, clamp(aboveUV, 0.002, 0.998)).rgb;
      vec3 color = mix(above, underwater, submerged);
      color = mix(color, color * vec3(0.55, 0.8, 0.92), boundary * 0.45);
      color += vec3(0.32, 0.65, 0.72) * boundary * 0.16;

      float aspect = u_resolution.x / u_resolution.y;
      float burst = smoothstep(0.28, 0.43, p) * (1.0 - smoothstep(0.76, 1.0, p));
      for (int i = 0; i < 20; i++) {
        float seed = float(i) + 1.0;
        float size = mix(0.005, 0.027, hash(seed + 3.0));
        float bx = hash(seed * 2.0) + sin(t * 2.5 + seed) * 0.025;
        float by = 1.3 - fract(hash(seed * 4.0) + p * (0.75 + hash(seed) * 0.8)) * 1.65;
        vec2 offset = (uv - vec2(bx, by)) * vec2(aspect, 1.0);
        float distanceToBubble = length(offset) / size;
        float ring = (1.0 - smoothstep(0.82, 1.0, distanceToBubble)) * smoothstep(0.53, 0.83, distanceToBubble);
        float glint = 1.0 - smoothstep(0.0, 0.3, length(offset / size - vec2(-0.3, -0.4)));
        color += vec3(0.58, 0.8, 0.9) * (ring * 0.28 + glint * 0.5) * burst * submerged;

        // Fine suspended particles persist once the larger entry bubbles pass.
        vec2 particle = vec2(hash(seed * 7.0), fract(hash(seed * 9.0) - t * (0.004 + hash(seed) * 0.004)));
        float dust = 1.0 - smoothstep(0.0003, 0.0016, length((uv - particle) * vec2(aspect, 1.0)));
        color += vec3(0.4, 0.65, 0.75) * dust * 0.17 * submerged;
      }
      gl_FragColor = vec4(color, 1.0);
    }
  `;

  function compile(type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
      const message = gl.getShaderInfoLog(shader);
      gl.deleteShader(shader);
      throw new Error(message);
    }
    return shader;
  }

  function loadImage(source) {
    return new Promise((resolve, reject) => {
      const image = new Image();
      image.onload = () => resolve(image);
      image.onerror = () => reject(new Error('Ocean image could not be loaded.'));
      image.src = source;
    });
  }

  function resize() {
    if (!gl || failed) return;
    const width = canvas.clientWidth;
    const height = canvas.clientHeight;
    // Limit fill rate on large/high-DPI screens; reduce further after sustained slow frames.
    const ratio = Math.min(window.devicePixelRatio || 1, 1.25, Math.sqrt(1400000 / (width * height))) * resolutionScale;
    canvas.width = Math.max(1, Math.round(width * ratio));
    canvas.height = Math.max(1, Math.round(height * ratio));
    gl.viewport(0, 0, canvas.width, canvas.height);
    if (ready) render();
  }

  function render() {
    gl.uniform2f(uniforms.resolution, canvas.width, canvas.height);
    gl.uniform1f(uniforms.time, sceneTime / 1000);
    gl.uniform1f(uniforms.progress, Math.min(introTime / INTRO_MS, 1));
    gl.drawArrays(gl.TRIANGLES, 0, 6);
  }

  function tick(now) {
    if (!ready || failed || paused || document.hidden || reducedMotion.matches) return;
    const delta = previousTime ? now - previousTime : 0;
    previousTime = now;
    sceneTime += Math.min(delta, 80);
    introTime = Math.min(INTRO_MS, introTime + delta);
    if (introTime >= INTRO_MS && !introDone) revealForm();
    render();
    if (introDone && delta > 26) slowFrames++;
    else slowFrames = Math.max(0, slowFrames - 1);
    if (slowFrames > 75 && resolutionScale > 0.55) {
      resolutionScale *= 0.8;
      slowFrames = 0;
      resize();
    }
    frame = requestAnimationFrame(tick);
  }

  function resume() {
    cancelAnimationFrame(frame);
    previousTime = 0;
    if (ready && !failed && !paused && !document.hidden && !reducedMotion.matches) frame = requestAnimationFrame(tick);
  }

  skip.addEventListener('click', () => {
    revealForm(true);
    if (ready) render();
  });
  motion.addEventListener('click', () => {
    paused = !paused;
    motion.setAttribute('aria-pressed', String(paused));
    motion.innerHTML = paused ? 'Reanudar ambiente <span aria-hidden="true">▷</span>' : 'Pausar ambiente <span aria-hidden="true">Ⅱ</span>';
    resume();
  });
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) cancelAnimationFrame(frame);
    else resume();
  });
  window.addEventListener('resize', resize);
  window.addEventListener('pagehide', () => cancelAnimationFrame(frame));
  window.addEventListener('pageshow', (event) => {
    if (event.persisted && ready) {
      if (!reducedMotion.matches) {
        introTime = 0;
        introDone = false;
        paused = false;
        motion.setAttribute('aria-pressed', 'false');
        motion.innerHTML = 'Pausar ambiente <span aria-hidden="true">Ⅱ</span>';
        motion.hidden = true;
        skip.hidden = false;
        shell.inert = true;
        document.body.classList.add('is-diving');
      }
      resume();
    }
  });
  reducedMotion.addEventListener('change', () => {
    if (reducedMotion.matches) {
      cancelAnimationFrame(frame);
      canvas.classList.remove('is-ready');
      revealForm();
    } else if (ready && !failed) {
      canvas.classList.add('is-ready');
      motion.hidden = false;
      resume();
    }
  });
  canvas.addEventListener('webglcontextlost', (event) => {
    event.preventDefault();
    staticFallback();
  });

  async function initialize() {
    try {
      gl = canvas.getContext('webgl', { alpha: false, antialias: false, depth: false, stencil: false, powerPreference: 'low-power' });
      if (!gl) { staticFallback(); return; }
      const vertex = compile(gl.VERTEX_SHADER, vertexSource);
      const fragment = compile(gl.FRAGMENT_SHADER, fragmentSource);
      program = gl.createProgram();
      gl.attachShader(program, vertex);
      gl.attachShader(program, fragment);
      gl.linkProgram(program);
      gl.deleteShader(vertex);
      gl.deleteShader(fragment);
      if (!gl.getProgramParameter(program, gl.LINK_STATUS)) throw new Error(gl.getProgramInfoLog(program));
      gl.useProgram(program);
      const buffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1]), gl.STATIC_DRAW);
      const position = gl.getAttribLocation(program, 'a_position');
      gl.enableVertexAttribArray(position);
      gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0);
      uniforms = {
        resolution: gl.getUniformLocation(program, 'u_resolution'),
        time: gl.getUniformLocation(program, 'u_time'),
        progress: gl.getUniformLocation(program, 'u_progress')
      };
      const images = await Promise.all([loadImage(canvas.dataset.underwater), loadImage(canvas.dataset.surface)]);
      if (failed) return;
      images.forEach((image, index) => {
        const texture = gl.createTexture();
        textures.push(texture);
        gl.activeTexture(gl.TEXTURE0 + index);
        gl.bindTexture(gl.TEXTURE_2D, texture);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGB, gl.RGB, gl.UNSIGNED_BYTE, image);
        gl.uniform1i(gl.getUniformLocation(program, index ? 'u_surface' : 'u_underwater'), index);
      });
      gl.uniform2f(gl.getUniformLocation(program, 'u_imageAspect'), images[0].width / images[0].height, images[1].width / images[1].height);
      ready = true;
      clearTimeout(loadingDeadline);
      resize();
      if (!reducedMotion.matches) canvas.classList.add('is-ready');
      if (introDone) revealForm();
      resume();
    } catch (error) {
      console.warn('WaveWires: using the static ocean background.', error);
      staticFallback();
    }
  }
  initialize();
})();
