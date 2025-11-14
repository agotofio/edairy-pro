-- Supabase/Postgres schema for Electronic Diary
-- Enable uuid-ossp or pgcrypto for gen_random_uuid (Supabase has gen_random_uuid available)
create extension if not exists "pgcrypto";

-- users
create table if not exists users (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  full_name text,
  role text not null check (role in ('student','teacher','admin')),
  created_at timestamptz default now()
);

create index if not exists idx_users_email on users(email);

-- groups (class or cohort)
create table if not exists groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  year int,
  created_at timestamptz default now()
);

-- subjects
create table if not exists subjects (
  id uuid primary key default gen_random_uuid(),
  code text,
  title text not null,
  created_at timestamptz default now()
);
create index if not exists idx_subjects_title on subjects(title);

-- enrollments: students in subjects/groups
create table if not exists enrollments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  subject_id uuid references subjects(id) on delete cascade,
  group_id uuid references groups(id) on delete cascade,
  status text default 'active',
  created_at timestamptz default now()
);
create index if not exists idx_enrollments_user on enrollments(user_id);
create index if not exists idx_enrollments_subject on enrollments(subject_id);

-- teachers_subjects
create table if not exists teachers_subjects (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references users(id) on delete cascade,
  subject_id uuid references subjects(id) on delete cascade,
  group_id uuid references groups(id) on delete cascade,
  created_at timestamptz default now()
);
create index if not exists idx_teachers_subjects on teachers_subjects(teacher_id, subject_id);

-- grades
create table if not exists grades (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references users(id) on delete cascade,
  teacher_id uuid references users(id) on delete cascade,
  subject_id uuid references subjects(id) on delete cascade,
  group_id uuid references groups(id) on delete cascade,
  value numeric check (value >= 0 and value <= 12),
  type text, -- 'test','homework','lab','exam'
  weight numeric default 1,
  comment text,
  date date default current_date,
  created_at timestamptz default now()
);
create index if not exists idx_grades_student on grades(student_id);
create index if not exists idx_grades_subject on grades(subject_id);

-- attendance
create table if not exists attendance (
  id uuid primary key default gen_random_uuid(),
  student_id uuid references users(id) on delete cascade,
  subject_id uuid references subjects(id) on delete cascade,
  group_id uuid references groups(id) on delete cascade,
  date date not null,
  status text check (status in ('present','absent','excused')),
  reason text,
  created_at timestamptz default now()
);
create index if not exists idx_attendance_student on attendance(student_id);

-- homeworks
create table if not exists homeworks (
  id uuid primary key default gen_random_uuid(),
  subject_id uuid references subjects(id) on delete cascade,
  group_id uuid references groups(id) on delete cascade,
  teacher_id uuid references users(id) on delete cascade,
  title text,
  description text,
  due_date date,
  attached_url text,
  created_at timestamptz default now()
);

-- events / notifications
create table if not exists events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id),
  type text,
  payload jsonb,
  read boolean default false,
  created_at timestamptz default now()
);

-- Sample admin user (create manually using Supabase Auth linking or insert with service key)
-- insert into users (email, full_name, role) values ('admin@example.com','System Admin','admin');

-- Useful view: student average by subject
create or replace view student_subject_avg as
select student_id, subject_id, avg(value * weight) as avg_weighted
from grades
group by student_id, subject_id;
