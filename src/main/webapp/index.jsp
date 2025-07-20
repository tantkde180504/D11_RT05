<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>43 Gundam Hobby - Mô hình Gundam chính hãng</title>
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
    <link href="<%=request.getContextPath()%>/css/modern-ecommerce.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/modern-header.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/header-z-index-fix.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Success notification for OAuth login -->
    <div id="oauth-success-notification" class="alert alert-success alert-dismissible fade oauth-notification">
        <strong>🎉 Đăng nhập thành công!</strong>
        <p class="mb-0" id="welcome-message">Chào mừng bạn quay trở lại!</p>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>

    <!-- Header -->
    <header class="bg-white shadow-sm sticky-top modern-header">
        <div class="container">
            <div class="row align-items-center py-3">
                <!-- Logo Section with Hamburger Menu -->
                <div class="col-lg-3 col-md-4 col-6">
                    <div class="header-logo-section">
                        <!-- Hamburger Menu (Mobile) -->
                        <button class="hamburger-menu modern-hamburger" id="hamburgerBtn" aria-label="Menu">
                            <span class="line"></span>
                            <span class="line"></span>
                            <span class="line"></span>
                        </button>
                        
                        <div class="logo modern-logo">
                            <a href="<%=request.getContextPath()%>/">
                                <img src="<%=request.getContextPath()%>/img/logo.png" alt="43 Gundam Logo" class="logo-img">
                                <div class="logo-glow"></div>
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Search Section -->
                <div class="col-lg-6 col-md-4 col-12 order-lg-2 order-md-2 order-3">
                    <div class="header-center-section">
                        <div class="search-container w-100 modern-search">
                            <form class="search-form" action="<%=request.getContextPath()%>/search.jsp" method="get" id="headerSearchForm">
                                <div class="input-group modern-input-group">
                                    <span class="input-group-text search-icon">
                                        <i class="fas fa-search"></i>
                                    </span>
                                    <input type="text" name="q" class="form-control search-input modern-search-input" 
                                           placeholder="Tìm kiếm sản phẩm Gundam..." id="headerSearchInput" autocomplete="off">
                                    <button class="btn btn-search modern-search-btn" type="submit">
                                        <i class="fas fa-rocket"></i>
                                        <span class="btn-text">Tìm</span>
                                    </button>
                                </div>
                                <!-- Autocomplete suggestions -->
                                <div id="headerSearchSuggestions" class="search-suggestions modern-suggestions"></div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-lg-3 order-md-3 order-2">
                    <div class="header-actions-section modern-actions">
                        <div class="account-menu me-3">
                            <!-- Unified Account Button -->
                            <div id="unified-account-menu">
                                <div class="dropdown">
                                    <!-- This button will dynamically change based on login state -->
                                    <a href="#" class="btn btn-outline-primary dropdown-toggle modern-account-btn" 
                                       id="unifiedAccountDropdown" role="button" data-bs-toggle="dropdown">
                                        <!-- Content will be updated by JavaScript -->
                                        <i class="fas fa-user me-1"></i>
                                        <span class="account-text d-none d-md-inline">Tài khoản</span>
                                        <div class="btn-ripple"></div>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end modern-dropdown" id="unifiedAccountDropdownMenu">
                                        <!-- Menu items will be updated by JavaScript -->
                                        <li><a class="dropdown-item modern-dropdown-item" href="<%=request.getContextPath()%>/login.jsp">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </a></li>
                                        <li><a class="dropdown-item modern-dropdown-item" href="<%=request.getContextPath()%>/register.jsp">
                                            <i class="fas fa-user-plus me-2"></i>Đăng ký
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- Work Dashboard Button (for staff/admin/shipper) -->
                        <div class="work-dashboard-btn me-3" id="workDashboardBtn" style="display: none;">
                            <a href="#" class="btn btn-warning modern-work-btn" id="workDashboardLink">
                                <i class="fas fa-briefcase me-1"></i>
                                <span class="d-none d-lg-inline">Trang làm việc</span>
                                <div class="btn-ripple"></div>
                            </a>
                        </div>
                        <div class="cart-btn">
                            <a href="cart.jsp" class="btn btn-primary modern-cart-btn">
                                <i class="fas fa-shopping-cart me-1"></i>
                                <span class="cart-count modern-cart-count">0</span>
                                <span class="d-none d-lg-inline ms-1">Giỏ hàng</span>
                                <div class="btn-ripple"></div>
                                <div class="cart-notification" id="cartNotification"></div>
                            </a>
                        </div>                        
                    </div>
                </div>
            </div>
        </div>
        <div class="header-shadow"></div>
    </header>    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Hero Banner - CAROUSEL CỐ ĐỊNH - KHÔNG ĐƯỢC THAY ĐỔI BỞI JAVASCRIPT -->
    <!-- DO NOT MODIFY: This carousel is protected and should remain static -->
    <section class="hero-banner py-4">
        <div class="container">
            <div class="row">
                <div class="col-lg-9">
                    <!-- PROTECTED CAROUSEL: heroCarousel - DO NOT TOUCH -->
                    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel" data-protected="true">
                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
                        </div>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="<%=request.getContextPath()%>/img/Banner2.jpg" class="d-block w-100" alt="Banner 1" 
                                     onerror="this.src='https://via.placeholder.com/800x400/ff6600/ffffff?text=GUNPLA+45th+Anniversary'">
                                <div class="carousel-caption">
                                    <h3 class="banner-title">GUNPLA 45th Anniversary</h3>
                                    <p class="banner-subtitle">Perfect Grade Unleashed Nu Gundam</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="<%=request.getContextPath()%>/img/Banner1.jpg" class="d-block w-100" alt="Banner 2"
                                     onerror="this.src='https://via.placeholder.com/800x400/0066cc/ffffff?text=Gundam+Base+Tour'">
                                <div class="carousel-caption">
                                    <h3 class="banner-title">The Gundam Base World Tour 2025</h3>
                                    <p class="banner-subtitle">Khám phá bộ sưu tập mới nhất từ Bandai</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="<%=request.getContextPath()%>/img/sale.png" class="d-block w-100" alt="Banner 3"
                                     onerror="this.src='https://via.placeholder.com/800x400/cc0066/ffffff?text=Special+Sale'">
                                <div class="carousel-caption">
                                    <h3 class="banner-title">Special Sale Event</h3>
                                    <p class="banner-subtitle">Giảm giá lên đến 50% cho các sản phẩm chọn lọc</p>
                                </div>
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </button>
                    </div>
                    <!-- END PROTECTED CAROUSEL -->
                </div>
                <div class="col-lg-3">
                    <div class="side-banners">
                        <div class="side-banner mb-3">
                            <img src="<%=request.getContextPath()%>/img/sale.png" class="img-fluid rounded" alt="Sale Banner">
                        </div>
                        <div class="side-banner">
                            <img src="<%=request.getContextPath()%>/img/New.jpg" class="img-fluid rounded" alt="New Arrivals">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Product Sections -->
    <!-- Category Navigation -->
    <section class="category-nav py-4 bg-light">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="category-slider">
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=HG" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_2.jpg" alt="High Grade">
                                </div>
                                <span class="category-name">High Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=RG" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_4.jpg" alt="Real Grade">
                                </div>
                                <span class="category-name">Real Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=MG" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_3.jpg" alt="Master Grade">
                                </div>
                                <span class="category-name">Master Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=PG" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_5.jpg" alt="Perfect Grade">
                                </div>
                                <span class="category-name">Perfect Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=METAL_BUILD" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_1.jpg" alt="Metal Build">
                                </div>
                                <span class="category-name">Metal Build</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="<%=request.getContextPath()%>/grade.jsp?grade=SD" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_11.jpg" alt="Super Deformed">
                                </div>
                                <span class="category-name">Super Deformed</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Pre-Order Section -->
    <section class="product-section py-5 bg-light">
        <div class="container">
            <div class="section-header mb-4">
                <h2 class="section-title">
                    <span class="title-icon">�</span>
                    Hàng Pre-Order
                </h2>
                <a href="#" class="view-all-btn">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
            </div>
            <div class="row">
                <!-- Enhanced Pre-Order Product Card -->
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card preorder-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/667eea/ffffff?text=MG+RX-78" class="img-fluid" alt="MG RX-78-2 Fat Cat">
                            <div class="product-badges">
                                <span class="badge bg-gradient-primary">🎯 Pre-Order</span>
                                <span class="badge bg-gradient-danger">💥 -86%</span>
                            </div>
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                </button>
                            </div>
                            <!-- Countdown Timer for Pre-Order -->
                            <div class="preorder-countdown">
                                <div class="countdown-timer">
                                    <span class="countdown-label">Kết thúc sau:</span>
                                    <div class="countdown-display">
                                        <span class="time-unit">
                                            <span class="time-value">15</span>
                                            <span class="time-label">ngày</span>
                                        </span>
                                        <span class="time-separator">:</span>
                                        <span class="time-unit">
                                            <span class="time-value">08</span>
                                            <span class="time-label">giờ</span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">MG RX-78-2 2.0 Fat Cat Limited Edition</h6>
                            <p class="product-category">🏆 Master Grade Premium</p>
                            <div class="product-price">
                                <span class="current-price">100.000₫</span>
                                <span class="old-price">680.000₫</span>
                                <span class="discount-percent">-86%</span>
                            </div>
                            <div class="preorder-progress mb-3">
                                <div class="progress-label">
                                    <span>🎯 Đã đặt: 45/100</span>
                                    <span class="text-success">Còn 55 suất</span>
                                </div>
                                <div class="progress" style="height: 8px; border-radius: 10px;">
                                    <div class="progress-bar bg-gradient-success" style="width: 45%; border-radius: 10px;"></div>
                                </div>
                            </div>
                            <button class="btn btn-gradient-warning add-to-cart w-100">
                                <i class="fas fa-rocket me-2"></i>Đặt trước ngay
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Second Pre-Order Product -->
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card preorder-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/764ba2/ffffff?text=PG+Strike" class="img-fluid" alt="PG Strike Freedom">
                            <div class="product-badges">
                                <span class="badge bg-gradient-info">🔥 Hot Pre-Order</span>
                                <span class="badge bg-gradient-warning">⭐ Limited</span>
                            </div>
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                </button>
                            </div>
                            <div class="preorder-countdown">
                                <div class="countdown-timer">
                                    <span class="countdown-label">Ra mắt:</span>
                                    <div class="countdown-display">
                                        <span class="time-unit">
                                            <span class="time-value">Mar</span>
                                            <span class="time-label">2025</span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">PG Strike Freedom Gundam 2.0</h6>
                            <p class="product-category">👑 Perfect Grade Unleashed</p>
                            <div class="product-price">
                                <span class="current-price">2.500.000₫</span>
                            </div>
                            <div class="preorder-progress mb-3">
                                <div class="progress-label">
                                    <span>🎯 Đã đặt: 78/150</span>
                                    <span class="text-warning">Còn 72 suất</span>
                                </div>
                                <div class="progress" style="height: 8px; border-radius: 10px;">
                                    <div class="progress-bar bg-gradient-info" style="width: 52%; border-radius: 10px;"></div>
                                </div>
                            </div>
                            <button class="btn btn-gradient-info add-to-cart w-100">
                                <i class="fas fa-star me-2"></i>Đặt trước VIP
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Third Pre-Order Product -->
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card preorder-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/f093fb/ffffff?text=Metal+Build" class="img-fluid" alt="Metal Build Barbatos">
                            <div class="product-badges">
                                <span class="badge bg-gradient-dark">💎 Premium</span>
                                <span class="badge bg-gradient-success">✨ New</span>
                            </div>
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                </button>
                            </div>
                            <div class="preorder-countdown coming-soon">
                                <div class="countdown-timer">
                                    <span class="countdown-label">Coming Soon</span>
                                    <div class="countdown-display">
                                        <span class="time-unit">
                                            <span class="time-value">🔜</span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">Metal Build Gundam Barbatos Lupus Rex</h6>
                            <p class="product-category">💎 Metal Build Series</p>
                            <div class="product-price">
                                <span class="current-price">4.200.000₫</span>
                            </div>
                            <div class="preorder-progress mb-3">
                                <div class="progress-label">
                                    <span>📋 Đăng ký quan tâm</span>
                                    <span class="text-info">245 người quan tâm</span>
                                </div>
                                <div class="progress" style="height: 8px; border-radius: 10px;">
                                    <div class="progress-bar bg-gradient-purple" style="width: 35%; border-radius: 10px;"></div>
                                </div>
                            </div>
                            <button class="btn btn-gradient-purple add-to-cart w-100">
                                <i class="fas fa-bell me-2"></i>Đăng ký thông báo
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Add more pre-order products -->
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card preorder-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/20c997/ffffff?text=RG+Nu" class="img-fluid" alt="RG Nu Gundam">
                            <div class="product-badges">
                                <span class="badge bg-gradient-success">🆕 New Arrival</span>
                            </div>
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-eye me-2"></i>Xem chi tiết
                                </button>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">RG Nu Gundam Clear Color</h6>
                            <p class="product-category">🌟 Real Grade Special</p>
                            <div class="product-price">
                                <span class="current-price">750.000₫</span>
                            </div>
                            <div class="preorder-progress mb-3">
                                <div class="progress-label">
                                    <span>🎯 Còn hàng</span>
                                    <span class="text-success">Sẵn sàng giao hàng</span>
                                </div>
                                <div class="progress" style="height: 8px; border-radius: 10px;">
                                    <div class="progress-bar bg-gradient-success" style="width: 100%; border-radius: 10px;"></div>
                                </div>
                            </div>
                            <button class="btn btn-gradient-success add-to-cart w-100">
                                <i class="fas fa-shopping-cart me-2"></i>Mua ngay
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Store Features Section -->
    <section class="features-section py-5 bg-light">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shipping-fast"></i>
                        </div>
                        <h5 class="feature-title">Giao hàng siêu tốc</h5>
                        <p class="feature-desc">
                            Giao hàng nhanh trong 2-24h tại Đà Nẵng. 
                            Toàn quốc 1-3 ngày.
                        </p>
                        <div class="feature-highlight">
                            ⚡ FREE SHIP đơn từ 500K
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-award"></i>
                        </div>
                        <h5 class="feature-title">Hàng chính hãng 100%</h5>
                        <p class="feature-desc">
                            Cam kết chỉ bán hàng chính hãng Bandai. 
                            Bảo hành đổi trả trong 30 ngày.
                        </p>
                        <div class="feature-highlight">
                            🏆 Uy tín từ 2020
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-tools"></i>
                        </div>
                        <h5 class="feature-title">Dịch vụ tư vấn</h5>
                        <p class="feature-desc">
                            Tư vấn lắp ráp, sơn, trang trí miễn phí. 
                            Hướng dẫn chi tiết cho người mới.
                        </p>
                        <div class="feature-highlight">
                            💬 Hỗ trợ 24/7
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <h5 class="feature-title">Thanh toán linh hoạt</h5>
                        <p class="feature-desc">
                            Hỗ trợ nhiều hình thức thanh toán: 
                            COD, chuyển khoản, ví điện tử.
                        </p>
                        <div class="feature-highlight">
                            💳 An toàn & Bảo mật
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Recently Viewed Section -->
    <section class="product-section py-5">
        <div class="container">
            <div class="section-header mb-4">
                <h2 class="section-title">
                    <span class="title-icon">�️</span>
                    Sản phẩm đã xem
                </h2>
                <a href="#" class="view-all-btn" onclick="clearRecentlyViewed()">Xóa lịch sử <i class="fas fa-trash ms-1"></i></a>
            </div>
            
            <!-- Empty state -->
            <div id="recentlyViewedEmpty" class="text-center py-5" style="display: none;">
                <i class="fas fa-eye-slash text-muted" style="font-size: 3rem;"></i>
                <h5 class="mt-3 text-muted">Chưa có sản phẩm nào được xem</h5>
                <p class="text-muted">Các sản phẩm bạn đã xem sẽ hiển thị tại đây</p>
                <a href="<%=request.getContextPath()%>/all-products.jsp" class="btn btn-primary">
                    <i class="fas fa-shopping-bag me-2"></i>Khám phá sản phẩm
                </a>
            </div>
            
            <!-- Products container -->
            <div class="row" id="recentlyViewedContainer">
                <!-- Recently viewed products will be loaded here -->
            </div>
        </div>
    </section>    <!-- Footer -->
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
    
    <!-- Carousel Protection Script - Load FIRST to protect carousel -->
    <script src="<%=request.getContextPath()%>/js/carousel-protection.js"></script>
    
    <!-- Product Manager - Load AFTER carousel protection -->
    <script src="<%=request.getContextPath()%>/js/product-manager.js"></script>
    
    <!-- Search Autocomplete Script -->
    <script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>
    
    <!-- Recently Viewed Tracker -->
    <script src="<%=request.getContextPath()%>/js/recently-viewed-tracker.js"></script>
    
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

        // Initialize static add-to-cart buttons (for pre-order and tools sections)
        function initializeStaticCartButtons() {
            document.querySelectorAll('.add-to-cart:not([data-dynamic])').forEach(button => {
                button.addEventListener('click', function() {
                    const productId = this.getAttribute('data-product-id');
                    if (!productId) {
                        showNotification('⚠️ Chức năng này sẽ được cập nhật sau!', 'info');
                        return;
                    }
                    
                    // Check if button is disabled (out of stock)
                    if (this.disabled) {
                        return;
                    }
                    
                    // Show loading state
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang thêm...';
                    this.disabled = true;
                    
                    fetch('<%=request.getContextPath()%>/api/cart/add', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        credentials: 'same-origin',
                        body: JSON.stringify({ productId: Number(productId), quantity: 1 })
                    }) 
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            this.innerHTML = '<i class="fas fa-check me-1"></i>Đã thêm';
                            this.classList.add('btn-success');
                            this.classList.remove('btn-primary', 'btn-warning');
                            showNotification('✅ Đã thêm sản phẩm vào giỏ hàng!', 'success');
                        } else {
                            this.innerHTML = originalHTML;
                            this.disabled = false;
                            showNotification('❌ ' + (data.message || 'Có lỗi xảy ra!'), 'error');
                        }
                        
                        // Reset button after 2 seconds
                        setTimeout(() => {
                            if (this.classList.contains('btn-success')) {
                                this.innerHTML = originalHTML;
                                this.classList.remove('btn-success');
                                this.classList.add('btn-primary');
                                this.disabled = false;
                            }
                        }, 2000);
                    })
                    .catch(() => {
                        this.innerHTML = originalHTML;
                        this.disabled = false;
                        showNotification('❌ Không thể thêm vào giỏ hàng. Vui lòng thử lại!', 'error');
                    });
                });
            });
        }

        // Recently Viewed Products Functions
            const container = document.getElementById('newArrivalsContainer');
            const loading = document.getElementById('newArrivalsLoading');
            const error = document.getElementById('newArrivalsError');
            
            // Show loading
            loading.style.display = 'block';
            error.style.display = 'none';
            container.innerHTML = '';
            
            console.log('🔄 Loading new arrivals from database...');
            
            // Fetch latest products from API with explicit ordering
            fetch('<%=request.getContextPath()%>/api/products/latest?limit=6')
                .then(response => {
                    console.log('📡 API Response status:', response.status);
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('📊 API Response data:', data);
                    loading.style.display = 'none';
                    
                    if (data.success && data.data && data.data.length > 0) {
                        console.log('✅ Successfully loaded', data.data.length, 'products');
                        
                        // Enhanced debugging for each product
                        console.log('🔍 Detailed Product Analysis:');
                        data.data.forEach((product, index) => {
                            console.log(`Product ${index + 1} [${product.name}]:`, {
                                id: product.id,
                                isActive: product.isActive,
                                isActiveType: typeof product.isActive,
                                stockQuantity: product.stockQuantity,
                                stockType: typeof product.stockQuantity,
                                createdAt: product.createdAt,
                                price: product.price,
                                category: product.category,
                                grade: product.grade
                            });
                        });
                        
                        renderNewArrivals(data.data);
                    } else {
                        console.warn('⚠️ No products found or API returned empty data');
                        showNewArrivalsError('Không có sản phẩm mới nào.');
                    }
                })
                .catch(err => {
                    console.error('❌ Error loading new arrivals:', err);
                    loading.style.display = 'none';
                    showNewArrivalsError('Không thể tải danh sách sản phẩm mới. Vui lòng thử lại sau.');
                });
        }
        
        function renderNewArrivals(products) {
            const container = document.getElementById('newArrivalsContainer');
            container.innerHTML = '';
            
            console.log('🎨 Rendering New Arrivals - Products sorted by newest first:');
            
            // Sort products by creation date (newest first) to ensure proper order
            const sortedProducts = products.sort((a, b) => {
                const dateA = getProductDate(a.createdAt);
                const dateB = getProductDate(b.createdAt);
                return dateB - dateA; // Newest first
            });
            
            sortedProducts.forEach((product, index) => {
                console.log(`  ${index + 1}. ${product.name} - Created: ${formatProductDate(product.createdAt)}`);
                const productCard = createProductCard(product);
                container.appendChild(productCard);
            });
            
            console.log(`✅ Rendered ${sortedProducts.length} products in newest-first order`);
            
            // Re-attach event listeners for new add-to-cart buttons
            attachAddToCartListeners();
        }
        
        function createProductCard(product) {
            const col = document.createElement('div');
            col.className = 'col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4';
            
            // Handle price formatting
            let formattedPrice = '0₫';
            if (product.price) {
                const price = parseFloat(product.price);
                if (!isNaN(price)) {
                    formattedPrice = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(price);
                }
            }
            
            // Handle image with multiple fallbacks
            const contextPath = '<%=request.getContextPath()%>';
            const defaultImage = contextPath + '/img/RGStrikeGundam.jpg';
            const placeholderImage = 'https://via.placeholder.com/250x250/cccccc/666666?text=Gundam+Model';
            const productImage = product.imageUrl || defaultImage;
            
            // Handle category display
            const categoryDisplay = getCategoryDisplayName(product.category) || 'Gundam Model';
            
            // Handle grade display
            const gradeDisplay = getGradeDisplayName(product.grade);
            const finalCategoryDisplay = gradeDisplay || categoryDisplay;
            
            // Calculate if product is new (added within last 30 days)
            const isNew = isProductNew(product.createdAt);
            const createdDate = formatProductDate(product.createdAt);
            const newBadge = isNew ? '<span class="badge bg-success">Mới</span>' : '';
            
            console.log(`📅 Product Date Info [${product.name}]: Created ${createdDate}, IsNew: ${isNew}`);
            
            // Handle stock status - kiểm tra cả is_active và stock_quantity
            const isActive = product.isActive === true; // Strict check for true
            const stockQuantity = product.stockQuantity ? parseInt(product.stockQuantity) : 0;
            const isInStock = isActive && stockQuantity > 0;
            
            // Enhanced debugging stock status
            console.log(`📦 Product Stock Debug [${product.name}]:`, {
                isActive: product.isActive,
                isActiveType: typeof product.isActive,
                stockQuantity: product.stockQuantity,
                stockQuantityType: typeof product.stockQuantity,
                parsedStockQuantity: stockQuantity,
                finalIsInStock: isInStock,
                createdAt: product.createdAt
            });
            
            const stockBadge = !isInStock ? '<span class="badge bg-danger">Hết hàng</span>' : '';
            
            col.innerHTML = `
                <div class="product-card">
                    <div class="product-image">
                        <a href="${contextPath}/product-detail.jsp?id=${product.id}">
                            <img src="${productImage}" class="img-fluid" alt="${product.name || 'Gundam Model'}" 
                                 onerror="this.src='${placeholderImage}'">
                        </a>
                        <div class="product-badges">
                            ${newBadge}
                            ${stockBadge}
                        </div>
                        <div class="product-overlay">
                            <a href="${contextPath}/product-detail.jsp?id=${product.id}" class="btn btn-outline-light btn-sm">
                                <i class="fas fa-eye"></i> Xem nhanh
                            </a>
                        </div>
                    </div>
                    <div class="product-info">
                        <h6 class="product-title">
                            <a href="${contextPath}/product-detail.jsp?id=${product.id}" class="text-decoration-none text-dark">
                                ${product.name || 'Tên sản phẩm'}
                            </a>
                        </h6>
                        <p class="product-category">${finalCategoryDisplay}</p>
                        <div class="product-price">
                            <span class="current-price">${formattedPrice}</span>
                        </div>
                        <button class="btn ${isInStock ? 'btn-primary' : 'btn-secondary'} add-to-cart w-100" 
                                data-product-id="${product.id}" 
                                data-dynamic="true"
                                ${!isInStock ? 'disabled' : ''}>
                            <i class="fas fa-${isInStock ? 'cart-plus' : 'times'} me-1"></i>
                            ${isInStock ? 'Thêm vào giỏ' : 'Hết hàng'}
                        </button>
                    </div>
                </div>
            `;
            
            return col;
        }
        
        function getCategoryDisplayName(category) {
            const categoryNames = {
                'GUNDAM_BANDAI': 'Gundam Bandai',
                'PRE_ORDER': 'Pre-Order',
                'TOOLS_ACCESSORIES': 'Dụng cụ & Phụ kiện'
            };
            return categoryNames[category] || category;
        }
        
        function getGradeDisplayName(grade) {
            const gradeNames = {
                'HG': 'High Grade (HG)',
                'RG': 'Real Grade (RG)', 
                'MG': 'Master Grade (MG)',
                'PG': 'Perfect Grade (PG)',
                'SD': 'Super Deformed (SD)',
                'METAL_BUILD': 'Metal Build',
                'FULL_MECHANICS': 'Full Mechanics',
                'TOOLS': 'Dụng cụ',
                'PAINT': 'Sơn & Vật liệu',
                'BASE_STAND': 'Đế & Giá đỡ',
                'DECAL': 'Decal & Nhãn dán'
            };
            return gradeNames[grade] || null;
        }
        
        function getProductDate(createdDate) {
            if (!createdDate) return new Date(0); // Very old date for fallback
            
            try {
                if (Array.isArray(createdDate)) {
                    // Java LocalDateTime serialized as array [year, month, day, hour, minute, second, nano]
                    return new Date(createdDate[0], createdDate[1] - 1, createdDate[2], 
                                  createdDate[3] || 0, createdDate[4] || 0, createdDate[5] || 0);
                } else {
                    return new Date(createdDate);
                }
            } catch (error) {
                console.warn('Error parsing product date:', error);
                return new Date(0);
            }
        }
        
        function formatProductDate(createdDate) {
            const date = getProductDate(createdDate);
            return date.toLocaleString('vi-VN');
        }
        
        function isProductNew(createdDate) {
            if (!createdDate) return false;
            
            try {
                const productDate = getProductDate(createdDate);
                const now = new Date();
                const thirtyDaysAgo = new Date(now.getTime() - (30 * 24 * 60 * 60 * 1000));
                
                return productDate >= thirtyDaysAgo;
            } catch (error) {
                console.warn('Error checking if product is new:', error);
                return false;
            }
        }
        
        function showNewArrivalsError(message) {
            const error = document.getElementById('newArrivalsError');
            const messageElement = error.querySelector('i').nextSibling;
            if (messageElement) {
                messageElement.textContent = ' ' + message;
            }
            error.style.display = 'block';
            
            // Add retry button
            if (!error.querySelector('.retry-btn')) {
                const retryBtn = document.createElement('button');
                retryBtn.className = 'btn btn-outline-warning btn-sm ms-2 retry-btn';
                retryBtn.innerHTML = '<i class="fas fa-redo me-1"></i>Thử lại';
                retryBtn.onclick = function() {
                    error.style.display = 'none';
                    // Reload function removed
                };
                error.appendChild(retryBtn);
            }
        }
        
        function attachAddToCartListeners() {
            // Only attach to dynamically created buttons
            document.querySelectorAll('.add-to-cart[data-dynamic="true"]').forEach(button => {
                // Remove existing listeners to avoid duplicates
                button.replaceWith(button.cloneNode(true));
            });
            
            // Re-attach listeners to dynamic buttons only
            document.querySelectorAll('.add-to-cart[data-dynamic="true"]').forEach(button => {
                button.addEventListener('click', function() {
                    // Check if button is disabled (out of stock)
                    if (this.disabled) {
                        showNotification('⚠️ Sản phẩm này hiện đang hết hàng', 'warning');
                        return;
                    }
                    
                    const productId = this.getAttribute('data-product-id');
                    
                    // Show loading state
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang thêm...';
                    this.disabled = true;
                    
                    fetch('<%=request.getContextPath()%>/api/cart/add', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        credentials: 'same-origin',
                        body: JSON.stringify({ productId: Number(productId), quantity: 1 })
                    }) 
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            this.innerHTML = '<i class="fas fa-check me-1"></i>Đã thêm';
                            this.classList.add('btn-success');
                            this.classList.remove('btn-primary');
                            
                            // Show success notification
                            showNotification('✅ Đã thêm sản phẩm vào giỏ hàng!', 'success');
                        } else {
                            this.innerHTML = originalHTML;
                            this.disabled = false;
                            showNotification('❌ ' + (data.message || 'Có lỗi xảy ra!'), 'error');
                        }
                        
                        // Reset button after 2 seconds
                        setTimeout(() => {
                            if (this.classList.contains('btn-success')) {
                                this.innerHTML = originalHTML;
                                this.classList.remove('btn-success');
                                this.classList.add('btn-primary');
                                this.disabled = false;
                            }
                        }, 2000);
                    })
                    .catch(() => {
                        this.innerHTML = originalHTML;
                        this.disabled = false;
                        showNotification('❌ Không thể thêm vào giỏ hàng. Vui lòng thử lại!', 'error');
                    });
                });
            });
        }
        
        // Simple notification function
        function showNotification(message, type = 'info') {
            // Create or get notification container
            let container = document.getElementById('notification-container');
            if (!container) {
                container = document.createElement('div');
                container.id = 'notification-container';
                container.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    z-index: 9999;
                    max-width: 350px;
                `;
                document.body.appendChild(container);
            }
            
            // Create notification
            const notification = document.createElement('div');
            const bgClass = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : 'bg-info';
            notification.className = `alert ${bgClass} text-white alert-dismissible fade show mb-2`;
            notification.innerHTML = `
                ${message}
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            `;
            
            container.appendChild(notification);
            
            // Auto remove after 4 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 4000);
        }
        
        // Recently Viewed Products Management
        function loadRecentlyViewed() {
            console.log('👁️ Loading recently viewed products...');
            
            const container = document.getElementById('recentlyViewedContainer');
            const emptyState = document.getElementById('recentlyViewedEmpty');
            
            if (!container || !emptyState) {
                console.warn('Recently viewed elements not found');
                return;
            }
            
            // Get recently viewed products from localStorage
            const recentlyViewed = getRecentlyViewedProducts();
            
            if (recentlyViewed.length === 0) {
                container.innerHTML = '';
                emptyState.style.display = 'block';
                return;
            }
            
            emptyState.style.display = 'none';
            
            // Fetch product details for recently viewed items
            Promise.all(recentlyViewed.map(item => 
                fetch(`<%=request.getContextPath()%>/api/products/${item.id}`)
                    .then(response => response.json())
                    .then(data => ({ ...data.data, viewedAt: item.viewedAt }))
                    .catch(error => {
                        console.error('Error fetching product:', error);
                        return null;
                    })
            ))
            .then(products => {
                // Filter out null products and sort by view time (most recent first)
                const validProducts = products.filter(product => product !== null)
                    .sort((a, b) => new Date(b.viewedAt) - new Date(a.viewedAt));
                
                console.log(`✅ Loaded ${validProducts.length} recently viewed products`);
                renderRecentlyViewed(validProducts);
            });
        }
        
        function renderRecentlyViewed(products) {
            const container = document.getElementById('recentlyViewedContainer');
            container.innerHTML = '';
            
            products.forEach(product => {
                const productCard = createRecentlyViewedCard(product);
                container.appendChild(productCard);
            });
            
            // Re-attach event listeners for add-to-cart buttons
            attachAddToCartListeners();
        }
        
        function createRecentlyViewedCard(product) {
            const col = document.createElement('div');
            col.className = 'col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4';
            
            // Handle price formatting
            let formattedPrice = '0₫';
            if (product.price) {
                const price = parseFloat(product.price);
                if (!isNaN(price)) {
                    formattedPrice = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(price);
                }
            }
            
            // Handle image
            const contextPath = '<%=request.getContextPath()%>';
            const defaultImage = contextPath + '/img/RGStrikeGundam.jpg';
            const placeholderImage = 'https://via.placeholder.com/250x250/cccccc/666666?text=Gundam+Model';
            const productImage = product.imageUrl || defaultImage;
            
            // Handle category display
            const categoryDisplay = getCategoryDisplayName(product.category) || 'Gundam Model';
            const gradeDisplay = getGradeDisplayName(product.grade);
            const finalCategoryDisplay = gradeDisplay || categoryDisplay;
            
            // Handle stock status
            const isActive = product.isActive === true;
            const stockQuantity = product.stockQuantity ? parseInt(product.stockQuantity) : 0;
            const isInStock = isActive && stockQuantity > 0;
            
            // Format viewed time
            const viewedAt = new Date(product.viewedAt).toLocaleString('vi-VN');
            
            const stockBadge = !isInStock ? '<span class="badge bg-danger">Hết hàng</span>' : '';
            
            col.innerHTML = `
                <div class="product-card">
                    <div class="product-image">
                        <img src="${productImage}" class="img-fluid" alt="${product.name || 'Gundam Model'}" 
                             onerror="this.src='${placeholderImage}'">
                        <div class="product-badges">
                            <span class="badge bg-info">Đã xem</span>
                            ${stockBadge}
                        </div>
                        <div class="product-overlay">
                            <a href="${contextPath}/product-detail.jsp?id=${product.id}" class="btn btn-outline-light btn-sm">
                                <i class="fas fa-eye"></i> Xem lại
                            </a>
                        </div>
                    </div>
                    <div class="product-info">
                        <h6 class="product-title">${product.name || 'Tên sản phẩm'}</h6>
                        <p class="product-category">${finalCategoryDisplay}</p>
                        <p class="product-viewed-time text-muted small">
                            <i class="fas fa-clock me-1"></i>Xem lúc: ${viewedAt}
                        </p>
                        <div class="product-price">
                            <span class="current-price">${formattedPrice}</span>
                        </div>
                        <div class="product-actions d-flex">
                            <button class="btn ${isInStock ? 'btn-primary' : 'btn-secondary'} add-to-cart flex-grow-1" 
                                    data-product-id="${product.id}" 
                                    data-dynamic="true"
                                    ${!isInStock ? 'disabled' : ''}>
                                <i class="fas fa-${isInStock ? 'cart-plus' : 'times'} me-1"></i>
                                ${isInStock ? 'Thêm vào giỏ' : 'Hết hàng'}
                            </button>
                            <button class="btn btn-outline-danger btn-sm ms-2" 
                                    onclick="removeFromRecentlyViewed(${product.id})"
                                    title="Xóa khỏi danh sách đã xem">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            return col;
        }
        
        function getRecentlyViewedProducts() {
            const stored = localStorage.getItem('recentlyViewed');
            return stored ? JSON.parse(stored) : [];
        }
        
        function addToRecentlyViewed(productId) {
            let recentlyViewed = getRecentlyViewedProducts();
            
            // Remove existing entry if present
            recentlyViewed = recentlyViewed.filter(item => item.id !== productId);
            
            // Add to beginning of array
            recentlyViewed.unshift({
                id: productId,
                viewedAt: new Date().toISOString()
            });
            
            // Keep only last 12 items
            recentlyViewed = recentlyViewed.slice(0, 12);
            
            localStorage.setItem('recentlyViewed', JSON.stringify(recentlyViewed));
            
            console.log(`👁️ Added product ${productId} to recently viewed`);
        }
        
        function removeFromRecentlyViewed(productId) {
            let recentlyViewed = getRecentlyViewedProducts();
            recentlyViewed = recentlyViewed.filter(item => item.id !== productId);
            
            localStorage.setItem('recentlyViewed', JSON.stringify(recentlyViewed));
            
            console.log(`🗑️ Removed product ${productId} from recently viewed`);
            
            // Reload the recently viewed section
            loadRecentlyViewed();
        }
        
        function clearRecentlyViewed() {
            if (confirm('Bạn có chắc chắn muốn xóa tất cả lịch sử xem sản phẩm?')) {
                localStorage.removeItem('recentlyViewed');
                console.log('🗑️ Cleared all recently viewed products');
                loadRecentlyViewed();
            }
        }
        
        // Make functions available globally
        window.addToRecentlyViewed = addToRecentlyViewed;
        window.removeFromRecentlyViewed = removeFromRecentlyViewed;
        window.clearRecentlyViewed = clearRecentlyViewed;
    </script>
    <!-- Final auth state verification and cleanup -->
    <script>
        window.addEventListener('load', function() {
            console.log('🔄 Window loaded, performing final auth checks...');
            
            // Initialize static cart buttons first
            initializeStaticCartButtons();
            
            // Load recently viewed products (backup load)
            if (document.getElementById('recentlyViewedContainer').innerHTML.trim() === '') {
                console.log('🔄 Backup: Loading recently viewed products...');
                loadRecentlyViewed();
            }
            
            // Debug auth state immediately
            console.log('📊 Initial Auth State Debug:');
            console.log('- localStorage.currentUser:', localStorage.getItem('currentUser'));
            console.log('- localStorage.googleUser:', localStorage.getItem('googleUser'));
            console.log('- localStorage.userLoggedIn:', localStorage.getItem('userLoggedIn'));
            console.log('- localStorage.userName:', localStorage.getItem('userName'));
            
            // Check server session immediately
            if (window.unifiedNavbarManager) {
                console.log('🔄 Checking server auth state...');
                window.unifiedNavbarManager.checkAuthState();
            }
            
            // Clean up justLoggedIn flag after a delay
            setTimeout(function() {
                if (localStorage.getItem('justLoggedIn')) {
                    console.log('🧹 Removing justLoggedIn flag');
                    localStorage.removeItem('justLoggedIn');
                }
            }, 2000);
            
            // Final unified navbar state check
            setTimeout(function() {
                if (window.unifiedNavbarManager) {
                    console.log('🔄 Final unified navbar refresh');
                    window.unifiedNavbarManager.refreshNavbar();
                }
            }, 1500);
            
            // Verify carousel integrity
            setTimeout(function() {
                if (window.checkCarouselIntegrity) {
                    const isIntact = window.checkCarouselIntegrity();
                    if (!isIntact) {
                        console.error('❌ CẢNH BÁO: Carousel có thể đã bị thay đổi!');
                    } else {
                        console.log('✅ Carousel vẫn nguyên vẹn và được bảo vệ');
                    }
                }
            }, 500);
        });
        
        // DOM ready handlers
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📦 DOM ready, setting up unified navbar...');
            
            // Initialize static cart buttons first
            initializeStaticCartButtons();
            
            // Load recently viewed products
            loadRecentlyViewed();
            
            // Initialize modern e-commerce features
            if (typeof initializeModernFeatures === 'function') {
                initializeModernFeatures();
            }
            
            // Check for logout parameter in URL
            const urlParams = new URLSearchParams(window.location.search);
            const logoutParam = urlParams.get('logout');
            
            if (logoutParam) {
                console.log('🚪 Logout parameter detected, forcing complete cleanup...');
                
                // Force clear all auth data
                localStorage.clear();
                sessionStorage.clear();
                
                // Remove specific items
                localStorage.removeItem('currentUser');
                localStorage.removeItem('googleUser');
                localStorage.removeItem('userRole');
                localStorage.removeItem('justLoggedIn');
                localStorage.removeItem('userName');
                localStorage.removeItem('userEmail');
                localStorage.removeItem('userPicture');
                localStorage.removeItem('userLoggedIn');
                
                sessionStorage.removeItem('userId');
                sessionStorage.removeItem('userType');
                sessionStorage.removeItem('userName');
                
                // Clean URL by removing logout parameter
                const cleanUrl = window.location.pathname + window.location.hash;
                window.history.replaceState({}, document.title, cleanUrl);
                
                console.log('✅ Forced logout cleanup completed');
            }
            
            // Immediate auth state debug
            console.log('🔍 Immediate Auth Check:');
            console.log('- currentUser:', localStorage.getItem('currentUser'));
            console.log('- googleUser:', localStorage.getItem('googleUser'));
            console.log('- userLoggedIn:', localStorage.getItem('userLoggedIn'));
            
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
    </script>
    
    <!-- Chat Widget Functions -->
    <script>
    // Function to open chat widget - called from dropdown menu
    function openChatWidget() {
        console.log('🔗 openChatWidget called from dropdown menu');
        
        // Gọi toggleChatWidget từ chat-widget.jsp
        if (typeof toggleChatWidget === 'function') {
            toggleChatWidget();
        } else {
            console.log('❌ toggleChatWidget function not found');
        }
    }
    </script>
    
    <script src="<%=request.getContextPath()%>/js/modern-ecommerce.js"></script>
    <script src="<%=request.getContextPath()%>/js/modern-header.js"></script>
    </body>
</html>
