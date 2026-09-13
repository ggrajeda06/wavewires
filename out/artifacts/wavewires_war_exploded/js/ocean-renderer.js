import * as THREE from '../vendor/three/three.module.min.js';
import { INTRO_SECONDS, IMPACT_SECONDS, FINAL_PITCH, getCameraPose } from './ocean-motion.js';

export { INTRO_SECONDS } from './ocean-motion.js';

const fullscreenVertex = `
  varying vec2 vUv;
  void main() { vUv = uv; gl_Position = vec4(position.xy, 0.0, 1.0); }
`;

const waterVertex = `
  uniform float uTime;
  varying vec3 vWorld;
  varying vec2 vSlope;
  float waves(vec2 p) {
    vec2 a = vec2(0.34, 0.17);
    vec2 b = vec2(-0.21, 0.56);
    vec2 c = vec2(0.82, 0.43);
    float wa = dot(p, a) - uTime * 0.78;
    float wb = dot(p, b) - uTime * 1.04;
    float wc = dot(p, c) - uTime * 1.36;
    vSlope = a * cos(wa) * 0.17 + b * cos(wb) * 0.085 + c * cos(wc) * 0.035;
    return sin(wa) * 0.17 + sin(wb) * 0.085 + sin(wc) * 0.035;
  }
  void main() {
    vec3 p = position;
    p.y += waves(p.xz);
    vWorld = (modelMatrix * vec4(p, 1.0)).xyz;
    gl_Position = projectionMatrix * viewMatrix * vec4(vWorld, 1.0);
  }
`;

const waterFragment = `
  uniform float uTime;
  uniform float uUnder;
  uniform float uFade;
  uniform vec3 uSun;
  uniform sampler2D uNormals;
  varying vec3 vWorld;
  varying vec2 vSlope;
  void main() {
    vec2 p = vWorld.xz;
    // Tiled, filtered noise at unrelated scales avoids repeating sine-wave stripes.
    vec2 broad = texture2D(uNormals, p * 0.037 + vec2(uTime * 0.013, -uTime * 0.007)).rg * 2.0 - 1.0;
    vec2 medium = texture2D(uNormals, p.yx * 0.091 + broad * 0.055 + vec2(-uTime * 0.019, uTime * 0.009)).rg * 2.0 - 1.0;
    vec2 fine = texture2D(uNormals, p * 0.23 + vec2(uTime * 0.022)).rg * 2.0 - 1.0;
    float distanceToEye = length(cameraPosition - vWorld);
    // Match the displaced wave geometry, with smaller ripples fading into the horizon.
    vec2 slope = -vSlope + broad * 0.24 + (medium * 0.12 + fine * 0.045) * exp(-distanceToEye * 0.045);
    vec3 n = normalize(vec3(slope.x, 1.0, slope.y));
    vec3 view = normalize(cameraPosition - vWorld);
    float fresnel = 0.025 + 0.975 * pow(1.0 - abs(dot(n, view)), 5.0);
    vec3 reflected = reflect(-view, n);
    vec3 sky = mix(vec3(0.68, 0.8, 0.85), vec3(0.17, 0.42, 0.65), pow(max(reflected.y, 0.0), 0.55));
    float sparkle = pow(max(dot(reflected, uSun), 0.0), 120.0);
    float broadSun = pow(max(dot(reflected, uSun), 0.0), 20.0);
    vec3 deep = vec3(0.008, 0.12, 0.2) + vec3(0.015, 0.065, 0.08) * (n.x + n.z + 1.0);
    vec3 above = mix(deep, sky, fresnel) + vec3(1.0, 0.96, 0.85) * sparkle * 0.65 + broadSun * 0.055;
    float distanceFade = 1.0 - exp(-distanceToEye * 0.009);
    above = mix(above, vec3(0.68, 0.8, 0.85), distanceFade * 0.55);
    float transmission = pow(max(dot(normalize(vWorld - cameraPosition), uSun), 0.0), 22.0);
    vec3 below = vec3(0.025, 0.24, 0.35) + vec3(0.3, 0.6, 0.7) * transmission;
    below += pow(max(0.0, n.x * n.z * 4.0 + 0.15), 3.0) * vec3(0.12, 0.32, 0.39);
    // Underwater absorption hides the finite mesh edge and the distant horizon.
    float underwaterAlpha = 0.24 * exp(-distanceToEye * 0.16);
    gl_FragColor = vec4(mix(above, below, uUnder), mix(1.0, underwaterAlpha, uUnder) * uFade);
  }
`;

const compositeFragment = `
  varying vec2 vUv;
  uniform sampler2D uScene;
  uniform sampler2D uPhoto;
  uniform vec2 uResolution;
  uniform float uImageAspect;
  uniform float uTime;
  uniform float uImpact;
  uniform float uCameraY;
  uniform float uTanFov;
  uniform float uFinalBlend;
  uniform mat3 uCameraRotation;
  uniform mat3 uReferenceInverse;
  float hash(float n) { return fract(sin(n * 127.1) * 4375.5453); }
  vec2 cover(vec2 uv) {
    float aspect = uResolution.x / uResolution.y;
    return (uv - 0.5) * vec2(min(aspect / uImageAspect, 1.0), min(uImageAspect / aspect, 1.0)) + 0.5;
  }
  void main() {
    vec2 uv = vec2(vUv.x, 1.0 - vUv.y);
    float aspect = uResolution.x / uResolution.y;
    float phase = uTime * 0.62;
    vec2 agitation = vec2(sin(uv.y * 39.0 + uTime * 16.0), cos(uv.x * 32.0 - uTime * 12.0));
    vec2 sceneUV = vUv + agitation * uImpact * 0.012;
    vec4 world = texture2D(uScene, clamp(sceneUV, 0.002, 0.998));
    vec3 ray = normalize(uCameraRotation * vec3((uv.x * 2.0 - 1.0) * aspect * uTanFov, (1.0 - uv.y * 2.0) * uTanFov, -1.0));
    vec3 localRay = uReferenceInverse * ray;
    float refFov = 0.554309; // tan(58 degrees / 2)
    float forward = max(-localRay.z, 0.025);
    vec2 projected = vec2(0.5 + localRay.x / (2.0 * forward * refFov * aspect), 0.5 - localRay.y / (2.0 * forward * refFov));
    projected = mix(projected, uv, uFinalBlend);
    vec2 waterUV = cover(projected);
    waterUV = (waterUV - vec2(0.5, 0.25)) / 1.025 + vec2(0.5, 0.25);
    float edge = smoothstep(-0.25, 0.1, waterUV.x) * (1.0 - smoothstep(0.9, 1.25, waterUV.x));
    edge *= smoothstep(-0.25, 0.02, waterUV.y) * (1.0 - smoothstep(0.98, 1.25, waterUV.y));
    edge *= smoothstep(0.05, 0.45, -localRay.z);
    edge = mix(edge, 1.0, uFinalBlend);
    float surfaceWeight = 1.0 - smoothstep(0.05, 0.85, waterUV.y);
    vec2 ripple = vec2(sin(waterUV.y * 27.0 + phase) + sin(waterUV.x * 36.0 - phase * 0.8) * 0.35,
      cos(waterUV.x * 23.0 + phase * 0.75) + sin(waterUV.y * 35.0 - phase) * 0.3) * (0.0009 + surfaceWeight * 0.0026);
    waterUV += ripple + agitation * uImpact * 0.008;
    vec3 underwater = texture2D(uPhoto, clamp(waterUV, 0.002, 0.998)).rgb;
    vec2 sunVector = waterUV - vec2(0.64 + sin(phase * 0.5) * 0.005, 0.045);
    float angle = atan(sunVector.x, max(sunVector.y, 0.025));
    float shafts = pow(max(0.0, sin(angle * 32.0 + sin(phase) * 0.75)), 12.0)
      + pow(max(0.0, sin(angle * 51.0 - phase * 0.5)), 20.0) * 0.35;
    float rayFalloff = smoothstep(0.04, 0.24, waterUV.y) * (1.0 - smoothstep(0.3, 1.2, length(sunVector)));
    underwater += vec3(0.22, 0.64, 0.8) * shafts * rayFalloff * 0.095;
    float wave = sin(uv.x * 15.0 + phase) * cos(uv.y * 12.0 - phase * 0.7);
    underwater *= 1.0 + wave * surfaceWeight * 0.038;
    underwater = mix(vec3(0.007, 0.072, 0.13), underwater, edge);
    for (int i = 0; i < 20; i++) {
      float seed = float(i) + 1.0;
      vec2 particle = vec2(hash(seed * 7.0), fract(hash(seed * 9.0) - uTime * (0.004 + hash(seed) * 0.004)));
      float dust = 1.0 - smoothstep(0.0003, 0.0016, length((uv - particle) * vec2(aspect, 1.0)));
      underwater += vec3(0.4, 0.65, 0.75) * dust * 0.17;
    }
    // The waterline follows the near plane of the moving camera, not a screen wipe.
    float nearHeight = uCameraY + ray.y * 0.15 + wave * 0.017;
    float immersion = smoothstep(-0.06, 0.06, -nearHeight);
    vec3 submerged = underwater * (1.0 - world.a) + world.rgb;
    vec3 color = mix(world.rgb, submerged, immersion);
    color = mix(color, underwater, uFinalBlend);
    float veil = uImpact * (0.06 + 0.06 * sin(uv.x * 16.0 + uv.y * 24.0 + uTime * 15.0));
    color = mix(color, vec3(0.25, 0.59, 0.68), veil);
    gl_FragColor = vec4(color, 1.0);
  }
`;

function createWaterNormals() {
  const size = 256;
  const heights = new Float32Array(size * size);
  const data = new Uint8Array(size * size * 4);
  const random = (x, y) => {
    let n = Math.imul(x + 17, 374761393) ^ Math.imul(y + 31, 668265263);
    n = Math.imul(n ^ (n >>> 13), 1274126177);
    return ((n ^ (n >>> 16)) >>> 0) / 4294967295;
  };
  const mix = (a, b, t) => a + (b - a) * t;
  // Periodic value noise gives seamless mipmaps without an external texture asset.
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      let height = 0;
      for (let octave = 0; octave < 5; octave++) {
        const period = 4 << octave;
        const px = x * period / size;
        const py = y * period / size;
        const ix = Math.floor(px);
        const iy = Math.floor(py);
        const fx = px - ix;
        const fy = py - iy;
        const sx = fx * fx * (3 - 2 * fx);
        const sy = fy * fy * (3 - 2 * fy);
        height += mix(mix(random(ix, iy), random((ix + 1) % period, iy), sx),
          mix(random(ix, (iy + 1) % period), random((ix + 1) % period, (iy + 1) % period), sx), sy) * 0.5 ** octave;
      }
      heights[y * size + x] = height;
    }
  }
  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const dx = (heights[y * size + (x + 1) % size] - heights[y * size + (x + size - 1) % size]) * 18;
      const dz = (heights[((y + 1) % size) * size + x] - heights[((y + size - 1) % size) * size + x]) * 18;
      const length = Math.hypot(dx, 1, dz);
      const index = (y * size + x) * 4;
      data[index] = Math.round((dx / length * 0.5 + 0.5) * 255);
      data[index + 1] = Math.round((dz / length * 0.5 + 0.5) * 255);
      data[index + 2] = 255;
      data[index + 3] = 255;
    }
  }
  const texture = new THREE.DataTexture(data, size, size);
  texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
  texture.magFilter = THREE.LinearFilter;
  texture.minFilter = THREE.LinearMipmapLinearFilter;
  texture.generateMipmaps = true;
  texture.needsUpdate = true;
  return texture;
}

function createBubbles() {
  const count = 120;
  const base = new THREE.PlaneGeometry(1, 1);
  const geometry = new THREE.InstancedBufferGeometry();
  geometry.index = base.index;
  geometry.attributes = { ...base.attributes };
  geometry.instanceCount = count;
  const origins = new Float32Array(count * 3);
  const sizes = new Float32Array(count);
  const speeds = new Float32Array(count);
  const random = n => { const x = Math.sin(n * 127.1) * 43758.5453; return x - Math.floor(x); };
  for (let i = 0; i < count; i++) {
    origins.set([(random(i + 1) - 0.5) * 7, -7 + random(i + 10) * 8, -0.7 - random(i + 20) * 5], i * 3);
    sizes[i] = 0.025 + random(i + 30) ** 3 * 0.24;
    speeds[i] = 0.4 + random(i + 40) * 0.9;
  }
  geometry.setAttribute('aOrigin', new THREE.InstancedBufferAttribute(origins, 3));
  geometry.setAttribute('aSize', new THREE.InstancedBufferAttribute(sizes, 1));
  geometry.setAttribute('aSpeed', new THREE.InstancedBufferAttribute(speeds, 1));
  const material = new THREE.ShaderMaterial({
    transparent: true, depthWrite: false, toneMapped: false,
    uniforms: { uAfterImpact: { value: 0 }, uOpacity: { value: 0 } },
    vertexShader: `
      attribute vec3 aOrigin;
      attribute float aSize;
      attribute float aSpeed;
      uniform float uAfterImpact;
      varying vec2 vUv;
      void main() {
        vUv = uv;
        vec3 center = aOrigin;
        center.y += uAfterImpact * aSpeed;
        center.x += sin(uAfterImpact * 2.5 + aOrigin.y) * 0.12;
        vec4 viewCenter = modelViewMatrix * vec4(center, 1.0);
        viewCenter.xy += position.xy * aSize;
        gl_Position = projectionMatrix * viewCenter;
      }
    `,
    fragmentShader: `
      varying vec2 vUv;
      uniform float uOpacity;
      void main() {
        vec2 p = vUv * 2.0 - 1.0;
        float r = length(p);
        if (r > 1.0) discard;
        float rim = smoothstep(0.6, 0.88, r) * (1.0 - smoothstep(0.88, 1.0, r));
        float glint = exp(-length(p - vec2(-0.32, 0.4)) * 16.0);
        float alpha = (rim * 0.45 + glint * 0.8 + 0.015) * uOpacity;
        gl_FragColor = vec4(mix(vec3(0.35, 0.7, 0.8), vec3(0.94, 1.0, 1.0), glint + rim * 0.4), alpha);
      }
    `
  });
  const mesh = new THREE.Mesh(geometry, material);
  mesh.frustumCulled = false;
  mesh.renderOrder = 2;
  return mesh;
}

export async function createOceanRenderer(canvas) {
  const renderer = new THREE.WebGLRenderer({ canvas, alpha: false, antialias: false, powerPreference: 'low-power' });
  renderer.setClearColor(0x000000, 0);
  renderer.toneMapping = THREE.NoToneMapping;
  const resources = [];
  let disposed = false;
  let shaderError = false;
  renderer.debug.onShaderError = () => { shaderError = true; };
  let photo;
  try {
    photo = await new THREE.TextureLoader().loadAsync(canvas.dataset.underwater);
  } catch (error) {
    renderer.dispose();
    throw error;
  }
  photo.colorSpace = THREE.NoColorSpace;
  photo.flipY = false;
  photo.minFilter = THREE.LinearFilter;
  photo.generateMipmaps = false;
  resources.push(photo);
  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(58, 1, 0.025, 350);
  const reference = new THREE.Quaternion().setFromEuler(new THREE.Euler(FINAL_PITCH, 0, 0, 'YXZ'));
  const referenceInverse = new THREE.Matrix3().setFromMatrix4(new THREE.Matrix4().makeRotationFromQuaternion(reference.clone().invert()));
  const sun = new THREE.Vector3(0.28, 0.50, -1).applyQuaternion(reference).normalize();

  const sky = new THREE.Mesh(new THREE.SphereGeometry(200, 24, 16), new THREE.ShaderMaterial({
    side: THREE.BackSide, depthWrite: false, toneMapped: false,
    uniforms: { uSun: { value: sun } },
    vertexShader: `varying vec3 vDirection; void main() { vDirection = position; gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0); }`,
    fragmentShader: `
      varying vec3 vDirection;
      uniform vec3 uSun;
      void main() {
        vec3 d = normalize(vDirection);
        vec3 color = mix(vec3(0.68, 0.8, 0.85), vec3(0.17, 0.42, 0.65), pow(max(d.y, 0.0), 0.55));
        float sun = max(dot(d, uSun), 0.0);
        color += vec3(1.0, 0.93, 0.8) * (pow(sun, 500.0) * 1.2 + pow(sun, 16.0) * 0.14);
        gl_FragColor = vec4(color, 1.0);
      }
    `
  }));
  scene.add(sky);
  const normals = createWaterNormals();
  resources.push(normals);
  const waterUniforms = { uTime: { value: 0 }, uUnder: { value: 0 }, uFade: { value: 1 }, uSun: { value: sun }, uNormals: { value: normals } };
  const water = new THREE.Mesh(new THREE.PlaneGeometry(260, 260, 180, 180).rotateX(-Math.PI / 2), new THREE.ShaderMaterial({
    uniforms: waterUniforms, vertexShader: waterVertex, fragmentShader: waterFragment,
    side: THREE.DoubleSide, transparent: true, depthWrite: false, toneMapped: false
  }));
  scene.add(water);
  const bubbles = createBubbles();
  scene.add(bubbles);
  const target = new THREE.WebGLRenderTarget(1, 1, { depthBuffer: true, stencilBuffer: false });
  const compositeUniforms = {
    uScene: { value: target.texture }, uPhoto: { value: photo },
    uResolution: { value: new THREE.Vector2(1, 1) }, uImageAspect: { value: photo.image.width / photo.image.height },
    uTime: { value: 0 }, uImpact: { value: 0 }, uCameraY: { value: 0 },
    uTanFov: { value: 0.554309 }, uFinalBlend: { value: 0 },
    uCameraRotation: { value: new THREE.Matrix3() }, uReferenceInverse: { value: referenceInverse }
  };
  const composite = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), new THREE.ShaderMaterial({
    uniforms: compositeUniforms, vertexShader: fullscreenVertex, fragmentShader: compositeFragment,
    depthTest: false, depthWrite: false, toneMapped: false
  }));
  const postScene = new THREE.Scene();
  const postCamera = new THREE.Camera();
  postScene.add(composite);
  resources.push(target, sky.geometry, sky.material, water.geometry, water.material, bubbles.geometry, bubbles.material, composite.geometry, composite.material);

  function draw(introSeconds, ambientSeconds) {
    if (disposed) return;
    const pose = getCameraPose(introSeconds);
    camera.position.set(pose.x, pose.y, pose.z);
    camera.rotation.set(pose.pitch, pose.yaw, pose.roll, 'YXZ');
    camera.fov = pose.fov;
    camera.updateProjectionMatrix();
    camera.updateMatrixWorld();
    waterUniforms.uTime.value = ambientSeconds;
    waterUniforms.uUnder.value = THREE.MathUtils.smoothstep(-pose.y, -0.12, 0.12);
    waterUniforms.uFade.value = 1 - pose.finalBlend;
    bubbles.material.uniforms.uAfterImpact.value = Math.max(0, introSeconds - IMPACT_SECONDS);
    bubbles.material.uniforms.uOpacity.value = pose.particles;
    sky.visible = pose.y > -0.08;
    bubbles.visible = pose.particles > 0;
    // Once settled, only the original ambient shader is rendered.
    if (introSeconds < INTRO_SECONDS) {
      renderer.setRenderTarget(target);
      renderer.render(scene, camera);
    }
    compositeUniforms.uTime.value = ambientSeconds;
    compositeUniforms.uImpact.value = pose.impact;
    compositeUniforms.uCameraY.value = pose.y;
    compositeUniforms.uTanFov.value = Math.tan(THREE.MathUtils.degToRad(pose.fov / 2));
    compositeUniforms.uFinalBlend.value = pose.finalBlend;
    compositeUniforms.uCameraRotation.value.setFromMatrix4(camera.matrixWorld);
    renderer.setRenderTarget(null);
    renderer.render(postScene, postCamera);
    if (shaderError) throw new Error('Ocean shader compilation failed.');
  }

  return {
    draw,
    resize(width, height, scale = 1) {
      if (disposed) return;
      const ratio = Math.min(window.devicePixelRatio || 1, 1.25, Math.sqrt(1400000 / Math.max(1, width * height))) * scale;
      const w = Math.max(1, Math.round(width * ratio));
      const h = Math.max(1, Math.round(height * ratio));
      renderer.setPixelRatio(1);
      renderer.setSize(w, h, false);
      target.setSize(w, h);
      compositeUniforms.uResolution.value.set(w, h);
      camera.aspect = width / Math.max(1, height);
      camera.updateProjectionMatrix();
    },
    dispose() {
      if (disposed) return;
      disposed = true;
      resources.forEach(resource => resource.dispose());
      renderer.dispose();
    }
  };
}
