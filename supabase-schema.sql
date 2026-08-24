-- ============================================================
-- SUPABASE SCHEMA - KHO BAI HOC SO MAI SON
-- Chay toan bo file nay trong Supabase > SQL Editor > New query.
-- Sau do tao Storage bucket public co ten: lesson-files
-- ============================================================

create extension if not exists pgcrypto;

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text,
  created_at timestamptz not null default now()
);

create table if not exists public.lessons (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  level text not null check (level in ('THCS','THPT')),
  grade text not null,
  subject text not null,
  teacher text not null,
  school_year text,
  tags text,
  description text,
  cover_url text,
  lesson_url text,
  views bigint not null default 0 check (views >= 0),
  downloads bigint not null default 0 check (downloads >= 0),
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.lesson_files (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  name text not null,
  storage_path text not null unique,
  mime_type text,
  size_bytes bigint not null default 0 check (size_bytes >= 0),
  created_at timestamptz not null default now()
);

create index if not exists lesson_files_lesson_id_idx on public.lesson_files(lesson_id);
create index if not exists lessons_created_at_idx on public.lessons(created_at desc);
create index if not exists lessons_subject_idx on public.lessons(subject);
create index if not exists lessons_teacher_idx on public.lessons(teacher);

-- Hàm kiểm tra quyền quản trị. SECURITY DEFINER giúp policy kiểm tra bảng admins
-- mà không cần mở quyền đọc trực tiếp bảng admins cho trình duyệt.
create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admins a
    where a.user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;

-- Bộ đếm công khai: khách chỉ được tăng lượt xem/tải, không được sửa nội dung bài.
create or replace function public.increment_lesson_views(p_lesson_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.lessons
  set views = views + 1
  where id = p_lesson_id;
$$;

create or replace function public.increment_lesson_downloads(p_lesson_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.lessons
  set downloads = downloads + 1
  where id = p_lesson_id;
$$;

revoke all on function public.increment_lesson_views(uuid) from public;
revoke all on function public.increment_lesson_downloads(uuid) from public;
grant execute on function public.increment_lesson_views(uuid) to anon, authenticated;
grant execute on function public.increment_lesson_downloads(uuid) to anon, authenticated;

alter table public.admins enable row level security;
alter table public.lessons enable row level security;
alter table public.lesson_files enable row level security;

-- Least privilege grants.
revoke all on table public.admins from anon, authenticated;
revoke all on table public.lessons from anon, authenticated;
revoke all on table public.lesson_files from anon, authenticated;

grant select on table public.lessons to anon, authenticated;
grant select on table public.lesson_files to anon, authenticated;
grant insert, update, delete on table public.lessons to authenticated;
grant insert, update, delete on table public.lesson_files to authenticated;

-- Xóa policy cũ nếu chạy lại script.
drop policy if exists lessons_public_read on public.lessons;
drop policy if exists lessons_admin_insert on public.lessons;
drop policy if exists lessons_admin_update on public.lessons;
drop policy if exists lessons_admin_delete on public.lessons;
drop policy if exists lesson_files_public_read on public.lesson_files;
drop policy if exists lesson_files_admin_insert on public.lesson_files;
drop policy if exists lesson_files_admin_update on public.lesson_files;
drop policy if exists lesson_files_admin_delete on public.lesson_files;

create policy lessons_public_read
on public.lessons for select
to anon, authenticated
using (true);

create policy lessons_admin_insert
on public.lessons for insert
to authenticated
with check ((select public.is_admin()));

create policy lessons_admin_update
on public.lessons for update
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));

create policy lessons_admin_delete
on public.lessons for delete
to authenticated
using ((select public.is_admin()));

create policy lesson_files_public_read
on public.lesson_files for select
to anon, authenticated
using (true);

create policy lesson_files_admin_insert
on public.lesson_files for insert
to authenticated
with check ((select public.is_admin()));

create policy lesson_files_admin_update
on public.lesson_files for update
to authenticated
using ((select public.is_admin()))
with check ((select public.is_admin()));

create policy lesson_files_admin_delete
on public.lesson_files for delete
to authenticated
using ((select public.is_admin()));

-- STORAGE POLICIES cho bucket lesson-files.
-- Bucket phải được tạo trong Dashboard > Storage và đặt Public.
drop policy if exists lesson_storage_admin_select on storage.objects;
drop policy if exists lesson_storage_admin_insert on storage.objects;
drop policy if exists lesson_storage_admin_update on storage.objects;
drop policy if exists lesson_storage_admin_delete on storage.objects;

create policy lesson_storage_admin_select
on storage.objects for select
to authenticated
using (
  bucket_id = 'lesson-files'
  and (select public.is_admin())
);

create policy lesson_storage_admin_insert
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'lesson-files'
  and (select public.is_admin())
);

create policy lesson_storage_admin_update
on storage.objects for update
to authenticated
using (
  bucket_id = 'lesson-files'
  and (select public.is_admin())
)
with check (
  bucket_id = 'lesson-files'
  and (select public.is_admin())
);

create policy lesson_storage_admin_delete
on storage.objects for delete
to authenticated
using (
  bucket_id = 'lesson-files'
  and (select public.is_admin())
);

-- ============================================================
-- SAU KHI TẠO USER QUẢN TRỊ TRONG Authentication > Users,
-- thay email dưới đây rồi chạy RIÊNG câu lệnh INSERT này.
-- ============================================================
-- insert into public.admins (user_id, email)
-- select id, email from auth.users
-- where lower(email) = lower('admin@truong.edu.vn')
-- on conflict (user_id) do update set email = excluded.email;
