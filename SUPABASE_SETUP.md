# KẾT NỐI SUPABASE CHO KHO BÀI HỌC SỐ

Website này đã được chuyển từ LocalStorage/IndexedDB sang Supabase:

- **Database:** bảng `lessons`, `lesson_files`, `admins`
- **Storage:** bucket `lesson-files`
- **Authentication:** đăng nhập quản trị bằng email + mật khẩu Supabase Auth
- **Phân quyền:** RLS, chỉ user có trong bảng `admins` được đăng/sửa/xóa
- **Khách:** được xem bài học và tải tài liệu, không có quyền ghi dữ liệu

## 1. Tạo project Supabase

1. Truy cập Supabase Dashboard và tạo project mới.
2. Mở **SQL Editor**.
3. Sao chép toàn bộ nội dung file `supabase-schema.sql` và bấm **Run**.

## 2. Tạo bucket lưu file

1. Vào **Storage** > **New bucket**.
2. Tên bucket: `lesson-files`.
3. Bật **Public bucket**.
4. Tạo bucket.

> Không đổi tên bucket nếu chưa sửa đồng thời `supabase-config.js` và các policy trong SQL.

## 3. Tạo tài khoản quản trị

1. Vào **Authentication** > **Users** > **Add user**.
2. Nhập email quản trị và mật khẩu.
3. Tạo user.
4. Trở lại SQL Editor và chạy, sau khi thay email thật:

```sql
insert into public.admins (user_id, email)
select id, email from auth.users
where lower(email) = lower('EMAIL_QUAN_TRI_CUA_BAN')
on conflict (user_id) do update set email = excluded.email;
```

Có thể cấp quyền cho nhiều quản trị viên bằng cách tạo thêm user rồi chạy câu lệnh trên cho từng email.

## 4. Cấu hình Supabase đã được điền sẵn

Bộ website này đã được cấu hình với project Supabase của bạn:

- Project URL: `https://kufxnulpaptgvhrexwup.supabase.co`
- Bucket: `lesson-files`
- Publishable key: đã điền trong `supabase-config.js`

Không cần sửa `supabase-config.js` nữa, trừ khi sau này bạn chuyển sang project Supabase khác.

**Không bao giờ** đưa Secret key hoặc `service_role` key vào website hoặc GitHub.

## 5. Đưa lên GitHub

Upload toàn bộ các file trong thư mục này lên repository:

- `index.html`
- `supabase-config.js`
- `supabase-schema.sql` (có thể giữ để quản trị, không ảnh hưởng website)
- `README.md`
- `SUPABASE_SETUP.md`
- `favicon.svg`
- `.nojekyll`

Sau đó bật GitHub Pages: **Settings > Pages > Deploy from a branch > main > /(root)**.

## 6. Kiểm tra

1. Mở website GitHub Pages ở chế độ ẩn danh: phải xem được danh sách bài học.
2. Người chưa đăng nhập không thấy nút **Đăng bài học** và **Quản trị**.
3. Đăng nhập bằng email quản trị: nút đăng bài và quản trị xuất hiện.
4. Đăng thử một bài kèm PDF/HTML/hình ảnh.
5. Mở website trên máy khác: bài vừa đăng phải xuất hiện, chứng tỏ dữ liệu đã lưu online.

## Ghi chú về bài học HTML

Supabase Storage phục vụ file HTML theo cơ chế an toàn và có thể trả HTML dưới dạng văn bản. Website đã xử lý bằng cách tải nội dung HTML rồi tạo Blob URL để hiển thị trong iframe. Cách này phù hợp nhất với bài học HTML **một file tự chứa**. Nếu bài học HTML phụ thuộc nhiều file CSS/JS/ảnh tương đối, nên đóng gói thành một HTML tự chứa hoặc đưa bài học lên một URL riêng rồi nhập vào mục **Liên kết bài học trực tuyến**.
