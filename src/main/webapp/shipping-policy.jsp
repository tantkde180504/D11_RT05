<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách vận chuyển - 43 Gundam Hobby</title>
    <!-- Unified CSS Includes -->
    <jsp:include page="includes/unified-css.jsp" />
</head>
<body>
    <!-- Unified Header Includes -->
    <jsp:include page="includes/unified-header.jsp" />

    <!-- Main Content -->
    <div class="container my-5">
        <!-- Breadcrumb -->
        <nav class="breadcrumb-custom" aria-label="breadcrumb">
            <ol class="breadcrumb mb-0">
                <li class="breadcrumb-item">
                    <a href="<%=request.getContextPath()%>/" class="text-decoration-none">
                        <i class="fas fa-home me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-shipping-fast me-1"></i>Chính sách vận chuyển
                </li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-12">
                <!-- Page Header -->
                <div class="text-center mb-5">
                    <h1 class="policy-title display-5 fw-bold">
                        <i class="fas fa-shipping-fast me-3 text-primary"></i>
                        Chính sách vận chuyển, giao nhận và kiểm hàng
                    </h1>
                    <p class="lead text-muted">Quy định về việc giao hàng, nhận hàng và kiểm hàng tại 43 Gundam Hobby</p>
                </div>

                <!-- Policy Content -->
                <div class="policy-content">
                    <!-- Section I -->
                    <div class="policy-section">
                        <h2 class="section-title">
                            <i class="fas fa-truck me-2 text-primary"></i>
                            I. CHÍNH SÁCH VẬN CHUYỂN - GIAO, NHẬN HÀNG VÀ KIỂM HÀNG
                        </h2>

                        <!-- Subsection 1 -->
                        <div class="mb-4">
                            <h4 class="subsection-title">
                                <i class="fas fa-map-marked-alt me-2"></i>
                                1. Phạm vi áp dụng:
                            </h4>
                            <div class="highlight-box">
                                <p class="mb-0">
                                    <strong>Phạm vi áp dụng:</strong> tất cả mọi tỉnh thành trên cả nước.
                                </p>
                            </div>
                        </div>

                        <!-- Subsection 2 -->
                        <div class="mb-4">
                            <h4 class="subsection-title">
                                <i class="fas fa-clock me-2"></i>
                                2. Thời gian giao – nhận hàng
                            </h4>
                            <ul class="policy-list">
                                <li>Đơn hàng sau khi được tiếp nhận xử lý xong sẽ được giao ngay trong vòng <strong>24h</strong> hoặc theo tiến độ hợp đồng.</li>
                                <li>Đối với khách hàng ở tỉnh xa, sau khi tiếp nhận đơn hàng thời gian nhận hàng dự kiến từ <strong>3 - 5 ngày</strong>. Tuy nhiên, tùy vào tình trạng hàng hóa điều kiện thời tiết,... mà ngày nhận hàng sẽ có sự thay đổi.</li>
                                <li>Thời gian giao hàng được tính từ lúc hoàn tất thủ tục đặt hàng với nhân viên tư vấn đến khi nhận được hàng.</li>
                            </ul>
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Lưu ý:</strong> Trường hợp phát sinh chậm trễ trong việc giao hàng hoặc sản phẩm không được bán quá 10 ngày, khách hàng có thể hủy đơn hàng mà không chịu bất kỳ chi phí nào.
                            </div>
                        </div>

                        <!-- Subsection 3 -->
                        <div class="mb-4">
                            <h4 class="subsection-title">
                                <i class="fas fa-shipping-fast me-2"></i>
                                3. Hình thức giao hàng:
                            </h4>
                            
                            <div class="highlight-box">
                                <p><strong>43gundamhobby.com</strong> sử dụng đơn vị giao hàng là <strong>Sapo Express</strong>. Mọi sự cố xảy ra trong quá trình vận chuyển trước khi sản phẩm tới tay quý khách, chúng tôi sẽ giải quyết với các đơn vị giao hàng.</p>
                            </div>

                            <ul class="policy-list">
                                <li>Trong trường hợp bên giao hàng liên lạc quý khách không được (đối với Sapo Express sẽ liên lạc quý khách 2-3 lần trong thời gian 2-3 ngày) hoặc quý khách không chấp nhận nhận hàng dẫn đến sản phẩm bị hoàn về cửa hàng, mọi chi phí liên quan tới việc trả hàng, giao hàng lại sẽ do quý khách trả.</li>
                                <li>Quý khách vui lòng <strong>đồng kiểm</strong> với bên giao hàng để đảm bảo nhận được sản phẩm đẹp, tốt, và có sự chứng kiến của bên giao hàng trong trường hợp sản phẩm có sự cố.</li>
                                <li><strong>Đối với khách tỉnh xa:</strong> Sử dụng dịch vụ giao hàng.</li>
                                <li><strong>Đối với khách nội thành/ ngoại thành:</strong> Sử dụng dịch vụ giao hàng.</li>
                            </ul>

                            <!-- Responsibility Section -->
                            <div class="card mt-4">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0">
                                        <i class="fas fa-file-contract me-2"></i>
                                        Phân định trách nhiệm về cung cấp chứng từ hàng hóa
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <ul class="mb-0">
                                        <li><strong>43gundamhobby.com</strong> có trách nhiệm cung cấp đầy đủ và chính xác các chứng từ liên quan đến hàng hóa cho tổ chức cung cấp dịch vụ logistics và bên nhận hàng.</li>
                                        <li>Tất cả các đơn hàng đều được đóng gói sẵn sàng trước khi vận chuyển, được niêm phong bởi <strong>43gundamhobby.com</strong></li>
                                        <li>Đơn vị vận chuyển (ĐVVC) sẽ chỉ chịu trách nhiệm vận chuyển hàng hóa theo nguyên tắc <strong>"nguyên đai, nguyên kiện"</strong>, cung cấp chứng từ là phiếu giao hàng trong đó có thông tin như: Thông tin Người nhận, bao gồm: Tên người nhận, số điện thoại và địa chỉ người nhận, tên hàng hóa.</li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Package Information -->
                            <div class="alert alert-info mt-4">
                                <h6><i class="fas fa-box me-2"></i>Thông tin trên bao bì:</h6>
                                <ul class="mb-0">
                                    <li>Thông tin Người nhận, bao gồm: Tên người nhận, số điện thoại và địa chỉ người nhận.</li>
                                    <li>Để đảm bảo an toàn cho hàng hóa, <strong>43gundamhobby.com</strong> sẽ gửi kèm Phiếu bán hàng hợp lệ của sản phẩm trong bưu kiện (nếu có), sau khi khách hàng xác nhận 43gundamhobby.com sẽ xuất hóa đơn điện tử và gửi qua mail của khách hàng cung cấp.</li>
                                    <li>Phiếu bán hàng là căn cứ hỗ trợ quá trình xử lý khiếu nại như: xác định giá trị thị trường của hàng hóa, đảm bảo hàng hóa lưu thông hợp lệ v.v..</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Section II -->
                    <div class="policy-section">
                        <h2 class="section-title">
                            <i class="fas fa-search me-2 text-success"></i>
                            II. CHÍNH SÁCH KIỂM HÀNG
                        </h2>

                        <div class="row">
                            <div class="col-lg-6">
                                <div class="card h-100">
                                    <div class="card-header bg-success text-white">
                                        <h6 class="mb-0">
                                            <i class="fas fa-eye me-2"></i>
                                            Quyền kiểm hàng
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <p>Khi nhận hàng quý khách có quyền yêu cầu nhân viên giao hàng mở cho kiểm.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-lg-6">
                                <div class="card h-100">
                                    <div class="card-header bg-warning text-dark">
                                        <h6 class="mb-0">
                                            <i class="fas fa-exchange-alt me-2"></i>
                                            Trường hợp giao sai hàng
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <p>Trường hợp đơn hàng đặt mà bên bán giao không đúng loại sản phẩm quý khách có quyền trả hàng và không thanh toán tiền.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card mt-4">
                            <div class="card-header bg-info text-white">
                                <h6 class="mb-0">
                                    <i class="fas fa-undo me-2"></i>
                                    Chính sách hoàn tiền và đổi hàng
                                </h6>
                            </div>
                            <div class="card-body">
                                <p>Trường hợp quý khách đã thanh toán trước nhưng đơn hàng không đúng quý khách yêu cầu hoàn toàn hoặc giao lại đơn mới như đã đặt.</p>
                                
                                <div class="contact-info">
                                    <h6 class="fw-bold mb-3">
                                        <i class="fas fa-headset me-2"></i>
                                        Liên hệ hỗ trợ:
                                    </h6>
                                    <p class="mb-0">Trong trường hợp yêu cầu hoàn tiền hoặc đổi đơn quý khách liên hệ:</p>
                                    <ul class="mt-2 mb-0">
                                        <li>
                                            <i class="fas fa-envelope me-2 text-primary"></i>
                                            Email: <a href="mailto:43gundamhobby@gmail.com" class="text-decoration-none fw-bold">43gundamhobby@gmail.com</a>
                                        </li>
                                        <li>
                                            <i class="fas fa-phone me-2 text-success"></i>
                                            Hotline: <a href="tel:0385546145" class="text-decoration-none fw-bold">0385546145</a>
                                        </li>
                                    </ul>
                                    <div class="alert alert-success mt-3 mb-0">
                                        <i class="fas fa-shield-alt me-2"></i>
                                        <strong>Cam kết:</strong> Chúng tôi cam kết sẽ giải quyết mọi yêu cầu của quý khách.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Summary Section -->
                    <div class="text-center mt-5">
                        <div class="card border-primary">
                            <div class="card-body">
                                <h5 class="card-title text-primary">
                                    <i class="fas fa-handshake me-2"></i>
                                    43 Gundam Hobby - Cam kết chất lượng dịch vụ
                                </h5>
                                <p class="card-text">
                                    Chúng tôi luôn đặt sự hài lòng của khách hàng lên hàng đầu với dịch vụ giao hàng nhanh chóng, 
                                    an toàn và chính sách hỗ trợ tận tình.
                                </p>
                                <div class="row text-center mt-4">
                                    <div class="col-md-4">
                                        <div class="feature-item">
                                            <i class="fas fa-shipping-fast fa-2x text-primary mb-2"></i>
                                            <h6>Giao hàng nhanh</h6>
                                            <small class="text-muted">24h nội thành</small>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="feature-item">
                                            <i class="fas fa-shield-alt fa-2x text-success mb-2"></i>
                                            <h6>An toàn bảo mật</h6>
                                            <small class="text-muted">Đóng gói cẩn thận</small>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="feature-item">
                                            <i class="fas fa-headset fa-2x text-info mb-2"></i>
                                            <h6>Hỗ trợ 24/7</h6>
                                            <small class="text-muted">Luôn sẵn sàng giúp đỡ</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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

    <!-- Unified Scripts Include -->
    <jsp:include page="includes/unified-scripts.jsp" />
    
    <!-- Page-specific functionality -->
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
    </script>
</body>
</html>






