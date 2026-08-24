# Kho bài học số - Trường PTDTNT THCS-THPT Mai Sơn

Phiên bản GitHub Pages đã kết nối kiến trúc Supabase để lưu dữ liệu trực tuyến.

## Thành phần

- `index.html` - giao diện và ứng dụng
- `supabase-config.js` - Project URL + Publishable key
- `supabase-schema.sql` - cơ sở dữ liệu, RLS và Storage policies
- `SUPABASE_SETUP.md` - hướng dẫn cài đặt từng bước
- `favicon.svg` - biểu tượng website
- `.nojekyll` - cấu hình GitHub Pages

## Bảo mật

Website chỉ dùng **Publishable key** (hoặc legacy anon key) ở frontend. Quyền truy cập thật được kiểm soát bằng Supabase Auth và Row Level Security. Không đưa Secret key / service_role key vào GitHub hoặc trình duyệt.

Xem `SUPABASE_SETUP.md` để cài đặt.


## Supabase đã cấu hình

Project URL đã được gắn sẵn trong `supabase-config.js`: `https://kufxnulpaptgvhrexwup.supabase.co`.

Trước khi dùng thật, vẫn cần chạy `supabase-schema.sql`, tạo bucket `lesson-files`, tạo tài khoản trong Authentication và thêm tài khoản đó vào bảng `public.admins`.
