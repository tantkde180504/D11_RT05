<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm theo Grade - 43 Gundam Hobby</title>
    <%@ include file="/includes/unified-css.jsp" %>
</head>
<body>
    <!-- Header -->
    <%@ include file="/includes/unified-header.jsp" %>

    <!-- Grade Header Banner -->
    <section class="grade-banner py-4 bg-primary text-white">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2" id="gradeTitle">High Grade (HG)</h1>
                    <p class="lead mb-0" id="gradeDescription">Mô hình Gundam tỉ lệ 1/144 với khả năng khớp nối linh hoạt và chi tiết tinh xảo</p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="grade-icon">
                        <i class="fas fa-robot fa-4x opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content Grade Products -->
    <main class="container py-4">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-4">
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/all-products.jsp">Sản phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page" id="breadcrumbGrade">High Grade</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Sidebar Grade Selection -->
            <aside class="col-lg-3 mb-4">
                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-layer-group me-2"></i>Chọn Grade</h5>
                    </div>
                    <div class="card-body p-3">
                        <div class="grade-options">
                            <div class="grade-option" data-grade="HG">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradeHG" value="HG">
                                <label class="form-check-label w-100" for="gradeHG">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-primary">High Grade (HG)</div>
                                        <small class="text-muted">Tỉ lệ 1/144 - Cơ bản, dễ lắp ráp</small>
                                    </div>
                                </label>
                            </div>
                            <div class="grade-option mt-2" data-grade="RG">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradeRG" value="RG">
                                <label class="form-check-label w-100" for="gradeRG">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-success">Real Grade (RG)</div>
                                        <small class="text-muted">Tỉ lệ 1/144 - Chi tiết cao</small>
                                    </div>
                                </label>
                            </div>
                            <div class="grade-option mt-2" data-grade="MG">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradeMG" value="MG">
                                <label class="form-check-label w-100" for="gradeMG">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-warning">Master Grade (MG)</div>
                                        <small class="text-muted">Tỉ lệ 1/100 - Khung nội tại</small>
                                    </div>
                                </label>
                            </div>
                            <div class="grade-option mt-2" data-grade="PG">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradePG" value="PG">
                                <label class="form-check-label w-100" for="gradePG">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-danger">Perfect Grade (PG)</div>
                                        <small class="text-muted">Tỉ lệ 1/60 - Siêu chi tiết</small>
                                    </div>
                                </label>
                            </div>
                            <div class="grade-option mt-2" data-grade="SD">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradeSD" value="SD">
                                <label class="form-check-label w-100" for="gradeSD">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-info">Super Deformed (SD)</div>
                                        <small class="text-muted">Phong cách chibi dễ thương</small>
                                    </div>
                                </label>
                            </div>
                            <div class="grade-option mt-2" data-grade="METAL_BUILD">
                                <input class="form-check-input" type="radio" name="gradeSelect" id="gradeMetalBuild" value="METAL_BUILD">
                                <label class="form-check-label w-100" for="gradeMetalBuild">
                                    <div class="grade-card p-3 rounded border">
                                        <div class="fw-bold text-dark">Metal Build</div>
                                        <small class="text-muted">Kim loại cao cấp</small>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Price Filter -->
                <div class="card shadow-sm mb-3">
                    <div class="card-header bg-light">
                        <h6 class="mb-0"><i class="fas fa-filter me-2"></i>Bộ lọc</h6>
                    </div>
                    <div class="card-body">
                        <div class="filter-title">Khoảng giá</div>
                        <input type="range" class="form-range" min="0" max="5000000" step="50000" id="priceRange" value="5000000">
                        <div class="d-flex justify-content-between small">
                            <span>0₫</span>
                            <span id="maxPriceDisplay">5.000.000₫+</span>
                        </div>
                        
                        <div class="filter-title mt-3">Tình trạng</div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterInStock" checked>
                            <label class="form-check-label" for="filterInStock">Còn hàng</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="filterOutOfStock">
                            <label class="form-check-label" for="filterOutOfStock">Hết hàng</label>
                        </div>
                    </div>
                </div>
            </aside>

            <!-- Products Grid -->
            <section class="col-lg-9">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="h4 fw-bold mb-1" id="productGridTitle">Sản phẩm High Grade</h2>
                        <p class="text-muted mb-0">
                            <span id="productCount">Đang tải...</span> sản phẩm
                        </p>
                    </div>
                    <select class="form-select w-auto" id="sortSelect">
                        <option value="latest">Sắp xếp: Mới nhất</option>
                        <option value="price_asc">Giá tăng dần</option>
                        <option value="price_desc">Giá giảm dần</option>
                        <option value="name_asc">Tên A-Z</option>
                        <option value="name_desc">Tên Z-A</option>
                    </select>
                </div>

                <!-- Loading state -->
                <div id="products-loading" class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Đang tải sản phẩm...</span>
                    </div>
                    <p class="mt-3 text-muted">Đang tải sản phẩm từ database...</p>
                </div>

                <!-- Error state -->
                <div id="products-error" class="alert alert-warning text-center" style="display: none;">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <span id="error-message">Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.</span>
                    <div class="mt-2">
                        <button class="btn btn-outline-warning btn-sm" onclick="loadGradeProducts()">
                            <i class="fas fa-redo me-1"></i>Thử lại
                        </button>
                    </div>
                </div>

                <!-- No products state -->
                <div id="no-products" class="text-center py-5" style="display: none;">
                    <i class="fas fa-robot fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Không có sản phẩm nào</h4>
                    <p class="text-muted">Chưa có sản phẩm nào cho grade này. Hãy thử chọn grade khác!</p>
                </div>

                <!-- Products container -->
                <div class="row g-3" id="products-grid">
                    <!-- Products will be loaded here dynamically -->
                </div>

                <!-- Pagination -->
                <nav aria-label="Product pagination" id="pagination-container" style="display: none;">
                    <ul class="pagination justify-content-center mt-4" id="pagination">
                        <!-- Pagination will be generated here -->
                    </ul>
                </nav>
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
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=HG">High Grade (HG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=MG">Master Grade (MG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=RG">Real Grade (RG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=PG">Perfect Grade (PG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=SD">Super Deformed (SD)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=METAL_BUILD">Metal Build</a></li>
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

    <%@ include file="/includes/unified-scripts.jsp" %>
    
    <!-- Context Path Setup -->
    <script>
        window.contextPath = '<%=request.getContextPath()%>';
        console.log('Context path set to:', window.contextPath);
    </script>
    
    <!-- Grade Page Main Script -->
    <script>
        // Grade configuration
        const gradeConfig = {
            'HG': {
                title: 'High Grade (HG)',
                description: 'Mô hình Gundam tỉ lệ 1/144 với khả năng khớp nối linh hoạt và chi tiết tinh xảo',
                color: 'primary'
            },
            'RG': {
                title: 'Real Grade (RG)',
                description: 'Mô hình Gundam tỉ lệ 1/144 với chi tiết cao và khung nội tại thực tế',
                color: 'success'
            },
            'MG': {
                title: 'Master Grade (MG)',
                description: 'Mô hình Gundam tỉ lệ 1/100 với khung nội tại chi tiết và khả năng tùy biến cao',
                color: 'warning'
            },
            'PG': {
                title: 'Perfect Grade (PG)',
                description: 'Mô hình Gundam tỉ lệ 1/60 với chi tiết siêu thực và cơ chế phức tạp',
                color: 'danger'
            },
            'SD': {
                title: 'Super Deformed (SD)',
                description: 'Mô hình Gundam phong cách chibi dễ thương và dễ lắp ráp',
                color: 'info'
            },
            'METAL_BUILD': {
                title: 'Metal Build',
                description: 'Mô hình Gundam cao cấp với chất liệu kim loại và chi tiết hoàn hảo',
                color: 'dark'
            }
        };

        // Global variables
        let currentGrade = 'HG';
        let currentSort = 'latest';
        let currentPage = 1;
        let totalPages = 1;
        let allProducts = [];
        let filteredProducts = [];
        const itemsPerPage = 12;

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Get grade from URL parameter
            const urlParams = new URLSearchParams(window.location.search);
            const gradeParam = urlParams.get('grade');
            
            if (gradeParam && gradeConfig[gradeParam]) {
                currentGrade = gradeParam;
            }

            // Initialize UI
            updateGradeUI();
            setupEventListeners();
            loadGradeProducts();
        });

        function updateGradeUI() {
            const config = gradeConfig[currentGrade];
            if (!config) return;

            // Update page title
            document.title = config.title + ' - 43 Gundam Hobby';
            
            // Update header banner
            document.getElementById('gradeTitle').textContent = config.title;
            document.getElementById('gradeDescription').textContent = config.description;
            
            // Update breadcrumb
            document.getElementById('breadcrumbGrade').textContent = config.title;
            
            // Update product grid title
            document.getElementById('productGridTitle').textContent = 'Sản phẩm ' + config.title;
            
            // Update grade selection
            const gradeRadio = document.getElementById('grade' + currentGrade);
            if (gradeRadio) {
                gradeRadio.checked = true;
            }
            
            // Update banner color
            const banner = document.querySelector('.grade-banner');
            banner.className = 'grade-banner py-4 bg-' + config.color + ' text-white';
        }

        function setupEventListeners() {
            // Grade selection
            document.querySelectorAll('input[name="gradeSelect"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    if (this.checked) {
                        currentGrade = this.value;
                        updateURL();
                        updateGradeUI();
                        loadGradeProducts();
                    }
                });
            });

            // Sort selection
            document.getElementById('sortSelect').addEventListener('change', function() {
                currentSort = this.value;
                currentPage = 1;
                applyFiltersAndSort();
            });

            // Price range filter
            const priceRange = document.getElementById('priceRange');
            const maxPriceDisplay = document.getElementById('maxPriceDisplay');
            
            priceRange.addEventListener('input', function() {
                const value = parseInt(this.value);
                if (value >= 5000000) {
                    maxPriceDisplay.textContent = '5.000.000₫+';
                } else {
                    maxPriceDisplay.textContent = new Intl.NumberFormat('vi-VN', {
                        style: 'currency',
                        currency: 'VND'
                    }).format(value);
                }
            });

            priceRange.addEventListener('change', function() {
                currentPage = 1;
                applyFiltersAndSort();
            });

            // Stock filters
            document.getElementById('filterInStock').addEventListener('change', function() {
                currentPage = 1;
                applyFiltersAndSort();
            });

            document.getElementById('filterOutOfStock').addEventListener('change', function() {
                currentPage = 1;
                applyFiltersAndSort();
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

        function updateURL() {
            const url = new URL(window.location);
            url.searchParams.set('grade', currentGrade);
            window.history.pushState({}, '', url);
        }

        function loadGradeProducts() {
            showLoading();
            hideError();
            hideNoProducts();

            console.log('🔄 Loading products for grade: ' + currentGrade);

            fetch('<%=request.getContextPath()%>/api/products/grade/' + currentGrade)
                .then(response => {
                    console.log('📡 API Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('📊 API Response data:', data);
                    hideLoading();
                    
                    if (data.success && data.data) {
                        allProducts = data.data;
                        console.log('✅ Successfully loaded ' + allProducts.length + ' products for grade ' + currentGrade);
                        
                        if (allProducts.length === 0) {
                            showNoProducts();
                        } else {
                            applyFiltersAndSort();
                        }
                    } else {
                        console.warn('⚠️ No products found or API returned empty data');
                        showNoProducts();
                    }
                })
                .catch(err => {
                    console.error('❌ Error loading grade products:', err);
                    hideLoading();
                    showError('Không thể tải danh sách sản phẩm. Vui lòng thử lại sau.');
                });
        }

        function applyFiltersAndSort() {
            // Apply filters
            filteredProducts = allProducts.filter(product => {
                // Price filter
                const priceRange = document.getElementById('priceRange');
                const maxPrice = parseInt(priceRange.value);
                const productPrice = parseFloat(product.price) || 0;
                
                if (maxPrice < 5000000 && productPrice > maxPrice) {
                    return false;
                }

                // Stock filter
                const filterInStock = document.getElementById('filterInStock').checked;
                const filterOutOfStock = document.getElementById('filterOutOfStock').checked;
                const isInStock = product.isActive && product.stockQuantity > 0;

                if (!filterInStock && !filterOutOfStock) {
                    return true; // Show all if no filter selected
                }

                if (filterInStock && !filterOutOfStock) {
                    return isInStock;
                }

                if (!filterInStock && filterOutOfStock) {
                    return !isInStock;
                }

                return true; // Show all if both filters selected
            });

            // Apply sorting
            sortProducts();

            // Update product count
            updateProductCount();

            // Calculate pagination
            totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
            
            // Render current page
            renderProducts();
            renderPagination();
        }

        function sortProducts() {
            switch (currentSort) {
                case 'price_asc':
                    filteredProducts.sort((a, b) => (parseFloat(a.price) || 0) - (parseFloat(b.price) || 0));
                    break;
                case 'price_desc':
                    filteredProducts.sort((a, b) => (parseFloat(b.price) || 0) - (parseFloat(a.price) || 0));
                    break;
                case 'name_asc':
                    filteredProducts.sort((a, b) => (a.name || '').localeCompare(b.name || ''));
                    break;
                case 'name_desc':
                    filteredProducts.sort((a, b) => (b.name || '').localeCompare(a.name || ''));
                    break;
                case 'latest':
                default:
                    filteredProducts.sort((a, b) => {
                        const dateA = getProductDate(a.createdAt);
                        const dateB = getProductDate(b.createdAt);
                        return dateB - dateA; // Newest first
                    });
                    break;
            }
        }

        function updateProductCount() {
            const countElement = document.getElementById('productCount');
            countElement.textContent = filteredProducts.length + '';
        }

        function renderProducts() {
            const container = document.getElementById('products-grid');
            container.innerHTML = '';

            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const productsToShow = filteredProducts.slice(startIndex, endIndex);

            productsToShow.forEach(product => {
                const productCard = createProductCard(product);
                container.appendChild(productCard);
            });

            // Attach event listeners for add-to-cart buttons
            attachAddToCartListeners();
        }

        function createProductCard(product) {
            const col = document.createElement('div');
            col.className = 'col-6 col-md-4 col-lg-3 mb-4';

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

            // Handle image with fallbacks
            const contextPath = '<%=request.getContextPath()%>';
            const defaultImage = contextPath + '/img/RGStrikeGundam.jpg';
            const placeholderImage = 'https://via.placeholder.com/250x250/cccccc/666666?text=Gundam+Model';
            const productImage = product.imageUrl || defaultImage;

            // Handle grade display
            const gradeDisplay = getGradeDisplayName(product.grade) || 'Gundam Model';

            // Calculate if product is new (added within last 30 days)
            const isNew = isProductNew(product.createdAt);
            const newBadge = isNew ? '<span class="badge bg-success">Mới</span>' : '';

            // Handle stock status
            const isActive = product.isActive === true;
            const stockQuantity = product.stockQuantity ? parseInt(product.stockQuantity) : 0;
            const isInStock = isActive && stockQuantity > 0;
            const stockBadge = !isInStock ? '<span class="badge bg-danger">Hết hàng</span>' : '';

            col.innerHTML = 
                '<div class="card product-card h-100 border-0 shadow-sm">' +
                    '<div class="position-relative">' +
                        '<img src="' + productImage + '" class="card-img-top product-img" alt="' + (product.name || 'Gundam Model') + '" ' +
                             'onerror="this.src=\'' + placeholderImage + '\'" style="height: 200px; object-fit: cover;">' +
                        '<div class="position-absolute top-0 start-0 p-2">' +
                            newBadge +
                            stockBadge +
                        '</div>' +
                        '<div class="product-overlay position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center" style="opacity: 0; transition: opacity 0.3s;">' +
                            '<a href="' + contextPath + '/product-detail.jsp?id=' + product.id + '" class="btn btn-outline-light btn-sm">' +
                                '<i class="fas fa-eye"></i> Xem chi tiết' +
                            '</a>' +
                        '</div>' +
                    '</div>' +
                    '<div class="card-body p-3">' +
                        '<h6 class="card-title mb-2" style="min-height: 2.5rem; font-size: 0.9rem;">' + (product.name || 'Tên sản phẩm') + '</h6>' +
                        '<p class="text-muted small mb-2">' + gradeDisplay + '</p>' +
                        '<div class="product-price mb-3">' +
                            '<span class="fw-bold text-primary">' + formattedPrice + '</span>' +
                        '</div>' +
                        '<button class="btn ' + (isInStock ? 'btn-primary' : 'btn-secondary') + ' btn-sm add-to-cart w-100" ' +
                                'data-product-id="' + product.id + '" ' +
                                (isInStock ? '' : 'disabled') + '>' +
                            '<i class="fas fa-' + (isInStock ? 'cart-plus' : 'times') + ' me-1"></i>' +
                            (isInStock ? 'Thêm vào giỏ' : 'Hết hàng') +
                        '</button>' +
                    '</div>' +
                '</div>';

            // Add hover effect for product overlay
            const card = col.querySelector('.card');
            const overlay = col.querySelector('.product-overlay');
            
            card.addEventListener('mouseenter', () => {
                overlay.style.opacity = '1';
            });
            
            card.addEventListener('mouseleave', () => {
                overlay.style.opacity = '0';
            });

            return col;
        }

        function renderPagination() {
            const container = document.getElementById('pagination-container');
            const pagination = document.getElementById('pagination');
            
            if (totalPages <= 1) {
                container.style.display = 'none';
                return;
            }

            container.style.display = 'block';
            pagination.innerHTML = '';

            // Previous button
            const prevLi = document.createElement('li');
            prevLi.className = 'page-item' + (currentPage === 1 ? ' disabled' : '');
            prevLi.innerHTML = '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">Trước</a>';
            pagination.appendChild(prevLi);

            // Page numbers
            const startPage = Math.max(1, currentPage - 2);
            const endPage = Math.min(totalPages, currentPage + 2);

            if (startPage > 1) {
                const firstLi = document.createElement('li');
                firstLi.className = 'page-item';
                firstLi.innerHTML = '<a class="page-link" href="#" data-page="1">1</a>';
                pagination.appendChild(firstLi);

                if (startPage > 2) {
                    const dotsLi = document.createElement('li');
                    dotsLi.className = 'page-item disabled';
                    dotsLi.innerHTML = '<span class="page-link">...</span>';
                    pagination.appendChild(dotsLi);
                }
            }

            for (let i = startPage; i <= endPage; i++) {
                const pageLi = document.createElement('li');
                pageLi.className = 'page-item' + (i === currentPage ? ' active' : '');
                pageLi.innerHTML = '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>';
                pagination.appendChild(pageLi);
            }

            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const dotsLi = document.createElement('li');
                    dotsLi.className = 'page-item disabled';
                    dotsLi.innerHTML = '<span class="page-link">...</span>';
                    pagination.appendChild(dotsLi);
                }

                const lastLi = document.createElement('li');
                lastLi.className = 'page-item';
                lastLi.innerHTML = '<a class="page-link" href="#" data-page="' + totalPages + '">' + totalPages + '</a>';
                pagination.appendChild(lastLi);
            }

            // Next button
            const nextLi = document.createElement('li');
            nextLi.className = 'page-item' + (currentPage === totalPages ? ' disabled' : '');
            nextLi.innerHTML = '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">Sau</a>';
            pagination.appendChild(nextLi);

            // Add click handlers
            pagination.querySelectorAll('.page-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const page = parseInt(this.getAttribute('data-page'));
                    if (page && page !== currentPage && page >= 1 && page <= totalPages) {
                        currentPage = page;
                        renderProducts();
                        renderPagination();
                        
                        // Scroll to top of products grid
                        document.getElementById('products-grid').scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
        }

        function attachAddToCartListeners() {
            document.querySelectorAll('.add-to-cart').forEach(button => {
                button.addEventListener('click', function() {
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

        // Utility functions
        function getGradeDisplayName(grade) {
            const gradeNames = {
                'HG': 'High Grade (HG)',
                'RG': 'Real Grade (RG)', 
                'MG': 'Master Grade (MG)',
                'PG': 'Perfect Grade (PG)',
                'SD': 'Super Deformed (SD)',
                'METAL_BUILD': 'Metal Build',
                'FULL_MECHANICS': 'Full Mechanics'
            };
            return gradeNames[grade] || grade;
        }

        function getProductDate(createdDate) {
            if (!createdDate) return new Date(0);
            
            try {
                if (Array.isArray(createdDate)) {
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

        function showLoading() {
            document.getElementById('products-loading').style.display = 'block';
        }

        function hideLoading() {
            document.getElementById('products-loading').style.display = 'none';
        }

        function showError(message) {
            const errorElement = document.getElementById('products-error');
            document.getElementById('error-message').textContent = message;
            errorElement.style.display = 'block';
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
            // Create or get notification container
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
            
            // Create notification
            const notification = document.createElement('div');
            const bgClass = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : type === 'warning' ? 'bg-warning' : 'bg-info';
            notification.className = 'alert ' + bgClass + ' text-white alert-dismissible fade show mb-2';
            notification.innerHTML = 
                message +
                '<button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>';
            
            container.appendChild(notification);
            
            // Auto remove after 4 seconds
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.remove();
                }
            }, 4000);
        }
    </script>

    <!-- Final auth state verification and cleanup -->
    <script>
        window.addEventListener('load', function() {
            console.log('🔄 Grade page loaded, performing auth checks...');
            
            // Check server session immediately
            if (window.unifiedNavbarManager) {
                window.unifiedNavbarManager.checkServerSession();
            }
            
            // Final unified navbar state check
            setTimeout(function() {
                if (window.unifiedNavbarManager) {
                    window.unifiedNavbarManager.updateNavbar();
                }
            }, 500);
        });
    </script>
</body>
</html>






