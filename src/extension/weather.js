(() => {
  "use strict";

  const layerId = "claude-styled-ambient-weather";
  const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
  let layer = null;

  const random = () => {
    if (globalThis.crypto?.getRandomValues) {
      const value = new Uint32Array(1);
      globalThis.crypto.getRandomValues(value);
      return value[0] / 4294967296;
    }
    return Math.random();
  };

  const between = (minimum, maximum) =>
    minimum + random() * (maximum - minimum);

  const setVariable = (element, name, value) => {
    element.style.setProperty(name, value);
  };

  const makeParticle = (weather) => {
    const particle = document.createElement("span");
    const drift = between(-9, 9);
    const duration =
      weather === "rain" ? between(1.15, 1.9) : between(9, 17);

    setVariable(particle, "--weather-x", `${between(0, 100).toFixed(2)}%`);
    setVariable(particle, "--weather-drift", `${drift.toFixed(2)}vw`);
    setVariable(
      particle,
      "--weather-mid-drift",
      `${(drift * 0.42 + between(-2.2, 2.2)).toFixed(2)}vw`,
    );
    setVariable(particle, "--weather-duration", `${duration.toFixed(2)}s`);
    setVariable(particle, "--weather-delay", `${(-random() * duration).toFixed(2)}s`);
    setVariable(
      particle,
      "--weather-opacity",
      weather === "rain"
        ? between(0.26, 0.5).toFixed(2)
        : between(0.32, 0.56).toFixed(2),
    );
    setVariable(particle, "--weather-length", `${between(22, 42).toFixed(1)}px`);
    setVariable(particle, "--weather-size", `${between(4, 9).toFixed(1)}px`);

    return particle;
  };

  const unmount = () => {
    layer?.remove();
    layer = null;
  };

  const mount = () => {
    unmount();
    if (reducedMotion.matches || document.getElementById(layerId)) {
      return;
    }

    const weather = random() < 0.5 ? "rain" : "snow";
    const particleCount = weather === "rain" ? 42 : 32;
    const fragment = document.createDocumentFragment();

    layer = document.createElement("div");
    layer.id = layerId;
    layer.dataset.weather = weather;
    layer.setAttribute("aria-hidden", "true");

    for (let index = 0; index < particleCount; index += 1) {
      fragment.append(makeParticle(weather));
    }

    layer.append(fragment);
    document.documentElement.append(layer);
  };

  mount();
  reducedMotion.addEventListener("change", mount);
})();
