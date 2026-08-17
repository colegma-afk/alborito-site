# Alborito — sitio estático (MVP público)

Sitio 100% estático (HTML/CSS/JS, sin build ni dependencias) listo para subir a cualquier hosting estático: Netlify, Vercel, GitHub Pages, Cloudflare Pages o un servidor propio con Nginx/Apache.

## Contenido
- `index.html` — Home (hero, aventuras, especiales con modal de video, recursos).
- `explorar.html` — catálogo con filtros (edad, asignatura, formato).
- `recursos.html` — recursos para niños, familias y docentes.
- `precios.html` — planes Gratuito / Familiar / Docente / Colegio.
- `accesibilidad.html` — panel DUA (alto contraste, texto grande), persistente en `localStorage`.
- `privacidad.html`, `terminos.html` — placeholders legales, **reemplazar antes de producción**.
- `assets/css/style.css` — design system (tokens de color, tipografía, espaciado, componentes).
- `assets/js/main.js` — menú móvil, modal de video accesible, toggles de accesibilidad.
- `robots.txt`, `sitemap.xml` — SEO técnico.

## Antes de subir a producción
1. **Reemplaza `https://alborito.example.com`** por tu dominio real en: `index.html`, `explorar.html`, `recursos.html`, `precios.html`, `accesibilidad.html`, `robots.txt`, `sitemap.xml`.
2. Sube el video real a `assets/video/` (o a un CDN/streaming) y actualiza los `data-video` en `index.html` — ahora apuntan a un placeholder.
3. Sube `Flipbooks_Alborito_Coleccion_Ordenada.zip` a `flipbooks/` (referenciado desde Home y Recursos).
4. Reemplaza `privacidad.html` y `terminos.html` por texto legal revisado.
5. Agrega `assets/img/og-cover.png` (1200×630) para que el link se vea bien al compartir.
6. Revisa el precio de los planes en `precios.html`.

## Deploy rápido

**Netlify / Vercel (arrastrar y soltar):**
Arrastra la carpeta `alborito-site/` completa al panel de deploy — no requiere configuración, es HTML estático puro.

**Netlify CLI:**
```bash
cd alborito-site
netlify deploy --prod
```

**GitHub Pages:**
```bash
cd alborito-site
git init && git add . && git commit -m "Alborito site"
git branch -M main
git remote add origin <tu-repo>
git push -u origin main
# Activar Pages en Settings → Pages → branch main → carpeta /
```

**Servidor propio (Nginx):** apunta `root` a esta carpeta; no requiere PHP/Node, solo servir archivos estáticos.

## Siguiente fase (no incluida en este MVP estático)
Auth, perfiles de niño/familia/docente, progreso, CMS y backend requieren la arquitectura completa (Next.js + NestJS + PostgreSQL) descrita en el documento de arquitectura EdTech — este sitio cubre las páginas **públicas** del roadmap MVP.
