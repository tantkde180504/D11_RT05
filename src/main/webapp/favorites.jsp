<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích - 43 Gundam Hobby</title>
    <%@ include file="/includes/unified-css.jsp" %>
</head>
<body>
    <!-- Header -->
    <%@ include file="/includes/unified-header.jsp" %>

    <!-- Main Content -->
    <main class="container py-4">
        <div class="row">
            <!-- Breadcrumb -->
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Sản phẩm yêu thích</li>
                    </ol>
                </nav>
            </div>
            
            <!-- Main Content Area -->
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3 fw-bold mb-0">
                        <i class="fas fa-heart text-danger me-2"></i>
                        Sản phẩm yêu thích
                    </h1>
                    <span class="badge bg-primary" id="favoritesCount">0 sản phẩm</span>
                </div>
                
                <!-- Login Required Message -->
                <div class="alert alert-info" id="loginRequiredMessage" style="display: none;">
                    <i class="fas fa-info-circle me-2"></i>
                    Vui lòng <a href="<%=request.getContextPath()%>/login.jsp" class="alert-link">đăng nhập</a> để xem danh sách sản phẩm yêu thích của bạn.
                </div>
                
                <!-- Empty Favorites Message -->
                <div class="text-center py-5" id="emptyFavoritesMessage" style="display: none;">
                    <i class="fas fa-heart-broken text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-3 text-muted">Chưa có sản phẩm yêu thích</h4>
                    <p class="text-muted">Hãy thêm những sản phẩm mà bạn yêu thích vào danh sách này!</p>
                    <a href="<%=request.getContextPath()%>/all-products.jsp" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>Khám phá sản phẩm
                    </a>
                </div>
                
                <!-- Products Grid -->
                <div class="row g-3" id="favoritesGrid">
                    <!-- Loading spinner -->
                    <div class="col-12 text-center" id="loadingSpinner">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang tải...</span>
                        </div>
                        <p class="mt-2">Đang tải sản phẩm yêu thích...</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

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
                    <div class="col-md-6">
                        <div class="newsletter-section">
                            <h6 class="newsletter-title mb-3">Đăng ký nhận thông tin</h6>
                            <p class="newsletter-desc">Nhận tin tức về sản phẩm mới và khuyến mãi</p>
                            <form class="newsletter-form">
                                <div class="input-group">
                                    <input type="email" class="form-control newsletter-input" placeholder="Email của bạn...">
                                    <button class="btn btn-primary newsletter-btn" type="submit">
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
                        <p class="copyright-text mb-0">© 2024 43 Gundam Hobby. Tất cả quyền được bảo lưu.</p>
                    </div>
                    <div class="col-md-6">
                        <div class="payment-methods text-md-end">
                            <span class="me-2">Phương thức thanh toán:</span>
                            <i class="fab fa-cc-visa payment-icon"></i>
                            <i class="fab fa-cc-mastercard payment-icon"></i>
                            <i class="fas fa-mobile-alt payment-icon"></i>
                            <i class="fas fa-university payment-icon"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <%@ include file="/includes/unified-scripts.jsp" %>
    
    <!-- Favorites-specific scripts -->
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    <script src="<%=request.getContextPath()%>/js/favorites-manager.js"></script>
</body>
</html>





