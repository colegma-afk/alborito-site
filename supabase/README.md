# Conectar Alborito a Supabase (gratis)

No puedo crear la cuenta por ti — son 2 minutos:

1. Ve a **https://supabase.com** → "Start your project" → inicia sesión con GitHub (misma cuenta `colegma-afk`, sin contraseña nueva que recordar).
2. "New project" → nombre `alborito` → elige una región cercana (ej. `South America (São Paulo)`) → genera y **guarda tú mismo** la contraseña de la base de datos (yo no debo verla ni guardarla).
3. Cuando el proyecto esté listo: ve a **SQL Editor → New query**, pega el contenido de [`schema.sql`](./schema.sql) y dale **Run**. Esto crea todas las tablas (usuarios, estudiantes, colegios, contenidos, progreso, insignias) con seguridad a nivel de fila (RLS) ya activada.
4. Ve a **Project Settings → API** y copia:
   - `Project URL`
   - `anon public` key
5. Pégame esos dos valores (o guárdalos en un `.env` — nunca los subas al repositorio de GitHub) y conecto el frontend.

## Por qué este esquema
Sigue las entidades mínimas de la arquitectura EdTech: `users` (roles vía enum), `students` (perfiles infantiles administrados por un adulto), `contents` (CMS con metadata pedagógica: edad, asignatura, habilidad), `progress`/`badges`/`favorites` (gamificación) y `audit_log`. Las políticas RLS aseguran que una familia solo pueda ver el progreso de sus propios hijos — coherente con la sección de seguridad infantil del documento de arquitectura.

## Siguiente paso (no incluido aún)
Conectar el sitio estático a Supabase requiere JS de cliente (`@supabase/supabase-js` vía CDN) para login y lectura de datos — lo agrego en cuanto tengas el proyecto creado y me pases la URL/API key.
