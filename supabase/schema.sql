-- Alborito — esquema inicial Supabase (Postgres)
-- Pegar en: Supabase → SQL Editor → New query → Run
-- Cubre las entidades mínimas de la arquitectura EdTech (users, contenido, progreso).
-- RLS (Row Level Security) queda activado desde el inicio: nadie ve datos que no le pertenecen.

create extension if not exists "pgcrypto";

-- 1) Usuarios y roles ---------------------------------------------------
create type user_role as enum ('super_admin','admin','school_admin','teacher','parent','student','editor','author','moderator');

create table users (
  id uuid primary key default gen_random_uuid(),
  auth_id uuid unique references auth.users(id) on delete cascade,
  email text unique,
  full_name text,
  role user_role not null default 'parent',
  created_at timestamptz not null default now()
);

create table students (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references users(id) on delete cascade,
  display_name text not null,
  birth_year int,
  avatar_seed text default 'sprout-1', -- referencia a la hoja de modelo del personaje
  created_at timestamptz not null default now()
);

create table schools (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country text,
  created_at timestamptz not null default now()
);

create table classrooms (
  id uuid primary key default gen_random_uuid(),
  school_id uuid references schools(id) on delete cascade,
  teacher_id uuid references users(id) on delete set null,
  name text not null,
  created_at timestamptz not null default now()
);

create table classroom_students (
  classroom_id uuid references classrooms(id) on delete cascade,
  student_id uuid references students(id) on delete cascade,
  primary key (classroom_id, student_id)
);

-- 2) Contenido (CMS) -----------------------------------------------------
create type content_type as enum ('story','video','game','activity','resource');

create table contents (
  id uuid primary key default gen_random_uuid(),
  type content_type not null,
  slug text unique not null,
  title text not null,
  description text,
  min_age int,
  max_age int,
  subject text,           -- lenguaje, ciencias, matemática, socioemocional...
  skill text,              -- comprensión lectora, funciones ejecutivas...
  duration_minutes int,
  media_url text,
  thumbnail_url text,
  published boolean not null default false,
  created_by uuid references users(id),
  created_at timestamptz not null default now()
);

create table learning_objectives (
  id uuid primary key default gen_random_uuid(),
  content_id uuid references contents(id) on delete cascade,
  description text not null
);

-- 3) Progreso y gamificación ---------------------------------------------
create table progress (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references students(id) on delete cascade,
  content_id uuid references contents(id) on delete cascade,
  status text not null default 'started', -- started | completed
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (student_id, content_id)
);

create table badges (
  id uuid primary key default gen_random_uuid(),
  code text unique not null,
  name text not null,
  description text
);

create table student_badges (
  student_id uuid references students(id) on delete cascade,
  badge_id uuid references badges(id) on delete cascade,
  earned_at timestamptz not null default now(),
  primary key (student_id, badge_id)
);

create table favorites (
  student_id uuid references students(id) on delete cascade,
  content_id uuid references contents(id) on delete cascade,
  primary key (student_id, content_id)
);

-- 4) Auditoría -------------------------------------------------------------
create table audit_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references users(id),
  action text not null,
  entity text,
  entity_id uuid,
  created_at timestamptz not null default now()
);

-- 5) Row Level Security ----------------------------------------------------
alter table users enable row level security;
alter table students enable row level security;
alter table progress enable row level security;
alter table favorites enable row level security;
alter table contents enable row level security;

-- Un usuario ve y edita su propia fila
create policy "users_self" on users
  for select using (auth.uid() = auth_id);
create policy "users_self_update" on users
  for update using (auth.uid() = auth_id);

-- Una familia solo ve/edita a sus propios hijos
create policy "students_owned_by_parent" on students
  for all using (parent_id in (select id from users where auth_id = auth.uid()));

-- El progreso solo es visible/editable por el padre del estudiante dueño
create policy "progress_owned" on progress
  for all using (
    student_id in (
      select s.id from students s
      join users u on u.id = s.parent_id
      where u.auth_id = auth.uid()
    )
  );

create policy "favorites_owned" on favorites
  for all using (
    student_id in (
      select s.id from students s
      join users u on u.id = s.parent_id
      where u.auth_id = auth.uid()
    )
  );

-- El contenido publicado es de lectura pública
create policy "contents_public_read" on contents
  for select using (published = true);

-- Semillas de ejemplo (opcional, borrar en producción)
insert into badges (code, name, description) values
  ('primera-semilla','Primera semilla','Completaste tu primer cuento'),
  ('explorador','Explorador del bosque','Completaste 5 aventuras'),
  ('lector-constante','Lector constante','Leíste 3 días seguidos');
