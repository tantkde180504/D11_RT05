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
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
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
                        <div class="cart-btn me-2">
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

    <!-- Category Navigation -->
    <section class="category-nav py-4 bg-light">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="category-slider">
                        <div class="category-item">
                            <a href="#" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_2.jpg" alt="High Grade">
                                </div>
                                <span class="category-name">High Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="#" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_4.jpg" alt="Real Grade">
                                </div>
                                <span class="category-name">Real Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="#" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_3.jpg" alt="Master Grade">
                                </div>
                                <span class="category-name">Master Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="#" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_5.jpg" alt="Perfect Grade">
                                </div>
                                <span class="category-name">Perfect Grade</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="#" class="category-link">
                                <div class="category-icon">
                                    <img src="<%=request.getContextPath()%>/img/coll_1.jpg" alt="Metal Build">
                                </div>
                                <span class="category-name">Metal Build</span>
                            </a>
                        </div>
                        <div class="category-item">
                            <a href="#" class="category-link">
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
    </section>    <!-- Product Sections -->
    <!-- New Arrivals -->
    <section class="product-section py-5">
        <div class="container">
            <div class="section-header mb-4">
                <h2 class="section-title">
                    <span class="title-icon">🆕</span>
                    Hàng Mới Về
                </h2>
                <a href="#" class="view-all-btn">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
            </div>
            <div class="row">
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=RG+RX-78" class="img-fluid" alt="RG RX-78-2">
                            <div class="product-badges>
                                <span class="badge bg-success">Mới</span>
                            </div>
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">RG RX-78-2 Gundam</h6>
                            <p class="product-category">Real Grade</p>
                            <div class="product-price">
                                <span class="current-price">650.000₫</span>
                                <span class="old-price">750.000₫</span>
                                <span class="discount-percent">-13%</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=MG+Wing" class="img-fluid" alt="MG Wing Zero">
                            <div class="product-badges">
                                <span class="badge bg-danger">Hot</span>
                            </div>
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">MG Wing Gundam Zero</h6>
                            <p class="product-category">Master Grade</p>
                            <div class="product-price">
                                <span class="current-price">1.200.000₫</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=HG+Strike" class="img-fluid" alt="HG Strike Freedom">
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">HG Strike Freedom</h6>
                            <p class="product-category">High Grade</p>
                            <div class="product-price">
                                <span class="current-price">450.000₫</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=PG+Unicorn" class="img-fluid" alt="PG Unicorn">
                            <div class="product-badges">
                                <span class="badge bg-warning">Premium</span>
                            </div>
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">PG Unicorn Gundam</h6>
                            <p class="product-category">Perfect Grade</p>
                            <div class="product-price">
                                <span class="current-price">3.500.000₫</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=RG+Barbatos" class="img-fluid" alt="RG Barbatos">
                            <div class="product-badges">
                                <span class="badge bg-success">Mới</span>
                            </div>
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">RG Gundam Barbatos</h6>
                            <p class="product-category">Real Grade</p>
                            <div class="product-price">
                                <span class="current-price">750.000₫</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=MG+Destiny" class="img-fluid" alt="MG Destiny">
                            <div class="product-overlay">
                                <a href="<%=request.getContextPath()%>/product-detail.jsp" class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </a>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">MG Destiny Gundam</h6>
                            <p class="product-category">Master Grade</p>
                            <div class="product-price">
                                <span class="current-price">1.350.000₫</span>
                                <span class="old-price">1.500.000₫</span>
                                <span class="discount-percent">-10%</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
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
                    <span class="title-icon">📦</span>
                    Hàng Pre-Order
                </h2>
                <a href="#" class="view-all-btn">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
            </div>
            <div class="row">
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=MG+RX-78" class="img-fluid" alt="MG RX-78-2 Fat Cat">
                            <div class="product-badges">
                                <span class="badge bg-info">Pre-Order</span>
                                <span class="badge bg-danger">-86%</span>
                            </div>
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </button>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">MG RX-78-2 2.0 Fat Cat</h6>
                            <p class="product-category">Master Grade</p>
                            <div class="product-price">
                                <span class="current-price">100.000₫</span>
                                <span class="old-price">680.000₫</span>
                                <span class="discount-percent">-86%</span>
                            </div>
                            <button class="btn btn-warning add-to-cart w-100">
                                <i class="fas fa-clock me-1"></i>Đặt trước
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Add more pre-order products as needed -->
            </div>
        </div>
    </section>

    <!-- Tools & Accessories Section -->
    <section class="product-section py-5">
        <div class="container">
            <div class="section-header mb-4">
                <h2 class="section-title">
                    <span class="title-icon">🛠️</span>
                    Phụ Kiện & Mô Hình
                </h2>
                <a href="#" class="view-all-btn">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
            </div>
            <div class="row">
                <div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/250x250/cccccc/666666?text=Paint+Set" class="img-fluid" alt="Paint Set">
                            <div class="product-overlay">
                                <button class="btn btn-outline-light btn-sm">
                                    <i class="fas fa-eye"></i> Xem nhanh
                                </button>
                            </div>
                        </div>
                        <div class="product-info">
                            <h6 class="product-title">Mr. Color Paint Set</h6>
                            <p class="product-category">Dụng cụ sơn</p>
                            <div class="product-price">
                                <span class="current-price">210.000₫</span>
                            </div>
                            <button class="btn btn-primary add-to-cart w-100">
                                <i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
                <!-- Add more tools and accessories as needed -->
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

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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

        // Add to cart functionality
        document.querySelectorAll('.add-to-cart').forEach(button => {
            button.addEventListener('click', function() {
                // Add your cart logic here
                this.innerHTML = '<i class="fas fa-check me-1"></i>Đã thêm';
                this.classList.add('btn-success');
                this.classList.remove('btn-primary');
                
                setTimeout(() => {
                    this.innerHTML = '<i class="fas fa-cart-plus me-1"></i>Thêm vào giỏ';
                    this.classList.remove('btn-success');
                    this.classList.add('btn-primary');
                }, 2000);
            });
        });

        // Category popup functionality
        const categoryBtn = document.getElementById('categoryBtn');
        const categoryPopup = document.getElementById('categoryPopup');

        categoryBtn.addEventListener('click', () => {
            categoryPopup.classList.toggle('show');
        });

        window.addEventListener('click', (e) => {
            if (!categoryBtn.contains(e.target) && !categoryPopup.contains(e.target)) {
                categoryPopup.classList.remove('show');
            }
        });

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
