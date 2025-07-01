<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - Gundam Hobby</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-bg-orange.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-menu-white.css">
    
    <style>
        .search-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .search-filters {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .filter-group {
            margin-bottom: 1rem;
        }
        
        .filter-group label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        
        .price-range {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .price-input {
            flex: 1;
            max-width: 120px;
        }
        
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #e9ecef;
        }
        
        .sort-controls {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .product-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .product-image {
            position: relative;
            overflow: hidden;
            height: 250px;
        }
        
        .product-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .product-card:hover .product-image img {
            transform: scale(1.05);
        }
        
        .product-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #ff6b35;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .product-info {
            padding: 1.2rem;
        }
        
        .product-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #2c3e50;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price {
            font-size: 1.3rem;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 0.8rem;
        }
        
        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .view-detail-btn {
            width: 100%;
            background: linear-gradient(45deg, #ff6b35, #f7931e);
            border: none;
            color: white;
            padding: 0.8rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .view-detail-btn:hover {
            background: linear-gradient(45deg, #e55a2b, #e8841a);
            transform: translateY(-2px);
            color: white;
        }
        
        .pagination-container {
            display: flex;
            justify-content: center;
            margin: 2rem 0;
        }
        
        .no-results {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .no-results i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #dee2e6;
        }
        
        .loading {
            text-align: center;
            padding: 2rem;
        }
        
        .spinner-border {
            color: #ff6b35;
        }
        
        @media (max-width: 768px) {
            .search-filters {
                padding: 1rem;
            }
            
            .results-header {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
            
            .sort-controls {
                justify-content: center;
            }
            
            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
            
            .price-range {
                flex-direction: column;
                gap: 5px;
            }
            
            .price-input {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="Logo" width="40" height="40" class="me-2">
                <span class="fw-bold">Gundam Hobby</span>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/all-products">Sản phẩm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">Giới thiệu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Liên hệ</a>
                    </li>
                </ul>

                <!-- Search Form -->
                <form class="d-flex me-3" id="headerSearchForm" action="${pageContext.request.contextPath}/search" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" name="q" placeholder="Tìm kiếm sản phẩm..." 
                               value="${query}" id="headerSearchInput" autocomplete="off">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <!-- Autocomplete suggestions -->
                    <div id="headerSearchSuggestions" class="search-suggestions"></div>
                </form>

                <!-- User Menu -->
                <div class="nav-user-menu">
                    <div id="userNotLoggedIn" style="display: none;">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary me-2">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Đăng ký</a>
                    </div>
                    
                    <div id="userLoggedIn" style="display: none;">
                        <div class="dropdown">
                            <button class="btn btn-outline-primary dropdown-toggle d-flex align-items-center" type="button" 
                                    id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-user-circle me-2"></i>
                                <span id="userName">User</span>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                    <i class="fas fa-user me-2"></i>Hồ sơ
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/orders">
                                    <i class="fas fa-shopping-bag me-2"></i>Đơn hàng
                                </a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" id="logoutBtn">
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </nav>

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
            <form id="filterForm" method="get" action="${pageContext.request.contextPath}/search">
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
    <script src="${pageContext.request.contextPath}/js/search-autocomplete.js"></script>
    
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
            initializeAuthentication();
            initializeSearch();
            loadProducts();
            setupEventListeners();
        });

        // Authentication handling
        function initializeAuthentication() {
            try {
                const userInfo = JSON.parse(localStorage.getItem('userInfo') || sessionStorage.getItem('userInfo') || 'null');
                
                if (userInfo && userInfo.username) {
                    document.getElementById('userLoggedIn').style.display = 'block';
                    document.getElementById('userNotLoggedIn').style.display = 'none';
                    document.getElementById('userName').textContent = userInfo.username;
                } else {
                    document.getElementById('userLoggedIn').style.display = 'none';
                    document.getElementById('userNotLoggedIn').style.display = 'block';
                }
            } catch (error) {
                console.error('Error checking authentication:', error);
                document.getElementById('userLoggedIn').style.display = 'none';
                document.getElementById('userNotLoggedIn').style.display = 'block';
            }
        }

        // Logout handling
        document.getElementById('logoutBtn').addEventListener('click', function(e) {
            e.preventDefault();
            localStorage.removeItem('userInfo');
            sessionStorage.removeItem('userInfo');
            window.location.href = '${pageContext.request.contextPath}/';
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

            const apiUrl = '${pageContext.request.contextPath}/search/api?' + params.toString();
            console.log('API URL:', apiUrl);

            fetch(apiUrl)
                .then(response => {
                    console.log('API Response status:', response.status);
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
                    showError('Lỗi kết nối. Vui lòng thử lại.');
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
                const imageUrl = product.imageUrl || '${pageContext.request.contextPath}/img/placeholder.jpg';
                const categoryDisplay = product.category ? product.category.replace(/_/g, ' ') : '';
                const gradeDisplay = product.grade || '';
                
                return '<div class="product-card">' +
                    '<div class="product-image">' +
                        '<img src="' + imageUrl + '" alt="' + (product.name || '') + '" onerror="this.src=\'${pageContext.request.contextPath}/img/placeholder.jpg\'">' +
                        (gradeDisplay ? '<div class="product-badge">' + gradeDisplay + '</div>' : '') +
                    '</div>' +
                    '<div class="product-info">' +
                        '<h5 class="product-title">' + (product.name || 'Tên sản phẩm') + '</h5>' +
                        '<div class="product-price">' + formatPrice(product.price) + '</div>' +
                        '<div class="product-meta">' +
                            '<span><i class="fas fa-tag me-1"></i>' + categoryDisplay + '</span>' +
                            '<span><i class="fas fa-boxes me-1"></i>' + (product.stockQuantity || 0) + '</span>' +
                        '</div>' +
                        '<a href="${pageContext.request.contextPath}/product/' + product.id + '" class="btn view-detail-btn">' +
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
</body>
</html>
