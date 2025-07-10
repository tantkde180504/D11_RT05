<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Universal Sidebar Navigation (works on all screen sizes) -->
<div class="mobile-sidebar" id="mobileSidebar">
    <button class="sidebar-close" id="sidebarClose" aria-label="Đóng menu">&times;</button>
    
    <div class="sidebar-header">
        <h4><i class="fas fa-rocket me-2"></i>GundamHobby Menu</h4>
        <p class="mb-0 text-muted small">✨ Khám phá thế giới mô hình tuyệt vời</p>
    </div>
    
    <!-- Category Section in Sidebar -->
    <div class="category-section">
        <h5><i class="fas fa-layer-group me-2"></i>Danh Mục Sản Phẩm</h5>
        <ul class="category-list">
            <li><a href="#"><i class="fas fa-robot me-2"></i>Gundam Bandai</a></li>
            <li><a href="#"><i class="fas fa-industry me-2"></i>Mô hình Trung</a></li>
            <li><a href="#"><i class="fas fa-gem me-2"></i>Metal Build - Diecast</a></li>
            <li><a href="#"><i class="fas fa-tools me-2"></i>Dụng cụ - Tool</a></li>
            <li><a href="#"><i class="fas fa-puzzle-piece me-2"></i>Phụ kiện - Base</a></li>
            <li><a href="#"><i class="fas fa-dragon me-2"></i>Mô hình Dragon Ball</a></li>
            <li><a href="#"><i class="fas fa-palette me-2"></i>Sơn - Decal</a></li>
        </ul>
    </div>
    
    <ul class="sidebar-menu">
        <li><a href="<%=request.getContextPath()%>/"><i class="fas fa-home me-2"></i>Trang chủ</a></li>
        <li><a href="<%=request.getContextPath()%>/all-products.jsp"><i class="fas fa-th-large me-2"></i>Tất cả sản phẩm</a></li>
        <li><a href="#"><i class="fas fa-star me-2"></i>Hàng mới về</a></li>
        <li><a href="#"><i class="fas fa-clock me-2"></i>Hàng Pre-order</a></li>
        <li>
            <a href="#" data-bs-toggle="collapse" data-bs-target="#phukienSubmenu" aria-expanded="false">
                <i class="fas fa-cubes me-2"></i>Phụ kiện & Mô hình <i class="fas fa-chevron-down float-end"></i>
            </a>
            <ul class="collapse submenu" id="phukienSubmenu">
                <li><a href="#"><i class="fas fa-tools me-2"></i>Dụng cụ - Tool</a></li>
                <li><a href="#"><i class="fas fa-puzzle-piece me-2"></i>Phụ kiện - Base</a></li>
                <li><a href="#"><i class="fas fa-dragon me-2"></i>Mô hình Dragon Ball</a></li>
            </ul>
        </li>
        <li>
            <a href="#" data-bs-toggle="collapse" data-bs-target="#bandaiSubmenu" aria-expanded="false">
                <i class="fas fa-robot me-2"></i>Bandai Collection <i class="fas fa-chevron-down float-end"></i>
            </a>
            <ul class="collapse submenu" id="bandaiSubmenu">
                <li><a href="#"><i class="fas fa-award me-2"></i>High Grade (HG)</a></li>
                <li><a href="#"><i class="fas fa-trophy me-2"></i>Master Grade (MG)</a></li>
                <li><a href="#"><i class="fas fa-medal me-2"></i>Real Grade (RG)</a></li>
                <li><a href="#"><i class="fas fa-crown me-2"></i>Perfect Grade (PG)</a></li>
            </ul>
        </li>
        <li><a href="favorites.jsp"><i class="fas fa-heart me-2"></i>Yêu thích</a></li>
        <li><a href="#"><i class="fas fa-user me-2"></i>Tài khoản</a></li>
    </ul>
    
    <!-- Additional Info Section for Desktop -->
    <div class="sidebar-footer d-none d-lg-block">
        <div class="contact-info mt-4 p-3 rounded">
            <h6 class="mb-3"><i class="fas fa-headset me-2"></i>Liên hệ hỗ trợ</h6>
            <p class="mb-2 small"><i class="fas fa-map-marker-alt me-2"></i>59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng</p>
            <p class="mb-2 small"><i class="fas fa-phone-alt me-2"></i>0385 546 145</p>
            <p class="mb-2 small"><i class="fas fa-envelope me-2"></i>43gundamhobby@gmail.com</p>
            <p class="mb-0 small"><i class="fas fa-clock me-2"></i>8:00 - 22:00 hàng ngày</p>
        </div>
    </div>
</div>

<!-- Sidebar Overlay -->
<div class="mobile-overlay" id="mobileOverlay"></div>
