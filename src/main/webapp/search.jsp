<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hamburger-menu.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-fix.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/account-menu-fix.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-avatar.css">
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
                <form class="d-flex me-3" id="headerSearchForm" action="${pageContext.request.contextPath}/search.jsp" method="get">
                    <div class="input-group">
                        <input class="form-control" type="search" name="q" placeholder="Tìm kiếm sản phẩm..." 
                               value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" id="headerSearchInput" autocomplete="off">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <!-- Autocomplete suggestions -->
                    <div id="headerSearchSuggestions" class="search-suggestions"></div>
                </form>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2>Kết quả tìm kiếm</h2>
        <p id="searchQueryDisplay"></p>
        
        <!-- Loading -->
        <div id="loadingIndicator" class="text-center">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Đang tải...</span>
            </div>
            <p class="mt-2">Đang tìm kiếm sản phẩm...</p>
        </div>

        <!-- Products Grid -->
        <div id="productsContainer" style="display: none;">
            <div class="row" id="productGrid">
                <!-- Products will be loaded here -->
            </div>
        </div>

        <!-- No Results -->
        <div id="noResults" style="display: none;">
            <div class="text-center">
                <i class="fas fa-search fa-4x text-muted"></i>
                <h4 class="mt-3">Không tìm thấy sản phẩm nào</h4>
                <p>Hãy thử thay đổi từ khóa tìm kiếm</p>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Search Autocomplete Script -->
    <script src="${pageContext.request.contextPath}/js/search-autocomplete.js"></script>
    
    <script>
        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Get query from URL parameter
            const urlParams = new URLSearchParams(window.location.search);
            const query = urlParams.get('q') || '';
            
            // Display query in UI
            const queryDisplay = document.getElementById('searchQueryDisplay');
            if (query) {
                queryDisplay.innerHTML = 'Tìm kiếm cho: "<strong>' + escapeHtml(query) + '</strong>"';
                loadProducts(query);
            } else {
                queryDisplay.innerHTML = '';
                hideLoading();
            }
        });

        function loadProducts(query) {
            console.log('Loading products for query:', query);
            
            const apiUrl = '${pageContext.request.contextPath}/search/api?q=' + encodeURIComponent(query) + '&size=20';
            console.log('API URL:', apiUrl);

            fetch(apiUrl)
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('API request failed: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('API Response:', data);
                    hideLoading();
                    
                    if (data.success && data.products) {
                        displayProducts(data.products);
                    } else {
                        showNoResults();
                    }
                })
                .catch(error => {
                    console.error('Error loading products:', error);
                    hideLoading();
                    showError(error.message);
                });
        }

        function displayProducts(products) {
            console.log('Displaying products:', products.length);
            const container = document.getElementById('productGrid');
            const productsContainer = document.getElementById('productsContainer');
            
            if (!products || products.length === 0) {
                showNoResults();
                return;
            }
            
            document.getElementById('noResults').style.display = 'none';
            productsContainer.style.display = 'block';
            
            container.innerHTML = products.map(product => {
                const imageUrl = product.imageUrl || '${pageContext.request.contextPath}/img/placeholder.jpg';
                const price = formatPrice(product.price);
                
                return '<div class="col-md-4 col-lg-3 mb-4">' +
                    '<div class="card h-100">' +
                        '<img src="' + imageUrl + '" class="card-img-top" alt="' + (product.name || '') + '" style="height: 200px; object-fit: cover;" onerror="this.src=\'${pageContext.request.contextPath}/img/placeholder.jpg\'">' +
                        '<div class="card-body d-flex flex-column">' +
                            '<h5 class="card-title">' + (product.name || 'Tên sản phẩm') + '</h5>' +
                            '<p class="card-text text-danger fw-bold">' + price + '</p>' +
                            '<div class="mt-auto">' +
                                '<a href="${pageContext.request.contextPath}/product/' + product.id + '" class="btn btn-primary w-100">' +
                                    '<i class="fas fa-eye me-2"></i>Xem chi tiết' +
                                '</a>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            }).join('');
        }

        function showNoResults() {
            document.getElementById('productsContainer').style.display = 'none';
            document.getElementById('noResults').style.display = 'block';
        }

        function showError(message) {
            document.getElementById('productsContainer').style.display = 'none';
            const noResults = document.getElementById('noResults');
            noResults.style.display = 'block';
            noResults.innerHTML = 
                '<div class="text-center">' +
                    '<i class="fas fa-exclamation-triangle fa-4x text-warning"></i>' +
                    '<h4 class="mt-3">Đã xảy ra lỗi</h4>' +
                    '<p>' + message + '</p>' +
                '</div>';
        }

        function hideLoading() {
            document.getElementById('loadingIndicator').style.display = 'none';
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }
        
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
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
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Avatar Utils -->
    <script src="${pageContext.request.contextPath}/js/avatar-utils.js"></script>
    
    <!-- Authentication and Navbar Scripts -->
    <script src="${pageContext.request.contextPath}/js/auth-sync.js"></script>
    <script src="${pageContext.request.contextPath}/js/navbar-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/google-oauth-clean.js"></script>
    <script src="${pageContext.request.contextPath}/js/navbar-fix.js"></script>
    <script src="${pageContext.request.contextPath}/js/hamburger-menu.js"></script>
    
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
</body>
</html>
