<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
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
                <div class="col-lg-6 col-md-4 col-12 order-lg-2 order-md-2 order-3">
                    <div class="header-center-section">
                        <div class="search-container w-100">
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
                </div>
                
                <!-- Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-lg-3 order-md-3 order-2">
                    <div class="header-actions-section">
                        <div class="account-menu me-3">
                            <%
                                Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
                                String userName = (String) session.getAttribute("userName");
                                String userPicture = (String) session.getAttribute("userPicture");
                                
                                if (isLoggedIn != null && isLoggedIn) {
                            %>
                                <!-- User logged in -->
                                <div class="dropdown">
                                    <a href="#" class="dropdown-toggle text-decoration-none d-flex align-items-center" data-bs-toggle="dropdown">
                                        <% if (userPicture != null && !userPicture.isEmpty()) { %>
                                            <img src="<%= userPicture %>" alt="Avatar" class="rounded-circle me-2 avatar-32">
                                        <% } else { %>
                                            <i class="fas fa-user-circle me-2 user-icon-32"></i>
                                        <% } %>
                                        <span class="text-dark d-none d-md-inline">Xin chào, <%= userName != null ? userName : "User" %></span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end z-index-1050">
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp"><i class="fas fa-user me-2"></i>Hồ sơ khách hàng</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="#" onclick="logoutUser()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                    </ul>
                                </div>
                            <%
                                } else {
                            %>
                                <!-- User not logged in -->
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
                            <%
                                }
                            %>
                        </div>
                        
                        <div class="cart-section">
                            <a href="<%=request.getContextPath()%>/cart.jsp" class="btn btn-outline-primary position-relative">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    0
                                    <span class="visually-hidden">items in cart</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Include Mobile Sidebar -->
    <%@ include file="includes/mobile-sidebar.jsp" %>

    <!-- Main Content -->
    <main class="container py-4">
        <div class="row">
            <!-- Breadcrumb -->
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="<%=request.getContextPath()%>/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Sản phẩm yêu thích</li>
                    </ol>
                </nav>
            </div>
            
            <!-- Main Content Area -->
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3 fw-bold mb-0">
                        <i class="fas fa-heart text-danger me-2"></i>
                        Sản phẩm yêu thích
                    </h1>
                    <span class="badge bg-primary" id="favoritesCount">0 sản phẩm</span>
                </div>
                
                <!-- Login Required Message -->
                <div class="alert alert-info" id="loginRequiredMessage" style="display: none;">
                    <i class="fas fa-info-circle me-2"></i>
                    Vui lòng <a href="<%=request.getContextPath()%>/login.jsp" class="alert-link">đăng nhập</a> để xem danh sách sản phẩm yêu thích của bạn.
                </div>
                
                <!-- Empty Favorites Message -->
                <div class="text-center py-5" id="emptyFavoritesMessage" style="display: none;">
                    <i class="fas fa-heart-broken text-muted" style="font-size: 4rem;"></i>
                    <h4 class="mt-3 text-muted">Chưa có sản phẩm yêu thích</h4>
                    <p class="text-muted">Hãy thêm những sản phẩm mà bạn yêu thích vào danh sách này!</p>
                    <a href="<%=request.getContextPath()%>/all-products.jsp" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>Khám phá sản phẩm
                    </a>
                </div>
                
                <!-- Products Grid -->
                <div class="row g-3" id="favoritesGrid">
                    <!-- Loading spinner -->
                    <div class="col-12 text-center" id="loadingSpinner">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Đang tải...</span>
                        </div>
                        <p class="mt-2">Đang tải sản phẩm yêu thích...</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-dark text-white py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h5>43 Gundam Hobby</h5>
                    <p class="mb-0">Chuyên cung cấp mô hình Gundam chính hãng</p>
                </div>
                <div class="col-md-4">
                    <h5>Liên hệ</h5>
                    <p class="mb-1"><i class="fas fa-map-marker-alt me-2"></i>59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng</p>
                    <p class="mb-1"><i class="fas fa-phone me-2"></i>0385 546 145</p>
                    <p class="mb-0"><i class="fas fa-envelope me-2"></i>43gundamhobby@gmail.com</p>
                </div>
                <div class="col-md-4">
                    <h5>Giờ mở cửa</h5>
                    <p class="mb-0">8:00 - 22:00 hàng ngày</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    <script src="<%=request.getContextPath()%>/js/favorites-manager.js"></script>
</body>
</html>