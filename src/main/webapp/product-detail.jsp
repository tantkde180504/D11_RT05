<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.mycompany.model.Product" %>
<%
    // Lấy thông tin sản phẩm từ request parameter hoặc attribute
    String productIdParam = request.getParameter("id");
    Long productId = null;
    
    if (productIdParam != null && !productIdParam.trim().isEmpty()) {
        try {
            productId = Long.parseLong(productIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/all-products.jsp");
            return;
        }
    }
    
    // Nếu không có ID, redirect về trang all-products
    if (productId == null) {
        response.sendRedirect(request.getContextPath() + "/all-products.jsp");
        return;
    }
    
    // Format number cho giá tiền (VND)
    NumberFormat vndFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - 43 Gundam Hobby</title>
    <meta name="description" content="Xem chi tiết sản phẩm mô hình Gundam chính hãng tại 43 Gundam Hobby">
    <meta name="keywords" content="gundam, mô hình, bandai, chi tiết sản phẩm">
    
    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/product-detail.css" rel="stylesheet">
    
    <!-- Google OAuth Handler -->
    <script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>
    
    <!-- Google Fonts -->
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
                <div class="col-lg-6 col-md-4 col-12 order-md-2 order-3">
                    <div class="header-center-section">
                        <div class="search-container">
                            <form class="search-form" action="<%=request.getContextPath()%>/search" method="get">
                                <div class="input-group">
                                    <input type="text" class="form-control" name="q" placeholder="Tìm kiếm sản phẩm..." aria-label="Search">
                                    <button class="btn btn-search" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- User Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-md-3 order-2">
                    <div class="header-actions-section">
                        <!-- Account Menu -->
                        <div class="account-menu me-3">
                            <!-- User Info (visible when logged in) -->
                            <div id="nav-user-info" class="d-none"></div>
                            
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
                        
                        <!-- Cart Button -->
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

    <!-- Include Sidebar Navigation -->
    <%@ include file="includes/mobile-sidebar.jsp" %>

    <!-- Product Detail Container -->
    <div class="product-detail-container">
        <div class="container">
            <!-- Breadcrumb -->
            <div class="breadcrumb-section">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/"><i class="fas fa-home me-1"></i>Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/all-products.jsp">Sản phẩm</a></li>
                        <li class="breadcrumb-item active" aria-current="page" id="productBreadcrumb">Chi tiết sản phẩm</li>
                    </ol>
                </nav>
            </div>

            <!-- Loading State -->
            <div id="loadingState" class="text-center py-5">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="visually-hidden">Đang tải...</span>
                </div>
                <p class="mt-3 text-muted">Đang tải thông tin sản phẩm...</p>
            </div>

            <!-- Error State -->
            <div id="errorState" class="alert alert-danger text-center" style="display: none;">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <span id="errorMessage">Có lỗi xảy ra khi tải thông tin sản phẩm.</span>
                <div class="mt-3">
                    <a href="<%=request.getContextPath()%>/all-products.jsp" class="btn btn-primary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách sản phẩm
                    </a>
                </div>
            </div>

            <!-- Product Main Info -->
            <div id="productMain" class="product-main" style="display: none;">
                <div class="row">
                    <!-- Product Images -->
                    <div class="col-lg-6 col-md-6">
                        <div class="product-image-gallery">
                            <div class="main-product-image">
                                <div class="product-badges" id="productBadges">
                                    <!-- Badges will be inserted here dynamically -->
                                </div>
                                <img id="mainProductImg" src="" alt="Product Image" class="img-fluid">
                            </div>
                            <div class="product-thumbnails" id="productThumbnails">
                                <!-- Thumbnails will be inserted here if available -->
                            </div>
                        </div>
                    </div>
                    
                    <!-- Product Info -->
                    <div class="col-lg-6 col-md-6">
                        <div class="product-info">
                            <h1 class="product-title" id="productTitle">Tên sản phẩm</h1>
                            
                            <div class="product-meta" id="productMeta">
                                <!-- Meta info will be inserted here -->
                            </div>
                            
                            <div class="product-price" id="productPrice">
                                <!-- Price will be inserted here -->
                            </div>
                            
                            <div class="stock-status" id="stockStatus">
                                <!-- Stock status will be inserted here -->
                            </div>
                            
                            <div class="quantity-section">
                                <span class="quantity-label">Số lượng:</span>
                                <div class="quantity-control">
                                    <button type="button" class="quantity-btn" id="decreaseQty">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number" class="quantity-input" id="quantityInput" value="1" min="1" max="10">
                                    <button type="button" class="quantity-btn" id="increaseQty">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="product-actions">
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-add-cart" id="addToCartBtn">
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                                    </button>
                                    <button type="button" class="btn btn-buy-now" id="buyNowBtn">
                                        <i class="fas fa-bolt me-2"></i>Mua ngay
                                    </button>
                                    <button type="button" class="btn btn-wishlist" id="wishlistBtn" title="Thêm vào yêu thích">
                                        <i class="far fa-heart"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Product Description -->
            <div id="productDescription" class="product-description" style="display: none;">
                <h2 class="section-title">
                    <i class="fas fa-info-circle me-2"></i>Mô tả sản phẩm
                </h2>
                <div class="description-content" id="descriptionContent">
                    <!-- Description will be inserted here -->
                </div>
            </div>

            <!-- Product Specifications -->
            <div id="productSpecifications" class="product-specifications" style="display: none;">
                <h2 class="section-title">
                    <i class="fas fa-list-ul me-2"></i>Thông số kỹ thuật
                </h2>
                <div class="table-responsive">
                    <table class="spec-table">
                        <tbody id="specTableBody">
                            <!-- Specifications will be inserted here -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Product Reviews Section -->
            <div class="product-reviews">
                <div class="reviews-header">
                    <h2 class="section-title">
                        <i class="fas fa-star me-2"></i>Đánh giá sản phẩm
                    </h2>
                    <div class="rating-summary">
                        <div class="overall-rating">
                            <div class="rating-score">
                                <span class="score" id="overallScore">4.5</span>
                                <div class="rating-stars" id="overallStars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                </div>
                                <span class="total-reviews" id="totalReviews">(23 đánh giá)</span>
                            </div>
                        </div>
                        <div class="rating-breakdown">
                            <div class="rating-bar">
                                <span class="rating-label">5 sao</span>
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 60%"></div>
                                </div>
                                <span class="rating-count">14</span>
                            </div>
                            <div class="rating-bar">
                                <span class="rating-label">4 sao</span>
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 30%"></div>
                                </div>
                                <span class="rating-count">7</span>
                            </div>
                            <div class="rating-bar">
                                <span class="rating-label">3 sao</span>
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 8%"></div>
                                </div>
                                <span class="rating-count">2</span>
                            </div>
                            <div class="rating-bar">
                                <span class="rating-label">2 sao</span>
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 0%"></div>
                                </div>
                                <span class="rating-count">0</span>
                            </div>
                            <div class="rating-bar">
                                <span class="rating-label">1 sao</span>
                                <div class="bar-container">
                                    <div class="bar-fill" style="width: 2%"></div>
                                </div>
                                <span class="rating-count">0</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Add Review Form -->
                <div class="add-review" id="addReviewSection">
                    <h3 class="review-form-title">
                        <i class="fas fa-edit me-2"></i>Viết đánh giá
                    </h3>
                    <form class="review-form" id="reviewForm">
                        <div class="rating-input">
                            <label class="form-label">Đánh giá của bạn *</label>
                            <div class="star-rating" id="starRating">
                                <span class="star" data-rating="1"><i class="far fa-star"></i></span>
                                <span class="star" data-rating="2"><i class="far fa-star"></i></span>
                                <span class="star" data-rating="3"><i class="far fa-star"></i></span>
                                <span class="star" data-rating="4"><i class="far fa-star"></i></span>
                                <span class="star" data-rating="5"><i class="far fa-star"></i></span>
                            </div>
                            <input type="hidden" id="ratingValue" name="rating" value="0">
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="reviewerName" class="form-label">Họ tên *</label>
                                <input type="text" class="form-control" id="reviewerName" name="name" required>
                            </div>
                            <div class="col-md-6">
                                <label for="reviewerEmail" class="form-label">Email *</label>
                                <input type="email" class="form-control" id="reviewerEmail" name="email" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="reviewTitle" class="form-label">Tiêu đề đánh giá</label>
                            <input type="text" class="form-control" id="reviewTitle" name="title" placeholder="Tóm tắt đánh giá của bạn">
                        </div>
                        <div class="mb-3">
                            <label for="reviewContent" class="form-label">Nội dung đánh giá *</label>
                            <textarea class="form-control" id="reviewContent" name="content" rows="4" 
                                placeholder="Chia sẻ trải nghiệm của bạn về sản phẩm này..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                        </button>
                    </form>
                </div>

                <!-- Reviews List -->
                <div class="reviews-list" id="reviewsList">
                    <div class="reviews-header-controls">
                        <h3>Tất cả đánh giá</h3>
                        <div class="review-filters">
                            <select class="form-select" id="reviewFilter">
                                <option value="all">Tất cả đánh giá</option>
                                <option value="5">5 sao</option>
                                <option value="4">4 sao</option>
                                <option value="3">3 sao</option>
                                <option value="2">2 sao</option>
                                <option value="1">1 sao</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Sample Reviews -->
                    <div class="review-item">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="reviewer-details">
                                    <h5 class="reviewer-name">Nguyễn Minh Tuấn</h5>
                                    <div class="review-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="review-date">2 ngày trước</span>
                                </div>
                            </div>
                        </div>
                        <div class="review-content">
                            <h6 class="review-title">Sản phẩm tuyệt vời!</h6>
                            <p>Chất lượng plastic rất tốt, chi tiết sắc nét. Đóng gói cẩn thận, giao hàng nhanh. Rất hài lòng với mua hàng này. Sẽ tiếp tục ủng hộ shop!</p>
                        </div>
                        <div class="review-actions">
                            <button class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-thumbs-up me-1"></i>Hữu ích (5)
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-reply me-1"></i>Trả lời
                            </button>
                        </div>
                    </div>

                    <div class="review-item">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="reviewer-details">
                                    <h5 class="reviewer-name">Lê Hoàng Nam</h5>
                                    <div class="review-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="far fa-star"></i>
                                    </div>
                                    <span class="review-date">1 tuần trước</span>
                                </div>
                            </div>
                        </div>
                        <div class="review-content">
                            <h6 class="review-title">Tốt nhưng có thể cải thiện</h6>
                            <p>Mô hình đẹp, lắp ráp dễ dàng. Tuy nhiên một số chi tiết nhỏ hơi khó khớp. Nhìn chung vẫn rất hài lòng với sản phẩm.</p>
                        </div>
                        <div class="review-actions">
                            <button class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-thumbs-up me-1"></i>Hữu ích (2)
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-reply me-1"></i>Trả lời
                            </button>
                        </div>
                    </div>

                    <div class="review-item">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="reviewer-details">
                                    <h5 class="reviewer-name">Trần Thị Mai</h5>
                                    <div class="review-rating">
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <span class="review-date">2 tuần trước</span>
                                </div>
                            </div>
                        </div>
                        <div class="review-content">
                            <h6 class="review-title">Mua cho con trai, bé rất thích</h6>
                            <p>Bé rất thích mô hình này. Chất lượng tốt, an toàn cho trẻ em. Giao hàng đúng hẹn. Shop phục vụ tận tình. Sẽ quay lại mua thêm!</p>
                        </div>
                        <div class="review-actions">
                            <button class="btn btn-sm btn-outline-primary">
                                <i class="fas fa-thumbs-up me-1"></i>Hữu ích (8)
                            </button>
                            <button class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-reply me-1"></i>Trả lời
                            </button>
                        </div>
                    </div>

                    <!-- Load More Reviews -->
                    <div class="text-center mt-4">
                        <button class="btn btn-outline-primary" id="loadMoreReviews">
                            <i class="fas fa-chevron-down me-2"></i>Xem thêm đánh giá
                        </button>
                    </div>
                </div>
            </div>

            <!-- Related Products -->
            <div id="relatedProducts" class="related-products" style="display: none;">
                <h2 class="section-title">
                    <i class="fas fa-cubes me-2"></i>Sản phẩm liên quan
                </h2>
                <div class="related-products-grid" id="relatedProductsGrid">
                    <!-- Related products will be inserted here -->
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
    
    <!-- Hamburger Menu Script -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    
    <!-- Product Detail Script -->
    <script>
        // Product ID from server
        const productId = <%= productId %>;
        const contextPath = '<%= request.getContextPath() %>';
        
        // Load product data when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadProductData();
            setupEventListeners();
        });
        
        // Load product data from API
        async function loadProductData() {
            try {
                const response = await fetch(contextPath + '/api/products/' + productId);
                const data = await response.json();
                
                if (data.success && data.data) {
                    displayProduct(data.data);
                    document.getElementById('loadingState').style.display = 'none';
                    
                    // Load reviews for this product
                    loadProductReviews(productId);
                } else {
                    showError(data.message || 'Không tìm thấy sản phẩm');
                }
            } catch (error) {
                console.error('Error loading product:', error);
                showError('Có lỗi xảy ra khi tải thông tin sản phẩm');
            }
        }
        
        // Display product information
        function displayProduct(product) {
            // Update page title and breadcrumb
            document.title = product.name + ' - 43 Gundam Hobby';
            document.getElementById('productBreadcrumb').textContent = product.name;
            
            // Display main product info
            document.getElementById('productTitle').textContent = product.name;
            
            // Display product image
            const defaultImage = contextPath + '/img/RGStrikeGundam.jpg';
            const productImage = product.imageUrl || defaultImage;
            document.getElementById('mainProductImg').src = productImage;
            document.getElementById('mainProductImg').alt = product.name;
            
            // Display product meta
            displayProductMeta(product);
            
            // Display price
            displayProductPrice(product);
            
            // Display stock status
            displayStockStatus(product);
            
            // Display description
            displayProductDescription(product);
            
            // Display specifications
            displayProductSpecifications(product);
            
            // Load related products
            loadRelatedProducts(product);
            
            // Show all sections
            document.getElementById('productMain').style.display = 'block';
            document.getElementById('productDescription').style.display = 'block';
            document.getElementById('productSpecifications').style.display = 'block';
        }
        
        // Display product meta information
        function displayProductMeta(product) {
            let metaHtml = '';
            
            if (product.category) {
                metaHtml += '<div class="product-category"><i class="fas fa-tag"></i><span>' + getCategoryDisplayName(product.category) + '</span></div>';
            }
            
            if (product.grade) {
                metaHtml += '<div class="product-grade"><i class="fas fa-star"></i><span>' + product.grade + '</span></div>';
            }
            
            if (product.brand) {
                metaHtml += '<div class="product-brand"><i class="fas fa-industry"></i><span>' + product.brand + '</span></div>';
            }
            
            document.getElementById('productMeta').innerHTML = metaHtml;
        }
        
        // Display product price
        function displayProductPrice(product) {
            const price = parseFloat(product.price);
            const formattedPrice = new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
            
            const priceHtml = '<div class="current-price">' + formattedPrice + '</div>';
            document.getElementById('productPrice').innerHTML = priceHtml;
        }
        
        // Display stock status
        function displayStockStatus(product) {
            const stock = parseInt(product.stockQuantity);
            let statusClass, statusIcon, statusText;
            
            if (stock > 10) {
                statusClass = 'in-stock';
                statusIcon = 'fas fa-check-circle';
                statusText = 'Còn hàng';
            } else if (stock > 0) {
                statusClass = 'low-stock';
                statusIcon = 'fas fa-exclamation-triangle';
                statusText = 'Chỉ còn ' + stock + ' sản phẩm';
            } else {
                statusClass = 'out-of-stock';
                statusIcon = 'fas fa-times-circle';
                statusText = 'Hết hàng';
            }
            
            const statusHtml = '<i class="' + statusIcon + '"></i><span>' + statusText + '</span>';
            
            const statusElement = document.getElementById('stockStatus');
            statusElement.className = 'stock-status ' + statusClass;
            statusElement.innerHTML = statusHtml;
            
            // Update quantity input max value
            const qtyInput = document.getElementById('quantityInput');
            qtyInput.max = Math.max(1, stock);
            
            // Disable buttons if out of stock
            const addToCartBtn = document.getElementById('addToCartBtn');
            const buyNowBtn = document.getElementById('buyNowBtn');
            
            if (stock <= 0) {
                addToCartBtn.disabled = true;
                addToCartBtn.innerHTML = '<i class="fas fa-times me-2"></i>Hết hàng';
                buyNowBtn.disabled = true;
                buyNowBtn.innerHTML = '<i class="fas fa-times me-2"></i>Hết hàng';
                qtyInput.disabled = true;
            }
        }
        
        // Display product description
        function displayProductDescription(product) {
            const description = product.description || 'Chưa có mô tả chi tiết cho sản phẩm này.';
            document.getElementById('descriptionContent').innerHTML = '<p>' + description + '</p>';
        }
        
        // Display product specifications
        function displayProductSpecifications(product) {
            const specs = [
                { label: 'Tên sản phẩm', value: product.name },
                { label: 'Thương hiệu', value: product.brand || 'N/A' },
                { label: 'Danh mục', value: getCategoryDisplayName(product.category) },
                { label: 'Cấp độ', value: product.grade || 'N/A' },
                { label: 'Tình trạng', value: product.isActive ? 'Đang bán' : 'Ngừng bán' },
                { label: 'Số lượng tồn kho', value: product.stockQuantity || 0 }
            ];
            
            let specHtml = '';
            specs.forEach(spec => {
                specHtml += '<tr><th>' + spec.label + '</th><td>' + spec.value + '</td></tr>';
            });
            
            document.getElementById('specTableBody').innerHTML = specHtml;
        }
        
        // Load related products
        async function loadRelatedProducts(product) {
            try {
                let relatedProducts = [];
                
                // Try to get products from same category
                if (product.category) {
                    const response = await fetch(contextPath + '/api/products/category/' + product.category);
                    const data = await response.json();
                    
                    if (data.success && data.data) {
                        relatedProducts = data.data.filter(p => p.id !== product.id).slice(0, 8);
                    }
                }
                
                // If not enough, get latest products
                if (relatedProducts.length < 4) {
                    const response = await fetch(contextPath + '/api/products/latest?limit=8');
                    const data = await response.json();
                    
                    if (data.success && data.data) {
                        const latestProducts = data.data.filter(p => p.id !== product.id);
                        relatedProducts = [...relatedProducts, ...latestProducts].slice(0, 8);
                    }
                }
                
                if (relatedProducts.length > 0) {
                    displayRelatedProducts(relatedProducts);
                    document.getElementById('relatedProducts').style.display = 'block';
                }
            } catch (error) {
                console.error('Error loading related products:', error);
            }
        }
        
        // Display related products
        function displayRelatedProducts(products) {
            let html = '';
            products.forEach(product => {
                const price = parseFloat(product.price);
                const formattedPrice = new Intl.NumberFormat('vi-VN', {
                    style: 'currency',
                    currency: 'VND'
                }).format(price);
                
                const defaultImage = contextPath + '/img/RGStrikeGundam.jpg';
                const productImage = product.imageUrl || defaultImage;
                
                html += '<div class="related-product-card">' +
                    '<div class="related-product-image">' +
                        '<img src="' + productImage + '" alt="' + product.name + '" onerror="this.src=\'' + defaultImage + '\'">' +
                    '</div>' +
                    '<div class="related-product-info">' +
                        '<h6 class="related-product-title">' + product.name + '</h6>' +
                        '<div class="related-product-price">' + formattedPrice + '</div>' +
                        '<button class="related-product-btn" onclick="window.location.href=\'' + contextPath + '/product-detail.jsp?id=' + product.id + '\'">' +
                            '<i class="fas fa-eye me-1"></i>Xem chi tiết' +
                        '</button>' +
                    '</div>' +
                '</div>';
            });
            
            document.getElementById('relatedProductsGrid').innerHTML = html;
        }
        
        // Show error message
        function showError(message) {
            document.getElementById('loadingState').style.display = 'none';
            document.getElementById('errorMessage').textContent = message;
            document.getElementById('errorState').style.display = 'block';
        }
        
        // Get category display name
        function getCategoryDisplayName(category) {
            const categoryNames = {
                'GUNDAM_BANDAI': 'Gundam Bandai',
                'PRE_ORDER': 'Pre-Order',
                'TOOLS_ACCESSORIES': 'Dụng cụ & Phụ kiện'
            };
            return categoryNames[category] || category;
        }
        
        // Setup event listeners
        function setupEventListeners() {
            // Quantity controls
            document.getElementById('decreaseQty').addEventListener('click', function() {
                const input = document.getElementById('quantityInput');
                const currentValue = parseInt(input.value);
                if (currentValue > parseInt(input.min)) {
                    input.value = currentValue - 1;
                }
            });
            
            document.getElementById('increaseQty').addEventListener('click', function() {
                const input = document.getElementById('quantityInput');
                const currentValue = parseInt(input.value);
                if (currentValue < parseInt(input.max)) {
                    input.value = currentValue + 1;
                }
            });
            
            // Add to cart button
            document.getElementById('addToCartBtn').addEventListener('click', function() {
                const quantity = document.getElementById('quantityInput').value;
                // Add your cart logic here
                this.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm vào giỏ';
                this.classList.add('btn-success');
                this.classList.remove('btn-add-cart');
                
                setTimeout(() => {
                    this.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng';
                    this.classList.remove('btn-success');
                    this.classList.add('btn-add-cart');
                }, 2000);
            });
            
            // Buy now button
            document.getElementById('buyNowBtn').addEventListener('click', function() {
                const quantity = document.getElementById('quantityInput').value;
                // Add your buy now logic here
                alert(`Mua ngay ${quantity} sản phẩm`);
            });
            
            // Wishlist button
            document.getElementById('wishlistBtn').addEventListener('click', function() {
                const icon = this.querySelector('i');
                if (icon.classList.contains('far')) {
                    icon.classList.remove('far');
                    icon.classList.add('fas');
                    this.style.color = '#e74c3c';
                } else {
                    icon.classList.remove('fas');
                    icon.classList.add('far');
                    this.style.color = '';
                }
            });
        }
        
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

        // ===== REVIEW FUNCTIONALITY =====
        
        // Star Rating Functionality
        const starRating = document.getElementById('starRating');
        const ratingValue = document.getElementById('ratingValue');
        const stars = starRating.querySelectorAll('.star');
        
        stars.forEach((star, index) => {
            star.addEventListener('mouseenter', () => {
                highlightStars(index + 1);
            });
            
            star.addEventListener('mouseleave', () => {
                highlightStars(parseInt(ratingValue.value));
            });
            
            star.addEventListener('click', () => {
                const rating = index + 1;
                ratingValue.value = rating;
                highlightStars(rating);
            });
        });
        
        function highlightStars(rating) {
            stars.forEach((star, index) => {
                const icon = star.querySelector('i');
                if (index < rating) {
                    star.classList.add('active');
                    icon.className = 'fas fa-star';
                } else {
                    star.classList.remove('active');
                    icon.className = 'far fa-star';
                }
            });
        }
        
        // Review Form Submission
        const reviewForm = document.getElementById('reviewForm');
        reviewForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const rating = parseInt(ratingValue.value);
            if (rating === 0) {
                alert('Vui lòng chọn số sao đánh giá!');
                return;
            }
            
            const formData = new FormData(reviewForm);
            const reviewData = {
                reviewerName: formData.get('name'),
                reviewerEmail: formData.get('email'),
                title: formData.get('title'),
                content: formData.get('content'),
                rating: rating
            };
            
            // Validate required fields
            if (!reviewData.reviewerName || !reviewData.reviewerEmail || !reviewData.content) {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return;
            }
            
            try {
                const response = await fetch(contextPath + '/api/reviews/product/' + productId, {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(reviewData)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert('Cảm ơn bạn đã đánh giá sản phẩm!');
                    reviewForm.reset();
                    ratingValue.value = '0';
                    highlightStars(0);
                    
                    // Reload reviews to show the new one
                    loadProductReviews(productId);
                } else {
                    alert('Có lỗi xảy ra: ' + (result.message || 'Không thể gửi đánh giá'));
                }
                
            } catch (error) {
                console.error('Error submitting review:', error);
                alert('Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại!');
            }
        });
        
        // Load Reviews for Product
        function loadProductReviews(productId) {
            // Load review statistics
            fetch(contextPath + '/api/reviews/product/' + productId + '/statistics')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateReviewStatistics(data.statistics);
                }
            })
            .catch(error => {
                console.error('Error loading review statistics:', error);
            });
            
            // Load reviews list
            fetch(contextPath + '/api/reviews/product/' + productId)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    displayReviews(data.reviews);
                }
            })
            .catch(error => {
                console.error('Error loading reviews:', error);
            });
        }
        
        function updateReviewStatistics(stats) {
            // Update overall score
            const overallScore = document.getElementById('overallScore');
            if (overallScore) {
                overallScore.textContent = stats.averageRating || '0';
            }
            
            // Update total reviews count
            const totalReviews = document.getElementById('totalReviews');
            if (totalReviews) {
                totalReviews.textContent = '(' + (stats.totalReviews || 0) + ' đánh giá)';
            }
            
            // Update star display
            const overallStars = document.getElementById('overallStars');
            if (overallStars) {
                const rating = stats.averageRating || 0;
                const fullStars = Math.floor(rating);
                const hasHalfStar = (rating % 1) >= 0.5;
                
                let starsHtml = '';
                for (let i = 0; i < 5; i++) {
                    if (i < fullStars) {
                        starsHtml += '<i class="fas fa-star"></i>';
                    } else if (i === fullStars && hasHalfStar) {
                        starsHtml += '<i class="fas fa-star-half-alt"></i>';
                    } else {
                        starsHtml += '<i class="far fa-star"></i>';
                    }
                }
                overallStars.innerHTML = starsHtml;
            }
            
            // Update rating breakdown bars
            if (stats.ratingBreakdown) {
                const ratingBars = document.querySelectorAll('.rating-bar');
                for (let i = 1; i <= 5; i++) {
                    const breakdownData = stats.ratingBreakdown[i + '_star'];
                    if (breakdownData && ratingBars[5-i]) {
                        const bar = ratingBars[5-i];
                        const fill = bar.querySelector('.bar-fill');
                        const count = bar.querySelector('.rating-count');
                        
                        if (fill) fill.style.width = breakdownData.percentage + '%';
                        if (count) count.textContent = breakdownData.count;
                    }
                }
            }
        }
        
        function displayReviews(reviews) {
            const reviewsList = document.getElementById('reviewsList');
            if (!reviewsList) return;
            
            // Remove existing reviews but keep header
            const existingReviews = reviewsList.querySelectorAll('.review-item, .no-reviews, .load-more-container');
            existingReviews.forEach(item => item.remove());
            
            if (!reviews || reviews.length === 0) {
                const noReviewsHtml = '<div class="no-reviews text-center py-4">' +
                    '<i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>' +
                    '<h5 class="text-muted">Chưa có đánh giá nào</h5>' +
                    '<p class="text-muted">Hãy là người đầu tiên đánh giá sản phẩm này!</p>' +
                '</div>';
                reviewsList.insertAdjacentHTML('beforeend', noReviewsHtml);
                return;
            }
            
            // Display reviews
            reviews.forEach(review => {
                const reviewHtml = createReviewHtml(review);
                reviewsList.insertAdjacentHTML('beforeend', reviewHtml);
            });
            
            // Add load more button if there are many reviews
            if (reviews.length >= 5) {
                const loadMoreHtml = '<div class="load-more-container text-center mt-4">' +
                    '<button type="button" class="btn btn-outline-primary" id="loadMoreReviews">' +
                        '<i class="fas fa-plus me-2"></i>Xem thêm đánh giá' +
                    '</button>' +
                '</div>';
                reviewsList.insertAdjacentHTML('beforeend', loadMoreHtml);
                
                // Re-attach event listener
                const newLoadMoreBtn = document.getElementById('loadMoreReviews');
                if (newLoadMoreBtn) {
                    newLoadMoreBtn.addEventListener('click', () => {
                        alert('Chức năng đang được phát triển...');
                    });
                }
            }
        }
        
        function createReviewHtml(review) {
            const stars = generateStarsHtml(review.rating);
            const timeAgo = review.timeAgo || formatDate(review.createdDate) || 'Vừa xong';
            const verifiedBadge = review.isVerified ? '<span class="verified-badge ms-2"><i class="fas fa-check-circle"></i> Đã xác thực</span>' : '';
            
            return '<div class="review-item">' +
                '<div class="review-header">' +
                    '<div class="reviewer-info">' +
                        '<div class="reviewer-avatar">' +
                            '<i class="fas fa-user-circle"></i>' +
                        '</div>' +
                        '<div class="reviewer-details">' +
                            '<h5 class="reviewer-name">' + escapeHtml(review.reviewerName) + verifiedBadge + '</h5>' +
                            '<div class="review-rating">' + stars + '</div>' +
                            '<span class="review-date">' + timeAgo + '</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="review-content">' +
                    (review.title ? '<h6 class="review-title">' + escapeHtml(review.title) + '</h6>' : '') +
                    '<p class="review-text">' + escapeHtml(review.content) + '</p>' +
                    '<div class="review-actions">' +
                        '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="markHelpful(' + review.id + ')">' +
                            '<i class="fas fa-thumbs-up me-1"></i>Hữu ích (' + (review.helpfulCount || 0) + ')' +
                        '</button>' +
                    '</div>' +
                '</div>' +
            '</div>';
        }
        
        function generateStarsHtml(rating) {
            let starsHtml = '';
            for (let i = 1; i <= 5; i++) {
                if (i <= rating) {
                    starsHtml += '<i class="fas fa-star"></i>';
                } else {
                    starsHtml += '<i class="far fa-star"></i>';
                }
            }
            return starsHtml;
        }
        
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function formatDate(dateString) {
            if (!dateString) return '';
            try {
                const date = new Date(dateString);
                const now = new Date();
                const diffMs = now - date;
                const diffMinutes = Math.floor(diffMs / (1000 * 60));
                
                if (diffMinutes < 60) {
                    return diffMinutes + ' phút trước';
                } else if (diffMinutes < 1440) {
                    return Math.floor(diffMinutes / 60) + ' giờ trước';
                } else if (diffMinutes < 10080) {
                    return Math.floor(diffMinutes / 1440) + ' ngày trước';
                } else {
                    return date.toLocaleDateString('vi-VN');
                }
            } catch (e) {
                return 'Vừa xong';
            }
        }
        
        function markHelpful(reviewId) {
            alert('Cảm ơn phản hồi của bạn!');
        }
        
        // Review Filter
        const reviewFilter = document.getElementById('reviewFilter');
        if (reviewFilter) {
            reviewFilter.addEventListener('change', (e) => {
                const filterValue = e.target.value;
                const reviewItems = document.querySelectorAll('.review-item');
                
                reviewItems.forEach(item => {
                    if (filterValue === 'all') {
                        item.style.display = 'block';
                    } else {
                        const stars = item.querySelectorAll('.review-rating .fas.fa-star');
                        const reviewRating = stars.length;
                        
                        if (reviewRating == filterValue) {
                            item.style.display = 'block';
                        } else {
                            item.style.display = 'none';
                        }
                    }
                });
            });
        }

        // ===== AUTHENTICATION & USER INFO =====
        
        function initializeUserAuth() {
            // Check multiple sources for user info
            const userInfo = getUserInfo();
            
            if (userInfo && userInfo.name) {
                displayUserInfo(userInfo);
            } else {
                displayLoginButton();
            }
        }
        
        function getUserInfo() {
            // Check localStorage first
            let userInfo = localStorage.getItem('userInfo');
            if (userInfo) {
                try {
                    return JSON.parse(userInfo);
                } catch (e) {
                    console.error('Error parsing userInfo from localStorage:', e);
                }
            }
            
            // Check sessionStorage
            userInfo = sessionStorage.getItem('userInfo');
            if (userInfo) {
                try {
                    return JSON.parse(userInfo);
                } catch (e) {
                    console.error('Error parsing userInfo from sessionStorage:', e);
                }
            }
            
            // Check for OAuth success in URL params (for redirect scenarios)
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('login') === 'success') {
                // Try to get user info via API call if needed
                return null; // Will trigger login button display
            }
            
            return null;
        }
        
        function displayUserInfo(userInfo) {
            const userName = userInfo.name || userInfo.email || userInfo.username || 'Người dùng';
            
            const navUserInfo = document.getElementById('nav-user-info');
            const navLoginBtn = document.getElementById('nav-login-btn');
            
            if (navUserInfo && navLoginBtn) {
                navUserInfo.innerHTML = 
                    '<div class="dropdown">' +
                        '<a href="#" class="btn btn-outline-primary dropdown-toggle" ' +
                           'id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">' +
                            '<i class="fas fa-user-circle me-1"></i>' +
                            '<span class="d-none d-md-inline">' + userName + '</span>' +
                        '</a>' +
                        '<ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">' +
                            '<li><h6 class="dropdown-header">' +
                                '<i class="fas fa-user-circle me-2"></i>' + userName +
                            '</h6></li>' +
                            '<li><hr class="dropdown-divider"></li>' +
                            '<li><a class="dropdown-item" href="' + contextPath + '/profile.jsp">' +
                                '<i class="fas fa-user me-2"></i>Hồ sơ cá nhân' +
                            '</a></li>' +
                            '<li><a class="dropdown-item" href="' + contextPath + '/orders">' +
                                '<i class="fas fa-box me-2"></i>Đơn hàng của tôi' +
                            '</a></li>' +
                            '<li><a class="dropdown-item" href="' + contextPath + '/wishlist">' +
                                '<i class="fas fa-heart me-2"></i>Danh sách yêu thích' +
                            '</a></li>' +
                            '<li><a class="dropdown-item" href="' + contextPath + '/settings">' +
                                '<i class="fas fa-cog me-2"></i>Cài đặt' +
                            '</a></li>' +
                            '<li><hr class="dropdown-divider"></li>' +
                            '<li><a class="dropdown-item text-danger" href="#" onclick="logoutUser()">' +
                                '<i class="fas fa-sign-out-alt me-2"></i>Đăng xuất' +
                            '</a></li>' +
                        '</ul>' +
                    '</div>';
                
                navUserInfo.classList.remove('d-none');
                navLoginBtn.classList.add('d-none');
                
                // Initialize Bootstrap dropdown
                const dropdownTrigger = navUserInfo.querySelector('[data-bs-toggle="dropdown"]');
                if (dropdownTrigger && window.bootstrap) {
                    new bootstrap.Dropdown(dropdownTrigger);
                }
            }
        }
        
        function displayLoginButton() {
            const navUserInfo = document.getElementById('nav-user-info');
            const navLoginBtn = document.getElementById('nav-login-btn');
            
            if (navUserInfo && navLoginBtn) {
                navUserInfo.classList.add('d-none');
                navLoginBtn.classList.remove('d-none');
            }
        }
        
        function logoutUser() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                // Clear all stored user data
                localStorage.removeItem('userInfo');
                sessionStorage.removeItem('userInfo');
                localStorage.removeItem('authToken');
                sessionStorage.removeItem('authToken');
                
                // Clear any other auth-related storage
                Object.keys(localStorage).forEach(key => {
                    if (key.startsWith('auth_') || key.startsWith('user_')) {
                        localStorage.removeItem(key);
                    }
                });
                
                // Redirect to home page
                window.location.href = contextPath + '/';
            }
        }

        // Initialize authentication when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            initializeUserAuth();
        });
        
        // Re-check auth status when user returns to tab (in case of logout in another tab)
        document.addEventListener('visibilitychange', function() {
            if (!document.hidden) {
                initializeUserAuth();
            }
        });
    </script>
</body>
</html>
