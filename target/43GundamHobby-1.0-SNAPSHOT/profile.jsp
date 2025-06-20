<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin khách hàng - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <style>
        .profile-sidebar {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 24px 0;
        }
        .profile-sidebar .nav-link.active {
            background: #f0f0f0;
            font-weight: 500;
        }
        .profile-content {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            padding: 32px;
            min-height: 400px;
        }
    </style>
</head>
<body style="background:#f8f9fa;">
    <header class="bg-white shadow-sm sticky-top">
        <div class="container">
            <div class="row align-items-center py-3">
                <div class="col-md-3">
                    <div class="logo">
                        <a href="<%=request.getContextPath()%>/">
                            <img src="<%=request.getContextPath()%>/img/logo.png" alt="43 Gundam Hobby Logo" class="logo-img">
                        </a>
                    </div>
                </div>
                <div class="col-md-9">
                    <nav class="navbar navbar-expand-lg">
                        <ul class="navbar-nav ms-auto">
                            <li class="nav-item">
                                <a class="nav-link" href="<%=request.getContextPath()%>/">Trang chủ</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </header>
    <main class="container my-5">
        <div class="row">
            <div class="col-md-3">
                <div class="profile-sidebar">
                    <div class="text-center mb-4">
                        <i class="fas fa-user-circle fa-3x text-primary mb-2"></i>
                        <h5 id="profileUserName">Xin chào, User</h5>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#" id="profileInfoTab"><i class="fas fa-user me-2"></i>Thông tin tài khoản</a>
                        <a class="nav-link" href="#" id="profileOrdersTab"><i class="fas fa-box me-2"></i>Đơn hàng của bạn</a>
                        <a class="nav-link" href="#" id="profilePasswordTab"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a>
                        <a class="nav-link" href="#" id="profileAddressTab"><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ <span class="badge bg-secondary ms-1">0</span></a>
                        <a class="nav-link text-danger" href="#" onclick="userLogout()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                    </nav>
                </div>
            </div>
            <div class="col-md-9">
                <div class="profile-content" id="profileContent">
                    <!-- Nội dung từng tab sẽ được hiển thị ở đây -->
                    <h4>Thông tin tài khoản</h4>
                    <p>Email: <span id="profileUserEmail">user@email.com</span></p>
                    <p>Họ tên: <span id="profileUserFullName">User</span></p>
                </div>
            </div>
        </div>
    </main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/account-dropdown.js"></script>
    <script>
        // Hiển thị tên và email người dùng từ session (ưu tiên session, fallback localStorage)
        document.addEventListener('DOMContentLoaded', function() {
            let name = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "User" %>';
            let email = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "user@email.com" %>';
            // Nếu không có trong session, fallback localStorage (giữ lại logic cũ)
            if (!name || name === 'null') name = localStorage.getItem('userName') || 'User';
            if (!email || email === 'null') email = localStorage.getItem('userEmail') || 'user@email.com';
            document.getElementById('profileUserName').textContent = 'Xin chào, ' + name;
            document.getElementById('profileUserEmail').textContent = email;
            document.getElementById('profileUserFullName').textContent = name;
        });
        // Tab switching (có thể mở rộng sau)
        document.getElementById('profileInfoTab').onclick = function() {
            document.getElementById('profileContent').innerHTML = `<h4>Thông tin tài khoản</h4><p>Email: <span id='profileUserEmail'>${localStorage.getItem('userEmail')||'user@email.com'}</span></p><p>Họ tên: <span id='profileUserFullName'>${localStorage.getItem('userName')||'User'}</span></p>`;
        };
        document.getElementById('profileOrdersTab').onclick = function() {
            document.getElementById('profileContent').innerHTML = `<h4>Đơn hàng của bạn</h4><p>Bạn chưa có đơn hàng nào.</p>`;
        };
        document.getElementById('profilePasswordTab').onclick = function() {
            document.getElementById('profileContent').innerHTML = `<h4>Đổi mật khẩu</h4><p>Chức năng này sẽ được cập nhật sau.</p>`;
        };
        document.getElementById('profileAddressTab').onclick = function() {
            document.getElementById('profileContent').innerHTML = `<h4>Sổ địa chỉ</h4><p>Bạn chưa có địa chỉ nào.</p>`;
        };
    </script>
</body>
</html>
