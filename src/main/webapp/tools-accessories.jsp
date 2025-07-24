<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dụng cụ & Phụ kiện - 43 Gundam Hobby</title>
    <!-- Unified CSS Includes -->
    <jsp:include page="includes/unified-css.jsp" />
</head>
<body>
    <!-- Unified Header Includes -->
    <jsp:include page="includes/unified-header.jsp" />

    <!-- Tools & Accessories Header Banner -->
    <section class="grade-banner py-4 bg-success text-white">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">Dụng cụ & Phụ kiện</h1>
                    <p class="lead mb-0">Công cụ và phụ kiện chuyên dụng cho việc lắp ráp và trang trí mô hình Gundam</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="grade-icon">
                        <i class="fas fa-tools fa-4x opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Tools & Accessories -->
    <main class="container py-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-4">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/all-products.jsp">Sản phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page">Dụng cụ & Phụ kiện</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Sidebar Category Selection -->
            <aside class="col-lg-3 mb-4">
                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-layer-group me-2"></i>Loại sản phẩm</h5>
                    </div>
                    <div class="card-body p-3">
                        <div class="category-options">
                            <div class="category-option" data-category="TOOLS">
                                <input class="form-check-input" type="radio" name="categorySelect" id="categoryTools" value="TOOLS" checked>
                                <label class="form-check-label w-100" for="categoryTools">
                                    <div class="category-card p-3 rounded border">
                                        <div class="fw-bold text-primary">Dụng cụ</div>
                                        <small class="text-muted">Kìm, dao cắt, file, khoan...</small>
                                    </div>
                                </label>
                            </div>
                            <div class="category-option mt-2" data-category="BASE_STAND">
                                <input class="form-check-input" type="radio" name="categorySelect" id="categoryBase" value="BASE_STAND">
                                <label class="form-check-label w-100" for="categoryBase">
                                    <div class="category-card p-3 rounded border">
                                        <div class="fw-bold text-success">Đế & Giá đỡ</div>
                                        <small class="text-muted">Action Base, Stand, Display Base...</small>
                                    </div>
                                </label>
                            </div>
                            <div class="category-option mt-2" data-category="ALL">
                                <input class="form-check-input" type="radio" name="categorySelect" id="categoryAll" value="ALL">
                                <label class="form-check-label w-100" for="categoryAll">
                                    <div class="category-card p-3 rounded border">
                                        <div class="fw-bold text-warning">Tất cả</div>
                                        <small class="text-muted">Hiển thị tất cả dụng cụ & phụ kiện</small>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="card shadow-sm">
                    <div class="card-header bg-secondary text-white">
                        <h6 class="mb-0"><i class="fas fa-filter me-2"></i>Bộ lọc</h6>
                    </div>
                    <div class="card-body">
                        <!-- Price Range Filter -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Khoảng giá</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <input type="number" class="form-control form-control-sm" id="priceMin" placeholder="Từ">
                                </div>
                                <div class="col-6">
                                    <input type="number" class="form-control form-control-sm" id="priceMax" placeholder="Đến">
                                </div>
                            </div>
                        </div>

                        <!-- Sort Options -->
                        <div class="mb-3">
                            <label class="form-label fw-bold">Sắp xếp theo</label>
                            <select class="form-select form-select-sm" id="sortBy">
                                <option value="newest">Mới nhất</option>
                                <option value="price_asc">Giá thấp đến cao</option>
                                <option value="price_desc">Giá cao đến thấp</option>
                                <option value="name_asc">Tên A-Z</option>
                                <option value="name_desc">Tên Z-A</option>
                            </select>
                        </div>

                        <button class="btn btn-primary btn-sm w-100" onclick="applyFilters()">
                            <i class="fas fa-search me-1"></i>Áp dụng bộ lọc
                        </button>
                        
                        <!-- Debug button -->
                        <button class="btn btn-warning btn-sm w-100 mt-2" onclick="debugLoadProducts()">
                            <i class="fas fa-bug me-1"></i>Debug Load
                        </button>
                    </div>
                </div>
            </aside>

            <!-- Products Grid -->
            <div class="col-lg-9">
                <!-- Stats Bar -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="products-count">
                        <span class="text-muted">Hiển thị <span id="showing-count">0</span> trên <span id="total-count">0</span> sản phẩm</span>
                    </div>
                    <div class="view-options">
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-outline-secondary btn-sm active" id="gridView">
                                <i class="fas fa-th"></i>
                            </button>
                            <button type="button" class="btn btn-outline-secondary btn-sm" id="listView">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Loading State -->
                <div id="products-loading" class="text-center py-5">
                    <div class="spinner-border text-success" role="status">
                        <span class="visually-hidden">Đang tải...</span>
                    </div>
                    <p class="mt-3 text-muted">Đang tải sản phẩm...</p>
                </div>

                <!-- Error State -->
                <div id="products-error" class="alert alert-danger text-center" style="display: none;">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <span id="error-message">Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.</span>
                    <button class="btn btn-outline-danger btn-sm ms-2" onclick="loadProducts()">
                        <i class="fas fa-redo me-1"></i>Thử lại
                    </button>
                </div>

                <!-- No Products State -->
                <div id="no-products" class="text-center py-5" style="display: none;">
                    <i class="fas fa-tools text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-3 text-muted">Không tìm thấy sản phẩm</h4>
                    <p class="text-muted">Thử thay đổi bộ lọc hoặc tìm kiếm từ khóa khác</p>
                </div>

                <!-- Products Container -->
                <div class="row" id="products-container">
                    <!-- Products will be loaded here dynamically -->
                </div>

                <!-- Pagination -->
                <nav aria-label="Products pagination" class="mt-4">
                    <ul class="pagination justify-content-center" id="pagination">
                        <!-- Pagination will be generated dynamically -->
                    </ul>
                </nav>
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
    
    <!-- Page-specific Tools & Accessories functionality -->
    <script>
        // Context Path Setup
        window.contextPath = '<%=request.getContextPath()%>';
        
        // Tools & Accessories Page Variables
        let currentCategory = 'TOOLS';
        let currentPage = 1;
        let itemsPerPage = 12;
        let totalProducts = 0;
        let isLoading = false;

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('🔧 Tools & Accessories page initializing...');
            initializePage();
            
            // Try to load products immediately
            setTimeout(() => {
                loadProducts();
            }, 500);
        });

        function initializePage() {
            // Category selection handlers
            document.querySelectorAll('input[name="categorySelect"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        currentCategory = this.value;
                        currentPage = 1;
                        loadProducts();
                    }
                });
            });

            // Sort handler
            document.getElementById('sortBy').addEventListener('change', function() {
                currentPage = 1;
                loadProducts();
            });

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
        }

        function loadProducts() {
            if (isLoading) return;
            isLoading = true;

            showLoading();
            hideError();
            hideNoProducts();

            // Build API URL using same pattern as grade.jsp
            let apiUrl = window.contextPath + '/api/products/grade/' + currentCategory;
            
            console.log('API URL being used:', apiUrl);

            console.log('Loading tools & accessories:', apiUrl);

            fetch(apiUrl)
                .then(response => {
                    console.log('API Response Status:', response.status);
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('API Response Data:', data);
                    hideLoading();
                    isLoading = false;

                    // Handle response - same pattern as grade.jsp
                    let products = Array.isArray(data) ? data : (data.data || []);
                    
                    if (products.length > 0) {
                        totalProducts = products.length;
                        allProducts = products;
                        renderProducts(products);
                        updateProductsCount();
                        renderPagination(1);
                    } else {
                        console.log('No products found, trying fallback API...');
                        tryFallbackAPI();
                    }
                })
                .catch(error => {
                    console.error('Error loading products:', error);
                    console.log('Primary API failed, trying fallback...');
                    tryFallbackAPI();
                });
        }

        function renderProducts(products) {
            const container = document.getElementById('products-container');
            container.innerHTML = '';

            products.forEach(product => {
                const productCard = createProductCard(product);
                container.appendChild(productCard);
            });

            // Attach add-to-cart listeners
            attachAddToCartListeners();
        }

        function createProductCard(product) {
            const col = document.createElement('div');
            col.className = 'col-xl-3 col-lg-4 col-md-6 col-sm-6 mb-4';

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
            const contextPath = window.contextPath;
            const defaultImage = contextPath + '/img/tools-placeholder.jpg';
            const productImage = product.imageUrl || defaultImage;

            // Handle category display
            const categoryDisplay = getCategoryDisplayName(product.grade);

            // Calculate if product is new
            const isNew = isProductNew(product.createdAt);
            const newBadge = isNew ? '<span class="badge bg-success">Mới</span>' : '';

            // Handle stock status
            const isActive = product.isActive === true;
            const stockQuantity = product.stockQuantity ? parseInt(product.stockQuantity) : 0;
            const isInStock = isActive && stockQuantity > 0;
            const stockBadge = !isInStock ? '<span class="badge bg-danger">Hết hàng</span>' : '';

            col.innerHTML = 
                '<div class="product-card">' +
                    '<div class="product-image">' +
                        '<a href="' + contextPath + '/product-detail.jsp?id=' + product.id + '">' +
                            '<img src="' + productImage + '" class="img-fluid" alt="' + (product.name || 'Tools & Accessories') + '" ' +
                                 'onerror="this.src=\'https://via.placeholder.com/250x250/cccccc/666666?text=Tools\'">' +
                        '</a>' +
                        '<div class="product-badges">' +
                            newBadge +
                            stockBadge +
                        '</div>' +
                        '<div class="product-overlay">' +
                            '<a href="' + contextPath + '/product-detail.jsp?id=' + product.id + '" class="btn btn-outline-light btn-sm">' +
                                '<i class="fas fa-eye"></i> Xem chi tiết' +
                            '</a>' +
                        '</div>' +
                    '</div>' +
                    '<div class="product-info">' +
                        '<h6 class="product-title">' +
                            '<a href="' + contextPath + '/product-detail.jsp?id=' + product.id + '" class="text-decoration-none text-dark">' +
                                (product.name || 'Tên sản phẩm') +
                            '</a>' +
                        '</h6>' +
                        '<p class="product-category">' + categoryDisplay + '</p>' +
                        '<div class="product-price">' +
                            '<span class="current-price">' + formattedPrice + '</span>' +
                        '</div>' +
                        '<button class="btn ' + (isInStock ? 'btn-success' : 'btn-secondary') + ' add-to-cart w-100" ' +
                                'data-product-id="' + product.id + '" ' +
                                (isInStock ? '' : 'disabled') + '>' +
                            '<i class="fas fa-cart-plus me-1"></i>' +
                            (isInStock ? 'Thêm vào giỏ' : 'Hết hàng') +
                        '</button>' +
                    '</div>' +
                '</div>';

            return col;
        }

        function getCategoryDisplayName(grade) {
            const categoryNames = {
                'TOOLS': 'Dụng cụ',
                'BASE_STAND': 'Đế & Giá đỡ'
            };
            return categoryNames[grade] || 'Phụ kiện';
        }

        function isProductNew(createdDate) {
            if (!createdDate) return false;
            
            try {
                let productDate;
                if (Array.isArray(createdDate)) {
                    productDate = new Date(createdDate[0], createdDate[1] - 1, createdDate[2], 
                                         createdDate[3] || 0, createdDate[4] || 0, createdDate[5] || 0);
                } else {
                    productDate = new Date(createdDate);
                }
                
                const now = new Date();
                const thirtyDaysAgo = new Date(now.getTime() - (30 * 24 * 60 * 60 * 1000));
                
                return productDate >= thirtyDaysAgo;
            } catch (error) {
                return false;
            }
        }

        function attachAddToCartListeners() {
            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function() {
                    if (this.disabled) return;
                    
                    const productId = this.getAttribute('data-product-id');
                    const originalHTML = this.innerHTML;
                    
                    // Show loading state
                    this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang thêm...';
                    this.disabled = true;
                    
                    fetch(window.contextPath + '/api/cart/add', {
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
                        showNotification('❌ Không thể thêm vào giỏ hàng!', 'error');
                    });
                });
            });
        }

        function applyFilters() {
            currentPage = 1;
            loadProducts();
        }

        function renderPagination(totalPages) {
            const pagination = document.getElementById('pagination');
            pagination.innerHTML = '';

            if (totalPages <= 1) return;

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
            prevLi.innerHTML = '<a class="page-link" href="#" onclick="changePage(' + (currentPage - 1) + ')">Trước</a>';
            pagination.appendChild(prevLi);

            // Page numbers
            for (let i = 1; i <= totalPages; i++) {
                const li = document.createElement('li');
                li.className = 'page-item' + (i === currentPage ? ' active' : '');
                li.innerHTML = '<a class="page-link" href="#" onclick="changePage(' + i + ')">' + i + '</a>';
                pagination.appendChild(li);
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
            nextLi.innerHTML = '<a class="page-link" href="#" onclick="changePage(' + (currentPage + 1) + ')">Sau</a>';
            pagination.appendChild(nextLi);
        }

        function changePage(page) {
            if (page < 1 || isLoading) return;
            currentPage = page;
            loadProducts();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function updateProductsCount() {
            const start = (currentPage - 1) * itemsPerPage + 1;
            const end = Math.min(currentPage * itemsPerPage, totalProducts);
            
            document.getElementById('showing-count').textContent = start + '-' + end;
            document.getElementById('total-count').textContent = totalProducts;
        }

        function showLoading() {
            document.getElementById('products-loading').style.display = 'block';
        }

        function hideLoading() {
            document.getElementById('products-loading').style.display = 'none';
        }

        function showError(message) {
            document.getElementById('error-message').textContent = message;
            document.getElementById('products-error').style.display = 'block';
        }

        function hideError() {
            document.getElementById('products-error').style.display = 'none';
        }

        function showNoProducts() {
            document.getElementById('no-products').style.display = 'block';
        }

        function hideNoProducts() {
            document.getElementById('no-products').style.display = 'none';
        }

        function showNotification(message, type = 'info') {
            let container = document.getElementById('notification-container');
            if (!container) {
                container = document.createElement('div');
                container.id = 'notification-container';
                container.style.cssText = 
                    'position: fixed;' +
                    'top: 20px;' +
                    'right: 20px;' +
                    'z-index: 9999;' +
                    'max-width: 350px;';
                document.body.appendChild(container);
            }
            
            const notification = document.createElement('div');
            const bgClass = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : 'bg-info';
            notification.className = `alert ${bgClass} text-white alert-dismissible fade show mb-2`;
            notification.innerHTML = 
                message +
                '<button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>';
            
            container.appendChild(notification);
            
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 4000);
        }

        function tryFallbackAPI() {
            console.log('Trying fallback API endpoints...');
            
            // Try different API endpoints using same pattern as grade.jsp
            let fallbackUrls = [
                window.contextPath + '/api/products/grade/TOOLS',
                window.contextPath + '/api/products/grade/BASE_STAND',
                window.contextPath + '/api/products/grade/HG', // Try a known working grade
                window.contextPath + '/api/products/grade/MG'  // Try another known working grade
            ];

            // Try each fallback URL
            tryNextFallback(fallbackUrls, 0);
        }

        function tryNextFallback(urls, index) {
            if (index >= urls.length) {
                hideLoading();
                isLoading = false;
                showError('Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.');
                return;
            }

            const url = urls[index];
            console.log('Trying fallback URL:', url);

            fetch(url)
                .then(response => {
                    console.log('Fallback API Response Status:', response.status);
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('Fallback API Response Data:', data);
                    hideLoading();
                    isLoading = false;

                    // Handle response - same pattern as grade.jsp
                    let products = Array.isArray(data) ? data : (data.data || []);
                    
                    if (products.length > 0) {
                        // Filter products for tools and accessories if needed
                        let filteredProducts = products;
                        if (url.includes('/grade/HG') || url.includes('/grade/MG')) {
                            // Filter products from other grades that might have tools/accessories
                            filteredProducts = products.filter(product => 
                                (product.grade === 'TOOLS' || product.grade === 'BASE_STAND') ||
                                (product.category && product.category.includes('TOOLS')) ||
                                (product.name && (product.name.toLowerCase().includes('tool') || 
                                                 product.name.toLowerCase().includes('base') ||
                                                 product.name.toLowerCase().includes('stand')))
                            );
                        }

                        if (filteredProducts.length > 0) {
                            totalProducts = filteredProducts.length;
                            allProducts = filteredProducts;
                            renderProducts(filteredProducts);
                            updateProductsCount();
                            renderPagination(1);
                        } else {
                            tryNextFallback(urls, index + 1);
                        }
                    } else {
                        tryNextFallback(urls, index + 1);
                    }
                })
                .catch(error => {
                    console.error('Fallback API error:', error);
                    tryNextFallback(urls, index + 1);
                });
        }

        function debugLoadProducts() {
            console.log('=== DEBUG: Testing all possible API endpoints ===');
            
            const testUrls = [
                window.contextPath + '/api/products/all',
                window.contextPath + '/api/products',
                window.contextPath + '/api/products/by-category?category=TOOLS_ACCESSORIES',
                window.contextPath + '/api/products/by-grade?grade=TOOLS',
                window.contextPath + '/api/products/by-grade?grade=BASE_STAND',
                window.contextPath + '/api/products/search?q=tool'
            ];

            testUrls.forEach((url, index) => {
                fetch(url)
                    .then(response => {
                        console.log('Test URL ' + (index + 1) + ' [' + url + '] Status:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('Test URL ' + (index + 1) + ' Data:', data);
                        if (data.success && data.data && data.data.length > 0) {
                            console.log('✅ URL ' + (index + 1) + ' returned ' + data.data.length + ' products');
                            
                            // If this is the first successful API, show the products
                            if (index === 0) {
                                renderProducts(data.data.slice(0, 12)); // Show first 12 products
                                hideLoading();
                                showNotification('Debug: Loaded from URL ' + (index + 1), 'success');
                            }
                        } else {
                            console.log('❌ URL ' + (index + 1) + ' returned no products');
                        }
                    })
                    .catch(error => {
                        console.log('❌ URL ' + (index + 1) + ' Error:', error);
                    });
            });
        }
    </script>

    <!-- Final auth state verification -->
    <script>
        window.addEventListener('load', function() {
            console.log('🔄 Tools & Accessories page loaded, performing auth checks...');
            
            if (window.unifiedNavbarManager) {
                window.unifiedNavbarManager.checkServerSession();
            }
            
            setTimeout(function() {
                if (window.unifiedNavbarManager) {
                    window.unifiedNavbarManager.updateNavbar();
                }
            }, 500);
        });
    </script>
</body>
</html>






