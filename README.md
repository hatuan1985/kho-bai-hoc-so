# Kho bài học số - Trường PTDTNT THCS-THPT Mai Sơn

Website tĩnh chạy trực tiếp trên trình duyệt, sẵn sàng đưa lên GitHub Pages.

## Cấu trúc

- `index.html`: trang web chính
- `favicon.svg`: biểu tượng website
- `.nojekyll`: giúp GitHub Pages phục vụ trực tiếp các tệp tĩnh

## Đưa lên GitHub Pages

1. Tạo một repository mới trên GitHub.
2. Upload toàn bộ các tệp trong thư mục này vào nhánh `main`.
3. Vào `Settings` > `Pages`.
4. Tại `Build and deployment`, chọn `Deploy from a branch`.
5. Chọn nhánh `main` và thư mục `/ (root)` rồi nhấn `Save`.
6. Chờ GitHub Pages tạo địa chỉ website.

## Tài khoản quản trị mặc định

- Tên đăng nhập: `admin`
- Mật khẩu: `123456`

Sau khi đăng nhập, nên đổi mật khẩu trong mục Quản trị.

## Lưu ý

Phiên bản hiện tại lưu bài học và tệp đính kèm bằng LocalStorage/IndexedDB trên từng trình duyệt. Khi website được đưa lên GitHub Pages, dữ liệu không tự đồng bộ giữa các máy. Cơ chế quản trị hiện tại cũng là phía trình duyệt, phù hợp bản thử nghiệm/nội bộ; nếu triển khai công khai cho nhiều giáo viên cùng đăng bài, nên chuyển sang hệ thống đăng nhập và lưu trữ phía máy chủ như Supabase.
