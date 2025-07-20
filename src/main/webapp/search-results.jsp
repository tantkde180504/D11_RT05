<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="error.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - Gundam Hobby</title>
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
    </header>

    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Search Header -->
    <section class="search-container">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h1 class="mb-3">
                        <i class="fas fa-search me-2"></i>
                        Kết quả tìm kiếm
                    </h1>
                    <c:if test="${not empty query}">
                        <p class="lead">Tìm kiếm cho: "<strong>${query}</strong>"</p>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <!-- Main Content -->
    <div class="container">
        <!-- Search Filters -->
        <div class="search-filters">
            <form id="filterForm" method="get" action="<%=request.getContextPath()%>/search">
                <div class="row">
                    <div class="col-md-3">
                        <div class="filter-group">
                            <label for="searchQuery">Từ khóa tìm kiếm</label>
                            <input type="text" class="form-control" id="searchQuery" name="q" 
                                   value="${query}" placeholder="Nhập từ khóa...">
                        </div>
                    </div>
                    
                    <div class="col-md-3">
                        <div class="filter-group">
                            <label for="categoryFilter">Danh mục</label>
                            <select class="form-select" id="categoryFilter" name="category">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${category eq cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="filter-group">
                            <label>Khoảng giá (VNĐ)</label>
                            <div class="price-range">
                                <input type="number" class="form-control price-input" name="minPrice" 
                                       value="${minPrice}" placeholder="Từ" min="0">
                                <span>-</span>
                                <input type="number" class="form-control price-input" name="maxPrice" 
                                       value="${maxPrice}" placeholder="Đến" min="0">
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-2">
                        <div class="filter-group">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-filter me-1"></i>Lọc
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Results Header -->
        <div class="results-header">
            <div>
                <h4 class="mb-0">Kết quả tìm kiếm</h4>
                <p class="text-muted mb-0" id="resultsCount">Đang tải...</p>
            </div>
            
            <div class="sort-controls">
                <label for="sortSelect" class="form-label mb-0 me-2">Sắp xếp:</label>
                <select class="form-select" id="sortSelect" style="width: auto;">
                    <option value="name:asc" ${sort eq 'name' and order eq 'asc' ? 'selected' : ''}>Tên A-Z</option>
                    <option value="name:desc" ${sort eq 'name' and order eq 'desc' ? 'selected' : ''}>Tên Z-A</option>
                    <option value="price:asc" ${sort eq 'price' and order eq 'asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                    <option value="price:desc" ${sort eq 'price' and order eq 'desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                    <option value="category:asc" ${sort eq 'category' and order eq 'asc' ? 'selected' : ''}>Danh mục A-Z</option>
                </select>
            </div>
        </div>

        <!-- Loading -->
        <div id="loadingIndicator" class="loading">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Đang tải...</span>
            </div>
            <p class="mt-2">Đang tìm kiếm sản phẩm...</p>
        </div>

        <!-- Products Grid -->
        <div id="productsContainer" style="display: none;">
            <div class="product-grid" id="productGrid">
                <!-- Products will be loaded here -->
            </div>
        </div>

        <!-- No Results -->
        <div id="noResults" class="no-results" style="display: none;">
            <i class="fas fa-search"></i>
            <h4>Không tìm thấy sản phẩm nào</h4>
            <p>Hãy thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
        </div>

        <!-- Pagination -->
        <div id="paginationContainer" class="pagination-container" style="display: none;">
            <!-- Pagination will be loaded here -->
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Gundam Hobby</h5>
                    <p>Cửa hàng mô hình Gundam uy tín với nhiều năm kinh nghiệm</p>
                </div>
                <div class="col-md-6">
                    <h5>Liên hệ</h5>
                    <p><i class="fas fa-phone me-2"></i>0123 456 789</p>
                    <p><i class="fas fa-envelope me-2"></i>info@gundamhobby.com</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Search Autocomplete Script -->
    <script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>
    
    <script>
        // Search functionality
        let currentPage = parseInt('${currentPage}') || 1;
        let currentFilters = {
            q: '${query}' || '',
            category: '${category}' || '',
            minPrice: ${minPrice != null ? minPrice : 'null'},
            maxPrice: ${maxPrice != null ? maxPrice : 'null'},
            sort: '${sort}' || 'name',
            order: '${order}' || 'asc'
        };

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Wait a bit for auth scripts to load
            setTimeout(() => {
                initializeSearch();
                loadProducts();
                setupEventListeners();
            }, 200);
        });

        // Search initialization
        function initializeSearch() {
            // Set current filter values
            document.getElementById('searchQuery').value = currentFilters.q;
            document.getElementById('categoryFilter').value = currentFilters.category;
            
            if (currentFilters.minPrice !== null) {
                document.querySelector('input[name="minPrice"]').value = currentFilters.minPrice;
            }
            if (currentFilters.maxPrice !== null) {
                document.querySelector('input[name="maxPrice"]').value = currentFilters.maxPrice;
            }
            
            // Set sort value
            const sortValue = currentFilters.sort + ':' + currentFilters.order;
            document.getElementById('sortSelect').value = sortValue;
        }

        // Load products
        function loadProducts(page = currentPage) {
            console.log('Loading products with filters:', currentFilters);
            showLoading();
            
            const params = new URLSearchParams();
            if (currentFilters.q) params.append('q', currentFilters.q);
            if (currentFilters.category) params.append('category', currentFilters.category);
            if (currentFilters.minPrice !== null) params.append('minPrice', currentFilters.minPrice);
            if (currentFilters.maxPrice !== null) params.append('maxPrice', currentFilters.maxPrice);
            params.append('sort', currentFilters.sort);
            params.append('order', currentFilters.order);
            params.append('page', page);
            params.append('size', 12);

            const apiUrl = '<%=request.getContextPath()%>/search/api?' + params.toString();
            console.log('API URL:', apiUrl);

            fetch(apiUrl)
                .then(response => {
                    console.log('API Response status:', response.status);
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('API Response data:', data);
                    hideLoading();
                    
                    if (data.success) {
                        displayProducts(data.products);
                        displayPagination(data.pagination);
                        updateResultsCount(data.totalResults);
                        currentPage = data.pagination.currentPage;
                    } else {
                        showError(data.message || 'Lỗi khi tải sản phẩm');
                    }
                })
                .catch(error => {
                    hideLoading();
                    console.error('Error loading products:', error);
                    
                    // If API endpoint doesn't exist, show sample products
                    if (error.message.includes('404') || error.message.includes('Not Found')) {
                        console.log('API endpoint not found, showing sample data');
                        showSampleProducts();
                    } else {
                        showError('Lỗi kết nối: ' + error.message);
                    }
                });
        }

        // Display products
        function displayProducts(products) {
            console.log('Displaying products:', products);
            const container = document.getElementById('productGrid');
            const productsContainer = document.getElementById('productsContainer');
            const noResults = document.getElementById('noResults');
            
            if (!products || products.length === 0) {
                console.log('No products to display');
                productsContainer.style.display = 'none';
                noResults.style.display = 'block';
                return;
            }
            
            console.log('Displaying', products.length, 'products');
            noResults.style.display = 'none';
            productsContainer.style.display = 'block';
            
            container.innerHTML = products.map(product => {
                const imageUrl = product.imageUrl || '<%=request.getContextPath()%>/img/placeholder.jpg';
                const categoryDisplay = product.category ? product.category.replace(/_/g, ' ') : '';
                const gradeDisplay = product.grade || '';
                
                return '<div class="product-card">' +
                    '<div class="product-image">' +
                        '<img src="' + imageUrl + '" alt="' + (product.name || '') + '" onerror="this.src=\'<%=request.getContextPath()%>/img/placeholder.jpg\'">' +
                        (gradeDisplay ? '<div class="product-badge">' + gradeDisplay + '</div>' : '') +
                    '</div>' +
                    '<div class="product-info">' +
                        '<h5 class="product-title">' + (product.name || 'Tên sản phẩm') + '</h5>' +
                        '<div class="product-price">' + formatPrice(product.price) + '</div>' +
                        '<div class="product-meta">' +
                            '<span><i class="fas fa-tag me-1"></i>' + categoryDisplay + '</span>' +
                            '<span><i class="fas fa-boxes me-1"></i>' + (product.stockQuantity || 0) + '</span>' +
                        '</div>' +
                        '<a href="<%=request.getContextPath()%>/product/' + product.id + '" class="btn view-detail-btn">' +
                            '<i class="fas fa-eye me-2"></i>Xem chi tiết' +
                        '</a>' +
                    '</div>' +
                '</div>';
            }).join('');
        }

        // Display pagination
        function displayPagination(pagination) {
            const container = document.getElementById('paginationContainer');
            
            if (!pagination || pagination.totalPages <= 1) {
                container.style.display = 'none';
                return;
            }
            
            container.style.display = 'block';
            
            let paginationHtml = '<nav aria-label="Search results pagination"><ul class="pagination justify-content-center">';
            
            // Previous button
            if (pagination.hasPrevious) {
                paginationHtml += '<li class="page-item">' +
                    '<a class="page-link" href="#" onclick="changePage(' + (pagination.currentPage - 1) + ')">' +
                    '<i class="fas fa-chevron-left"></i> Trước</a></li>';
            }
            
            // Page numbers
            const startPage = Math.max(1, pagination.currentPage - 2);
            const endPage = Math.min(pagination.totalPages, pagination.currentPage + 2);
            
            if (startPage > 1) {
                paginationHtml += '<li class="page-item"><a class="page-link" href="#" onclick="changePage(1)">1</a></li>';
                if (startPage > 2) {
                    paginationHtml += '<li class="page-item disabled"><span class="page-link">...</span></li>';
                }
            }
            
            for (let i = startPage; i <= endPage; i++) {
                paginationHtml += '<li class="page-item ' + (i === pagination.currentPage ? 'active' : '') + '">' +
                    '<a class="page-link" href="#" onclick="changePage(' + i + ')">' + i + '</a></li>';
            }
            
            if (endPage < pagination.totalPages) {
                if (endPage < pagination.totalPages - 1) {
                    paginationHtml += '<li class="page-item disabled"><span class="page-link">...</span></li>';
                }
                paginationHtml += '<li class="page-item"><a class="page-link" href="#" onclick="changePage(' + pagination.totalPages + ')">' + pagination.totalPages + '</a></li>';
            }
            
            // Next button
            if (pagination.hasNext) {
                paginationHtml += '<li class="page-item">' +
                    '<a class="page-link" href="#" onclick="changePage(' + (pagination.currentPage + 1) + ')">' +
                    'Sau <i class="fas fa-chevron-right"></i></a></li>';
            }
            
            paginationHtml += '</ul></nav>';
            container.innerHTML = paginationHtml;
        }

        // Setup event listeners
        function setupEventListeners() {
            // Filter form submission
            document.getElementById('filterForm').addEventListener('submit', function(e) {
                e.preventDefault();
                applyFilters();
            });

            // Sort change
            document.getElementById('sortSelect').addEventListener('change', function() {
                const [sort, order] = this.value.split(':');
                currentFilters.sort = sort;
                currentFilters.order = order;
                loadProducts(1);
            });

            // Search input autocomplete - handled by search-autocomplete.js
            // Just need to initialize the enhanced handler
            if (window.searchAutocomplete) {
                console.log('Search autocomplete already initialized');
            }
        }

        // Apply filters
        function applyFilters() {
            currentFilters.q = document.getElementById('searchQuery').value.trim();
            currentFilters.category = document.getElementById('categoryFilter').value;
            
            const minPriceInput = document.querySelector('input[name="minPrice"]');
            const maxPriceInput = document.querySelector('input[name="maxPrice"]');
            
            currentFilters.minPrice = minPriceInput.value ? parseFloat(minPriceInput.value) : null;
            currentFilters.maxPrice = maxPriceInput.value ? parseFloat(maxPriceInput.value) : null;
            
            loadProducts(1);
        }

        // Change page
        function changePage(page) {
            loadProducts(page);
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // Utility functions
        function showLoading() {
            document.getElementById('loadingIndicator').style.display = 'block';
            document.getElementById('productsContainer').style.display = 'none';
            document.getElementById('noResults').style.display = 'none';
            document.getElementById('paginationContainer').style.display = 'none';
        }

        function hideLoading() {
            document.getElementById('loadingIndicator').style.display = 'none';
        }

        function updateResultsCount(count) {
            const message = count === 0 ? 'Không tìm thấy sản phẩm nào' : 
                           count === 1 ? 'Tìm thấy 1 sản phẩm' : 
                           'Tìm thấy ' + count + ' sản phẩm';
            document.getElementById('resultsCount').textContent = message;
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }

        function showError(message) {
            document.getElementById('noResults').style.display = 'block';
            document.getElementById('noResults').innerHTML = 
                '<i class="fas fa-exclamation-triangle"></i>' +
                '<h4>Đã xảy ra lỗi</h4>' +
                '<p>' + message + '</p>';
        }

        // Show sample products when API is not available
        function showSampleProducts() {
            console.log('Showing sample products');
            hideLoading();
            
            const sampleProducts = [
                {
                    id: 1,
                    name: 'RG 1/144 RX-78-2 Gundam',
                    price: 850000,
                    category: 'Real Grade',
                    grade: 'RG',
                    stockQuantity: 15,
                    imageUrl: '<%=request.getContextPath()%>/img/RGStrikeGundam.jpg'
                },
                {
                    id: 2,
                    name: 'MG 1/100 Strike Freedom Gundam',
                    price: 1200000,
                    category: 'Master Grade',
                    grade: 'MG',
                    stockQuantity: 8,
                    imageUrl: '<%=request.getContextPath()%>/img/placeholder.jpg'
                },
                {
                    id: 3,
                    name: 'HG 1/144 Barbatos Lupus',
                    price: 550000,
                    category: 'High Grade',
                    grade: 'HG',
                    stockQuantity: 22,
                    imageUrl: '<%=request.getContextPath()%>/img/placeholder.jpg'
                }
            ];
            
            displayProducts(sampleProducts);
            updateResultsCount(sampleProducts.length);
            
            // Hide pagination for sample data
            document.getElementById('paginationContainer').style.display = 'none';
        }
    </script>

    <style>
        .search-suggestions {
            position: absolute;
            top: 100%;
            left: 0;
            right: 40px;
            background: white;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 5px 5px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .suggestion-item {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }

        .suggestion-item:hover {
            background-color: #f8f9fa;
        }

        .suggestion-item:last-child {
            border-bottom: none;
        }

        .input-group {
            position: relative;
        }
    </style>
    
    <!-- Avatar Utils -->
    <script src="<%=request.getContextPath()%>/js/avatar-utils.js"></script>
    
    <!-- Authentication and Navbar Scripts -->
    <script src="<%=request.getContextPath()%>/js/auth-sync.js"></script>
    <script src="<%=request.getContextPath()%>/js/navbar-manager.js"></script>
    <script src="<%=request.getContextPath()%>/js/google-oauth-clean.js"></script>
    <script src="<%=request.getContextPath()%>/js/navbar-fix.js"></script>
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    
    <!-- Force check auth state after page load -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Force check auth state multiple times to ensure sync
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 100);
            
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 500);
        });
    </script>
    <script src="<%=request.getContextPath()%>/js/modern-header.js"></script>
</body>
</html>






