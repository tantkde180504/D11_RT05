<!-- Unified Header Component - Single source of truth for all pages -->
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
                                       placeholder="" id="headerSearchInput" autocomplete="off">
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
                        <a href="<%=request.getContextPath()%>/cart.jsp" class="btn btn-primary modern-cart-btn">
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
