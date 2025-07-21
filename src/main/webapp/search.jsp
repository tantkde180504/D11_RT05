<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - Gundam Hobby</title>
    <%@ include file="/includes/unified-css.jsp" %>
</head>
<body>
    <!-- Success notification for OAuth login -->
    <div id="oauth-success-notification" class="alert alert-success alert-dismissible fade oauth-notification">
        <strong>🎉 Đăng nhập thành công!</strong>
        <p class="mb-0" id="welcome-message">Chào mừng bạn quay trở lại!</p>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>

    <!-- Header -->
    <%@ include file="/includes/unified-header.jsp" %>
    
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

    <%@ include file="/includes/unified-scripts.jsp" %>
    
    <!-- Search-specific scripts -->
    <script src="${pageContext.request.contextPath}/js/avatar-utils.js"></script>
    <script src="${pageContext.request.contextPath}/js/cart-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/auth-sync.js"></script>
    
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
                                '<a href="${pageContext.request.contextPath}/product-detail.jsp?id=' + product.id + '" class="btn btn-primary w-100">' +
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
            right: 0;
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

        .search-container {
            position: relative;
        }
    </style>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Avatar Utils -->
    <script src="${pageContext.request.contextPath}/js/avatar-utils.js"></script>
    
    <!-- Cart Manager Script -->
    <script src="${pageContext.request.contextPath}/js/cart-manager.js"></script>
    
    <!-- Unified Navbar Manager -->
    <script src="${pageContext.request.contextPath}/js/unified-navbar-manager.js"></script>
    
    <!-- Google OAuth Handler -->
    <script src="${pageContext.request.contextPath}/js/google-oauth-handler.js"></script>
    
    <!-- Authentication and Navbar Scripts -->
    <script src="${pageContext.request.contextPath}/js/auth-sync.js"></script>
    <script src="${pageContext.request.contextPath}/js/navbar-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/google-oauth-clean.js"></script>
    <script src="${pageContext.request.contextPath}/js/navbar-fix.js"></script>
    <script src="${pageContext.request.contextPath}/js/hamburger-menu.js"></script>
    
    <!-- Unified Navbar Debug -->
    <script src="${pageContext.request.contextPath}/js/unified-navbar-debug.js"></script>
    
    <!-- Force check auth state after page load -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            console.log('📦 DOM ready, setting up unified navbar...');
            
            // Initialize cart count
            if (window.cartManager) {
                window.cartManager.updateCartCount();
            }
            
            // Immediate auth state debug
            console.log('🔍 Immediate Auth Check:');
            console.log('- currentUser:', localStorage.getItem('currentUser'));
            console.log('- googleUser:', localStorage.getItem('googleUser'));
            console.log('- userLoggedIn:', localStorage.getItem('userLoggedIn'));
            
            // Ensure unified navbar manager is initialized
            if (window.unifiedNavbarManager) {
                setTimeout(() => {
                    console.log('⚡ Manual auth state check...');
                    window.unifiedNavbarManager.checkAuthState();
                }, 100);
                
                setTimeout(() => {
                    console.log('🔄 Refreshing navbar...');
                    window.unifiedNavbarManager.refreshNavbar();
                }, 200);
            } else {
                console.warn('⚠️ unifiedNavbarManager not found!');
            }
            
            // Force check auth state multiple times to ensure sync
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 300);
            
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 600);
        });
    </script>
</body>
</html>






