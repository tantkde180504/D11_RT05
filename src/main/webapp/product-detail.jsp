﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp"%>
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
    
    <jsp:include page="includes/unified-css.jsp" />
    <link href="<%=request.getContextPath()%>/css/product-detail.css" rel="stylesheet">
    
    <!-- Google OAuth Handler -->
    <script src="<%=request.getContextPath()%>/js/navbar-manager.js"></script>
    <script src="<%=request.getContextPath()%>/js/google-oauth-clean.js"></script>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Unified Header -->
    <jsp:include page="includes/unified-header.jsp" />
    
    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

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
            <div id="productDescription" style="display: block; margin: 30px 0; padding: 20px; border-radius: 10px;">
                <h2 style="color: #333; margin-bottom: 20px; font-size: 1.5rem;">
                    <i class="fas fa-info-circle" style="margin-right: 8px;"></i>Mô tả sản phẩm
                </h2>
                <div id="descriptionContent" style="min-height: 100px; background: #f8f9fa; padding: 20px; border-radius: 8px; font-size: 16px; line-height: 1.6;">
                    <p style="color: #666; text-align: center; font-size: 18px; margin: 40px 0;">
                        <i class="fas fa-spinner fa-spin" style="margin-right: 10px;"></i>
                        Đang tải mô tả sản phẩm...
                    </p>
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
                        <div class="rating-input mb-3">
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
                        <div class="mb-3">
                            <label for="reviewComment" class="form-label">Nội dung đánh giá *</label>
                            <textarea class="form-control" id="reviewComment" name="comment" rows="4" 
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
                    <!-- Review items sẽ được render động bằng JS từ API, xoá hết review mẫu tĩnh ở đây -->
                    <div id="dynamicReviews"></div>
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

    <!-- Scripts -->
    <jsp:include page="includes/unified-scripts.jsp" />
    
    <!-- Product Detail Script -->
    <script>
        // Product ID from server
        const productId = '<%= productId %>';
        const contextPath = '<%= request.getContextPath() %>';
        
        // Load product data when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Log product ID for debugging
            console.log('Product ID from JSP:', productId);
            console.log('Context path:', contextPath);
            
            // Load product data first
            loadProductData();
            
            // Setup event listeners
            setupEventListeners();
            
            // Ensure reviews load after page is ready - with multiple attempts for robustness
            setTimeout(() => {
                console.log('Loading reviews (first attempt)...');
                loadProductReviews(productId);
            }, 500);
            
            // Backup attempt in case first one fails
            setTimeout(() => {
                console.log('Loading reviews (backup attempt)...');
                const dynamicReviews = document.getElementById('dynamicReviews');
                if (dynamicReviews && dynamicReviews.innerHTML.trim() === '') {
                    console.log('No reviews loaded yet, trying again...');
                    loadProductReviews(productId);
                }
            }, 2000);
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
            console.log('displayProduct called with product data:', product);
            console.log('Product description in displayProduct:', product.description);
            
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
            document.getElementById('productSpecifications').style.display = 'block';
            
            // Load wishlist status for this product
            loadWishlistStatus();
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
            console.log('=== DISPLAY PRODUCT DESCRIPTION ===');
            console.log('Product data:', product);
            console.log('Description value:', product.description);
            
            const descriptionElement = document.getElementById('descriptionContent');
            
            if (!descriptionElement) {
                console.error('descriptionContent element not found!');
                return;
            }
            
            // Clear loading message
            descriptionElement.innerHTML = '';
            
            if (product.description && product.description.trim() !== '') {
                // Convert newlines to <br> tags
                const descriptionText = product.description.replace(/\n/g, '<br>');
                
                // Display clean description content
                const descriptionHtml = 
                    '<div style="color: #333; font-size: 16px; line-height: 1.8; padding: 20px; background: white; border-radius: 8px; border: 1px solid #e9ecef;">' +
                        descriptionText +
                    '</div>';
                
                descriptionElement.innerHTML = descriptionHtml;
                console.log('✅ Description displayed successfully');
            } else {
                // No description available
                const placeholderHtml = 
                    '<div style="text-align: center; padding: 40px; color: #6c757d;">' +
                        '<i class="fas fa-info-circle" style="font-size: 2em; margin-bottom: 15px; display: block;"></i>' +
                        '<p style="font-size: 16px; margin: 0;">Chưa có mô tả chi tiết cho sản phẩm này.</p>' +
                    '</div>';
                
                descriptionElement.innerHTML = placeholderHtml;
                console.log('ℹ️ No description available');
            }
            
            console.log('=== END DISPLAY PRODUCT DESCRIPTION ===');
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
                fetch(contextPath + '/api/cart/add', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    credentials: 'same-origin',
                    body: JSON.stringify({ productId: Number(productId), quantity: Number(quantity) })
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        this.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm vào giỏ';
                        this.classList.add('btn-success');
                        this.classList.remove('btn-add-cart');
                    } else {
                        alert(data.message || 'Có lỗi xảy ra!');
                    }
                    setTimeout(() => {
                        this.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng';
                        this.classList.remove('btn-success');
                        this.classList.add('btn-add-cart');
                    }, 2000);
                })
                .catch(() => {
                    alert('Không thể thêm vào giỏ hàng. Vui lòng thử lại!');
                });
            });
            
            // Buy now button
            document.getElementById('buyNowBtn').addEventListener('click', async function() {
                const quantity = parseInt(document.getElementById('quantityInput').value);
                // Kiểm tra đăng nhập
                const sessionUserId = getUserIdFromSession();
                if (!sessionUserId || sessionUserId === 'null') {
                    showToast('Bạn cần đăng nhập để mua hàng!', 'warning');
                    setTimeout(() => {
                        window.location.href = contextPath + '/login.jsp?returnUrl=' + encodeURIComponent(window.location.href);
                    }, 1500);
                    return;
                }
                // Kiểm tra tồn kho
                const stockElement = document.getElementById('stockStatus');
                if (stockElement.classList.contains('out-of-stock')) {
                    showToast('Sản phẩm đã hết hàng!', 'error');
                    return;
                }
                let originalContent = this.innerHTML;
                try {
                    // Disable button and show loading
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
                    this.disabled = true;
                    // Lấy thông tin sản phẩm hiện tại
                    const productResponse = await fetch(contextPath + '/api/products/' + productId);
                    const productData = await productResponse.json();
                    if (!productData.success || !productData.data) {
                        showToast('Không thể lấy thông tin sản phẩm!', 'error');
                        return;
                    }
                    const product = productData.data;
                    // --- Lưu vào localStorage cho chế độ mua ngay ---
                    const buyNowItem = {
                        id: product.id,
                        productId: product.id,
                        name: product.name,
                        productName: product.name,
                        price: parseFloat(product.price),
                        quantity: quantity,
                        imageUrl: product.imageUrl || contextPath + '/img/RGStrikeGundam.jpg'
                    };
                    localStorage.setItem('buyNowItem', JSON.stringify(buyNowItem));
                    localStorage.setItem('buyNowMode', 'true');
                    // Chuyển đến trang thanh toán
                    window.location.href = contextPath + '/payment.jsp?mode=buynow';
                } catch (error) {
                    console.error('Error during buy now:', error);
                    showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
                } finally {
                    // Restore button state
                    this.innerHTML = originalContent;
                    this.disabled = false;
                }
            });
            
            // Wishlist button
            document.getElementById('wishlistBtn').addEventListener('click', function() {
                toggleWishlist();
            });
            
            // Debug button for description (remove in production)
            const debugBtn = document.getElementById('debugDescriptionBtn');
            if (debugBtn) {
                debugBtn.addEventListener('click', function() {
                    const descSection = document.getElementById('productDescription');
                    const descContent = document.getElementById('descriptionContent');
                    
                    console.log('=== DEBUG DESCRIPTION ===');
                    console.log('Section element:', descSection);
                    console.log('Content element:', descContent);
                    console.log('Section display:', descSection.style.display);
                    console.log('Content innerHTML:', descContent.innerHTML);
                    
                    // Force show
                    descSection.style.display = 'block !important';
                    descSection.style.visibility = 'visible !important';
                    descSection.style.opacity = '1 !important';
                    
                    alert('Debug info logged to console. Section forced to show.');
                });
            }
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
        
        // ===== TOAST NOTIFICATION FUNCTION =====
        
        function showToast(message, type = 'success', duration = 3000) {
            // Remove existing toast if any
            const existingToast = document.querySelector('.toast-notification');
            if (existingToast) {
                existingToast.remove();
            }
            
            // Create toast element
            const toast = document.createElement('div');
            toast.className = `toast-notification toast-${type}`;
            
            // Set toast content based on type
            let icon = '';
            switch (type) {
                case 'success':
                    icon = '<i class="fas fa-check-circle"></i>';
                    break;
                case 'error':
                    icon = '<i class="fas fa-exclamation-circle"></i>';
                    break;
                case 'warning':
                    icon = '<i class="fas fa-exclamation-triangle"></i>';
                    break;
                case 'info':
                    icon = '<i class="fas fa-info-circle"></i>';
                    break;
                default:
                    icon = '<i class="fas fa-check-circle"></i>';
            }
            
            toast.innerHTML = `
                <div class="toast-content">
                    ${icon}
                    <span class="toast-message">${message}</span>
                </div>
                <button class="toast-close" onclick="this.parentElement.remove()">
                    <i class="fas fa-times"></i>
                </button>
            `;
            
            // Add toast to body
            document.body.appendChild(toast);
            
            // Show toast with animation
            setTimeout(() => {
                toast.classList.add('show');
            }, 100);
            
            // Auto hide toast after duration
            setTimeout(() => {
                toast.classList.remove('show');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.remove();
                    }
                }, 300);
            }, duration);
        }
        
        // ===== WISHLIST FUNCTIONALITY =====
        
        // Initialize wishlist state
        let isInWishlist = false;
        
        // Load wishlist status for current product
        async function loadWishlistStatus() {
            try {
                const sessionUserId = getUserIdFromSession();
                if (!sessionUserId) {
                    return; // User not logged in
                }
                
                const response = await fetch(contextPath + '/api/favorites/check?productId=' + productId, {
                    method: 'GET',
                    credentials: 'same-origin'
                });
                
                if (response.ok) {
                    const data = await response.json();
                    if (data.success) {
                        isInWishlist = data.inWishlist;
                        updateWishlistButton();
                    }
                }
            } catch (error) {
                console.error('Error loading wishlist status:', error);
            }
        }
        
        // Update wishlist button appearance
        function updateWishlistButton() {
            const wishlistBtn = document.getElementById('wishlistBtn');
            const icon = wishlistBtn.querySelector('i');
            
            if (isInWishlist) {
                icon.classList.remove('far');
                icon.classList.add('fas');
                wishlistBtn.style.color = '#e74c3c';
                wishlistBtn.title = 'Xóa khỏi danh sách yêu thích';
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
                wishlistBtn.style.color = '';
                wishlistBtn.title = 'Thêm vào danh sách yêu thích';
            }
        }
        
        // Toggle wishlist status
        async function toggleWishlist() {
            try {
                const sessionUserId = getUserIdFromSession();
                if (!sessionUserId) {
                    showToast('Vui lòng đăng nhập để sử dụng tính năng yêu thích!', 'warning');
                    setTimeout(() => {
                        window.location.href = contextPath + '/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                    }, 1500);
                    return;
                }
                
                const wishlistBtn = document.getElementById('wishlistBtn');
                const originalContent = wishlistBtn.innerHTML;
                
                // Show loading state
                wishlistBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                wishlistBtn.disabled = true;
                
                const endpoint = isInWishlist ? 'remove' : 'add';
                const response = await fetch(contextPath + '/api/favorites/' + endpoint, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    credentials: 'same-origin',
                    body: JSON.stringify({
                        productId: parseInt(productId),
                        userId: sessionUserId
                    })
                });
                
                const data = await response.json();
                
                if (response.ok && data.success) {
                    isInWishlist = !isInWishlist;
                    updateWishlistButton();
                    
                    const message = isInWishlist ? 
                        'Đã thêm vào danh sách yêu thích!' : 
                        'Đã xóa khỏi danh sách yêu thích!';
                    showToast(message, 'success');
                } else {
                    const errorMessage = data.message || 'Có lỗi xảy ra. Vui lòng thử lại!';
                    showToast(errorMessage, 'error');
                }
                
            } catch (error) {
                console.error('Error toggling wishlist:', error);
                showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
            } finally {
                // Restore button state
                const wishlistBtn = document.getElementById('wishlistBtn');
                wishlistBtn.innerHTML = '<i class="far fa-heart"></i>';
                wishlistBtn.disabled = false;
                updateWishlistButton();
            }
        }
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
            
            // Kiểm tra đăng nhập từ JSP session trực tiếp
            const sessionUserId = getUserIdFromSession();
            console.log('User ID from JSP session:', sessionUserId);
            
            if (!sessionUserId || sessionUserId === 'null') {
                const confirmLogin = confirm('Bạn cần đăng nhập để gửi đánh giá. Chuyển đến trang đăng nhập?');
                if (confirmLogin) {
                    window.location.href = contextPath + '/login.jsp?redirect=' + encodeURIComponent(window.location.href);
                }
                return;
            }
            
            const rating = parseInt(ratingValue.value);
            if (rating === 0) {
                alert('Vui lòng chọn số sao đánh giá!');
                return;
            }
            
            const formData = new FormData(reviewForm);
            const comment = formData.get('comment')?.trim();
            
            if (!comment) {
                alert('Vui lòng nhập nội dung đánh giá!');
                return;
            }
            
            const reviewData = {
                productId: parseInt(productId),
                userId: sessionUserId, // Gửi userId từ session
                rating: rating,
                comment: comment,
                isVerified: false
            };
            
            console.log('Sending review data:', reviewData);
            console.log('Product ID for review:', productId);
            console.log('Product ID type:', typeof productId);
            console.log('Product ID is empty?', !productId || productId.trim() === '');
            console.log('JSESSIONID cookie exists:', document.cookie.includes('JSESSIONID'));
            
            // Kiểm tra productId trước khi tạo URL
            if (!productId || productId.trim() === '' || productId === 'null' || productId === 'undefined') {
                alert('Lỗi: Không tìm thấy ID sản phẩm. Vui lòng reload trang!');
                return;
            }
            
            try {
                const submitButton = reviewForm.querySelector('button[type="submit"]');
                const originalButtonText = submitButton.innerHTML;
                submitButton.disabled = true;
                
                // Hiển thị trạng thái loading chi tiết hơn
                let loadingStep = 1;
                const loadingMessages = [
                    'Đang gửi đánh giá...',
                    'Đang kiểm tra quyền đánh giá...',
                    'Đang xử lý đánh giá...',
                    'Gần hoàn thành...'
                ];
                
                const updateLoadingMessage = () => {
                    if (loadingStep < loadingMessages.length) {
                        submitButton.innerHTML = `<i class="fas fa-spinner fa-spin me-2"></i>${loadingMessages[loadingStep - 1]}`;
                        loadingStep++;
                    }
                };
                
                updateLoadingMessage();
                const loadingInterval = setInterval(updateLoadingMessage, 10000); // Cập nhật message mỗi 10 giây
                
                const reviewUrl = contextPath + '/api/reviews/product/' + productId.trim();
                console.log('Review submission URL:', reviewUrl);
                console.log('Final URL parts - contextPath:', contextPath, 'productId:', productId.trim());
                
                // Tạo timeout controller để kiểm soát thời gian chờ
                const controller = new AbortController();
                const timeoutId = setTimeout(() => {
                    controller.abort();
                    console.log('Review submission timed out after 45 seconds');
                }, 45000); // Tăng timeout lên 45 giây
                
                const response = await fetch(reviewUrl, {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    credentials: 'same-origin', // Đảm bảo gửi cookie session
                    body: JSON.stringify(reviewData),
                    signal: controller.signal // Thêm signal để có thể cancel request
                });
                
                // Clear timeout nếu request hoàn thành
                clearTimeout(timeoutId);
                clearInterval(loadingInterval); // Clear loading interval
                
                console.log('Review submission response status:', response.status);
                console.log('Response headers:', Array.from(response.headers.entries()));
                
                // Đọc response text trước để debug
                const responseText = await response.text();
                console.log('Raw response text:', responseText);
                
                if (!response.ok) {
                    console.error('HTTP error! status:', response.status, 'response:', responseText);
                    throw new Error('HTTP error! status: ' + response.status + ' - ' + responseText);
                }
                
                // Parse JSON từ text
                let result;
                try {
                    result = JSON.parse(responseText);
                } catch (parseError) {
                    console.error('JSON parse error:', parseError, 'Raw text:', responseText);
                    throw new Error('Lỗi phản hồi từ server không hợp lệ');
                }
                console.log('Review submission result:', result);
                
                if (result.success) {
                    // Hiển thị thông báo thành công
                    const successAlert = document.createElement('div');
                    successAlert.className = 'alert alert-success alert-dismissible fade show';
                    successAlert.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>Cảm ơn bạn đã đánh giá sản phẩm!
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    `;
                    reviewForm.insertAdjacentElement('beforebegin', successAlert);
                    
                    // Reset form
                    reviewForm.reset();
                    ratingValue.value = '0';
                    highlightStars(0);
                    
                    // Reload reviews after a short delay
                    setTimeout(() => {
                        loadProductReviews(productId);
                    }, 1000);
                    
                    // Tự động ẩn thông báo sau 5 giây
                    setTimeout(() => {
                        successAlert.remove();
                    }, 5000);
                } else {
                    throw new Error(result.message || 'Không thể gửi đánh giá');
                }
                
            } catch (error) {
                // Clear loading interval nếu có lỗi
                if (typeof loadingInterval !== 'undefined') {
                    clearInterval(loadingInterval);
                }
                
                console.error('Error submitting review:', error);
                let errorMessage = error.message || 'Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại!';
                
                // Xử lý các loại lỗi khác nhau
                if (error.name === 'AbortError' || error.message.includes('timed out')) {
                    errorMessage = 'Yêu cầu gửi đánh giá bị timeout. Vui lòng thử lại sau.';
                } else if (error.message.includes('NetworkError') || error.message.includes('fetch')) {
                    errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet và thử lại.';
                } else if (error.message.includes('chỉ có thể đánh giá') || error.message.includes('only review products')) {
                    errorMessage = 'Bạn chỉ có thể đánh giá những sản phẩm đã mua và được giao thành công.';
                } else if (error.message.includes('đăng nhập') || error.message.includes('login')) {
                    errorMessage = 'Vui lòng đăng nhập để có thể gửi đánh giá.';
                }
                
                // Xử lý các loại lỗi khác nhau
                if (error.message && error.message.includes('chỉ có thể đánh giá sản phẩm đã mua')) {
                    errorMessage = `
                        <div>
                            <p class="mb-2">Bạn chỉ có thể đánh giá sản phẩm đã mua.</p>
                            <a href="${contextPath}/order-history.jsp" class="btn btn-sm btn-primary">
                                <i class="fas fa-shopping-bag me-1"></i>Xem lịch sử mua hàng
                            </a>
                        </div>
                    `;
                } else if (error.message && error.message.includes('purchased')) {
                    // Xử lý lỗi tiếng Anh
                    errorMessage = `
                        <div>
                            <p class="mb-2">Bạn chỉ có thể đánh giá sản phẩm đã mua.</p>
                            <a href="${contextPath}/order-history.jsp" class="btn btn-sm btn-primary">
                                <i class="fas fa-shopping-bag me-1"></i>Xem lịch sử mua hàng
                            </a>
                        </div>
                    `;
                } else if (response.status === 403 || response.status === 400) {
                    // Lỗi không có quyền hoặc bad request - có thể là chưa mua hàng
                    errorMessage = `
                        <div>
                            <p class="mb-2">Bạn chỉ có thể đánh giá sản phẩm đã mua.</p>
                            <a href="${contextPath}/order-history.jsp" class="btn btn-sm btn-primary">
                                <i class="fas fa-shopping-bag me-1"></i>Xem lịch sử mua hàng
                            </a>
                        </div>
                    `;
                }
                
                const errorAlert = document.createElement('div');
                errorAlert.className = 'alert alert-danger alert-dismissible fade show';
                errorAlert.innerHTML = `
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                reviewForm.insertAdjacentElement('beforebegin', errorAlert);
                
                // Tự động ẩn thông báo lỗi sau 5 giây
                setTimeout(() => {
                    errorAlert.remove();
                }, 5000);
            } finally {
                // Clear loading interval nếu vẫn đang chạy
                if (typeof loadingInterval !== 'undefined') {
                    clearInterval(loadingInterval);
                }
                // Khôi phục nút submit
                const submitButton = reviewForm.querySelector('button[type="submit"]');
                submitButton.disabled = false;
                submitButton.innerHTML = originalButtonText;
            }
        });

        // Hàm lấy ID người dùng hiện tại
        async function getCurrentUserId() {
            try {
                // Lấy userId từ session thông qua API
                const response = await fetch(contextPath + '/api/user-info', {
                    credentials: 'same-origin'
                });
                const data = await response.json();
                // Debug - hiển thị thông tin user trả về
                console.log('User info response:', data);
                if (data && data.isLoggedIn && data.userId) {
                    return data.userId;
                }
                return null;
            } catch (error) {
                console.error('Error getting user info:', error);
                return null;
            }
        }
        
        // Load Reviews for Product
        function loadProductReviews(productId) {
            console.log('Loading reviews for product ID:', productId);
            
            if (!productId) {
                console.error('Product ID is required to load reviews');
                return;
            }
            
            // Load review statistics
            fetch(contextPath + '/api/reviews/product/' + productId + '/statistics')
            .then(response => {
                console.log('Statistics API response status:', response.status);
                if (!response.ok) {
                    throw new Error('Statistics API returned status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Review statistics response:', data);
                if (data.success && data.statistics) {
                    updateReviewStatistics(data.statistics);
                } else {
                    console.warn('Statistics API succeeded but no valid data:', data);
                }
            })
            .catch(error => {
                console.error('Error loading review statistics:', error);
                // Don't fail the whole process for statistics
            });
            
            // Load reviews list
            const reviewsUrl = contextPath + '/api/reviews/product/' + productId;
            console.log('Fetching reviews from URL:', reviewsUrl);
            
            fetch(reviewsUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Cache-Control': 'no-cache'
                },
                credentials: 'same-origin'
            })
            .then(response => {
                console.log('Reviews API response status:', response.status);
                console.log('Reviews API response headers:', response.headers);
                
                if (!response.ok) {
                    throw new Error('Reviews API returned status: ' + response.status);
                }
                
                return response.text().then(text => {
                    console.log('Raw response text:', text);
                    try {
                        return JSON.parse(text);
                    } catch (parseError) {
                        console.error('JSON parse error:', parseError);
                        console.error('Response text that failed to parse:', text);
                        throw new Error('Invalid JSON response from reviews API');
                    }
                });
            })
            .then(data => {
                console.log('Reviews list response data:', data);
                console.log('Data type:', typeof data);
                console.log('Data keys:', Object.keys(data || {}));
                
                if (data && data.success) {
                    // Handle different possible response structures
                    let reviewsArray = [];
                    
                    if (data.reviews && Array.isArray(data.reviews)) {
                        reviewsArray = data.reviews;
                    } else if (data.data && Array.isArray(data.data)) {
                        reviewsArray = data.data;
                    } else if (Array.isArray(data)) {
                        reviewsArray = data;
                    }
                    
                    console.log('Extracted reviews array:', reviewsArray);
                    console.log('Number of reviews found:', reviewsArray.length);
                    
                    if (reviewsArray.length > 0) {
                        console.log('Sample review data:', reviewsArray[0]);
                    }
                    
                    displayReviews(reviewsArray);
                } else {
                    console.error('Failed to load reviews:', data ? data.message : 'Unknown error');
                    console.log('Full error response:', data);
                    displayReviews([]);
                }
            })
            .catch(error => {
                console.error('Error loading reviews:', error);
                console.error('Error details:', error.message);
                displayReviews([]);
                
                // Show user-friendly error in the UI
                const dynamicReviews = document.getElementById('dynamicReviews');
                if (dynamicReviews) {
                    dynamicReviews.innerHTML = '<div class="alert alert-warning text-center">' +
                        '<i class="fas fa-exclamation-triangle me-2"></i>' +
                        'Không thể tải đánh giá. Vui lòng thử lại sau.' +
                    '</div>';
                }
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
            console.log('Displaying reviews:', reviews);
            const dynamicReviews = document.getElementById('dynamicReviews');
            if (!dynamicReviews) {
                console.error('dynamicReviews element not found');
                return;
            }
            
            // Clear existing reviews
            dynamicReviews.innerHTML = '';
            
            if (!reviews || reviews.length === 0) {
                console.log('No reviews to display');
                const noReviewsHtml = '<div class="no-reviews text-center py-4">' +
                    '<i class="fas fa-comment-slash fa-3x text-muted mb-3"></i>' +
                    '<h5 class="text-muted">Chưa có đánh giá nào</h5>' +
                    '<p class="text-muted">Hãy là người đầu tiên đánh giá sản phẩm này!</p>' +
                '</div>';
                dynamicReviews.innerHTML = noReviewsHtml;
                return;
            }
            
            // Display reviews
            console.log('Creating HTML for ' + reviews.length + ' reviews');
            let reviewsHtml = '';
            reviews.forEach((review, index) => {
                try {
                    reviewsHtml += createReviewHtml(review);
                } catch (e) {
                    console.error('Error creating HTML for review #' + index, e);
                    console.error('Problem review:', review);
                }
            });
            
            dynamicReviews.innerHTML = reviewsHtml;
            
            // Re-attach review filter event listener
            const reviewFilter = document.getElementById('reviewFilter');
            if (reviewFilter) {
                // Remove existing listeners
                reviewFilter.removeEventListener('change', handleReviewFilter);
                reviewFilter.addEventListener('change', handleReviewFilter);
            }
        }
        
        function handleReviewFilter(e) {
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
        }
        
        function createReviewHtml(review) {
            console.log('Creating HTML for review:', review);
            
            // Check if review is valid
            if (!review || typeof review !== 'object') {
                console.error('Invalid review object:', review);
                return '';
            }
            
            // Ensure rating is valid (default to 1 if invalid)
            const rating = Math.max(1, Math.min(5, parseInt(review.rating) || 1));
            
            // Format stars based on rating
            const stars = generateStarsHtml(rating);
            
            // Use the timeAgo method from the Review object if available, otherwise format the date
            let timeDisplay = 'Vừa xong';
            if (review.timeAgo && review.timeAgo.trim() !== '') {
                timeDisplay = review.timeAgo;
            } else if (review.createdAt) {
                timeDisplay = formatDate(review.createdAt);
            } else if (review.created_at) {
                timeDisplay = formatDate(review.created_at);
            }
            
            // Verified badge display
            const isVerified = review.isVerified === true || review.isVerified === 'true' || review.is_verified === true || review.is_verified === 'true';
            const verifiedBadge = isVerified ? 
                '<span class="verified-badge ms-2"><i class="fas fa-check-circle"></i> Đã mua hàng</span>' : '';
                
            // Display username or user ID
            let reviewerName = 'Khách hàng';
            if (review.userName && review.userName.trim() !== '') {
                reviewerName = review.userName;
            } else if (review.user_name && review.user_name.trim() !== '') {
                reviewerName = review.user_name;
            } else if (review.userEmail && review.userEmail.trim() !== '') {
                reviewerName = review.userEmail.split('@')[0]; // Use email prefix
            } else if (review.user_email && review.user_email.trim() !== '') {
                reviewerName = review.user_email.split('@')[0]; // Use email prefix
            } else {
                const userId = review.userId || review.user_id || 'unknown';
                reviewerName = `Người dùng #${userId}`;
            }
            
            // Ensure comment is valid
            const comment = (review.comment && review.comment.trim() !== '') ? review.comment.trim() : 'Người dùng chưa để lại bình luận.';
            
            // Debug log for this specific review
            console.log('Processing review:', {
                id: review.id,
                userId: review.userId,
                rating: rating,
                comment: review.comment,
                createdAt: review.createdAt,
                timeAgo: review.timeAgo,
                isVerified: review.isVerified
            });

            return '<div class="review-item">' +
                '<div class="review-header">' +
                    '<div class="reviewer-info">' +
                        '<div class="reviewer-avatar">' +
                            '<i class="fas fa-user-circle"></i>' +
                        '</div>' +
                        '<div class="reviewer-details">' +
                            '<h5 class="reviewer-name">' + escapeHtml(reviewerName) + verifiedBadge + '</h5>' +
                            '<div class="review-rating">' + stars + '</div>' +
                            '<span class="review-date">' + timeDisplay + '</span>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="review-content">' +
                    (review.title ? '<h6 class="review-title">' + escapeHtml(review.title) + '</h6>' : '') +
                    '<p class="review-text">' + escapeHtml(comment) + '</p>' +
                    '<div class="review-actions">' +
                        '<button type="button" class="btn btn-sm btn-outline-secondary" onclick="markHelpful(' + (review.id || 0) + ')">' +
                            '<i class="fas fa-thumbs-up me-1"></i>Hữu ích (' + (review.helpfulCount || 0) + ')' +
                        '</button>' +
                    '</div>' +
                '</div>' +
            '</div>';
        }
        
        function generateStarsHtml(rating) {
            let starsHtml = '';
            const safeRating = Math.max(1, Math.min(5, parseInt(rating) || 1));
            
            for (let i = 1; i <= 5; i++) {
                if (i <= safeRating) {
                    starsHtml += '<i class="fas fa-star"></i>';
                } else {
                    starsHtml += '<i class="far fa-star"></i>';
                }
            }
            return starsHtml;
        }
        
        // Hàm trực tiếp để lấy user id từ session
        function getUserIdFromSession() {
            const sessionValue = '<%= session.getAttribute("userId") %>';
            console.log('Raw session userId value:', sessionValue);
            
            if (sessionValue && sessionValue !== 'null' && sessionValue.trim() !== '') {
                const parsedId = parseInt(sessionValue);
                console.log('Parsed userId:', parsedId);
                if (!isNaN(parsedId) && parsedId > 0) {
                    return parsedId;
                }
            }
            
            console.log('No valid userId found in session');
            return null;
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
    
    <!-- Search Autocomplete Script -->
    <script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>
    
    <!-- Recently Viewed Tracker -->
    <script src="<%=request.getContextPath()%>/js/recently-viewed-tracker.js"></script>

    <script src="<%=request.getContextPath()%>/js/product-detail-manager.js"></script>

    <script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>
</body>
</html>



