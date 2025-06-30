<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>43 Gundam Hobby - Mô hình Gundam chính hãng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/login-anhobby.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="bg-white shadow-sm sticky-top">
        <div class="container">
            <div class="row align-items-center py-3">
                <div class="col-lg-2 col-md-3">
                    <div class="logo">
                        <a href="<%=request.getContextPath()%>/">
                            <img src="<%=request.getContextPath()%>/img/logo.png" alt="43 Gundam Logo" class="logo-img">
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 col-md-5">
                    <div class="search-container">
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
                <div class="col-lg-4 col-md-4">
                    <div class="header-actions d-flex justify-content-end align-items-center">
                        <div class="account-menu me-3">
                            <div class="dropdown">
                                <a href="#" class="btn btn-outline-primary dropdown-toggle" 
                                   id="accountDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user me-1"></i>
                                    <span>Tài khoản</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li id="guestLoginOption"><a class="dropdown-item" href="<%=request.getContextPath()%>/login.jsp">
                                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                    </a></li>
                                    <li id="userMenu" class="d-none">
                                        <span class="dropdown-item disabled"><i class="fas fa-user me-2"></i>Xin chào, <span id="userName">User</span></span>
                                    </li>
                                    <li id="userAccountOption" class="d-none"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp">
                                        <i class="fas fa-id-card me-2"></i>Thông tin tài khoản
                                    </a></li>
                                    <li id="userOrdersOption" class="d-none"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp" onclick="document.getElementById('profileOrdersTab').click();return false;">
                                        <i class="fas fa-box me-2"></i>Đơn hàng của bạn
                                    </a></li>
                                    <li id="userDivider" class="d-none"><hr class="dropdown-divider"></li>
                                    <li id="userLogoutOption" class="d-none"><a class="dropdown-item text-danger" href="#" onclick="userLogout()">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a></li>
                                    <li><a class="dropdown-item" href="<%=request.getContextPath()%>/register.jsp">
                                        <i class="fas fa-user-plus me-2"></i>Đăng ký
                                    </a></li>
                                </ul>
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
    </header>    <!-- Navigation Bar giống anhobbystore.com -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top py-0 position-relative">
        <div class="container position-relative">
            <!-- Nút danh mục sản phẩm -->
            <div class="d-none d-lg-block position-relative">
                <button class="btn btn-outline-primary fw-bold px-4 py-2 me-3" id="categoryBtn" type="button">
                    <i class="fas fa-bars me-2"></i> DANH MỤC SẢN PHẨM
                </button>
                <div class="category-popup shadow" id="categoryPopup">
                    <div class="category-item">Gundam Bandai</div>
                    <div class="category-item">Mô hình Trung</div>
                    <div class="category-item">Metal Build - Diecast</div>
                    <div class="category-item">Dụng cụ - Tool</div>
                    <div class="category-item">Phụ kiện - Base</div>
                    <div class="category-item">Mô hình Dragon Ball</div>
                    <div class="category-item">Sơn - Decal</div>
                </div>
            </div>
            <!-- Menu -->
            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link fw-bold" href="<%=request.getContextPath()%>/all-products.jsp">Tất cả sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link fw-bold" href="#">HÀNG MỚI VỀ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link fw-bold" href="#">HÀNG PRE-ORDER</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" id="phukienDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            PHỤ KIỆN & MÔ HÌNH
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="phukienDropdown">
                            <li><a class="dropdown-item" href="#">Dụng cụ - Tool</a></li>
                            <li><a class="dropdown-item" href="#">Phụ kiện - Base</a></li>
                            <li><a class="dropdown-item" href="#">Mô hình Dragon Ball</a></li>
                        </ul>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" id="bandaiDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            BANDAI
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="bandaiDropdown">
                            <li><a class="dropdown-item" href="#">High Grade (HG)</a></li>
                            <li><a class="dropdown-item" href="#">Master Grade (MG)</a></li>
                            <li><a class="dropdown-item" href="#">Real Grade (RG)</a></li>
                            <li><a class="dropdown-item" href="#">Perfect Grade (PG)</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>        <div class="container d-flex flex-column align-items-center justify-content-center min-height-70vh">
        <div class="login-title mt-4">Đăng nhập tài khoản</div>
          <!-- Test Data Info -->
        <div class="alert alert-info mb-3 login-info-box">
            <strong>Test login endpoint:</strong><br>
            Endpoint: /api/login đã sẵn sàng<br>
            Sử dụng email/password từ database SQL Server Azure để login<br>
            <small>Role sẽ được chuyển hướng: ADMIN → dashboard.jsp, STAFF → staffsc.jsp, CUSTOMER → index.jsp</small>
        </div>
          <div class="login-form-box mx-auto" id="login-form">
            <form id="loginForm" action="/api/login" method="post" autocomplete="off">
                <div class="mb-3">
                    <label for="email" class="form-label">Email *</label>
                    <input type="email" class="form-control" id="email" name="email" required autocomplete="off">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu *</label>
                    <input type="password" class="form-control" id="password" name="password" required autocomplete="off">
                </div>
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <a href="#" class="forgot-password-link">Quên mật khẩu?</a>
                </div>
                <button type="submit" class="btn btn-login w-100">Đăng nhập</button>
            </form>
            <div class="login-divider">Hoặc đăng nhập bằng</div>
            <button type="button" class="btn btn-outline-danger social-login-btn" id="google-sign-in-btn">
                <i class="fab fa-google me-2"></i>Google
            </button>
            <div class="register-link">
                Bạn chưa có tài khoản? <a href="<%=request.getContextPath()%>/register.jsp">Đăng ký tại đây</a>
            </div>
        </div>
        
        <!-- User Info Display (hidden by default) -->
        <div id="user-info" class="login-form-box mx-auto d-none">
            <!-- Content will be populated by JavaScript -->
        </div>
    </div>
    <footer class="bg-white text-center py-3 mt-5 border-top footer-small">
        <div class="container">
            <div class="mb-1">
                © 2025 43 Gundam Hobby. All rights reserved.
            </div>
            <div>
                <a href="#" class="me-3 text-decoration-none text-muted">Chính sách bảo mật</a>
                <a href="#" class="me-3 text-decoration-none text-muted">Điều khoản sử dụng</a>
                <span class="me-3">Hotline: <a href="tel:0349999943" class="text-primary text-decoration-none">0349 999 943</a></span>
                <a href="mailto:43gundamhobby@gmail.com" class="text-muted text-decoration-none">43gundamhobby@gmail.com</a>
            </div>
        </div>    </footer>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/login-simple.js"></script>
    <script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>
</body>
</html>
