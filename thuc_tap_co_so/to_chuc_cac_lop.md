# BÁO CÁO CẤU TRÚC VÀ TỔ CHỨC CÁC LỚP CỦA CHƯƠNG TRÌNH

---

## 1. Môi trường cài đặt và công nghệ sử dụng

### a) Môi trường cài đặt
*   **Hệ điều hành**: Windows / macOS / Linux.
*   **Java Development Kit (JDK)**: Phiên bản **17** trở lên.
*   **Hệ quản trị cơ sở dữ liệu**: **MySQL** (từ 8.0 trở lên) hoặc **MariaDB** (sử dụng qua bộ công cụ **XAMPP**).
*   **Công cụ phát triển (IDE)**: **Visual Studio Code (VS Code)** (kèm extension Live Server) hoặc **IntelliJ IDEA**.

### b) Công nghệ sử dụng
*   **Frontend**: HTML5, CSS3 (thiết kế Dark Mode tối giản, hiện đại), Bootstrap 5, JavaScript thuần (ES6) và Fetch API để giao tiếp bất đồng bộ.
*   **Backend**: Spring Boot 3.x (Spring Web, Spring Security, Spring Data JPA), Maven (quản lý thư viện).
*   **Cơ chế bảo mật**: JSON Web Token (JWT) cho mục đích phân quyền và xác thực phiên đăng nhập.
*   **Cơ sở dữ liệu**: MySQL, Hibernate ORM làm cầu nối ánh xạ đối tượng (Object-Relational Mapping).

---

## 2. Tổ chức các lớp của chương trình

### a) Frontend (HTML, CSS, JS thuần)

*   **Trang giao diện (HTML):**
    *   `sign-in.html`: Màn hình đăng nhập hệ thống. Cho phép người dùng nhập Email và mật khẩu để xác thực tài khoản và nhận mã token JWT lưu vào LocalStorage.
    *   `sign-up.html`: Màn hình đăng ký tài khoản mới. Cho phép người dùng nhập các thông tin cá nhân và chọn vai trò hệ thống mặc định (Manager, Developer, Tester).
    *   `dashboard.html`: Trang tổng quan quản trị. Hiển thị các khối thống kê số lượng lỗi theo trạng thái, theo mức độ ưu tiên, danh sách không gian làm việc (Workspace) tham gia và bảng quản lý thành viên.
    *   `workspace.html`: Bảng điều khiển Kanban chi tiết. Hiển thị danh sách thẻ lỗi theo 4 cột trạng thái (*Open, In Progress, Resolved, Closed*), tích hợp các hộp thoại xem chi tiết lỗi, bình luận, đính kèm tệp và cập nhật thông tin lỗi.

*   **Tệp logic & định dạng (Assets):**
    *   `assets/app.js`: Lớp xử lý logic JavaScript trung tâm. Thực hiện bắt sự kiện tương tác của người dùng, gọi REST API bất đồng bộ thông qua Fetch API (kèm mã token JWT trong Header Authorization), quản lý hiển thị DOM và điều khiển định tuyến.
    *   `assets/styles.css`: Định nghĩa phong cách giao diện (CSS). Thiết kế hệ thống giao diện tối (Dark mode) hiện đại, bố cục Kanban linh hoạt, hiệu ứng chuyển động mượt mà và giao diện bảng biểu trực quan.

---

### b) Backend (Spring Boot Framework)

*   **Gói cấu hình (`com.example.demo.config`):**
    *   `SecurityConfig.java`: Cấu hình bảo mật hệ thống. Định nghĩa các endpoint công khai (permitAll) và các endpoint bắt buộc xác thực, cấu hình chính sách CORS hỗ trợ gọi API chéo nguồn, và thiết lập chuỗi bộ lọc bảo mật.
    *   `JwtAuthFilter.java`: Bộ lọc kiểm soát mọi yêu cầu HTTP gửi đến. Trích xuất mã JWT từ Header `Authorization`, xác thực tính hợp lệ của token và nạp thông tin người dùng vào ngữ cảnh bảo mật của Spring Security.
    *   `JwtUtils.java`: Lớp tiện ích xử lý Token JWT. Thực hiện mã hóa tạo token mới từ thông tin email người dùng, giải mã token và kiểm tra tính hợp hạn sử dụng với khóa ký cố định cấu hình từ `application.properties`.
    *   `CustomUserDetails.java`: Lớp bọc thông tin người dùng đăng nhập. Kế thừa `UserDetails` của Spring Security nhằm lưu trữ thông tin tài khoản và cấp các quyền tương ứng của người dùng.
    *   `CustomUserDetailsService.java`: Dịch vụ tìm kiếm tài khoản. Thực hiện truy vấn thông tin tài khoản từ cơ sở dữ liệu qua email phục vụ cho quá trình đăng nhập và xác thực của Spring Security.
    *   `Swagger2Config.java`: Cấu hình tự động sinh tài liệu API trực quan dạng Swagger UI để lập trình viên dễ dàng thử nghiệm API.

*   **Gói điều phối (`com.example.demo.controller`):**
    *   `AuthController.java`: Tiếp nhận và điều phối các yêu cầu đăng nhập (`/api/auth/login`) và đăng ký tài khoản (`/api/auth/register`).
    *   `UserController.java`: Cung cấp các API quản lý thông tin tài khoản người dùng (`/users`), cập nhật hồ sơ cá nhân và tải lên ảnh đại diện cá nhân.
    *   `WorkspaceController.java`: Cung cấp các API quản trị dự án (`/api/workspaces`), bao gồm tạo mới, xóa dự án, mời thành viên qua email và điều chỉnh vai trò thành viên.
    *   `BugController.java`: Cung cấp các API xử lý nghiệp vụ quản lý lỗi (`/api/bugs`), tạo bình luận dưới thẻ lỗi, truy vấn nhật ký thay đổi của một lỗi.
    *   `AttachmentController.java`: Cung cấp các API quản lý tệp tin đính kèm của lỗi, cho phép upload tệp minh chứng lỗi lên máy chủ và tải về (download).
    *   `DashboardController.java`: Cung cấp các API thống kê số lượng lỗi trong không gian làm việc phục vụ vẽ biểu đồ Dashboard.

*   **Gói thực thể (`com.example.demo.entity`):**
    *   `User.java`: Thực thể ánh xạ với bảng `users` trong cơ sở dữ liệu để quản lý tài khoản đăng nhập và mật khẩu đã mã hóa.
    *   `Member.java`: Thực thể ánh xạ với bảng `members` chứa hồ sơ cá nhân của người dùng và vai trò hệ thống (role) mặc định của họ.
    *   `Workspace.java`: Thực thể ánh xạ với bảng `workspaces` quản lý thông tin các không gian làm việc của dự án.
    *   `WorkspaceUser.java` / `WorkspaceUserId.java`: Thực thể ánh xạ bảng liên kết `workspace_users` để lưu thông tin vai trò của thành viên trong từng dự án cụ thể.
    *   `Bug.java`: Thực thể ánh xạ bảng `bugs` lưu thông tin mô tả chi tiết lỗi, mức độ ưu tiên và trạng thái lỗi.
    *   `Comment.java`: Thực thể ánh xạ bảng `comments` quản lý các đoạn thảo luận về lỗi dưới dạng văn bản.
    *   `Attachment.java`: Thực thể ánh xạ bảng `attachments` quản lý đường dẫn lưu trữ, tên file và dung lượng file đính kèm của lỗi.
    *   `BugHistory.java`: Thực thể ánh xạ bảng `bug_histories` để lưu vết mọi lịch sử biến động trạng thái và người phụ trách lỗi.
    *   `Label.java`: Thực thể ánh xạ bảng `labels` để định nghĩa nhãn dán phân loại lỗi.
    *   `BugLabel.java` / `BugLabelId.java`: Thực thể ánh xạ bảng trung gian liên kết giữa lỗi và nhãn dán.
    *   `ActivityLog.java`: Thực thể ánh xạ bảng `activity_logs` lưu nhật ký hoạt động chung trên hệ thống.

*   **Gói nghiệp vụ (`com.example.demo.service` & `com.example.demo.service.impl`):**
    *   `UserService.java` / `UserServiceImpl.java`: Xử lý logic nghiệp vụ đăng ký, cập nhật và xác thực thông tin tài khoản thành viên hệ thống.
    *   `WorkspaceService.java` / `WorkspaceServiceImpl.java`: Xử lý nghiệp vụ tạo mới, xóa bỏ không gian làm việc, ràng buộc quyền quản lý (chỉ Manager mới có quyền tạo và quản lý) và điều phối thêm mới, cập nhật vai trò của nhân sự tham gia.
    *   `BugService.java` / `BugServiceImpl.java`: Xử lý nghiệp vụ quản lý lỗi, tự động ghi nhận lịch sử biến động lỗi khi thay đổi trạng thái, và xử lý bình luận.
    *   `AttachmentService.java` / `AttachmentServiceImpl.java`: Xử lý logic lưu trữ tệp vật lý lên thư mục server và quản lý liên kết file đính kèm trong database.
    *   `DashboardService.java` / `DashboardServiceImpl.java`: Tính toán, truy vấn số liệu thống kê bug theo các chiều dữ liệu (Trạng thái, độ ưu tiên, lập trình viên).

*   **Gói lưu trữ (`com.example.demo.repository`):**
    *   `UserRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `users`.
    *   `MemberRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `members`.
    *   `WorkspaceRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `workspaces`.
    *   `WorkspaceUserRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `workspace_users`.
    *   `BugRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `bugs`.
    *   `CommentRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `comments`.
    *   `AttachmentRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `attachments`.
    *   `BugHistoryRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `bug_histories`.
    *   `LabelRepository.java`: Kế thừa `JpaRepository` để giao tiếp dữ liệu bảng `labels`.

*   **Gói truyền tải dữ liệu (`com.example.demo.model.dto`):**
    *   `UserDto.java`: Đối tượng đóng gói thông tin người dùng (ID, tên, email, ảnh đại diện, vai trò) trả về cho Client.
    *   `WorkspaceDto.java`: Chứa thông tin Workspace và danh sách các thành viên cùng vai trò cụ thể của họ trong dự án.
    *   `BugDto.java`: Đối tượng truyền tải chi tiết thông tin lỗi, mức độ ưu tiên, trạng thái, người tạo và người chịu trách nhiệm sửa.
    *   `CommentDto.java`: Chứa nội dung bình luận và thông tin người đăng bình luận nhằm hiển thị dưới dạng thảo luận nhóm.
    *   `AttachmentDto.java`: Chứa thông tin tệp tin đính kèm để hiển thị và tải về.
    *   `BugHistoryDto.java`: Đóng gói dữ liệu lịch sử thay đổi để hiển thị dưới dạng timeline hoạt động của lỗi.
    *   `AuthRes.java`: Chứa thông tin phản hồi sau khi xác thực thành công (Token JWT và thông tin người dùng).
    *   `DashboardSummaryDto.java` / `DashboardPriorityDto.java` / `DashboardDeveloperDto.java`: Đóng gói các chỉ số thống kê phục vụ vẽ biểu đồ trên Dashboard.

*   **Gói yêu cầu dữ liệu (`com.example.demo.model.request`):**
    *   `LoginReq.java`: Đóng gói thông tin yêu cầu đăng nhập gồm Email và Mật khẩu gửi lên từ client.
    *   `CreateUserReq.java`: Đóng gói thông tin đăng ký tài khoản mới.
    *   `UpdateUserReq.java`: Đóng gói thông tin cập nhật tài khoản và hồ sơ cá nhân người dùng.
    *   `CreateWorkspaceReq.java`: Đóng gói thông tin tên Workspace để thực hiện tạo mới.
    *   `AddMemberReq.java`: Đóng gói Email và vai trò khi mời thành viên mới vào dự án.
    *   `CreateBugReq.java`: Đóng gói thông tin chi tiết lỗi khi tạo mới lỗi.
    *   `UpdateBugReq.java`: Đóng gói thông tin chi tiết lỗi khi cập nhật thông tin và trạng thái lỗi.
    *   `CreateCommentReq.java`: Đóng gói nội dung bình luận mới cần tạo.
    *   `UploadFile.java`: Đóng gói dữ liệu tệp tin đính kèm (MultipartFile) khi gửi yêu cầu tải lên hệ thống.

*   **Gói ánh xạ (`com.example.demo.model.mapper`):**
    *   `UserMapper.java`: Lớp chuyển đổi dữ liệu qua lại giữa thực thể User, Member và DTO UserDto.
    *   `AttachmentMapper.java`: Lớp chuyển đổi dữ liệu thực thể Attachment sang AttachmentDto.

*   **Gói xử lý ngoại lệ (`com.example.demo.exception`):**
    *   `CustomExceptionHandler.java`: Lớp bắt lỗi tập trung (Global Exception Handler) xử lý toàn bộ các Exception phát sinh trong Runtime để trả về Error Response chuẩn hóa cho Client.
    *   `NotFoundException.java`: Ngoại lệ ném ra khi không tìm thấy thực thể tương ứng trong database.
    *   `DuplicateRecordException.java`: Ngoại lệ ném ra khi gặp lỗi trùng lặp dữ liệu (ví dụ: đăng ký trùng email).
    *   `ForbiddenException.java`: Ngoại lệ ném ra khi người dùng cố tình thực hiện các thao tác vượt quá quyền hạn của vai trò.
    *   `ErrorResponse.java`: Cấu trúc dữ liệu lỗi tiêu chuẩn (mã lỗi, thông điệp, mốc thời gian) trả về cho Client.
