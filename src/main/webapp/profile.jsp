<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin khách hàng - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/layout-sizing.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/address-book.css" rel="stylesheet">
    
    <style>
        .profile-body {
            background-color: #f8f9fa;
        }
        
        .profile-sidebar {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            border: 1px solid #e9ecef;
        }
        
        .profile-sidebar h5 {
            color: #212529 !important;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .profile-sidebar .text-muted {
            color: #6c757d !important;
            font-size: 0.9em;
        }
        
        .profile-content {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            min-height: 500px;
            border: 1px solid #e9ecef;
        }
        
        .profile-content .row.mb-3 {
            padding: 8px 0;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .profile-content .row.mb-3:last-child {
            border-bottom: none;
        }
        
        .profile-content .col-sm-4 {
            color: #6c757d;
            font-weight: 600;
        }
        
        .profile-content .col-sm-8 {
            color: #212529;
            font-weight: 500;
        }
        
        .avatar-80 {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
        
        .avatar-120 {
            width: 120px;
            height: 120px;
            object-fit: cover;
        }
        
        .avatar-32 {
            width: 32px;
            height: 32px;
            object-fit: cover;
        }
        
        .user-icon-32 {
            font-size: 32px;
            color: #6c757d;
        }
        
        .nav-link {
            color: #212529;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
            font-weight: 500;
            padding: 12px 16px;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .nav-link:hover {
            background-color: #e9ecef;
            color: #212529;
            font-weight: 600;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.9), -1px -1px 2px rgba(255,255,255,0.7);
        }
        
        .nav-link.active {
            background-color: #007bff;
            color: white !important;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0,123,255,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .nav-link.active:hover {
            background-color: #0056b3;
            color: white !important;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8), -1px -1px 2px rgba(0,0,0,0.6);
        }
        
        .info-section {
            border-left: 4px solid #007bff;
            padding-left: 1rem;
        }
        
        .avatar-section {
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #212529;
            margin-bottom: 8px;
        }
        
        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            color: white !important;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .btn-success:hover {
            background: linear-gradient(45deg, #218838, #1abc9c);
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(40,167,69,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8), -1px -1px 2px rgba(0,0,0,0.6);
        }
        
        .btn-outline-primary {
            color: #007bff !important;
            border-color: #007bff;
            font-weight: 600;
            padding: 8px 16px;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .btn-outline-primary:hover {
            background-color: #007bff !important;
            border-color: #007bff !important;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
            color: white !important;
            font-weight: 600;
            padding: 10px 20px;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #545b62;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(108,117,125,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8), -1px -1px 2px rgba(0,0,0,0.6);
        }
        
        .alert {
            border-radius: 10px;
            font-weight: 500;
        }
        
        .badge {
            font-weight: 600;
            font-size: 0.7em;
            text-shadow: 1px 1px 1px rgba(0,0,0,0.5), -1px -1px 1px rgba(0,0,0,0.3);
        }
        
        .badge.bg-primary {
            background-color: #007bff !important;
            color: white !important;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .text-danger {
            color: #dc3545 !important;
            font-weight: 600;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .text-muted {
            color: #6c757d !important;
        }
        
        .fw-bold {
            font-weight: 700 !important;
        }
        
        h4, h5, h6 {
            color: #212529;
            font-weight: 600;
        }
        
        .profile-content h4 {
            color: #007bff;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        
        .info-section h6 {
            color: #007bff;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
        }
        
        .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
        }
        
        @media (max-width: 768px) {
            .profile-content {
                padding: 1rem;
            }
            
            .avatar-section {
                margin-top: 2rem;
            }
        }
        
        /* Additional Button Styles for Better Visibility */
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white !important;
            font-weight: 600;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220,53,69,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8), -1px -1px 2px rgba(0,0,0,0.6);
        }
        
        .btn-warning {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #212529 !important;
            font-weight: 600;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .btn-warning:hover {
            background-color: #e0a800;
            border-color: #d39e00;
            color: #212529 !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(255,193,7,0.3);
            text-shadow: 1px 1px 2px rgba(255,255,255,0.9), -1px -1px 2px rgba(255,255,255,0.7);
        }
        
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            color: white !important;
            font-weight: 600;
            transition: all 0.3s ease;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.7), -1px -1px 2px rgba(0,0,0,0.5);
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004085;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,123,255,0.3);
            text-shadow: 1px 1px 2px rgba(0,0,0,0.8), -1px -1px 2px rgba(0,0,0,0.6);
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
            font-weight: 600;
            text-shadow: 1px 1px 1px rgba(0,0,0,0.5), -1px -1px 1px rgba(0,0,0,0.3);
        }
        
        /* Table Styles */
        .table {
            font-weight: 500;
        }
        
        .table th {
            background-color: #f8f9fa !important;
            color: #212529 !important;
            font-weight: 700;
            border-color: #dee2e6;
        }
        
        .table td {
            color: #212529;
            vertical-align: middle;
        }
        
        .table-bordered {
            border: 1px solid #dee2e6;
        }
        
        /* Order Status Styles */
        .order-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: 600;
            text-transform: uppercase;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .order-status.PENDING {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .order-status.CONFIRMED {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .order-status.PROCESSING {
            background-color: #cce5ff;
            color: #004085;
            border: 1px solid #99d3ff;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .order-status.DELIVERED {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        .order-status.CANCELLED {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            text-shadow: 1px 1px 2px rgba(255,255,255,0.8), -1px -1px 2px rgba(255,255,255,0.6);
        }
        
        /* Modal Improvements */
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        
        .modal-title {
            color: #212529;
            font-weight: 600;
        }
        
        .modal-body .form-label {
            color: #212529;
            font-weight: 600;
        }
        
        .modal-footer .btn {
            font-weight: 600;
        }
        
        /* Dropdown improvements */
        .dropdown-menu {
            border: 1px solid #dee2e6;
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15);
        }
        
        .dropdown-item {
            color: #212529;
            font-weight: 500;
        }
        
        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #212529;
        }
        
        .dropdown-header {
            color: #6c757d;
            font-weight: 600;
        }
        
        /* Spinner improvements */
        .spinner-border-sm {
            width: 1rem;
            height: 1rem;
        }
    </style>
</head>
<body class="profile-body">    <header class="bg-white shadow-sm sticky-top">
        <div class="container">
            <div class="row align-items-center py-3">
                <!-- Logo Section with Hamburger Menu -->
                <div class="col-lg-3 col-md-4 col-6">
                    <div class="header-logo-section">
                        <!-- Hamburger Menu (Mobile) -->
                        <button class="hamburger-menu" id="hamburgerBtn" aria-label="Menu">
                            <span class="line"></span>
                            <span class="line"></span>
                            <span class="line"></span>
                        </button>
                        
                        <div class="logo">
                            <a href="<%=request.getContextPath()%>/">
                                <img src="<%=request.getContextPath()%>/img/logo.png" alt="43 Gundam Logo" class="logo-img">
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Search Section -->
                <div class="col-lg-6 col-md-4 col-12 order-lg-2 order-md-2 order-3">
                    <div class="header-center-section">
                        <div class="search-container w-100">
                            <form class="search-form">
                                <div class="input-group">
                                    <input type="text" class="form-control search-input" placeholder="Tìm kiếm sản phẩm...">
                                    <button class="btn btn-search" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-lg-3 order-md-3 order-2">
                    <div class="header-actions-section">
                        <div class="account-menu me-3">
                            <!-- User Info (visible when logged in) -->
                            <div id="nav-user-info" class="d-none">
                                <div class="dropdown">
                                    <a href="#" class="btn btn-outline-success dropdown-toggle d-flex align-items-center" 
                                       id="userAccountDropdown" role="button" data-bs-toggle="dropdown">
                                        <div class="user-avatar-container me-2">
                                            <img id="userAvatarImage" 
                                                 src="<%=request.getContextPath()%>/img/placeholder.jpg" 
                                                 alt="User Avatar" 
                                                 class="user-avatar rounded-circle"
                                                 style="width: 32px; height: 32px; object-fit: cover;">
                                        </div>
                                        <span class="d-none d-md-inline">
                                            <span class="greeting-text">Xin chào</span>
                                            <span id="userDisplayName" class="fw-bold">User</span>
                                        </span>
                                        <span class="d-md-none">
                                            <span id="userDisplayNameMobile" class="fw-bold">User</span>
                                        </span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><h6 class="dropdown-header d-flex align-items-center">
                                            <img id="userAvatarDropdown" 
                                                 src="<%=request.getContextPath()%>/img/placeholder.jpg" 
                                                 alt="User Avatar" 
                                                 class="user-avatar-small rounded-circle me-2"
                                                 style="width: 24px; height: 24px; object-fit: cover;">
                                            <span id="userFullName">User Name</span>
                                        </h6></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp">
                                            <i class="fas fa-user-edit me-2"></i>Thông tin tài khoản
                                        </a></li>
                                        <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-shopping-bag me-2"></i>Đơn hàng của tôi
                                        </a></li>
                                        <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-heart me-2"></i>Sản phẩm yêu thích
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="#" onclick="userLogout()">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <!-- Login Button (visible when not logged in) -->
                            <div id="nav-login-btn">
                                <div class="dropdown">
                                    <a href="#" class="btn btn-outline-primary dropdown-toggle" 
                                       id="accountDropdown" role="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-user me-1"></i>
                                        <span class="d-none d-md-inline">Tài khoản</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/login.jsp">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </a></li>
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/register.jsp">
                                            <i class="fas fa-user-plus me-2"></i>Đăng ký
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="cart-btn">
                            <a href="#" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-1"></i>
                                <span class="cart-count">0</span>
                                <span class="d-none d-lg-inline ms-1">Giỏ hàng</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    
    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />
    <main class="container my-5">
        <div class="row">
            <div class="col-md-3">
                <div class="profile-sidebar">                    <div class="text-center mb-4">
                        <img id="profileUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-2 avatar-80">
                        <h5 id="profileUserName">Đang tải...</h5>
                        <small id="profileUserEmail" class="text-muted">Đang tải...</small>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#" id="profileInfoTab"><i class="fas fa-user me-2"></i>Thông tin tài khoản</a>
                        <a class="nav-link" href="#" id="profileAddressTab"><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ <span class="badge bg-primary ms-1">0</span></a>
                        <a class="nav-link" href="#" id="profileOrdersTab"><i class="fas fa-box me-2"></i>Đơn hàng của bạn</a>
                        <a class="nav-link" href="#" id="profilePasswordTab"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a>
                        <a class="nav-link text-danger" href="#" id="profileLogoutBtn"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                    </nav>
                </div>
            </div>
            <div class="col-md-9">                <div class="profile-content" id="profileContent">
                    <!-- Nội dung từng tab sẽ được hiển thị ở đây -->
                    <div id="profileInfoContent">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-user-circle me-2"></i>Thông tin tài khoản</h4>
                            <button type="button" class="btn btn-outline-primary" id="editProfileBtn">
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa
                            </button>
                        </div>
                        
                        <!-- View Mode -->
                        <div id="profileViewMode">
                            <div class="row mt-4">
                                <div class="col-md-8">
                                    <div class="info-section">
                                        <h6 class="text-muted mb-3">Thông tin cá nhân</h6>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Họ tên:</strong></div>
                                            <div class="col-sm-8" id="displayUserName">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Email:</strong></div>
                                            <div class="col-sm-8" id="displayUserEmail">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Số điện thoại:</strong></div>
                                            <div class="col-sm-8" id="displayUserPhone">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Địa chỉ:</strong></div>
                                            <div class="col-sm-8" id="displayUserAddress">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Ngày sinh:</strong></div>
                                            <div class="col-sm-8" id="displayUserDateOfBirth">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Giới tính:</strong></div>
                                            <div class="col-sm-8" id="displayUserGender">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Vai trò:</strong></div>
                                            <div class="col-sm-8" id="displayUserRole">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Đăng nhập bằng:</strong></div>
                                            <div class="col-sm-8" id="displayLoginType">Đang tải...</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 text-center">
                                    <div class="avatar-section">
                                        <img id="displayUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-3 avatar-120">
                                        <div class="mt-2">
                                            <small class="text-muted" id="avatarSource">Ảnh đại diện</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Edit Mode -->
                        <div id="profileEditMode" style="display: none;">
                            <form id="updateProfileForm">
                                <div class="row mt-4">
                                    <div class="col-md-8">
                                        <div class="info-section">
                                            <h6 class="text-muted mb-3">Cập nhật thông tin cá nhân</h6>
                                            
                                            <div class="mb-3">
                                                <label for="editFirstName" class="form-label">Họ *</label>
                                                <input type="text" class="form-control" id="editFirstName" name="firstName" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editLastName" class="form-label">Tên *</label>
                                                <input type="text" class="form-control" id="editLastName" name="lastName" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editEmail" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="editEmail" name="email" readonly>
                                                <div class="form-text">Email không thể thay đổi</div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editPhone" class="form-label">Số điện thoại</label>
                                                <input type="tel" class="form-control" id="editPhone" name="phone" placeholder="Nhập số điện thoại">
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editAddress" class="form-label">Địa chỉ</label>
                                                <textarea class="form-control" id="editAddress" name="address" rows="3" placeholder="Nhập địa chỉ của bạn"></textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="editDateOfBirth" class="form-label">Ngày sinh</label>
                                                        <input type="date" class="form-control" id="editDateOfBirth" name="dateOfBirth">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="editGender" class="form-label">Giới tính</label>
                                                        <select class="form-control" id="editGender" name="gender">
                                                            <option value="">Chọn giới tính</option>
                                                            <option value="Nam">Nam</option>
                                                            <option value="Nữ">Nữ</option>
                                                            <option value="Khác">Khác</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn btn-success">
                                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                                </button>
                                                <button type="button" class="btn btn-secondary" id="cancelEditBtn">
                                                    <i class="fas fa-times me-2"></i>Hủy
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-center">
                                        <div class="avatar-section">
                                            <img id="editUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-3 avatar-120">
                                            <div class="mt-2">
                                                <small class="text-muted" id="editAvatarSource">Ảnh đại diện</small>
                                            </div>
                                            <div class="mt-2">
                                                <small class="text-info">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Ảnh đại diện từ Google không thể thay đổi
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/navbar-manager.js"></script>
    <script src="<%=request.getContextPath()%>/js/google-oauth-clean.js"></script>
    
    <!-- Address Book Script -->
    <script src="<%=request.getContextPath()%>/js/address-book.js"></script>
    
    <!-- Test Scripts -->
    <script src="<%=request.getContextPath()%>/js/address-api-test.js"></script>
    <script src="<%=request.getContextPath()%>/js/address-e2e-test.js"></script>
    
    <!-- Avatar Utils -->
    <script src="<%=request.getContextPath()%>/js/avatar-utils.js"></script>
    
    <!-- Authentication and Navbar Scripts -->
    <script src="<%=request.getContextPath()%>/js/auth-sync.js"></script>
    <script src="<%=request.getContextPath()%>/js/navbar-fix.js"></script>
    
    <script>
        // Set context path globally for JavaScript access
        window.APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
        console.log('App context path from JSP:', window.APP_CONTEXT_PATH);
    </script>
    
    <script>
        // Load profile data from API
        function loadProfileData() {
            let contextPath = '';
            if (window.APP_CONTEXT_PATH !== undefined) {
                contextPath = window.APP_CONTEXT_PATH;
            }
            
            fetch(contextPath + '/api/profile/info')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.userData) {
                    const userData = data.userData;
                    
                    // Update display elements
                    document.getElementById('displayUserName').textContent = userData.fullName || 'Chưa có thông tin';
                    document.getElementById('displayUserEmail').textContent = userData.email;
                    document.getElementById('displayUserPhone').textContent = userData.phone || 'Chưa có thông tin';
                    document.getElementById('displayUserAddress').textContent = userData.address || 'Chưa có thông tin';
                    document.getElementById('displayUserDateOfBirth').textContent = userData.dateOfBirth || 'Chưa có thông tin';
                    document.getElementById('displayUserGender').textContent = userData.gender || 'Chưa có thông tin';
                    
                    // Update role display
                    let roleText = userData.role;
                    if (userData.role === 'CUSTOMER') roleText = 'Khách hàng';
                    else if (userData.role === 'ADMIN') roleText = 'Quản trị viên';
                    else if (userData.role === 'STAFF') roleText = 'Nhân viên';
                    document.getElementById('displayUserRole').textContent = roleText;
                    
                    // Update login type display
                    let loginTypeText = userData.provider;
                    if (userData.provider === 'google') loginTypeText = 'Google OAuth';
                    else if (userData.provider === 'local') loginTypeText = 'Tài khoản nội bộ';
                    document.getElementById('displayLoginType').textContent = loginTypeText;
                    
                    // Populate edit form
                    document.getElementById('editFirstName').value = userData.firstName;
                    document.getElementById('editLastName').value = userData.lastName;
                    document.getElementById('editEmail').value = userData.email;
                    document.getElementById('editPhone').value = userData.phone;
                    document.getElementById('editAddress').value = userData.address;
                    document.getElementById('editDateOfBirth').value = userData.dateOfBirth;
                    document.getElementById('editGender').value = userData.gender;
                    
                    // Store in localStorage for persistence
                    localStorage.setItem('userName', userData.fullName);
                    localStorage.setItem('userPhone', userData.phone);
                    localStorage.setItem('userAddress', userData.address);
                    localStorage.setItem('userDateOfBirth', userData.dateOfBirth);
                    localStorage.setItem('userGender', userData.gender);
                }
            })
            .catch(error => {
                console.error('Error loading profile data:', error);
                // Fall back to session data if API fails
                loadFromSession();
            });
        }
        
        // Fallback function to load from session data
        function loadFromSession() {
        // Hiển thị thông tin người dùng từ session
            // Lấy thông tin từ session JSP
            const userName = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>';
            const userEmail = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>';
            const userPicture = '<%= session.getAttribute("userPicture") != null ? session.getAttribute("userPicture") : "" %>';
            const userRole = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "CUSTOMER" %>';
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            // Try to get additional info from localStorage (if available)
            const storedPhone = localStorage.getItem('userPhone') || '';
            const storedAddress = localStorage.getItem('userAddress') || '';
            const storedDateOfBirth = localStorage.getItem('userDateOfBirth') || '';
            const storedGender = localStorage.getItem('userGender') || '';
            
            // Split full name into first and last name
            let firstName = '';
            let lastName = '';
            if (userName && userName !== 'null' && userName !== '') {
                const nameParts = userName.split(' ');
                if (nameParts.length >= 2) {
                    firstName = nameParts.slice(0, -1).join(' ');
                    lastName = nameParts[nameParts.length - 1];
                } else {
                    firstName = userName;
                    lastName = '';
                }
            }
            
            // Update display elements
            document.getElementById('displayUserName').textContent = userName || 'Chưa có thông tin';
            document.getElementById('displayUserEmail').textContent = userEmail;
            document.getElementById('displayUserPhone').textContent = storedPhone || 'Chưa có thông tin';
            document.getElementById('displayUserAddress').textContent = storedAddress || 'Chưa có thông tin';
            document.getElementById('displayUserDateOfBirth').textContent = storedDateOfBirth || 'Chưa có thông tin';
            document.getElementById('displayUserGender').textContent = storedGender || 'Chưa có thông tin';
            
            // Populate edit form
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editEmail').value = userEmail;
            document.getElementById('editPhone').value = storedPhone;
            document.getElementById('editAddress').value = storedAddress;
            document.getElementById('editDateOfBirth').value = storedDateOfBirth;
            document.getElementById('editGender').value = storedGender;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Try to load from API first, fallback to session if needed
            if ('<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>') {
                loadProfileData();
            } else {
                loadFromSession();
            }
            
            // Load address count immediately for sidebar badge
            setTimeout(() => {
                if (typeof loadAddressCount === 'function') {
                    loadAddressCount();
                }
            }, 100);
            
            // Get session data for sidebar and other elements
            const userName = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>';
            const userEmail = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>';
            const userPicture = '<%= session.getAttribute("userPicture") != null ? session.getAttribute("userPicture") : "" %>';
            const userRole = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "CUSTOMER" %>';
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            // Cập nhật thông tin trong sidebar
            if (userName && userName !== 'null' && userName !== '') {
                document.getElementById('profileUserName').textContent = 'Xin chào, ' + userName;
            } else {
                document.getElementById('profileUserName').textContent = 'Chưa đăng nhập';
            }
            
            if (userEmail && userEmail !== 'null' && userEmail !== '') {
                document.getElementById('profileUserEmail').textContent = userEmail;
            } else {
                document.getElementById('profileUserEmail').textContent = 'Chưa có email';
            }
            
            // Cập nhật avatar
            if (userPicture && userPicture !== 'null' && userPicture !== '') {
                document.getElementById('profileUserAvatar').src = userPicture;
                document.getElementById('displayUserAvatar').src = userPicture;
                document.getElementById('editUserAvatar').src = userPicture;
                document.getElementById('avatarSource').textContent = 'Ảnh đại diện từ Google';
                document.getElementById('editAvatarSource').textContent = 'Ảnh đại diện từ Google';
            } else {
                // Generate Gravatar from email
                if (userEmail) {
                    const gravatarUrl = generateGravatarUrl(userEmail);
                    document.getElementById('profileUserAvatar').src = gravatarUrl;
                    document.getElementById('displayUserAvatar').src = gravatarUrl;
                    document.getElementById('editUserAvatar').src = gravatarUrl;
                    document.getElementById('avatarSource').textContent = 'Ảnh đại diện Gravatar';
                    document.getElementById('editAvatarSource').textContent = 'Ảnh đại diện Gravatar';
                }
            }
            
            // Setup edit mode handlers
            setupEditHandlers();
        });
        
        // Setup edit mode event handlers
        function setupEditHandlers() {
            // Edit button click
            document.getElementById('editProfileBtn').addEventListener('click', function() {
                document.getElementById('profileViewMode').style.display = 'none';
                document.getElementById('profileEditMode').style.display = 'block';
                this.style.display = 'none';
            });
            
            // Cancel edit button click
            document.getElementById('cancelEditBtn').addEventListener('click', function() {
                document.getElementById('profileEditMode').style.display = 'none';
                document.getElementById('profileViewMode').style.display = 'block';
                document.getElementById('editProfileBtn').style.display = 'block';
            });
            
            // Form submit
            document.getElementById('updateProfileForm').addEventListener('submit', function(e) {
                e.preventDefault();
                updateProfile();
            });
        }
        
        // Update profile function
        function updateProfile() {
            const formData = new FormData(document.getElementById('updateProfileForm'));
            const firstName = formData.get('firstName').trim();
            const lastName = formData.get('lastName').trim();
            const phone = formData.get('phone').trim();
            const address = formData.get('address').trim();
            const email = formData.get('email');
            const dateOfBirth = formData.get('dateOfBirth');
            const gender = formData.get('gender');
            
            // Validation
            if (!firstName || !lastName) {
                alert('Vui lòng nhập đầy đủ họ và tên!');
                return;
            }
            
            // Show loading
            const submitBtn = document.querySelector('#updateProfileForm button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang cập nhật...';
            submitBtn.disabled = true;
            
            // Prepare update data
            const updateData = {
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                address: address,
                email: email,
                dateOfBirth: dateOfBirth,
                gender: gender
            };
            
            // Get context path
            let contextPath = '';
            if (window.APP_CONTEXT_PATH !== undefined) {
                contextPath = window.APP_CONTEXT_PATH;
            }
            
            // Send update request
            fetch(contextPath + '/api/profile/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updateData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('Update response:', data);
                
                if (data.success) {
                    // Update displayed information
                    const fullName = firstName + ' ' + lastName;
                    document.getElementById('displayUserName').textContent = fullName;
                    document.getElementById('profileUserName').textContent = 'Xin chào, ' + fullName;
                    document.getElementById('displayUserPhone').textContent = phone || 'Chưa có thông tin';
                    document.getElementById('displayUserAddress').textContent = address || 'Chưa có thông tin';
                    document.getElementById('displayUserDateOfBirth').textContent = dateOfBirth || 'Chưa có thông tin';
                    document.getElementById('displayUserGender').textContent = gender || 'Chưa có thông tin';
                    
                    // Store in localStorage for persistence
                    localStorage.setItem('userName', fullName);
                    localStorage.setItem('userPhone', phone);
                    localStorage.setItem('userAddress', address);
                    localStorage.setItem('userDateOfBirth', dateOfBirth);
                    localStorage.setItem('userGender', gender);
                    
                    // Switch back to view mode
                    document.getElementById('profileEditMode').style.display = 'none';
                    document.getElementById('profileViewMode').style.display = 'block';
                    document.getElementById('editProfileBtn').style.display = 'block';
                    
                    // Show success message
                    showNotification('Cập nhật thông tin thành công!', 'success');
                } else {
                    throw new Error(data.message || 'Cập nhật thất bại');
                }
            })
            .catch(error => {
                console.error('Update error:', error);
                showNotification('Lỗi cập nhật: ' + error.message, 'error');
            })
            .finally(() => {
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        }
        
        // Generate Gravatar URL
        function generateGravatarUrl(email) {
            if (!email) return '/img/default-avatar.png';
            
            // Simple hash function for demonstration
            let hash = 0;
            for (let i = 0; i < email.length; i++) {
                const char = email.charCodeAt(i);
                hash = ((hash << 5) - hash) + char;
                hash = hash & hash; // Convert to 32bit integer
            }
            const hashStr = Math.abs(hash).toString(16);
            return 'https://www.gravatar.com/avatar/' + hashStr + '?d=identicon&s=120';
        }
        
        // Show notification
        function showNotification(message, type = 'info') {
            // Create notification element
            const notification = document.createElement('div');
            const alertType = type === 'success' ? 'success' : 'danger';
            const iconType = type === 'success' ? 'check-circle' : 'exclamation-circle';
            
            notification.className = 'alert alert-' + alertType + ' alert-dismissible fade show position-fixed';
            notification.style.cssText = 'top: 20px; right: 20px; z-index: 1060; min-width: 300px;';
            notification.innerHTML = 
                '<i class="fas fa-' + iconType + ' me-2"></i>' +
                message +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            document.body.appendChild(notification);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, 5000);
        }
        
        // Xử lý tab switching
        document.getElementById('profileInfoTab').onclick = function(e) {
            e.preventDefault();
            // Remove active class from all tabs
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Show profile info content (đã có sẵn)
            const profileContent = document.getElementById('profileContent');
            profileContent.innerHTML = document.getElementById('profileInfoContent').outerHTML;
        };
        
        document.getElementById('profileAddressTab').onclick = async function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            // Load address book content
            const profileContent = document.getElementById('profileContent');
            profileContent.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';
            
            try {
                console.log('=== LOADING ADDRESS BOOK TAB ===');
                
                // Đảm bảo script address-book.js đã load
                if (typeof createAddressBookHTML === 'function') {
                    console.log('Creating address book HTML...');
                    const addressBookHTML = await createAddressBookHTML();
                    console.log('Address book HTML created, setting innerHTML...');
                    profileContent.innerHTML = addressBookHTML;
                    console.log('Address book tab loaded successfully');
                    
                    // Force refresh sau khi load để đảm bảo data mới nhất
                    if (typeof forceRefreshAddresses === 'function') {
                        console.log('Force refreshing addresses after tab load...');
                        setTimeout(() => {
                            forceRefreshAddresses();
                        }, 100);
                    }
                } else {
                    throw new Error('Address book script not loaded');
                }
            } catch (error) {
                console.error('Error loading address book:', error);
                profileContent.innerHTML = 
                    '<div class="alert alert-danger">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>' +
                    'Có lỗi xảy ra khi tải sổ địa chỉ. Vui lòng thử lại.' +
                    '<br><button class="btn btn-sm btn-outline-primary mt-2" onclick="location.reload()">Tải lại trang</button>' +
                    '</div>';
            }
        };
        
        document.getElementById('profileOrdersTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = `
                <h4><i class="fas fa-box me-2"></i>Đơn hàng của bạn</h4>
                <div id="order-history-list" class="mt-4">
                    <div class="text-muted">Đang tải dữ liệu...</div>
                </div>
                
                <!-- Modal Gửi Khiếu Nại -->
                <div class="modal fade" id="complaintModal" tabindex="-1" aria-labelledby="complaintModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <form id="complaintForm" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Gửi khiếu nại đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="complaintOrderId">
                                <div class="mb-3">
                                    <label for="complaintCategory" class="form-label">Danh mục (tùy chọn)</label>
                                    <select class="form-select" id="complaintCategory">
                                        <option value="">-- Chọn danh mục khiếu nại --</option>
                                        <option value="Giao hàng trễ">Giao hàng trễ</option>
                                        <option value="Hỏng sản phẩm">Hỏng sản phẩm</option>
                                        <option value="Thiếu hàng">Thiếu hàng</option>
                                        <option value="Sai hàng">Sai hàng</option>
                                        <option value="Không đúng mô tả">Không đúng mô tả</option>
                                        <option value="Không hoạt động">Không hoạt động</option>
                                        <option value="Chất lượng kém">Chất lượng kém</option>
                                        <option value="Lý do khác">Lý do khác</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="complaintContent" class="form-label">Nội dung khiếu nại *</label>
                                    <textarea class="form-control" id="complaintContent" rows="4" required></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Gửi khiếu nại</button>
                            </div>
                        </form>
                    </div>
                </div>
            `;
            
            // Load order history
            loadOrderHistory();
        };
        
        document.getElementById('profilePasswordTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = 
                '<h4><i class="fas fa-key me-2"></i>Đổi mật khẩu</h4>' +
                '<div class="alert alert-warning mt-4">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>' +
                    'Chức năng này sẽ được cập nhật trong phiên bản tiếp theo.' +
                '</div>';
        };
        
        // Xử lý đăng xuất
        document.getElementById('profileLogoutBtn').onclick = function(e) {
            e.preventDefault();
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                logoutUser();
            }
        };
        
        // Function đăng xuất
        function logoutUser() {
            // Gọi API logout của Spring Security OAuth2
            fetch('/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            }).then(() => {
                // Clear session storage
                sessionStorage.clear();
                localStorage.clear();
                
                // Redirect về trang chủ
                window.location.href = '/';
            }).catch(error => {
                console.error('Logout error:', error);
                // Fallback: redirect về trang chủ dù có lỗi
                window.location.href = '/';
            });
        }
        
        // Functions for order history
        async function loadOrderHistory() {
            const orderHistoryList = document.getElementById('order-history-list');
            try {
                const resp = await fetch('/api/orders/history', { headers: { 'Accept': 'application/json' } });
                if (!resp.ok) throw new Error('Lỗi xác thực hoặc máy chủ');
                const data = await resp.json();
                if (!Array.isArray(data)) {
                    orderHistoryList.innerHTML = '<div class="text-danger">' + (data.message || 'Không lấy được dữ liệu!') + '</div>';
                    return;
                }
                if (data.length === 0) {
                    orderHistoryList.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>Bạn chưa có đơn hàng nào. <a href="/" class="alert-link">Khám phá sản phẩm ngay!</a></div>';
                    return;
                }
                let html = '<div class="table-responsive"><table class="table table-bordered align-middle order-table"><thead class="table-light"><tr>' +
                    '<th>Hình ảnh</th><th>Mã đơn</th><th>Tên sản phẩm</th><th>Ngày đặt</th><th>Trạng thái</th><th>Tổng tiền</th><th>Hành động</th></tr></thead><tbody>';
                data.forEach(order => {
                    const product = order.firstProduct || {};
                    html += '<tr>' +
                        '<td style="width:70px">' + (product.image ? '<img src="' + product.image + '" alt="Ảnh" style="max-width:60px;max-height:60px;object-fit:cover;">' : '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td class="fw-bold">' + order.orderNumber + '</td>' +
                        '<td>' + (product.name || '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td>' + (order.orderDate ? new Date(order.orderDate).toLocaleString('vi-VN') : '') + '</td>' +
                        '<td>' + renderStatus(order.status) + '</td>' +
                        '<td class="text-danger fw-bold">' + formatCurrency(order.totalAmount) + '₫</td>' +
                        '<td>' + renderCancelBtn(order) + '</td>' +
                        '</tr>';
                });
                html += '</tbody></table></div>';
                orderHistoryList.innerHTML = html;
            } catch (e) {
                orderHistoryList.innerHTML = '<div class="text-danger">Lỗi tải dữ liệu!</div>';
            }
        }

        function formatCurrency(num) {
            if (!num) return '0';
            return Number(num).toLocaleString('vi-VN');
        }

        function renderStatus(status) {
            return '<span class="order-status ' + status + '">' + status + '</span>';
        }

        function renderCancelBtn(order) {
            if (["PENDING", "CONFIRMED", "PROCESSING"].includes(order.status)) {
                return '<button class="btn btn-danger btn-sm" onclick="cancelOrder(' + order.id + ', this)"><i class="fas fa-trash-alt me-1"></i>Hủy đơn</button>';
            } else if (order.status === "DELIVERED") {
                return '<button class="btn btn-warning btn-sm" onclick="sendComplaint(' + order.id + ', this)"><i class="fas fa-exclamation-circle me-1"></i>Gửi khiếu nại</button>';
            }
            return '';
        }

        window.cancelOrder = async function (orderId, btn) {
            if (!confirm('Bạn chắc chắn muốn xóa/hủy đơn hàng này?')) return;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xóa...';
            try {
                const resp = await fetch('/api/orders/' + orderId + '/cancel', { method: 'POST' });
                const data = await resp.json();
                if (data.success) {
                    btn.closest('tr').remove();
                    alert('Đã xóa/hủy đơn hàng thành công!');
                } else {
                    alert(data.message || 'Không thể xóa!');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
                }
            } catch (e) {
                alert('Lỗi kết nối máy chủ!');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
            }
        }

        window.sendComplaint = function (orderId) {
            document.getElementById('complaintOrderId').value = orderId;
            document.getElementById('complaintForm').reset();
            const modal = new bootstrap.Modal(document.getElementById('complaintModal'));
            modal.show();
        };

        // Handle complaint form submission
        document.addEventListener('submit', async function(e) {
            if (e.target && e.target.id === 'complaintForm') {
                e.preventDefault();
                const orderId = document.getElementById('complaintOrderId').value;
                const category = document.getElementById('complaintCategory').value.trim();
                const content = document.getElementById('complaintContent').value.trim();

                if (!content) {
                    alert('Vui lòng nhập nội dung khiếu nại!');
                    return;
                }

                try {
                    const resp = await fetch('/api/complaints/create', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ orderId, category, content })
                    });
                    const data = await resp.json();
                    if (data.success) {
                        alert('Gửi khiếu nại thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('complaintModal')).hide();
                    } else {
                        alert(data.message || 'Gửi khiếu nại thất bại!');
                    }
                } catch (err) {
                    alert('Lỗi kết nối máy chủ!');
                }
            }
        });
    </script>
    
    <!-- Hamburger Menu Script -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    
    <!-- Force check auth state after page load -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Force check auth state multiple times to ensure sync
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 100);
            
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 500);
        });
    </script>
</body>
</html>
