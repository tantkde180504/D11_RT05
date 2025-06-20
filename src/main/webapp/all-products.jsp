<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tất cả sản phẩm - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        .product-card:hover { box-shadow: 0 4px 24px rgba(0,0,0,0.12); transform: translateY(-2px); }
        .product-img { object-fit: cover; height: 220px; }
        .filter-title { font-weight: 600; font-size: 1.1rem; margin-top: 1.5rem; }
        .breadcrumb { background: none; }
        .price { color: #E55A00; font-weight: bold; font-size: 1.1rem; }
        .old-price { text-decoration: line-through; color: #888; font-size: 0.95em; }
        .discount-badge { background: #E55A00; color: #fff; font-size: 0.85em; border-radius: 6px; padding: 2px 8px; }
    </style>
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
                                    <li id="userMenu" style="display:none;">
                                        <span class="dropdown-item disabled"><i class="fas fa-user me-2"></i>Xin chào, <span id="userName">User</span></span>
                                    </li>
                                    <li id="userAccountOption" style="display:none;"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp">
                                        <i class="fas fa-id-card me-2"></i>Thông tin tài khoản
                                    </a></li>
                                    <li id="userOrdersOption" style="display:none;"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp" onclick="document.getElementById('profileOrdersTab').click();return false;">
                                        <i class="fas fa-box me-2"></i>Đơn hàng của bạn
                                    </a></li>
                                    <li id="userDivider" style="display:none;"><hr class="dropdown-divider"></li>
                                    <li id="userLogoutOption" style="display:none;"><a class="dropdown-item text-danger" href="#" onclick="userLogout()">
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
    </header>
    <!-- Navigation Bar -->
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
    </nav>
    <!-- Hero Banner -->
    <section class="hero-banner py-4">
        <div class="container">
            <div class="row">
                <div class="col-lg-9">
                    <div id="heroCarousel" class="carousel slide hero-carousel" data-bs-ride="carousel">
                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
                        </div>
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="<%=request.getContextPath()%>/img/Banner1.jpg" class="d-block w-100" alt="Banner 1" 
                                     onerror="this.src='https://via.placeholder.com/800x400/ff6600/ffffff?text=GUNPLA+45th+Anniversary'">
                                <div class="carousel-caption">
                                    <h3 class="banner-title">GUNPLA 45th Anniversary</h3>
                                    <p class="banner-subtitle">Perfect Grade Unleashed Nu Gundam</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="<%=request.getContextPath()%>/img/Banner2.jpg" class="d-block w-100" alt="Banner 2"
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
    <!-- Main Content All Products -->
    <main class="container py-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-3">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                <li class="breadcrumb-item active" aria-current="page">Tất cả sản phẩm</li>
            </ol>
        </nav>
        <div class="row">
            <!-- Sidebar bộ lọc -->
            <aside class="col-lg-3 mb-4">
                <div class="card shadow-sm mb-3">
                    <div class="card-body">
                        <div class="filter-title">Loại sản phẩm</div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterHG">
                            <label class="form-check-label" for="filterHG">High Grade (HG)</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterMG">
                            <label class="form-check-label" for="filterMG">Master Grade (MG)</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterRG">
                            <label class="form-check-label" for="filterRG">Real Grade (RG)</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterPG">
                            <label class="form-check-label" for="filterPG">Perfect Grade (PG)</label>
                        </div>
                        <div class="filter-title">Khoảng giá</div>
                        <input type="range" class="form-range" min="0" max="5000000" step="50000">
                        <div class="d-flex justify-content-between small">
                            <span>0₫</span><span>5.000.000₫+</span>
                        </div>
                        <div class="filter-title">Thương hiệu</div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterBandai">
                            <label class="form-check-label" for="filterBandai">Bandai</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterKhac">
                            <label class="form-check-label" for="filterKhac">Khác</label>
                        </div>
                    </div>
                </div>
            </aside>
            <!-- Lưới sản phẩm -->
            <section class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h1 class="h4 fw-bold mb-0">Tất cả sản phẩm</h1>
                    <select class="form-select w-auto">
                        <option>Sắp xếp: Mới nhất</option>
                        <option>Giá tăng dần</option>
                        <option>Giá giảm dần</option>
                        <option>Bán chạy</option>
                    </select>
                </div>
                <div class="row g-3">
                    <!-- Sản phẩm mẫu, thay bằng dữ liệu động nếu có -->
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 border-0 shadow-sm">
                            <img src="img/coll_1.jpg" class="card-img-top product-img" alt="Gundam 1">
                            <div class="card-body p-2">
                                <h6 class="card-title mb-1">Gundam RX-78-2</h6>
                                <div class="mb-1">
                                    <span class="price">450.000₫</span>
                                </div>
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-sm btn-outline-primary w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 border-0 shadow-sm">
                            <img src="img/coll_2.jpg" class="card-img-top product-img" alt="Gundam 2">
                            <div class="card-body p-2">
                                <h6 class="card-title mb-1">Gundam Barbatos</h6>
                                <div class="mb-1">
                                    <span class="price">650.000₫</span>
                                    <span class="old-price ms-2">800.000₫</span>
                                    <span class="discount-badge ms-2">-19%</span>
                                </div>
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-sm btn-outline-primary w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 border-0 shadow-sm">
                            <img src="img/coll_3.jpg" class="card-img-top product-img" alt="Gundam 3">
                            <div class="card-body p-2">
                                <h6 class="card-title mb-1">Gundam Exia</h6>
                                <div class="mb-1">
                                    <span class="price">1.200.000₫</span>
                                </div>
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-sm btn-outline-primary w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 border-0 shadow-sm">
                            <img src="img/coll_4.jpg" class="card-img-top product-img" alt="Gundam 4">
                            <div class="card-body p-2">
                                <h6 class="card-title mb-1">Gundam Unicorn</h6>
                                <div class="mb-1">
                                    <span class="price">2.000.000₫</span>
                                    <span class="old-price ms-2">2.500.000₫</span>
                                    <span class="discount-badge ms-2">-20%</span>
                                </div>
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-sm btn-outline-primary w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <!-- Thêm nhiều sản phẩm khác tại đây -->
                </div>
                <!-- Phân trang -->
                <nav class="mt-4 d-flex justify-content-center">
                    <ul class="pagination">
                        <li class="page-item disabled"><span class="page-link">&laquo;</span></li>
                        <li class="page-item active"><span class="page-link">1</span></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">&raquo;</a></li>
                    </ul>
                </nav>
            </section>
        </div>
    </main>
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
    <script>
    // Hiện/ẩn popup danh mục sản phẩm
    document.addEventListener('DOMContentLoaded', function() {
        var btn = document.getElementById('categoryBtn');
        var popup = document.getElementById('categoryPopup');
        if (btn && popup) {
            btn.addEventListener('mouseenter', function() {
                popup.classList.add('show');
            });
            btn.addEventListener('mouseleave', function() {
                setTimeout(function(){
                    if (!popup.matches(':hover')) popup.classList.remove('show');
                }, 100);
            });
            popup.addEventListener('mouseenter', function() {
                popup.classList.add('show');
            });
            popup.addEventListener('mouseleave', function() {
                popup.classList.remove('show');
            });
            // Mobile: click để toggle
            btn.addEventListener('click', function(e) {
                if (window.innerWidth < 992) {
                    popup.classList.toggle('show');
                }
            });
            // Click ngoài để ẩn
            document.addEventListener('click', function(e) {
                if (!btn.contains(e.target) && !popup.contains(e.target)) {
                    popup.classList.remove('show');
                }
            });
        }
    });
    </script>
</body>
</html>
