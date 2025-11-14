## Row Level Security (RLS) - basic examples

-- Enable RLS for grades (in Supabase SQL editor)
alter table grades enable row level security;

-- Allow students to select only their own grades
create policy "students_select_own" on grades
  for select using (auth.uid() = student_id);

-- Allow teachers assigned to subject to insert grades
create policy "teachers_insert" on grades
  for insert using (
    exists (
      select 1 from teachers_subjects ts where ts.teacher_id = auth.uid() and ts.subject_id = grades.subject_id
    )
  );

-- Allow teachers to update grades they created (or by policy)
create policy "teachers_update" on grades
  for update using (teacher_id = auth.uid());

Note: auth.uid() is Supabase's Postgres function mapping to the authenticated user's ID.
