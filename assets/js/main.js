// Alborito — comportamiento base del sitio
(function(){
  "use strict";

  // Menú móvil
  var header = document.querySelector(".site-header");
  var toggle = document.querySelector(".nav-toggle");
  if (toggle && header) {
    toggle.addEventListener("click", function () {
      var open = header.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
  }

  // Modal de video (cuentos animados / especiales)
  var modal = document.querySelector("#modal");
  if (modal) {
    var player = modal.querySelector("#player");
    var title = modal.querySelector("#modalTitle");
    var closeBtn = modal.querySelector(".close");
    var lastFocused = null;

    function openModal(btn) {
      lastFocused = document.activeElement;
      title.textContent = btn.dataset.title || "";
      player.src = btn.dataset.video || "";
      modal.classList.add("open");
      modal.removeAttribute("hidden");
      closeBtn.focus();
      player.play && player.play().catch(function () {});
      document.addEventListener("keydown", onKeydown);
    }
    function closeModal() {
      modal.classList.remove("open");
      modal.setAttribute("hidden", "");
      player.pause && player.pause();
      player.removeAttribute("src");
      document.removeEventListener("keydown", onKeydown);
      if (lastFocused) lastFocused.focus();
    }
    function onKeydown(e) {
      if (e.key === "Escape") closeModal();
    }

    document.querySelectorAll(".watch").forEach(function (b) {
      b.addEventListener("click", function () { openModal(b); });
    });
    closeBtn && closeBtn.addEventListener("click", closeModal);
    modal.addEventListener("click", function (e) {
      if (e.target === modal) closeModal();
    });
  }

  // Panel de accesibilidad: preferencias persistentes
  var contrastBtn = document.querySelector("[data-toggle='contrast']");
  var textBtn = document.querySelector("[data-toggle='text-lg']");

  function applyPref(key, className, btn) {
    var on = localStorage.getItem(key) === "1";
    document.body.classList.toggle(className, on);
    if (btn) btn.setAttribute("aria-pressed", on ? "true" : "false");
  }
  applyPref("alborito-contrast", "contrast-high", contrastBtn);
  applyPref("alborito-text-lg", "text-lg", textBtn);

  function wireToggle(btn, key, className) {
    if (!btn) return;
    btn.addEventListener("click", function () {
      var next = !document.body.classList.contains(className);
      document.body.classList.toggle(className, next);
      btn.setAttribute("aria-pressed", next ? "true" : "false");
      localStorage.setItem(key, next ? "1" : "0");
    });
  }
  wireToggle(contrastBtn, "alborito-contrast", "contrast-high");
  wireToggle(textBtn, "alborito-text-lg", "text-lg");

  // Marca el link de navegación activo
  var here = location.pathname.replace(/index\.html$/, "");
  document.querySelectorAll(".navlinks a").forEach(function (a) {
    var href = a.getAttribute("href").replace(/index\.html$/, "");
    if (href === here || (href === "/" && here === "")) {
      a.setAttribute("aria-current", "page");
    }
  });
})();
