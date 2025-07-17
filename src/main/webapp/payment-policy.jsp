<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách thanh toán - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/layout-sizing.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-fix.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/account-menu-fix.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/user-avatar.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        .policy-content {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin: 2rem 0;
        }
        
        .policy-header {
            border-bottom: 3px solid #007bff;
            padding-bottom: 1rem;
            margin-bottom: 2rem;
        }
        
        .policy-title {
            color: #007bff;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .policy-subtitle {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 0;
        }
        
        .section-title {
            color: #333;
            font-weight: 600;
            margin-top: 2rem;
            margin-bottom: 1rem;
            padding-left: 1rem;
            border-left: 4px solid #007bff;
        }
        
        .subsection-title {
            color: #007bff;
            font-weight: 600;
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .policy-text {
            line-height: 1.8;
            color: #555;
            margin-bottom: 1rem;
        }
        
        .step-list {
            list-style: none;
            padding-left: 0;
        }
        
        .step-list li {
            padding: 0.5rem 0;
            padding-left: 2rem;
            position: relative;
            color: #555;
            line-height: 1.6;
        }
        
        .step-list li::before {
            content: counter(step-counter);
            counter-increment: step-counter;
            position: absolute;
            left: 0;
            top: 0.5rem;
            background: #007bff;
            color: white;
            width: 1.5rem;
            height: 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .reset-counter {
            counter-reset: step-counter;
        }
        
        .highlight-box {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-left: 4px solid #28a745;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 0 4px 4px 0;
        }
        
        .warning-box {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            border-left: 4px solid #ffc107;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 0 4px 4px 0;
        }
        
        .contact-info {
            background-color: #e7f3ff;
            border: 1px solid #b3d9ff;
            border-left: 4px solid #007bff;
            padding: 1rem;
            margin: 1rem 0;
            border-radius: 0 4px 4px 0;
        }
        
        .contact-info strong {
            color: #007bff;
        }
        
        .breadcrumb-custom {
            background-color: #f8f9fa;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        
        .breadcrumb-custom .breadcrumb {
            margin-bottom: 0;
            background-color: transparent;
            padding: 0;
        }
        
        .breadcrumb-custom .breadcrumb-item a {
            color: #007bff;
            text-decoration: none;
        }
        
        .breadcrumb-custom .breadcrumb-item a:hover {
            text-decoration: underline;
        }
        
        .icon-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .payment-methods {
            display: flex;
            gap: 1rem;
            margin: 1rem 0;
            flex-wrap: wrap;
        }
        
        .payment-method {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            flex: 1;
            min-width: 200px;
            transition: all 0.3s ease;
        }
        
        .payment-method:hover {
            border-color: #007bff;
            box-shadow: 0 4px 8px rgba(0,123,255,0.2);
        }
        
        .payment-method i {
            font-size: 2rem;
            color: #007bff;
            margin-bottom: 0.5rem;
        }
        
        .payment-method h6 {
            color: #333;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .payment-method p {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0;
        }
    </style>
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
                            <form class="search-form" action="<%=request.getContextPath()%>/search.jsp" method="get" id="headerSearchForm">
                                <div class="input-group">
                                    <input type="text" name="q" class="form-control search-input" 
                                           placeholder="Tìm kiếm sản phẩm..." id="headerSearchInput" autocomplete="off">
                                    <button class="btn btn-search" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                                <!-- Autocomplete suggestions -->
                                <div id="headerSearchSuggestions" class="search-suggestions"></div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-lg-3 order-md-3 order-2">
                    <div class="header-actions-section">
                        <div class="account-menu me-3">
                            <!-- Unified Account Button -->
                            <div id="unified-account-menu">
                                <div class="dropdown">
                                    <!-- This button will dynamically change based on login state -->
                                    <a href="#" class="btn btn-outline-primary dropdown-toggle" 
                                       id="unifiedAccountDropdown" role="button" data-bs-toggle="dropdown">
                                        <!-- Content will be updated by JavaScript -->
                                        <i class="fas fa-user me-1"></i>
                                        <span class="account-text d-none d-md-inline">Tài khoản</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end" id="unifiedAccountDropdownMenu">
                                        <!-- Menu items will be updated by JavaScript -->
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
                            <a href="cart.jsp" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-1"></i>
                                <span class="cart-count">0</span>
                                <span class="d-none d-lg-inline ms-1">Giỏ hàng</span>
                            </a>
                        </div>
                        <div class="order-history-btn">
                            <a href="order-history.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-history me-1"></i>
                                <span class="d-none d-lg-inline">Lịch sử giao dịch</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Main Content -->
    <main class="container my-4">
        <!-- Breadcrumb -->
        <div class="breadcrumb-custom">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chính sách thanh toán</li>
                </ol>
            </nav>
        </div>

        <!-- Policy Content -->
        <div class="policy-content">
            <div class="policy-header">
                <h1 class="policy-title icon-title">
                    <i class="fas fa-credit-card"></i>
                    Chính sách thanh toán
                </h1>
                <p class="policy-subtitle">Chính Sách Phương Thức Thanh Toán tại 43 Gundam Hobby</p>
            </div>

            <!-- Payment Methods Overview -->
            <section class="mb-4">
                <h2 class="section-title">1. CÁC LOẠI HÌNH THANH TOÁN</h2>
                <p class="policy-text">
                    Hiện tại quý khách hàng mua hàng tại trang website của 43gundamhobby.com có hai hình thức thanh toán chính:
                </p>
                
                <div class="payment-methods">
                    <div class="payment-method">
                        <i class="fas fa-hand-holding-usd"></i>
                        <h6>Thanh toán tiền mặt khi nhận hàng (COD)</h6>
                        <p>Thanh toán trực tiếp cho nhân viên giao hàng</p>
                    </div>
                    <div class="payment-method">
                        <i class="fas fa-university"></i>
                        <h6>Thanh toán qua tài khoản ngân hàng</h6>
                        <p>Internet Banking: PayOS và các ngân hàng khác</p>
                    </div>
                </div>
            </section>

            <!-- Payment Process -->
            <section class="mb-4">
                <h2 class="section-title">2. CÁCH THỨC THANH TOÁN</h2>
                
                <!-- COD Payment -->
                <div class="subsection-title">2.1 Thanh toán tiền mặt khi nhận hàng (COD)</div>
                <ol class="step-list reset-counter">
                    <li>Thêm sản phẩm vào giỏ hàng</li>
                    <li>Kiểm tra giỏ hàng</li>
                    <li>Điền thông tin đơn hàng</li>
                    <li>Chọn phương thức thanh toán tiền mặt khi nhận hàng (COD)</li>
                    <li>Chờ xác nhận đơn hàng, chuẩn bị đơn hàng và vận chuyển đơn hàng từ 43gundamhobby.com</li>
                    <li>Nhận hàng và kiểm tra đơn hàng</li>
                    <li>Thanh toán tổng giá trị đơn hàng cho đơn vị vận chuyển</li>
                </ol>

                <!-- Online Banking Payment -->
                <div class="subsection-title">2.2 Thanh toán qua tài khoản ngân hàng (Internet Banking)</div>
                <ol class="step-list reset-counter">
                    <li>Thêm sản phẩm vào giỏ hàng</li>
                    <li>Kiểm tra giỏ hàng</li>
                    <li>Điền thông tin đơn hàng</li>
                    <li>Chọn phương thức thanh toán qua tài khoản ngân hàng</li>
                    <li>Thanh toán qua ngân hàng</li>
                    <li>Nội dung thanh toán: Mã đơn hàng + Họ và Tên + Số điện thoại (Trùng với thông tin của đơn hàng)</li>
                    <li>Chờ xác nhận đã hoàn thành thanh toán từ 43gundamhobby.com</li>
                    <li>Chờ chuẩn bị đơn hàng và vận chuyển đơn hàng từ 43gundamhobby.com</li>
                    <li>Nhận hàng và kiểm tra đơn hàng</li>
                </ol>

                <div class="warning-box">
                    <strong><i class="fas fa-exclamation-triangle me-2"></i>Lưu ý quan trọng:</strong>
                    Nếu đơn vị vận chuyển yêu cầu thu thêm chi phí khác, vui lòng liên hệ ngay số Hotline: <strong>0385546145</strong> để được hỗ trợ ngay.
                </div>
            </section>

            <!-- Shipping Policy -->
            <section class="mb-4">
                <h2 class="section-title">Chính sách chung về Giao - Nhận hàng tại 43gundamhobby.com</h2>
                
                <div class="subsection-title">1. Phí ship và thời gian nhận hàng</div>
                
                <h6 class="mt-3 mb-2"><strong>a. Phí ship khi mua hàng online tại 43gundamhobby.com</strong></h6>
                <p class="policy-text">
                    Phí ship tính theo chính sách vận chuyển của 43gundamhobby.com
                </p>

                <h6 class="mt-3 mb-2"><strong>b. Thời gian nhận hàng</strong></h6>
                <p class="policy-text">
                    Khách hàng khi đã được xác nhận đơn hàng đặt mua trên Website https://43gundamhobby.com, Facebook, Zalo... và các kênh thông tin chính thức khác của 43gundamhobby.com sẽ nhận được sản phẩm trong vòng từ <strong>3-7 ngày làm việc</strong> (tùy từng khu vực nhận hàng). Nhân viên chăm sóc tại 43gundamhobby.com sẽ liên hệ với bạn trong thời gian sớm nhất có thể để hoàn tất thủ tục liên quan.
                </p>

                <div class="highlight-box">
                    <strong><i class="fas fa-info-circle me-2"></i>Sản phẩm đặc biệt:</strong>
                    Đối với các đơn hàng sản xuất hoặc sản phẩm in ấn khác, thời gian sản xuất và giao hàng có thể sẽ lâu hơn. 43gundamhobby.com sẽ liên hệ và thông báo cụ thể về thời gian giao - nhận đến Quý khách.
                </div>
            </section>

            <!-- Customer Rights -->
            <section class="mb-4">
                <div class="subsection-title">2. Quyền lợi về việc Kiểm tra và Nhận đồ khi mua sắm Online</div>
                <p class="policy-text">
                    Để mang đến trải nghiệm mua sắm thuận lợi và thoải mái nhất cho khách hàng, 43gundamhobby.com luôn xây dựng những chính sách thân thiện nhất. Theo đó, tất cả khách hàng đặt mua sản phẩm của 43gundamhobby.com bằng phương thức mua hàng online đều được hưởng những quyền lợi như sau:
                </p>

                <div class="highlight-box">
                    <ul class="mb-0">
                        <li class="mb-2"><strong>Khách hàng được xem và kiểm tra trước khi thanh toán.</strong></li>
                        <li class="mb-2">Nếu thấy sản phẩm bị lỗi, dơ, không đúng mẫu, khách hàng hoàn toàn có thể trả lại ngay cho bưu tá và không cần thanh toán bất cứ chi phí phát sinh nào.</li>
                        <li class="mb-0">Nếu thấy sản phẩm không ưng ý, khách hàng hoàn toàn có thể trả lại ngay cho bưu tá và chỉ thanh toán phí ship.</li>
                    </ul>
                </div>
            </section>

            <!-- Exchange & Return Policy -->
            <section class="mb-4">
                <div class="subsection-title">3. Với khách hàng đã thanh toán và muốn đổi trả</div>
                
                <p class="policy-text">
                    Khách hàng có nhu cầu khiếu nại, đổi trả sản phẩm do lỗi của 43gundamhobby.com có thể liên hệ qua Hotline <strong>0385546145</strong> để được hỗ trợ sớm nhất.
                </p>
                
                <p class="policy-text">
                    Tư vấn viên sẽ hướng dẫn khách hàng các bước cần thiết để tiến hành đổi trả.
                </p>

                <div class="warning-box">
                    <strong><i class="fas fa-exclamation-triangle me-2"></i>Lưu ý:</strong>
                    Khách hàng được hỗ trợ đổi hàng với trường hợp thử đồ tại nhà mà không đúng với kích cỡ cơ thể. Khách hàng có thể tiến hành đổi trả online hoặc đổi trả trực tiếp tại hệ thống cửa hàng của 43gundamhobby.com. Hàng hóa khi đổi trả cần được giữ nguyên tem mác và chưa qua sử dụng, giặt tẩy.
                </div>

                <div class="contact-info">
                    <strong><i class="fas fa-link me-2"></i>Thông tin chi tiết:</strong>
                    Thông tin chi tiết và cụ thể về Chính sách đổi trả tại web
                </div>
            </section>

            <!-- Conclusion -->
            <section class="mb-4">
                <div class="highlight-box text-center">
                    <h5 class="mb-2"><i class="fas fa-heart text-danger me-2"></i>Cảm ơn quý khách!</h5>
                    <p class="mb-0">
                        Hy vọng, những thông tin trên đây có thể giúp cho trải nghiệm mua sắm online của bạn tại 43gundamhobby.com được an tâm và thuận tiện hơn!
                    </p>
                </div>
            </section>

            <!-- Contact Information -->
            <section class="mb-4">
                <h2 class="section-title icon-title">
                    <i class="fas fa-phone-alt"></i>
                    Thông tin liên hệ
                </h2>
                <div class="contact-info">
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-store me-2"></i>Cửa hàng:</strong> 43 Gundam Hobby</p>
                            <p><strong><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ:</strong> 59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng</p>
                            <p><strong><i class="fas fa-phone me-2"></i>Hotline:</strong> <a href="tel:0385546145" class="text-primary">0385546145</a> (8h-20h)</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong><i class="fas fa-envelope me-2"></i>Email:</strong> <a href="mailto:43gundamhobby@gmail.com" class="text-primary">43gundamhobby@gmail.com</a></p>
                            <p><strong><i class="fas fa-globe me-2"></i>Website:</strong> <a href="https://43gundamhobby.com" class="text-primary" target="_blank">43gundamhobby.com</a></p>
                            <p><strong><i class="fas fa-clock me-2"></i>Giờ làm việc:</strong> 8:00 - 20:00 (Hằng ngày)</p>
                        </div>
                    </div>
                </div>
            </section>
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

    <!-- Include Chat Widget -->
    <jsp:include page="chat-widget.jsp" />

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Legacy Cleanup - MUST RUN FIRST to remove old elements -->
    <script src="<%=request.getContextPath()%>/js/legacy-navbar-cleanup.js"></script>
    
    <!-- MD5 Library for Gravatar -->
    <script src="<%=request.getContextPath()%>/js/md5.min.js"></script>
    
    <!-- Email to Google Converter -->
    <script src="<%=request.getContextPath()%>/js/email-to-google-converter.js"></script>
    
    <!-- Anti-Flicker Unified - LOAD FIRST to prevent navbar flickering -->
    <script src="<%=request.getContextPath()%>/js/anti-flicker-unified.js"></script>
    
    <!-- Unified Navbar Manager - Core navbar logic -->
    <script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>
    
    <!-- Google OAuth Handler - Updated for unified navbar -->
    <script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>
    
    <!-- Hamburger Menu Script -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    
    <!-- Search Autocomplete Script -->
    <script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>
    
    <!-- Unified Navbar Debug Tool -->
    <script src="<%=request.getContextPath()%>/js/unified-navbar-debug.js"></script>
    
    <!-- Context Path Setup -->
    <script>
        window.contextPath = '<%=request.getContextPath()%>';
        console.log('Context path set to:', window.contextPath);
    </script>
    
    <!-- Basic page functionality -->
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

        // Initialize navbar on DOM ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📦 DOM ready, setting up unified navbar...');
            
            // Ensure unified navbar manager is initialized
            if (window.unifiedNavbarManager) {
                setTimeout(() => {
                    console.log('⚡ Manual auth state check...');
                    window.unifiedNavbarManager.checkAuthState();
                }, 100);
            } else {
                console.warn('⚠️ unifiedNavbarManager not found!');
            }
        });

        // Final auth state verification on window load
        window.addEventListener('load', function() {
            console.log('🔄 Window loaded, performing final auth checks...');
            
            // Check server session immediately
            if (window.unifiedNavbarManager) {
                console.log('🔄 Checking server auth state...');
                window.unifiedNavbarManager.checkAuthState();
            }
            
            // Final unified navbar state check
            setTimeout(function() {
                if (window.unifiedNavbarManager) {
                    console.log('🔄 Final unified navbar refresh');
                    window.unifiedNavbarManager.refreshNavbar();
                }
            }, 1500);
        });
    </script>
</body>
</html>
