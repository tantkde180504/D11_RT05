<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
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
                                    <li id="userMenu" class="d-none">
                                        <span class="dropdown-item disabled"><i class="fas fa-user me-2"></i>Xin chào, <span id="userName">User</span></span>
                                    </li>
                                    <li id="userAccountOption" class="d-none"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp">
                                        <i class="fas fa-id-card me-2"></i>Thông tin tài khoản
                                    </a></li>
                                    <li id="userOrdersOption" class="d-none"><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp" onclick="document.getElementById('profileOrdersTab').click();return false;">
                                        <i class="fas fa-box me-2"></i>Đơn hàng của bạn
                                    </a></li>
                                    <li id="userDivider" class="d-none"><hr class="dropdown-divider"></li>
                                    <li id="userLogoutOption" class="d-none"><a class="dropdown-item text-danger" href="#" onclick="userLogout()">
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
    </section>    <!-- Main Content: Chi tiết sản phẩm -->
    <main class="product-detail-container">
        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-nav d-none" id="breadcrumb-nav">
            <div class="container">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/all-products.jsp">Tất cả sản phẩm</a></li>
                        <li class="breadcrumb-item active" id="breadcrumb-product-name" aria-current="page">Chi tiết sản phẩm</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Loading State -->
        <div class="container">
            <div class="text-center py-5" id="product-loading">                <div class="loading-skeleton image mx-auto mb-4"></div>
                <div class="loading-skeleton title mx-auto mb-3"></div>
                <div class="loading-skeleton text mx-auto mb-2"></div>
                <div class="loading-skeleton text-small mx-auto mb-4"></div>
                <p class="text-muted">Đang tải thông tin sản phẩm từ database...</p>
            </div>

            <!-- Product Detail Content -->
            <div class="row g-4 d-none" id="product-content">
                <!-- Product Gallery -->
                <div class="col-lg-6">
                    <div class="product-gallery">
                        <div class="main-image-container">
                            <img id="main-product-image" 
                                 src="<%=request.getContextPath()%>/img/default-gundam.jpg" 
                                 alt="Product Image" 
                                 class="main-product-image image-zoom">
                        </div>
                        <div class="gallery-thumbnails" id="thumbnail-container">
                            <!-- Thumbnails will be loaded dynamically -->
                        </div>
                    </div>
                </div>

                <!-- Product Information -->
                <div class="col-lg-6">
                    <div class="product-info">
                        <!-- Product Title -->
                        <h1 class="product-title" id="product-title">Đang tải tên sản phẩm...</h1>
                        
                        <!-- Product Meta Information -->
                        <div class="product-meta" id="product-meta">
                            <!-- Grade, Brand, Stock status badges will be added here -->
                        </div>

                        <!-- Price Section -->
                        <div class="product-price-section" id="price-section">
                            <div class="d-flex align-items-center flex-wrap">
                                <span class="current-price" id="current-price">Đang tải giá...</span>                                <span class="old-price d-none" id="old-price"></span>
                                <span class="discount-percentage d-none" id="discount-badge"></span>
                            </div>
                        </div>

                        <!-- Product Description -->
                        <div class="product-description" id="product-description">
                            Đang tải mô tả sản phẩm...
                        </div>

                        <!-- Quantity Selector -->
                        <div class="quantity-selector d-none" id="quantity-selector">
                            <button type="button" class="quantity-btn" onclick="decreaseQuantity()">-</button>
                            <input type="number" class="quantity-input" id="quantity-input" value="1" min="1">
                            <button type="button" class="quantity-btn" onclick="increaseQuantity()">+</button>
                        </div>

                        <!-- Action Buttons -->
                        <div class="product-actions">
                            <button class="btn-add-to-cart" id="add-to-cart-btn" disabled>
                                <i class="fas fa-spinner fa-spin me-2"></i>Đang tải...
                            </button>
                            <button class="btn-wishlist d-none" id="wishlist-btn">
                                <i class="fas fa-heart me-2"></i>Yêu thích
                            </button>
                        </div>

                        <!-- Product Specifications Table -->
                        <div class="specifications-table d-none" id="specifications-container">
                            <table class="table table-striped mb-0">
                                <tbody id="specifications-table">
                                    <!-- Specifications will be loaded dynamically -->
                                </tbody>
                            </table>
                        </div>

                        <!-- Product Policies -->
                        <div class="product-policies">
                            <div class="policy-item">
                                <i class="fas fa-shipping-fast policy-icon"></i>
                                <span class="policy-text">Giao hàng toàn quốc, nhận hàng trong 2-3 ngày</span>
                            </div>
                            <div class="policy-item">
                                <i class="fas fa-undo policy-icon"></i>
                                <span class="policy-text">Đổi trả miễn phí trong 7 ngày nếu có lỗi từ nhà sản xuất</span>
                            </div>
                            <div class="policy-item">
                                <i class="fas fa-shield-alt policy-icon"></i>
                                <span class="policy-text">Bảo hành chính hãng theo quy định của Bandai</span>
                            </div>
                            <div class="policy-item">
                                <i class="fas fa-phone policy-icon"></i>
                                <span class="policy-text">Hỗ trợ 24/7 qua hotline: 0385546145</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>        <!-- Product Tabs -->
        <div class="container">
            <div class="product-tabs d-none" id="product-tabs">
                <div class="row">
                    <div class="col-lg-8">
                        <ul class="nav nav-tabs" id="productTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="description-tab" data-bs-toggle="tab" 
                                        data-bs-target="#description" type="button" role="tab" 
                                        aria-controls="description" aria-selected="true">
                                    <i class="fas fa-info-circle me-2"></i>Mô tả chi tiết
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="specifications-tab" data-bs-toggle="tab" 
                                        data-bs-target="#specifications" type="button" role="tab" 
                                        aria-controls="specifications" aria-selected="false">
                                    <i class="fas fa-list-ul me-2"></i>Thông số kỹ thuật
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" 
                                        data-bs-target="#reviews" type="button" role="tab" 
                                        aria-controls="reviews" aria-selected="false">
                                    <i class="fas fa-star me-2"></i>Đánh giá (0)
                                </button>
                            </li>
                        </ul>
                        
                        <div class="tab-content" id="productTabContent">
                            <!-- Description Tab -->
                            <div class="tab-pane fade show active" id="description" role="tabpanel" 
                                 aria-labelledby="description-tab">
                                <div id="product-description-content">
                                    <p class="text-muted">Đang tải mô tả sản phẩm...</p>
                                </div>
                            </div>
                            
                            <!-- Specifications Tab -->
                            <div class="tab-pane fade" id="specifications" role="tabpanel" 
                                 aria-labelledby="specifications-tab">
                                <div class="specifications-table">
                                    <table class="table table-striped" id="specs-detail-table">
                                        <tbody>
                                            <tr><td colspan="2" class="text-muted text-center">Đang tải thông số kỹ thuật...</td></tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            
                            <!-- Reviews Tab -->
                            <div class="tab-pane fade" id="reviews" role="tabpanel" 
                                 aria-labelledby="reviews-tab">
                                <div class="reviews-section">
                                    <div class="review-summary">
                                        <div class="review-score">
                                            <div class="score-number">0.0</div>
                                            <div class="score-stars">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <div class="score-text">0 đánh giá</div>
                                        </div>
                                        <div class="review-actions">
                                            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                                <i class="fas fa-plus me-2"></i>Viết đánh giá
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <div class="reviews-list" id="reviews-list">
                                        <div class="text-center text-muted py-4">
                                            <i class="fas fa-comments fa-3x mb-3"></i>
                                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                                            <p>Hãy là người đầu tiên đánh giá sản phẩm!</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Related Products Sidebar -->
                    <div class="col-lg-4">
                        <div class="related-products">
                            <h5 class="section-title mb-3">
                                <i class="fas fa-layer-group title-icon"></i>
                                Sản phẩm liên quan
                            </h5>
                            <div id="related-products-container">
                                <div class="text-center py-4">
                                    <div class="spinner-border spinner-border-sm text-primary" role="status">
                                        <span class="visually-hidden">Đang tải...</span>
                                    </div>
                                    <p class="text-muted mt-2 small">Đang tải sản phẩm liên quan...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Review Modal -->
    <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="reviewModalLabel">Viết đánh giá sản phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form class="review-form" id="reviewForm">
                        <div class="mb-3">
                            <label class="form-label">Đánh giá của bạn</label>
                            <div class="star-rating" id="starRating">
                                <span class="star" data-rating="1">★</span>
                                <span class="star" data-rating="2">★</span>
                                <span class="star" data-rating="3">★</span>
                                <span class="star" data-rating="4">★</span>
                                <span class="star" data-rating="5">★</span>
                            </div>
                            <input type="hidden" id="rating" name="rating" value="5">
                        </div>
                        <div class="mb-3">
                            <label for="reviewTitle" class="form-label">Tiêu đề đánh giá</label>
                            <input type="text" class="form-control" id="reviewTitle" name="reviewTitle" 
                                   placeholder="Tóm tắt đánh giá của bạn..." required>
                        </div>
                        <div class="mb-3">
                            <label for="reviewComment" class="form-label">Nội dung đánh giá</label>
                            <textarea class="form-control" id="reviewComment" name="reviewComment" rows="4" 
                                      placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="reviewerName" class="form-label">Tên của bạn</label>
                            <input type="text" class="form-control" id="reviewerName" name="reviewerName" 
                                   placeholder="Nhập tên hiển thị..." required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="submitReview()">
                        <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                    </button>
                </div>
            </div>
        </div>
    </div>
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

    <!-- Product Detail Dynamic Manager -->
    <script src="<%=request.getContextPath()%>/js/product-detail-manager.js"></script>
    
    <!-- Additional JavaScript for enhanced functionality -->
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
            
            // Show content when product is loaded
            setTimeout(function() {
                const loadingElement = document.getElementById('product-loading');
                const breadcrumbNav = document.getElementById('breadcrumb-nav');
                const productContent = document.getElementById('product-content');
                const productTabs = document.getElementById('product-tabs');
                
                if (window.productDetailManager && window.productDetailManager.product) {
                    // Product loaded successfully
                    if (loadingElement) loadingElement.style.display = 'none';
                    if (breadcrumbNav) breadcrumbNav.style.display = 'block';
                    if (productContent) productContent.style.display = 'block';
                    if (productTabs) productTabs.style.display = 'block';
                } else {
                    // Show static content after delay if dynamic loading fails
                    setTimeout(function() {
                        if (loadingElement) loadingElement.style.display = 'none';
                        if (breadcrumbNav) breadcrumbNav.style.display = 'block';
                        if (productContent) productContent.style.display = 'block';
                        if (productTabs) productTabs.style.display = 'block';
                    }, 3000);
                }
            }, 1000);
            
            // Back to top functionality
            const backToTopBtn = document.getElementById('backToTop');
            if (backToTopBtn) {
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
            }
        });
        
        // Quantity controls
        window.decreaseQuantity = function() {
            const input = document.getElementById('quantity-input');
            const current = parseInt(input.value);
            if (current > 1) {
                input.value = current - 1;
            }
        }

        window.increaseQuantity = function() {
            const input = document.getElementById('quantity-input');
            const current = parseInt(input.value);
            const max = parseInt(input.getAttribute('max')) || 999;
            if (current < max) {
                input.value = current + 1;
            }
        }

        // Star rating functionality
        function initStarRating() {
            const stars = document.querySelectorAll('.star-rating .star');
            const ratingInput = document.getElementById('rating');
            
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    ratingInput.value = rating;
                    
                    // Update star display
                    stars.forEach((s, index) => {
                        if (index < rating) {
                            s.classList.add('active');
                        } else {
                            s.classList.remove('active');
                        }
                    });
                });
                
                star.addEventListener('mouseover', function() {
                    const rating = this.getAttribute('data-rating');
                    stars.forEach((s, index) => {
                        if (index < rating) {
                            s.style.color = 'var(--warning-color)';
                        } else {
                            s.style.color = 'var(--border-color)';
                        }
                    });
                });
            });
            
            const starRating = document.querySelector('.star-rating');
            if (starRating) {
                starRating.addEventListener('mouseleave', function() {
                    const currentRating = ratingInput.value;
                    stars.forEach((s, index) => {
                        if (index < currentRating) {
                            s.style.color = 'var(--warning-color)';
                        } else {
                            s.style.color = 'var(--border-color)';
                        }
                    });
                });
            }
        }

        // Submit review
        window.submitReview = function() {
            const form = document.getElementById('reviewForm');
            const formData = new FormData(form);
            
            // Basic validation
            if (!formData.get('reviewTitle') || !formData.get('reviewComment') || !formData.get('reviewerName')) {
                alert('Vui lòng điền đầy đủ thông tin đánh giá!');
                return;
            }
            
            // Here you would normally send the review to your backend
            console.log('Review submitted:', Object.fromEntries(formData));
            
            // Close modal and show success message
            const modal = bootstrap.Modal.getInstance(document.getElementById('reviewModal'));
            if (modal) modal.hide();
            
            alert('Cảm ơn bạn đã đánh giá! Đánh giá của bạn sẽ được duyệt và hiển thị sớm.');
            
            // Reset form
            form.reset();
            document.getElementById('rating').value = '5';
            initStarRating();
        }

        // Image gallery functionality
        window.initImageGallery = function() {
            const thumbnails = document.querySelectorAll('.thumbnail-image');
            const mainImage = document.getElementById('main-product-image');
            
            thumbnails.forEach(thumb => {
                thumb.addEventListener('click', function() {
                    // Remove active class from all thumbnails
                    thumbnails.forEach(t => t.classList.remove('active'));
                    
                    // Add active class to clicked thumbnail
                    this.classList.add('active');
                    
                    // Update main image
                    mainImage.src = this.src;
                    mainImage.alt = this.alt;
                });
            });
        }

        // Enhanced initialization
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize star rating if exists
            if (document.querySelector('.star-rating')) {
                initStarRating();
            }
        });
    </script>
</body>
</html>
