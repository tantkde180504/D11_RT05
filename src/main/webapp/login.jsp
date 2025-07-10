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
    <link href="<%=request.getContextPath()%>/css/navbar-fix.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/user-avatar.css" rel="stylesheet">
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
                            <form class="search-form" action="<%=request.getContextPath()%>/search.jsp" method="get">
                                <div class="input-group">
                                    <input type="text" name="q" class="form-control search-input" 
                                           placeholder="Tìm kiếm sản phẩm..." autocomplete="off">
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
    </header>    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Login Form -->
    <div class="container d-flex flex-column align-items-center justify-content-center min-height-70vh">
        <div class="login-title mt-4">Đăng nhập tài khoản</div>
        
        <div class="login-form-box mx-auto" id="login-form">
            <form id="loginForm" action="<%=request.getContextPath()%>/api/login" method="post" autocomplete="off">
                <div class="mb-3">
                    <label for="email" class="form-label">Email *</label>
                    <input type="email" class="form-control" id="email" name="email" required autocomplete="off">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu *</label>
                    <input type="password" class="form-control" id="password" name="password" required autocomplete="off">
                </div>
                <button type="submit" class="btn btn-login w-100">Đăng nhập</button>
            </form>
            <div class="text-center mb-3">
                <button type="button" class="btn btn-link p-0 text-decoration-none forgot-password-link" onclick="window.location.href='<%=request.getContextPath()%>/forgot-password.jsp'">
                    Quên mật khẩu?
                </button>
                <br>
                <small class="text-muted">hoặc</small>
                <br>
                <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="text-primary">Khôi phục mật khẩu</a>
            </div>
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
    <!-- Footer -->
    <footer class="bg-dark text-white">
        <div class="footer-top py-5">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="footer-section">
                            <h5 class="footer-title">43 Gundam Hobby</h5>
                            <p class="footer-desc">Chuyên cung cấp mô hình Gundam chính hãng với giá tốt nhất. Uy tín - Chất lượng - Dịch vụ tận tâm.</p>
                            <div class="store-info">
                                <div class="info-item mb-2">
                                    <i class="fas fa-map-marker-alt me-2"></i>
                                    <span>59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng</span>
                                </div>
                                <div class="info-item mb-2">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:0385546145" class="text-white">0385546145 (8h-20h)</a>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-envelope me-2"></i>
                                    <a href="mailto:43gundamhobby@gmail.com" class="text-white">43gundamhobby@gmail.com</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Sản phẩm</h6>
                            <ul class="footer-links">
                                <li><a href="#">Gundam Bandai</a></li>
                                <li><a href="#">High Grade (HG)</a></li>
                                <li><a href="#">Master Grade (MG)</a></li>
                                <li><a href="#">Real Grade (RG)</a></li>
                                <li><a href="#">Perfect Grade (PG)</a></li>
                                <li><a href="#">Metal Build</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Dịch vụ</h6>
                            <ul class="footer-links">
                                <li><a href="#">Hàng Pre-Order</a></li>
                                <li><a href="#">Dụng cụ & Phụ kiện</a></li>
                                <li><a href="#">Hướng dẫn lắp ráp</a></li>
                                <li><a href="#">Sơn & Trang trí</a></li>
                                <li><a href="#">Bảo hành sản phẩm</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Chính sách</h6>
                            <ul class="footer-links">
                                <li><a href="#">Chính sách bảo mật</a></li>
                                <li><a href="#">Chính sách thanh toán</a></li>
                                <li><a href="#">Chính sách vận chuyển</a></li>
                                <li><a href="#">Chính sách đổi trả</a></li>
                                <li><a href="#">Quy định sử dụng</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Hỗ trợ</h6>
                            <ul class="footer-links">
                                <li><a href="#">Liên hệ</a></li>
                                <li><a href="#">FAQ</a></li>
                                <li><a href="#">Hướng dẫn đặt hàng</a></li>
                                <li><a href="#">Tra cứu đơn hàng</a></li>
                                <li><a href="#">Hỗ trợ kỹ thuật</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-social py-4 bg-darker">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h6 class="social-title mb-3">Theo dõi chúng tôi</h6>
                        <div class="social-links">
                            <a href="#" class="social-link facebook">
                                <i class="fab fa-facebook-f"></i>
                                <span>Facebook</span>
                            </a>
                            <a href="#" class="social-link youtube">
                                <i class="fab fa-youtube"></i>
                                <span>Youtube</span>
                            </a>
                            <a href="#" class="social-link tiktok">
                                <i class="fab fa-tiktok"></i>
                                <span>TikTok</span>
                            </a>
                            <a href="#" class="social-link instagram">
                                <i class="fab fa-instagram"></i>
                                <span>Instagram</span>
                            </a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="newsletter">
                            <h6 class="newsletter-title mb-3">Đăng ký nhận tin</h6>
                            <form class="newsletter-form">
                                <div class="input-group">
                                    <input type="email" class="form-control" placeholder="Nhập email của bạn...">
                                    <button class="btn btn-primary" type="submit">
                                        <i class="fas fa-paper-plane"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom py-3 bg-darker border-top border-secondary">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="copyright mb-0">&copy; 2025 43 Gundam Hobby. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <div class="payment-methods">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=VISA" alt="Visa" class="payment-icon">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=MC" alt="Mastercard" class="payment-icon">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=COD" alt="COD" class="payment-icon">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- MD5 Library for Gravatar -->
    <script src="<%=request.getContextPath()%>/js/md5.min.js"></script>
    
    <!-- Email to Google Converter -->
    <script src="<%=request.getContextPath()%>/js/email-to-google-converter.js"></script>
    
    <!-- Unified Navbar Manager -->
    <script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>
    
    <!-- Google OAuth Handler -->
    <script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>
    
    <!-- Login Script -->
    <script src="<%=request.getContextPath()%>/js/login-clean.js"></script>
    
    <!-- Hamburger Menu -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    
    <!-- Login Fallback Handler (if API is not available) -->
    <!-- <script src="<%=request.getContextPath()%>/js/login-fallback.js"></script> -->
    
    <!-- Hamburger Menu Script -->
    <!-- <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script> -->
    
    <!-- Login Debug Helper (Development Only) -->
    <!-- <script src="<%=request.getContextPath()%>/js/login-debug-helper.js"></script> -->
    
    <!-- Login Debug Fix - Sửa lỗi navbar sau login -->
    <!-- <script src="<%=request.getContextPath()%>/js/login-debug-fix.js"></script> -->
    
    <!-- Comprehensive Auth Manager - Đảm bảo auth state luôn đúng -->
    <!-- <script src="<%=request.getContextPath()%>/js/comprehensive-auth-manager.js"></script> -->
    
    <!-- Context Path Test Script (Development Only) -->
    <!-- <script src="<%=request.getContextPath()%>/js/context-path-test.js"></script> -->
    
    <script>
        // Back to top functionality
        const backToTopBtn = document.getElementById('backToTop');
        
        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 300) {
                backToTopBtn.classList.add('show');
            } else {
                backToTopBtn.classList.remove('show');
            }
        });
        
        backToTopBtn.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
        
        // Set context path globally for JavaScript access
        window.APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
        console.log('App context path from JSP:', window.APP_CONTEXT_PATH);
        
        // Debug: Add click handler for forgot password link
        document.addEventListener('DOMContentLoaded', function() {
            const forgotPasswordLink = document.getElementById('forgot-password-link');
            if (forgotPasswordLink) {
                console.log('Forgot password link found:', forgotPasswordLink);
                console.log('Link href:', forgotPasswordLink.href);
                
                // Add click event listener to debug
                forgotPasswordLink.addEventListener('click', function(e) {
                    console.log('🔗 Forgot password link clicked!');
                    console.log('Event:', e);
                    console.log('Target:', e.target);
                    console.log('Default prevented?', e.defaultPrevented);
                    
                    // Force navigation if something is preventing it
                    if (e.defaultPrevented) {
                        console.log('⚠️ Default prevented! Forcing navigation...');
                        window.location.href = this.href;
                    }
                });
                
                // Test click programmatically
                setTimeout(() => {
                    console.log('Testing programmatic click...');
                    console.log('Link is:', forgotPasswordLink);
                    console.log('Link href is:', forgotPasswordLink.href);
                }, 2000);
                
            } else {
                console.error('❌ Forgot password link not found!');
            }
        });
    </script>
</body>
</html>
