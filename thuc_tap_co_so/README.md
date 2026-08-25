# HƯỚNG DẪN CÀI ĐẶT VÀ KHỞI CHẠY DỰ ÁN BUG TRACKING (JIRA UI)

Tài liệu này hướng dẫn chi tiết các bước để cài đặt cấu hình và khởi chạy ứng dụng Quản lý lỗi (Bug Tracking System) trên một máy tính mới từ đầu.

---

## 1. YÊU CẦU MÔI TRƯỜNG CÀI ĐẶT (PREREQUISITES)

Trước khi tiến hành, máy tính cần cài đặt sẵn các công cụ sau:
*   **Java Development Kit (JDK)**: Phiên bản **17** trở lên (Khuyên dùng OpenJDK 17 hoặc Oracle JDK 17).
*   **Hệ quản trị CSDL**: **MySQL / MariaDB** (Thông thường sử dụng gói phần mềm **XAMPP** để tích hợp sẵn MySQL và giao diện phpMyAdmin).
*   **Trình soạn thảo mã nguồn**: **Visual Studio Code (VS Code)** hoặc các IDE khác như IntelliJ IDEA, Eclipse.
*   **VS Code Extensions (Khuyên dùng)**: Cài đặt tiện ích **Live Server** trong VS Code để khởi chạy Frontend ổn định không bị lỗi CORS.

---

## 2. CẤU TRÚC THƯ MỤC DỰ ÁN

Mã nguồn dự án bao gồm hai phần chính:
```
thuc_tap_co_so/
├── static-ui/                  ← Thư mục Frontend (HTML, CSS, JS thuần)
│   ├── assets/                 ← Chứa file app.js, styles.css
│   ├── sign-in.html            ← Trang đăng nhập
│   ├── sign-up.html            ← Trang đăng ký
│   ├── dashboard.html          ← Trang thống kê và quản lý workspace
│   ├── workspace.html          ← Bảng Kanban tương tác và quản lý lỗi
│   └── ...
│
└── static-ui/demo/demo/        ← Thư mục Backend (Dự án Java Spring Boot)
    ├── src/                    ← Mã nguồn java và tài nguyên properties
    ├── pom.xml                 ← Quản lý các dependency của Maven
    ├── mvnw.cmd & mvnw         ← Trình khởi chạy Maven Wrapper
    └── ...
```

---

## 3. HƯỚNG DẪN CÁC BƯỚC KHỞI CHẠY CHI TIẾT

### BƯỚC 1: Cấu hình và nạp Cơ sở dữ liệu (Database Setup)
1.  Mở phần mềm điều khiển **XAMPP Control Panel**, nhấn **Start** hai dịch vụ **Apache** và **MySQL**.
2.  Mở trình duyệt Web, truy cập trang quản trị cơ sở dữ liệu: `http://localhost/phpmyadmin/`.
3.  Tạo một cơ sở dữ liệu mới:
    *   Nhấp vào mục **New** bên cột trái.
    *   Đặt tên cơ sở dữ liệu: `new_ui`
    *   Chọn bảng mã (Collation): `utf8mb4_general_ci`
    *   Bấm **Create**.
4.  Nạp dữ liệu mẫu cho database:
    *   Nhấp chọn cơ sở dữ liệu `new_ui` vừa tạo.
    *   Chọn tab **Import** trên thanh menu ngang ở trên.
    *   Nhấp **Choose File** và tìm tới file cơ sở dữ liệu mẫu của dự án nằm tại đường dẫn: `static-ui/reset_db.sql` (đây là file SQL đã có sẵn dữ liệu seed hoàn chỉnh, các tài khoản và bug mẫu để test).
    *   Kéo xuống dưới cùng và nhấp **Import**.

### BƯỚC 2: Cấu hình kết nối Database cho Backend
1.  Dùng trình soạn thảo (VS Code) mở file cấu hình sau:
    `static-ui/demo/demo/src/main/resources/application.properties`
2.  Kiểm tra và chỉnh sửa cấu hình kết nối MySQL cho đúng với máy tính của bạn:
    ```properties
    # Cấu hình kết nối MySQL (Mặc định cổng 3306. Nếu MySQL của bạn chạy cổng 3307, sửa lại 3306 thành 3307)
    spring.datasource.url=jdbc:mysql://localhost:3306/new_ui?createDatabaseIfNotExist=true
    spring.datasource.username=root
    spring.datasource.password=
    ```
    *(Mặc định XAMPP để password của root là trống. Nếu bạn tự cài MySQL Server riêng và có đặt mật khẩu, hãy nhập mật khẩu đó vào dòng password trên).*

### BƯỚC 3: Khởi chạy Máy chủ Backend (Spring Boot RESTful API)
1.  Mở cửa sổ Command Prompt (CMD), PowerShell hoặc Terminal của VS Code.
2.  Di chuyển con trỏ thư mục vào thư mục gốc của dự án Java Backend:
    ```bash
    cd static-ui/demo/demo
    ```
3.  Sử dụng Maven Wrapper có sẵn để biên dịch và chạy dự án:
    *   **Trên hệ điều hành Windows**:
        ```bash
        .\mvnw.cmd spring-boot:run
        ```
    *   **Trên hệ điều hành macOS / Linux**:
        ```bash
        chmod +x mvnw
        ./mvnw spring-boot:run
        ```
4.  Khi màn hình console xuất hiện dòng chữ `Started UserManagementRestApiApplication in ... seconds` và không xuất hiện thông báo lỗi, máy chủ Backend đã khởi động thành công trên cổng **8080**.
5.  Bạn có thể kiểm tra danh sách API và tài liệu Swagger bằng cách truy cập: `http://localhost:8080/swagger-ui/index.html`.

### BƯỚC 4: Khởi chạy Giao diện Frontend
Do giao diện cần gửi các yêu cầu Ajax (Fetch API) lấy dữ liệu từ Backend (`http://localhost:8080`), trình duyệt sẽ chặn nếu bạn mở file HTML trực tiếp dưới dạng `file://D:/...` (Lỗi CORS). Do đó bạn cần chạy Frontend dưới dạng một máy chủ cục bộ (Local Server):
1.  Mở thư mục `static-ui` của dự án bằng **VS Code**.
2.  Nhấp chuột phải vào file **`sign-in.html`**, chọn **Open with Live Server**.
3.  VS Code sẽ khởi chạy máy chủ web tĩnh trên cổng mặc định `5500`. Trình duyệt tự động mở trang web tại địa chỉ: `http://127.0.0.1:5500/sign-in.html` (hoặc `http://localhost:5500/sign-in.html`).
4.  Hệ thống đã sẵn sàng hoạt động.

---

## 4. DANH SÁCH TÀI KHOẢN MẪU ĐỂ DÙNG THỬ (DEMO ACCOUNTS)

Cơ sở dữ liệu đã chứa sẵn các tài khoản mẫu với mật khẩu chung là **`secret123`**:

| STT | Email | Vai trò hệ thống / dự án | Quyền hạn chính |
|---|---|---|---|
| 1 | `manager@test.com` | **Manager** (Quản lý) | Có toàn quyền quản lý dự án, tạo Workspace, mời thành viên, gán lỗi (Assign) và xóa lỗi. |
| 2 | `dev@test.com` | **Developer** (Lập trình) | Xem các bug được phân công, cập nhật trạng thái sửa lỗi (Open -> In Progress -> Resolved), viết comment. |
| 3 | `tester@test.com` | **Tester** (Kiểm thử) | Phát hiện lỗi và tạo bug mới, kiểm tra kết quả sửa lỗi của Developer để đóng lỗi (Closed) hoặc mở lại lỗi (Re-open). |

*Lưu ý: Bạn cũng có thể đăng ký tài khoản mới trực tiếp tại trang Đăng ký (`sign-up.html`), sau đó đăng nhập và bắt đầu tạo Workspace của riêng mình.*
