﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>43 Gundam Hobby - Quên mật khẩu</title>
    <!-- Unified CSS -->
    <jsp:include page="includes/unified-css.jsp" />
</head>
<body>
    <!-- Unified Header -->
    <jsp:include page="includes/unified-header.jsp" />
    
    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Forgot Password Form -->
    <div class="container d-flex flex-column align-items-center justify-content-center min-height-70vh">
        <div class="login-title mt-4">Quên mật khẩu</div>
        
        <!-- Step 1: Email Input Form -->
        <div class="login-form-box mx-auto" id="step-1-email">
            <div class="text-center mb-4">
                <p class="text-muted">Nhập email của bạn để nhận mã OTP</p>
            </div>
            <form id="forgotPasswordForm" autocomplete="off">
                <div class="mb-3">
                    <label for="email" class="form-label">Email *</label>
                    <input type="email" class="form-control" name="email" required autocomplete="off" placeholder="" id="email">
                </div>
                <button type="submit" class="btn btn-login w-100">Gửi mã OTP</button>
            </form>
            
            <div class="text-center mt-3">
                <a href="<%=request.getContextPath()%>/login.jsp" class="text-primary text-decoration-none">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
                </a>
            </div>
        </div>
        
        <!-- Step 2: OTP Verification Form (hidden by default) -->
        <div id="step-2-otp" class="login-form-box mx-auto d-none">
            <div class="text-center mb-4">
                <i class="fas fa-envelope-circle-check text-success mb-3" style="font-size: 2rem;"></i>
                <h5>Nhập mã OTP</h5>
                <p class="text-muted">Chúng tôi đã gửi mã OTP 6 số đến email: <strong id="email-display"></strong></p>
                <p class="text-muted small">Mã OTP có hiệu lực trong 10 phút</p>
            </div>
            <form id="otpVerificationForm" autocomplete="off">
                <div class="mb-3">
                    <label for="otp" class="form-label">Mã OTP *</label>
                    <input type="text" class="form-control text-center" name="otp" required 
                           maxlength="6" pattern="[0-9]{6}" placeholder="" id="otp" 
                           style="letter-spacing: 0.5em; font-size: 1.2rem;">
                    <div class="form-text">Vui lòng nhập mã OTP gồm 6 chữ số</div>
                </div>
                <button type="submit" class="btn btn-login w-100">Xác nhận OTP</button>
            </form>
            
            <div class="text-center mt-3">
                <button id="resend-otp" class="btn btn-link text-decoration-none">
                    <i class="fas fa-refresh me-2"></i>Gửi lại mã OTP
                </button>
                <div class="mt-2">
                    <button id="back-to-email" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-arrow-left me-2"></i>Thay đổi email
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Step 3: Reset Password Form (hidden by default) -->
        <div id="step-3-reset" class="login-form-box mx-auto d-none">
            <div class="text-center mb-4">
                <i class="fas fa-key text-success mb-3" style="font-size: 2rem;"></i>
                <h5>Đặt mật khẩu mới</h5>
                <p class="text-muted">Tạo mật khẩu mới cho tài khoản của bạn</p>
            </div>
            <form id="resetPasswordForm" autocomplete="off">
                <input type="hidden" id="verification-token" name="token" value="">
                <div class="mb-3">
                    <label for="newPassword" class="form-label">Mật khẩu mới *</label>
                    <input type="password" class="form-control" id="newPassword" name="newPassword" required autocomplete="off">
                    <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                </div>
                <div class="mb-3">
                    <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới *</label>
                    <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required autocomplete="off">
                </div>
                <button type="submit" class="btn btn-login w-100">Cập nhật mật khẩu</button>
            </form>
        </div>
        
        <!-- Step 4: Success Message (hidden by default) -->
        <div id="step-4-success" class="login-form-box mx-auto d-none">
            <div class="text-center">
                <i class="fas fa-check-circle text-success mb-3" style="font-size: 3rem;"></i>
                <h4>Mật khẩu đã được cập nhật!</h4>
                <p class="text-muted">Mật khẩu của bạn đã được thay đổi thành công. Bạn có thể đăng nhập với mật khẩu mới ngay bây giờ.</p>
                <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-primary">Đăng nhập ngay</a>
            </div>
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
                                <li><a href="#">Chính sách thanh toán</a></li>
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
        </div>
    </footer>

    <!-- Back to Top Button -->
    <button class="back-to-top" id="backToTop">
        <i class="fas fa-chevron-up"></i>
    </button>

    <!-- Unified Scripts -->
    <jsp:include page="includes/unified-scripts.jsp" />
    
    <script src="<%=request.getContextPath()%>/js/forgot-password.js"></script>
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
    </script>
</body>
</html>






