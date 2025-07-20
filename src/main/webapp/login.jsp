<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>43 Gundam Hobby - Mô hình Gundam chính hãng</title>
    
    <!-- Unified CSS - Single source for consistent styling -->
    <jsp:include page="includes/unified-css.jsp" />
</head>
<body>
    <!-- Unified Header - Single source for all pages -->
    <jsp:include page="includes/unified-header.jsp" />
    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Login Form -->
    <div class="container-fluid bg-light py-5">
        <div class="container">
            <div class="row justify-content-center align-items-center min-vh-75">
                <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-5 col-xxl-4">
                    <!-- Login Card -->
                    <div class="card shadow-lg border-0 rounded-4">
                        <div class="card-body p-4 p-sm-5">
                            <!-- Login Header -->
                            <div class="text-center mb-4">
                                <h2 class="fw-bold text-primary mb-2">Đăng nhập tài khoản</h2>
                                <p class="text-muted mb-0">Chào mừng bạn quay trở lại!</p>
                            </div>
                            
                            <!-- Login Form -->
                            <form id="loginForm" action="<%=request.getContextPath()%>/api/login" method="post" autocomplete="off">
                                <div class="mb-3">
                                    <label for="email" class="form-label fw-semibold">
                                        <i class="fas fa-envelope me-2 text-primary"></i>Email
                                    </label>
                                    <input type="email" class="form-control form-control-lg rounded-3" 
                                           id="email" name="email" 
                                           placeholder="Nhập email của bạn..." 
                                           required autocomplete="off">
                                </div>
                                
                                <div class="mb-4">
                                    <label for="password" class="form-label fw-semibold">
                                        <i class="fas fa-lock me-2 text-primary"></i>Mật khẩu
                                    </label>
                                    <input type="password" class="form-control form-control-lg rounded-3" 
                                           id="password" name="password" 
                                           placeholder="Nhập mật khẩu..." 
                                           required autocomplete="off">
                                </div>
                                
                                <div class="d-grid mb-3">
                                    <button type="submit" class="btn btn-primary btn-lg rounded-3 fw-semibold">
                                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                    </button>
                                </div>
                            </form>
                            
                            <!-- Forgot Password Section -->
                            <div class="text-center mb-4">
                                <button type="button" class="btn btn-link p-0 text-decoration-none small" 
                                        onclick="window.location.href='<%=request.getContextPath()%>/forgot-password.jsp'">
                                    <i class="fas fa-question-circle me-1"></i>Quên mật khẩu?
                                </button>
                            </div>
                            
                            <!-- Divider -->
                            <div class="position-relative mb-4">
                                <hr class="border-secondary-subtle">
                                <div class="position-absolute top-50 start-50 translate-middle bg-white px-3">
                                    <small class="text-muted fw-medium">Hoặc đăng nhập bằng</small>
                                </div>
                            </div>
                            
                            <!-- Social Login -->
                            <div class="d-grid mb-4">
                                <button type="button" class="btn btn-outline-danger btn-lg rounded-3" id="google-sign-in-btn">
                                    <i class="fab fa-google me-2"></i>
                                    <span class="fw-semibold">Đăng nhập với Google</span>
                                </button>
                            </div>
                            
                            <!-- Register Link -->
                            <div class="text-center">
                                <p class="mb-0 text-muted">
                                    Bạn chưa có tài khoản? 
                                    <a href="<%=request.getContextPath()%>/register.jsp" 
                                       class="text-primary text-decoration-none fw-semibold">
                                        Đăng ký ngay
                                    </a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- User Info Display (hidden by default) -->
        <div id="user-info" class="d-none">
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
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=HG">High Grade (HG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=MG">Master Grade (MG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=RG">Real Grade (RG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=PG">Perfect Grade (PG)</a></li>
                                <li><a href="#">Metal Build</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Dịch vụ</h6>
                            <ul class="footer-links">
                                <li><a href="#">Hàng Pre-Order</a></li>
                                <li><a href="<%=request.getContextPath()%>/tools-accessories.jsp">Dụng cụ & Phụ kiện</a></li>
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
                                <li><a href="<%=request.getContextPath()%>/privacy-policy.jsp">Chính sách bảo mật</a></li>
                                <li><a href="<%=request.getContextPath()%>/payment-policy.jsp">Chính sách thanh toán</a></li>
                                <li><a href="<%=request.getContextPath()%>/shipping-policy.jsp">Chính sách vận chuyển</a></li>
                                <li><a href="<%=request.getContextPath()%>/shipping-policy.jsp">Chính sách đổi trả</a></li>
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
                            <a href="https://www.facebook.com/BANDAIHobbysite.EN" target="_blank" rel="noopener noreferrer" class="social-link facebook">
                                <i class="fab fa-facebook-f"></i>
                                <span>Facebook</span>
                            </a>
                            <a href="https://www.youtube.com/@GundamInfo" target="_blank" rel="noopener noreferrer" class="social-link youtube">
                                <i class="fab fa-youtube"></i>
                                <span>Youtube</span>
                            </a>
                            <a href="https://www.tiktok.com/@bandainamcoasiahobby_?is_from_webapp=1&sender_device=pc" target="_blank" rel="noopener noreferrer" class="social-link tiktok">
                                <i class="fab fa-tiktok"></i>
                                <span>TikTok</span>
                            </a>
                            <a href="https://www.instagram.com/bandaihobbyhk/" target="_blank" rel="noopener noreferrer" class="social-link instagram">
                                <i class="fab fa-instagram"></i>
                                <span>Instagram</span>
                            </a>
                        </div>
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
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/grade.jsp?grade=HG">High Grade (HG)</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/grade.jsp?grade=MG">Master Grade (MG)</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/grade.jsp?grade=RG">Real Grade (RG)</a></li>
                            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/grade.jsp?grade=PG">Perfect Grade (PG)</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </footer>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

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
    
    <!-- Unified Scripts - Single source for consistent behavior -->
    <jsp:include page="includes/unified-scripts.jsp" />
    
    <!-- Page-specific scripts -->
    <script src="<%=request.getContextPath()%>/js/login-clean.js"></script>
</body>
</html>






