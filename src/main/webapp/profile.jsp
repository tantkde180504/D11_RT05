<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin khách hàng - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
</head>
<body class="profile-body">    <header class="bg-white shadow-sm sticky-top">
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
                                String loginType = (String) session.getAttribute("loginType");
                                
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
                        <div class="cart-btn">
                            <a href="#" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-1"></i>
                                <span class="cart-count">0</span>
                                <span class="d-none d-lg-inline ms-1">Giỏ hàng</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>
    
    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />
    <main class="container my-5">
        <div class="row">
            <div class="col-md-3">
                <div class="profile-sidebar">                    <div class="text-center mb-4">
                        <img id="profileUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-2 avatar-80">
                        <h5 id="profileUserName">Đang tải...</h5>
                        <small id="profileUserEmail" class="text-muted">Đang tải...</small>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#" id="profileInfoTab"><i class="fas fa-user me-2"></i>Thông tin tài khoản</a>
                        <a class="nav-link" href="#" id="profileOrdersTab"><i class="fas fa-box me-2"></i>Đơn hàng của bạn</a>
                        <a class="nav-link" href="#" id="profilePasswordTab"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a>
                        <a class="nav-link" href="#" id="profileAddressTab"><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ <span class="badge bg-secondary ms-1">0</span></a>
                        <a class="nav-link text-danger" href="#" id="profileLogoutBtn"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                    </nav>
                </div>
            </div>
            <div class="col-md-9">                <div class="profile-content" id="profileContent">
                    <!-- Nội dung từng tab sẽ được hiển thị ở đây -->
                    <div id="profileInfoContent">
                        <h4><i class="fas fa-user-circle me-2"></i>Thông tin tài khoản</h4>
                        <div class="row mt-4">
                            <div class="col-md-8">
                                <div class="info-section">
                                    <h6 class="text-muted mb-3">Thông tin cá nhân</h6>
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Họ tên:</strong></div>
                                        <div class="col-sm-8" id="displayUserName">Đang tải...</div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Email:</strong></div>
                                        <div class="col-sm-8" id="displayUserEmail">Đang tải...</div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Vai trò:</strong></div>
                                        <div class="col-sm-8" id="displayUserRole">Đang tải...</div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Đăng nhập bằng:</strong></div>
                                        <div class="col-sm-8" id="displayLoginType">Đang tải...</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="avatar-section">
                                    <img id="displayUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-3 avatar-120">
                                    <div class="mt-2">
                                        <small class="text-muted">Ảnh đại diện từ Google</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<%=request.getContextPath()%>/js/account-dropdown.js"></script>
    <script>
        // Hiển thị thông tin người dùng từ session
        document.addEventListener('DOMContentLoaded', function() {
            // Lấy thông tin từ session JSP
            const userName = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>';
            const userEmail = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>';
            const userPicture = '<%= session.getAttribute("userPicture") != null ? session.getAttribute("userPicture") : "" %>';
            const userRole = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "CUSTOMER" %>';
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            // Cập nhật thông tin trong sidebar
            if (userName && userName !== 'null' && userName !== '') {
                document.getElementById('profileUserName').textContent = 'Xin chào, ' + userName;
                document.getElementById('displayUserName').textContent = userName;
            } else {
                document.getElementById('profileUserName').textContent = 'Chưa đăng nhập';
                document.getElementById('displayUserName').textContent = 'Chưa có thông tin';
            }
            
            if (userEmail && userEmail !== 'null' && userEmail !== '') {
                document.getElementById('profileUserEmail').textContent = userEmail;
                document.getElementById('displayUserEmail').textContent = userEmail;
            } else {
                document.getElementById('profileUserEmail').textContent = 'Chưa có email';
                document.getElementById('displayUserEmail').textContent = 'Chưa có thông tin';
            }
            
            // Cập nhật avatar
            if (userPicture && userPicture !== 'null' && userPicture !== '') {
                document.getElementById('profileUserAvatar').src = userPicture;
                document.getElementById('displayUserAvatar').src = userPicture;
            }
            
            // Cập nhật role
            let roleText = userRole;
            if (userRole === 'CUSTOMER') roleText = 'Khách hàng';
            else if (userRole === 'ADMIN') roleText = 'Quản trị viên';
            else if (userRole === 'STAFF') roleText = 'Nhân viên';
            document.getElementById('displayUserRole').textContent = roleText;
            
            // Cập nhật login type
            let loginTypeText = loginType;
            if (loginType === 'google') loginTypeText = 'Google OAuth';
            else if (loginType === 'local') loginTypeText = 'Tài khoản nội bộ';
            document.getElementById('displayLoginType').textContent = loginTypeText;
        });
        
        // Xử lý tab switching
        document.getElementById('profileInfoTab').onclick = function(e) {
            e.preventDefault();
            // Remove active class from all tabs
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Show profile info content (đã có sẵn)
            const profileContent = document.getElementById('profileContent');
            profileContent.innerHTML = document.getElementById('profileInfoContent').outerHTML;
        };
        
        document.getElementById('profileOrdersTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = `
                <h4><i class="fas fa-box me-2"></i>Đơn hàng của bạn</h4>
                <div id="order-history-list" class="mt-4">
                    <div class="text-muted">Đang tải dữ liệu...</div>
                </div>
                
                <!-- Modal Gửi Khiếu Nại -->
                <div class="modal fade" id="complaintModal" tabindex="-1" aria-labelledby="complaintModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <form id="complaintForm" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Gửi khiếu nại đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="complaintOrderId">
                                <div class="mb-3">
                                    <label for="complaintCategory" class="form-label">Danh mục (tùy chọn)</label>
                                    <select class="form-select" id="complaintCategory">
                                        <option value="">-- Chọn danh mục khiếu nại --</option>
                                        <option value="Giao hàng trễ">Giao hàng trễ</option>
                                        <option value="Hỏng sản phẩm">Hỏng sản phẩm</option>
                                        <option value="Thiếu hàng">Thiếu hàng</option>
                                        <option value="Sai hàng">Sai hàng</option>
                                        <option value="Không đúng mô tả">Không đúng mô tả</option>
                                        <option value="Không hoạt động">Không hoạt động</option>
                                        <option value="Chất lượng kém">Chất lượng kém</option>
                                        <option value="Lý do khác">Lý do khác</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="complaintContent" class="form-label">Nội dung khiếu nại *</label>
                                    <textarea class="form-control" id="complaintContent" rows="4" required></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Gửi khiếu nại</button>
                            </div>
                        </form>
                    </div>
                </div>
            `;
            
            // Load order history
            loadOrderHistory();
        };
        
        document.getElementById('profilePasswordTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = `
                <h4><i class="fas fa-key me-2"></i>Đổi mật khẩu</h4>
                <div class="alert alert-warning mt-4">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Chức năng này sẽ được cập nhật trong phiên bản tiếp theo.
                </div>
            `;
        };
        
        document.getElementById('profileAddressTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = `
                <h4><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ</h4>
                <div class="alert alert-info mt-4">
                    <i class="fas fa-info-circle me-2"></i>
                    Bạn chưa có địa chỉ nào được lưu.
                </div>
            `;
        };
        
        // Xử lý đăng xuất
        document.getElementById('profileLogoutBtn').onclick = function(e) {
            e.preventDefault();
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                logoutUser();
            }
        };
        
        // Function đăng xuất
        function logoutUser() {
            // Gọi API logout của Spring Security OAuth2
            fetch('/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            }).then(() => {
                // Clear session storage
                sessionStorage.clear();
                localStorage.clear();
                
                // Redirect về trang chủ
                window.location.href = '/';
            }).catch(error => {
                console.error('Logout error:', error);
                // Fallback: redirect về trang chủ dù có lỗi
                window.location.href = '/';
            });
        }
        
        // Functions for order history
        async function loadOrderHistory() {
            const orderHistoryList = document.getElementById('order-history-list');
            try {
                const resp = await fetch('/api/orders/history', { headers: { 'Accept': 'application/json' } });
                if (!resp.ok) throw new Error('Lỗi xác thực hoặc máy chủ');
                const data = await resp.json();
                if (!Array.isArray(data)) {
                    orderHistoryList.innerHTML = '<div class="text-danger">' + (data.message || 'Không lấy được dữ liệu!') + '</div>';
                    return;
                }
                if (data.length === 0) {
                    orderHistoryList.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>Bạn chưa có đơn hàng nào. <a href="/" class="alert-link">Khám phá sản phẩm ngay!</a></div>';
                    return;
                }
                let html = '<div class="table-responsive"><table class="table table-bordered align-middle order-table"><thead class="table-light"><tr>' +
                    '<th>Hình ảnh</th><th>Mã đơn</th><th>Tên sản phẩm</th><th>Ngày đặt</th><th>Trạng thái</th><th>Tổng tiền</th><th>Hành động</th></tr></thead><tbody>';
                data.forEach(order => {
                    const product = order.firstProduct || {};
                    html += '<tr>' +
                        '<td style="width:70px">' + (product.image ? '<img src="' + product.image + '" alt="Ảnh" style="max-width:60px;max-height:60px;object-fit:cover;">' : '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td class="fw-bold">' + order.orderNumber + '</td>' +
                        '<td>' + (product.name || '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td>' + (order.orderDate ? new Date(order.orderDate).toLocaleString('vi-VN') : '') + '</td>' +
                        '<td>' + renderStatus(order.status) + '</td>' +
                        '<td class="text-danger fw-bold">' + formatCurrency(order.totalAmount) + '₫</td>' +
                        '<td>' + renderCancelBtn(order) + '</td>' +
                        '</tr>';
                });
                html += '</tbody></table></div>';
                orderHistoryList.innerHTML = html;
            } catch (e) {
                orderHistoryList.innerHTML = '<div class="text-danger">Lỗi tải dữ liệu!</div>';
            }
        }

        function formatCurrency(num) {
            if (!num) return '0';
            return Number(num).toLocaleString('vi-VN');
        }

        function renderStatus(status) {
            return '<span class="order-status ' + status + '">' + status + '</span>';
        }

        function renderCancelBtn(order) {
            if (["PENDING", "CONFIRMED", "PROCESSING"].includes(order.status)) {
                return '<button class="btn btn-danger btn-sm" onclick="cancelOrder(' + order.id + ', this)"><i class="fas fa-trash-alt me-1"></i>Hủy đơn</button>';
            } else if (order.status === "DELIVERED") {
                return '<button class="btn btn-warning btn-sm" onclick="sendComplaint(' + order.id + ', this)"><i class="fas fa-exclamation-circle me-1"></i>Gửi khiếu nại</button>';
            }
            return '';
        }

        window.cancelOrder = async function (orderId, btn) {
            if (!confirm('Bạn chắc chắn muốn xóa/hủy đơn hàng này?')) return;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xóa...';
            try {
                const resp = await fetch('/api/orders/' + orderId + '/cancel', { method: 'POST' });
                const data = await resp.json();
                if (data.success) {
                    btn.closest('tr').remove();
                    alert('Đã xóa/hủy đơn hàng thành công!');
                } else {
                    alert(data.message || 'Không thể xóa!');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
                }
            } catch (e) {
                alert('Lỗi kết nối máy chủ!');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
            }
        }

        window.sendComplaint = function (orderId) {
            document.getElementById('complaintOrderId').value = orderId;
            document.getElementById('complaintForm').reset();
            const modal = new bootstrap.Modal(document.getElementById('complaintModal'));
            modal.show();
        };

        // Handle complaint form submission
        document.addEventListener('submit', async function(e) {
            if (e.target && e.target.id === 'complaintForm') {
                e.preventDefault();
                const orderId = document.getElementById('complaintOrderId').value;
                const category = document.getElementById('complaintCategory').value.trim();
                const content = document.getElementById('complaintContent').value.trim();

                if (!content) {
                    alert('Vui lòng nhập nội dung khiếu nại!');
                    return;
                }

                try {
                    const resp = await fetch('/api/complaints/create', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ orderId, category, content })
                    });
                    const data = await resp.json();
                    if (data.success) {
                        alert('Gửi khiếu nại thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('complaintModal')).hide();
                    } else {
                        alert(data.message || 'Gửi khiếu nại thất bại!');
                    }
                } catch (err) {
                    alert('Lỗi kết nối máy chủ!');
                }
            }
        });
    </script>
    
    <!-- Hamburger Menu Script -->
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
</body>
</html>
