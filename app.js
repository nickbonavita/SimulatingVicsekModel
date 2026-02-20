const presets = {
  A: { L: 7, r: 1, noise: 2, nP: 300, vel: 0.03, tI: 500 },
  B: { L: 25, r: 1, noise: 0.1, nP: 300, vel: 0.03, tI: 500 },
  C: { L: 7, r: 1, noise: 2, nP: 300, vel: 0.03, tI: 750 },
  D: { L: 5, r: 1, noise: 0.1, nP: 300, vel: 0.03, tI: 500 },
};

const els = {
  preset: document.getElementById("preset"),
  L: document.getElementById("L"),
  r: document.getElementById("r"),
  noise: document.getElementById("noise"),
  nP: document.getElementById("nP"),
  vel: document.getElementById("vel"),
  tI: document.getElementById("tI"),
  apply: document.getElementById("apply"),
  toggle: document.getElementById("toggle"),
  status: document.getElementById("status"),
  canvas: document.getElementById("simCanvas"),
};

const ctx = els.canvas.getContext("2d");
const sizePx = 760;

let sim = null;
let running = true;

function wrap(value, max) {
  if (value < 0) return value + max;
  if (value >= max) return value - max;
  return value;
}

function initFromConfig(config) {
  sim = {
    ...config,
    step: 0,
    x: new Float64Array(config.nP),
    y: new Float64Array(config.nP),
    theta: new Float64Array(config.nP),
    nextTheta: new Float64Array(config.nP),
  };

  for (let i = 0; i < sim.nP; i += 1) {
    sim.x[i] = Math.random() * sim.L;
    sim.y[i] = Math.random() * sim.L;
    sim.theta[i] = (Math.random() - 0.5) * 2 * Math.PI;
  }
}

function domainDistance(dx, L) {
  if (dx > L / 2) return dx - L;
  if (dx < -L / 2) return dx + L;
  return dx;
}

function updateSimulation() {
  if (!sim || sim.step >= sim.tI) return;

  const { nP, x, y, theta, nextTheta, L, r, vel, noise } = sim;
  const rSq = r * r;

  for (let i = 0; i < nP; i += 1) {
    let sinSum = 0;
    let cosSum = 0;
    let count = 0;

    for (let j = 0; j < nP; j += 1) {
      const dx = domainDistance(x[j] - x[i], L);
      const dy = domainDistance(y[j] - y[i], L);
      if (dx * dx + dy * dy < rSq) {
        sinSum += Math.sin(theta[j]);
        cosSum += Math.cos(theta[j]);
        count += 1;
      }
    }

    const baseAngle = count > 0 ? Math.atan2(sinSum / count, cosSum / count) : theta[i];
    nextTheta[i] = baseAngle + noise * (Math.random() - 0.5);
  }

  for (let i = 0; i < nP; i += 1) {
    theta[i] = nextTheta[i];
    x[i] = wrap(x[i] + vel * Math.cos(theta[i]), L);
    y[i] = wrap(y[i] + vel * Math.sin(theta[i]), L);
  }

  sim.step += 1;
}

function drawSimulation() {
  if (!sim) return;
  const { x, y, theta, nP, L, step, tI } = sim;

  ctx.clearRect(0, 0, sizePx, sizePx);
  ctx.fillStyle = "#0b0d12";
  ctx.fillRect(0, 0, sizePx, sizePx);

  ctx.strokeStyle = "#73a3ff";
  ctx.lineWidth = 1;

  const arrow = Math.max(2, sizePx / (L * 4));
  for (let i = 0; i < nP; i += 1) {
    const px = (x[i] / L) * sizePx;
    const py = (y[i] / L) * sizePx;
    const dx = Math.cos(theta[i]) * arrow;
    const dy = Math.sin(theta[i]) * arrow;

    ctx.beginPath();
    ctx.moveTo(px, py);
    ctx.lineTo(px + dx, py + dy);
    ctx.stroke();
  }

  els.status.textContent = running
    ? `Running • step ${step}/${tI}`
    : `Paused • step ${step}/${tI}`;
}

function readConfigFromInputs() {
  return {
    L: Number(els.L.value),
    r: Number(els.r.value),
    noise: Number(els.noise.value),
    nP: Number(els.nP.value),
    vel: Number(els.vel.value),
    tI: Number(els.tI.value),
  };
}

function setInputs(config) {
  els.L.value = config.L;
  els.r.value = config.r;
  els.noise.value = config.noise;
  els.nP.value = config.nP;
  els.vel.value = config.vel;
  els.tI.value = config.tI;
}

function loop() {
  if (running && sim && sim.step < sim.tI) {
    updateSimulation();
  }
  drawSimulation();
  requestAnimationFrame(loop);
}

els.preset.addEventListener("change", () => {
  const p = els.preset.value;
  if (p !== "CUSTOM") {
    setInputs(presets[p]);
    initFromConfig(presets[p]);
  }
});

els.apply.addEventListener("click", () => {
  const config = readConfigFromInputs();
  initFromConfig(config);
  running = true;
  els.toggle.textContent = "Pause";
});

els.toggle.addEventListener("click", () => {
  running = !running;
  els.toggle.textContent = running ? "Pause" : "Resume";
});

setInputs(presets.A);
initFromConfig(presets.A);
loop();