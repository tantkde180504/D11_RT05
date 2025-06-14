<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/login.css" rel="stylesheet">
</head>
<body class="login-page">
    <!-- Header -->
    <header class="bg-white shadow-sm">
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
                            <li class="nav-item">
                                <a class="nav-link" href="#">Sản phẩm</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">Liên hệ</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="login-main">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="login-container">
                        <div class="row">
                            <!-- Login Form -->
                            <div class="col-md-6">
                                <div class="login-form-section">
                                    <h2 class="login-title">Đăng nhập</h2>
                                    
                                    <form id="loginForm" action="<%=request.getContextPath()%>/login" method="post">
                                        <div class="mb-3">
                                            <label for="email" class="form-label">Email *</label>
                                            <input type="email" class="form-control" id="email" name="email" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="password" class="form-label">Mật khẩu *</label>
                                            <div class="password-input-wrapper">
                                                <input type="password" class="form-control" id="password" name="password" required>
                                                <button type="button" class="password-toggle" onclick="togglePassword()">
                                                    <i class="fas fa-eye" id="passwordIcon"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                                                <label class="form-check-label" for="rememberMe">
                                                    Ghi nhớ đăng nhập
                                                </label>
                                            </div>
                                        </div>
                                          <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="isAdmin" name="isAdmin">
                                                <label class="form-check-label" for="isAdmin">
                                                    Đăng nhập với quyền Admin
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="isStaff" name="isStaff">
                                                <label class="form-check-label" for="isStaff">
                                                    Đăng nhập với quyền Staff
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-primary btn-login w-100">
                                            Đăng nhập
                                        </button>
                                    </form>
                                    
                                    <div class="login-options">
                                        <div class="text-center my-3">
                                            <span class="text-muted">hoặc</span>
                                        </div>
                                        
                                        <div class="social-login">
                                            <button type="button" class="btn btn-outline-danger w-100">
                                                <i class="fab fa-google me-2"></i>
                                                Đăng nhập với Google
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="login-links text-center mt-4">
                                        <p>
                                            <a href="#" class="forgot-password-link">Quên mật khẩu?</a>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Register Form -->
                            <div class="col-md-6">
                                <div class="register-form-section">
                                    <h2 class="register-title">Đăng ký tài khoản mới</h2>
                                    <p class="register-subtitle text-muted">Tạo tài khoản để trải nghiệm mua sắm tốt hơn</p>
                                    
                                    <form id="registerForm" action="<%=request.getContextPath()%>/register" method="post">
                                        <div class="mb-3">
                                            <label for="firstName" class="form-label">Họ *</label>
                                            <input type="text" class="form-control" id="firstName" name="firstName" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="lastName" class="form-label">Tên *</label>
                                            <input type="text" class="form-control" id="lastName" name="lastName" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="registerEmail" class="form-label">Email *</label>
                                            <input type="email" class="form-control" id="registerEmail" name="email" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="registerPassword" class="form-label">Mật khẩu *</label>
                                            <div class="password-input-wrapper">
                                                <input type="password" class="form-control" id="registerPassword" name="password" required>
                                                <button type="button" class="password-toggle" onclick="toggleRegisterPassword()">
                                                    <i class="fas fa-eye" id="registerPasswordIcon"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu *</label>
                                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="agreeTerms" name="agreeTerms" required>
                                                <label class="form-check-label" for="agreeTerms">
                                                    Tôi đồng ý với <a href="#" class="text-primary">Điều khoản sử dụng</a> và <a href="#" class="text-primary">Chính sách bảo mật</a>
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="form-check">
                                                <input class="form-check-input" type="checkbox" id="newsletter" name="newsletter">
                                                <label class="form-check-label" for="newsletter">
                                                    Đăng ký nhận tin khuyến mãi và sản phẩm mới
                                                </label>
                                            </div>
                                        </div>
                                        
                                        <button type="submit" class="btn btn-success btn-register w-100">
                                            Tạo tài khoản
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <p>&copy; 2025 43 Gundam Hobby. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-end">
                    <a href="#" class="text-white-50 me-3">Chính sách bảo mật</a>
                    <a href="#" class="text-white-50">Điều khoản sử dụng</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/login.js"></script>
</body>
</html>
