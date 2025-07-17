<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Dashboard - 43 Gundam Hobby</title>
        <!-- CSS Files -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link href="css/styles.css" rel="stylesheet">
        <link href="css/staff-styles.css" rel="stylesheet">
    </head>

    <body class="staff-body">
        <div class="staff-container">
            <!-- Header -->
            <div class="staff-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h1 class="mb-0"><i class="fas fa-users-cog text-primary me-3"></i>Staff Dashboard</h1>
                        <p class="mb-0 text-muted">Quản lý hoạt động hỗ trợ khách hàng và vận hành</p>
                    </div>
                    <div class="col-md-6 text-end">
                        <div class="d-flex align-items-center justify-content-end">
                            <div class="me-3">
                                <span class="text-muted">Xin chào,</span>
                                <strong>Nhân viên ${staffName}</strong>
                            </div>
                            <div class="dropdown">
                                <button class="btn btn-outline-primary dropdown-toggle" type="button"
                                    data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle me-2"></i>Tài khoản
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Hồ sơ</a></li>
                                    <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Cài đặt</a>
                                    </li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item" href="#" onclick="logout()"><i
                                                class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ⚠️ Cảnh báo sản phẩm sắp hết -->
            <div id="low-stock-alert"
                class="alert alert-warning d-flex justify-content-between align-items-center mt-3 mx-3"
                style="display: none;">

                <span class="mb-0">
                    ⚠️ Có <span id="low-stock-count"></span> sản phẩm <strong>sắp hết hàng</strong>.
                </span>

                <a href="#inventory" data-tab="inventory" onclick="viewLowStockProducts()"
                    class="btn btn-sm btn-outline-dark ms-3">
                    Xem ngay
                </a>
            </div>


            <!-- Navigation -->
            <div class="staff-nav">
                <ul class="nav nav-pills justify-content-center">
                    <li class="nav-item">
                        <a class="nav-link active" href="#overview" data-tab="overview">
                            <i class="fas fa-chart-line me-2"></i>Tổng quan
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#messages" data-tab="messages">
                            <i class="fas fa-comments me-2"></i>Tin nhắn
                            <span class="notification-dot">5</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#complaints" data-tab="complaints">
                            <i class="fas fa-exclamation-triangle me-2"></i>Khiếu nại
                            <span class="notification-dot">3</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#inventory" data-tab="inventory">
                            <i class="fas fa-boxes me-2"></i>Tồn kho
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#returns" data-tab="returns">
                            <i class="fas fa-undo me-2"></i>Đổi trả
                            <span class="notification-dot">7</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#orders" data-tab="orders">
                            <i class="fas fa-shopping-cart me-2"></i>Đơn hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#support" data-tab="support">
                            <i class="fas fa-life-ring me-2"></i>Hỗ trợ
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Overview Tab -->
            <div id="overview" class="tab-content active">
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card stat-card-1">
                        <div class="icon"><i class="fas fa-comments"></i></div>
                        <div class="number">24</div>
                        <div class="label">Tin nhắn chờ xử lý</div>
                    </div>
                    <div class="stat-card stat-card-2">
                        <div class="icon"><i class="fas fa-exclamation-triangle"></i></div>
                        <div class="number"></div>
                        <div class="label">Khiếu nại mới</div>
                    </div>
                    <div class="stat-card stat-card-3">
                        <div class="icon"><i class="fas fa-undo"></i></div>
                        <div class="number"></div>
                        <div class="label">Yêu cầu đổi trả</div>
                    </div>
                    <div class="stat-card stat-card-4">
                        <div class="icon"><i class="fas fa-check-circle"></i></div>
                        <div class="number"></div>
                        <div class="label">Hoàn thành hôm nay</div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="staff-card">
                            <h5><i class="fas fa-clock me-2 text-primary"></i>Hoạt động gần đây</h5>
                            <div class="activity-list">
                                <div class="activity-item d-flex align-items-center p-3 border-bottom">
                                    <div class="activity-icon bg-primary text-white rounded-circle me-3">
                                        <i class="fas fa-comment"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">Tin nhắn mới từ khách hàng</h6>
                                        <p class="mb-0 text-muted small">Nguyễn Văn A hỏi về sản phẩm RG Strike Freedom
                                        </p>
                                        <small class="text-muted">5 phút trước</small>
                                    </div>
                                </div>
                                <div class="activity-item d-flex align-items-center p-3 border-bottom">
                                    <div class="activity-icon bg-warning text-white rounded-circle me-3">
                                        <i class="fas fa-exclamation"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">Khiếu nại mới</h6>
                                        <p class="mb-0 text-muted small">Sản phẩm bị lỗi trong quá trình vận chuyển</p>
                                        <small class="text-muted">15 phút trước</small>
                                    </div>
                                </div>
                                <div class="activity-item d-flex align-items-center p-3 border-bottom">
                                    <div class="activity-icon bg-info text-white rounded-circle me-3">
                                        <i class="fas fa-undo"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">Yêu cầu đổi trả</h6>
                                        <p class="mb-0 text-muted small">Đơn hàng #12345 yêu cầu đổi size</p>
                                        <small class="text-muted">30 phút trước</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="staff-card">
                            <h5><i class="fas fa-chart-pie me-2 text-primary"></i>Thống kê hôm nay</h5>
                            <div class="chart-container" style="position: relative; height: 200px; width: 100%;">
                                <canvas id="dailyStatsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Messages Tab - Real-time Chat -->
            <div id="messages" class="tab-content">
                <div class="staff-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5><i class="fas fa-comments me-2 text-primary"></i>Chat với khách hàng</h5>
                        <div class="d-flex gap-2">
                            <span id="staff-connection-status" class="badge bg-secondary">Đang kết nối...</span>
                            <button class="btn btn-outline-primary btn-sm" onclick="refreshCustomerList()">
                                <i class="fas fa-sync-alt me-1"></i>Làm mới
                            </button>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Customer List -->
                        <div class="col-lg-4">
                            <div class="customer-list-container">
                                <div class="search-box mb-3">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="customer-search" class="form-control"
                                        placeholder="Tìm kiếm khách hàng...">
                                </div>

                                <div id="customer-list" class="customer-list">
                                    <div class="text-center p-3 text-muted">
                                        <i class="fas fa-users fa-2x mb-2"></i>
                                        <p>Đang tải danh sách khách hàng...</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Chat Area -->
                        <div class="col-lg-8">
                            <div class="chat-area">
                                <!-- Chat Header -->
                                <div id="chat-header" class="chat-header" style="display: none;">
                                    <div class="d-flex align-items-center">
                                        <div class="customer-avatar me-3">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <div>
                                            <h6 class="mb-0" id="selected-customer-name">Chọn khách hàng</h6>
                                            <small class="text-muted" id="selected-customer-email"></small>
                                        </div>
                                    </div>
                                    <div class="chat-status">
                                        <span class="badge bg-success">Online</span>
                                    </div>
                                </div>

                                <!-- Chat Messages -->
                                <div id="staff-chat-messages" class="chat-messages">
                                    <div class="empty-chat">
                                        <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Chọn khách hàng để bắt đầu chat</h5>
                                        <p class="text-muted">Chọn một khách hàng từ danh sách bên trái để bắt đầu hội
                                            thoại</p>
                                    </div>
                                </div>

                                <!-- Chat Input -->
                                <div id="staff-chat-input" class="chat-input" style="display: none;">
                                    <div class="input-group">
                                        <input type="text" id="staff-message-input" class="form-control"
                                            placeholder="Nhập tin nhắn..." disabled>
                                        <button id="staff-send-button" class="btn btn-primary"
                                            onclick="sendStaffMessage()" disabled>
                                            <i class="fas fa-paper-plane"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Complaints Tab -->
            <div id="complaints" class="tab-content">
                <div class="staff-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5><i class="fas fa-exclamation-triangle me-2 text-warning"></i>Xử lý khiếu nại</h5>
                        <select id="complaint-status-filter" class="form-select auto-width">
                            <option value="">Tất cả khiếu nại</option>
                            <option value="PENDING">Chờ xử lý</option>
                            <option value="PROCESSING">Đang xử lý</option>
                            <option value="COMPLETED">Đã hoàn thành</option>
                            <option value="REJECTED">Từ chối</option>
                        </select>
                    </div>

                    <div class="table-responsive table-modern">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã khiếu nại</th>
                                    <th>Khách hàng</th>
                                    <th>Nội dung</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="complaint-table-body">
                                <!-- Dữ liệu sẽ được thêm bằng JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Inventory Tab -->
            <div id="inventory" class="tab-content">
                <div class="staff-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5><i class="fas fa-boxes me-2 text-info"></i>Quản lý tồn kho</h5>
                        <button class="btn btn-primary action-btn" data-bs-toggle="modal"
                            data-bs-target="#inventoryModal">
                            <i class="fas fa-plus me-2"></i>Cập nhật tồn kho
                        </button>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" class="form-control" placeholder="Tìm kiếm sản phẩm...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="category-filter">
                                <option value="">Tất cả danh mục</option>
                                <option value="GUNDAM_BANDAI">GUNDAM_BANDAI</option>
                                <option value="PRE_ORDER">PRE_ORDER</option>
                                <option value="TOOLS_ACCESSORIES">TOOLS_ACCESSORIES</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="status-filter">
                                <option value="">Tất cả trạng thái</option>
                                <option value="Còn hàng">Còn hàng</option>
                                <option value="Sắp hết">Sắp hết</option>
                                <option value="Hết hàng">Hết hàng</option>
                            </select>
                        </div>
                    </div>

                    <div class="table-responsive table-modern">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Hình ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>SKU</th>
                                    <th>Danh mục</th>
                                    <th>Tồn kho</th>
                                    <th>Trạng thái</th>
                                    <th>Giá</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="inventory-body">
                                <!-- Dữ liệu sẽ được tải từ API bằng JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Returns Tab -->
            <div id="returns" class="tab-content">
                <div class="staff-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5><i class="fas fa-undo me-2 text-info"></i>Xử lý đổi trả</h5>
                        <select class="form-select auto-width" id="filter-return-status">
                            <option value="ALL">Tất cả yêu cầu</option>
                            <option value="PROCESSING">Chờ xử lý</option>
                            <option value="COMPLETED">Đã xác nhận</option>
                        </select>
                    </div>

                    <div class="table-responsive table-modern">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Lý do</th>
                                    <th>Trạng thái</th>
                                    <th>Yêu cầu</th>
                                    <th>Ngày yêu cầu</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="returns-table-body">
                                <!-- Nội dung sẽ được render từ JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Modal Chi Tiết Return -->
            <div class="modal fade" id="returnModal" tabindex="-1" aria-labelledby="returnModalLabel"
                aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="returnModalLabel">Chi tiết yêu cầu đổi trả</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                        </div>
                        <div class="modal-body">
                            <p><strong>Mã đơn hàng:</strong> <span id="returnModalOrderNumber"></span></p>
                            <p><strong>Khách hàng:</strong> <span id="returnModalUserId"></span></p>
                            <p><strong>Sản phẩm:</strong> <span id="returnModalProductId"></span></p>
                            <p><strong>Lý do:</strong> <span id="returnModalReason"></span></p>
                            <p><strong>Yêu cầu:</strong> <span id="returnModalRequestType"></span></p>
                            <p><strong>Trạng thái:</strong> <span id="returnModalStatus"></span></p>
                            <p><strong>Ngày yêu cầu:</strong> <span id="returnModalCreatedAt"></span></p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders Tab -->
            <div id="orders" class="tab-content">
                <div class="staff-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5><i class="fas fa-shopping-cart me-2 text-success"></i>Quản lý đơn hàng</h5>
                        <div class="d-flex gap-2">
                            <select id="order-status-filter" class="form-select auto-width"
                                onchange="loadOrdersFromAPI()">
                                <option value="ALL">Tất cả trạng thái</option>
                                <option value="PENDING">Chờ xác nhận</option>
                                <option value="CONFIRMED">Đã xác nhận</option>
                                <option value="SHIPPING">Đang giao</option>
                                <option value="DELIVERED">Hoàn thành</option>
                                <option value="CANCELLED">Đã huỷ</option>
                            </select>
                            <button class="btn btn-primary action-btn" data-bs-toggle="modal"
                                data-bs-target="#orderModal">
                                <i class="fas fa-plus me-2"></i>Tạo đơn hàng
                            </button>
                        </div>
                    </div>

                    <div class="table-responsive table-modern">
                        <table class="table table-hover" id="orders-table">
                            <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đặt</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="orders-body">
                                <!-- Dữ liệu sẽ được render từ JavaScript -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- ✅ Modal: Cập nhật trạng thái đơn hàng -->
                <div class="modal fade" id="updateStatusModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Cập nhật trạng thái đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="update-order-id">
                                <div class="mb-3">
                                    <label for="new-status" class="form-label">Trạng thái mới:</label>
                                    <select class="form-select" id="new-status">
                                        <option value="PENDING">Chờ xác nhận</option>
                                        <option value="CONFIRMED">Đã xác nhận</option>
                                        <option value="SHIPPING">Đang giao</option>
                                        <option value="DELIVERED">Hoàn thành</option>
                                        <option value="CANCELLED">Đã huỷ</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button class="btn btn-primary" onclick="updateOrderStatus()">Lưu thay đổi</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal xem chi tiết đơn hàng -->
                <div class="modal fade" id="orderDetailModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Chi tiết đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div id="order-detail-body">
                                    <!-- JavaScript sẽ render nội dung tại đây -->
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                <button class="btn btn-outline-primary" onclick="printInvoice()">
                                    <i class="fas fa-print me-1"></i> In hóa đơn
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Support Tab -->
            <div id="support" class="tab-content">
                <div class="staff-card">
                    <h5><i class="fas fa-life-ring me-2 text-primary"></i>Hỗ trợ khách hàng</h5>

                    <div class="row">
                        <div class="col-lg-6">
                            <h6><i class="fas fa-question-circle me-2"></i>FAQ Quản lý</h6>
                            <div class="accordion" id="faqAccordion">
                                <div class="accordion-item">
                                    <h2 class="accordion-header">
                                        <button class="accordion-button" type="button" data-bs-toggle="collapse"
                                            data-bs-target="#faq1">
                                            Làm thế nào để xử lý khiếu nại?
                                        </button>
                                    </h2>
                                    <div id="faq1" class="accordion-collapse collapse show"
                                        data-bs-parent="#faqAccordion">
                                        <div class="accordion-body">
                                            1. Đọc kỹ nội dung khiếu nại<br>
                                            2. Liên hệ khách hàng để hiểu rõ vấn đề<br>
                                            3. Đưa ra giải pháp phù hợp<br>
                                            4. Theo dõi và cập nhật trạng thái
                                        </div>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <h2 class="accordion-header">
                                        <button class="accordion-button collapsed" type="button"
                                            data-bs-toggle="collapse" data-bs-target="#faq2">
                                            Quy trình xử lý đổi trả
                                        </button>
                                    </h2>
                                    <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                        <div class="accordion-body">
                                            1. Kiểm tra điều kiện đổi trả<br>
                                            2. Xác minh tình trạng sản phẩm<br>
                                            3. Phê duyệt hoặc từ chối yêu cầu<br>
                                            4. Xử lý hoàn tiền/đổi hàng
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <h6><i class="fas fa-tools me-2"></i>Công cụ hỗ trợ</h6>
                            <div class="list-group">
                                <a href="#" class="list-group-item list-group-item-action">
                                    <i class="fas fa-calculator me-2"></i>Tính toán phí vận chuyển
                                </a>
                                <a href="#" class="list-group-item list-group-item-action">
                                    <i class="fas fa-search me-2"></i>Tra cứu đơn hàng
                                </a>
                                <a href="#" class="list-group-item list-group-item-action">
                                    <i class="fas fa-chart-bar me-2"></i>Báo cáo thống kê
                                </a>
                                <a href="#" class="list-group-item list-group-item-action">
                                    <i class="fas fa-file-export me-2"></i>Xuất dữ liệu
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Update Stock Modal -->
            <div class="modal fade" id="updateStockModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Cập nhật số lượng</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center mb-4">
                                <img id="update-product-image" src="" class="rounded mb-3" alt="Product">
                                <h6 id="update-product-name">Tên sản phẩm</h6>
                                <p class="text-muted">SKU: <span id="update-product-sku">---</span></p>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Số lượng hiện tại</label>
                                <input type="number" class="form-control" id="current-stock" readonly>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số lượng mới</label>
                                <input type="number" class="form-control" id="new-stock"
                                    placeholder="Nhập số lượng mới">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Lý do thay đổi</label>
                                <textarea class="form-control" rows="3" id="update-reason"
                                    placeholder="Nhập lý do..."></textarea>
                            </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button id="btn-update-stock" type="button" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Product Detail Modal -->
            <div class="modal fade" id="productDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-eye me-2"></i>Chi tiết sản phẩm</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-5 text-center">
                                    <img id="detail-product-image" src="" class="img-fluid rounded" alt="Ảnh sản phẩm">
                                </div>
                                <div class="col-md-7">
                                    <h4 id="detail-product-name"></h4>
                                    <p><strong>SKU:</strong> <span id="detail-product-sku"></span></p>
                                    <p><strong>Giá:</strong> <span id="detail-product-price"></span></p>
                                    <p><strong>Danh mục:</strong> <span id="detail-product-category"></span></p>
                                    <p><strong>Grade:</strong> <span id="detail-product-grade"></span></p>
                                    <p><strong>Thương hiệu:</strong> <span id="detail-product-brand"></span></p>
                                    <p><strong>Tồn kho:</strong> <span id="detail-product-stock"></span></p>
                                    <p><strong>Mô tả:</strong><br><span id="detail-product-desc"></span></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <button class="quick-action-btn d-block" title="Tin nhắn nhanh" data-bs-toggle="modal"
                data-bs-target="#quickMessageModal">
                <i class="fas fa-comment"></i>
            </button>
            <button class="quick-action-btn d-block" title="Gọi điện">
                <i class="fas fa-phone"></i>
            </button>
            <button class="quick-action-btn d-block" title="Ghi chú">
                <i class="fas fa-sticky-note"></i>
            </button>
        </div>

        <!-- Modals -->
        <!-- Compose Message Modal -->
        <div class="modal fade modal-modern" id="composeModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Soạn tin nhắn mới</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label class="form-label">Người nhận</label>
                                <input type="email" class="form-control" placeholder="email@example.com">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Tiêu đề</label>
                                <input type="text" class="form-control" placeholder="Nhập tiêu đề...">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nội dung</label>
                                <textarea class="form-control" rows="6"
                                    placeholder="Nhập nội dung tin nhắn..."></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mức độ ưu tiên</label>
                                <select class="form-select">
                                    <option>Bình thường</option>
                                    <option>Cao</option>
                                    <option>Thấp</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Gửi tin nhắn</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Complaint Detail Modal -->
        <div class="modal fade modal-modern" id="complaintModal" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-exclamation-triangle me-2"></i>Chi tiết khiếu nại
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <!-- Thông tin khiếu nại -->
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header">
                                        <h6><i class="fas fa-info-circle me-2"></i>Thông tin khiếu nại</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p><strong>Khách hàng:</strong> <span
                                                        id="complaint-customer-name"></span></p>
                                                <p><strong>Email:</strong> <span id="complaint-email"></span></p>
                                                <p><strong>Điện thoại:</strong> <span id="complaint-phone"></span>
                                                </p>
                                                <p><strong>Đơn hàng:</strong> <span id="complaint-order-number"></span>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Ngày tạo:</strong> <span id="complaint-created-at"></span>
                                                </p>
                                                <p><strong>Lí do:</strong> <span id="complaint-category"></span></p>
                                                <p><strong>Trạng thái:</strong> <span id="complaint-status"></span>
                                                </p>
                                            </div>
                                        </div>
                                        <hr>
                                        <h6>Nội dung khiếu nại:</h6>
                                        <p id="complaint-content"></p>
                                        <!-- Thẻ này thay cho dòng "Hình ảnh/Video đính kèm:" -->
                                        <div class="card mt-3">
                                            <div class="card-header py-2">
                                                <h6 class="mb-0"><i class="fas fa-photo-video me-2"></i>Hình ảnh/Video
                                                    đính kèm</h6>
                                            </div>
                                            <div class="card-body">
                                                <div id="complaint-media-gallery" class="d-flex flex-wrap gap-2">
                                                    <!-- Ảnh/video sẽ được render tại đây -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Phản hồi & xử lý -->
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h6><i class="fas fa-cog me-2"></i>Phản hồi & giải pháp</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label">Giải pháp</label>
                                            <select class="form-select" id="complaint-solution">
                                                <option value="">-- Chọn giải pháp --</option>
                                                <option>Đổi sản phẩm mới</option>
                                                <option>Hoàn tiền</option>
                                                <option>Sửa chữa</option>
                                                <option>Giảm giá đơn hàng tiếp theo</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Phản hồi nhân viên</label>
                                            <textarea class="form-control" id="complaint-staff-response" rows="4"
                                                placeholder="Nhập phản hồi..."></textarea>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-success w-50"
                                                onclick="handleComplaintUpdate('PROCESSING')">
                                                <i class="fas fa-check me-1"></i>Phê duyệt
                                            </button>
                                            <button class="btn btn-danger w-50"
                                                onclick="handleComplaintUpdate('REJECTED')">
                                                <i class="fas fa-times me-1"></i>Từ chối
                                            </button>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <!-- Inventory Update Modal -->
        <div class="modal fade modal-modern" id="inventoryModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Cập nhật tồn kho</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Sản phẩm</label>
                                        <select class="form-select">
                                            <option>Chọn sản phẩm...</option>
                                            <option>RG Strike Freedom Gundam</option>
                                            <option>MG Barbatos</option>
                                            <option>PG Unicorn Gundam</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Loại cập nhật</label>
                                        <select class="form-select">
                                            <option>Nhập kho</option>
                                            <option>Xuất kho</option>
                                            <option>Điều chỉnh</option>
                                            <option>Kiểm kê</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Số lượng</label>
                                        <input type="number" class="form-control" placeholder="0">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Lý do</label>
                                        <select class="form-select">
                                            <option>Nhập hàng mới</option>
                                            <option>Bán hàng</option>
                                            <option>Hàng lỗi</option>
                                            <option>Mất mát</option>
                                            <option>Khác</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ghi chú</label>
                                        <textarea class="form-control" rows="3"
                                            placeholder="Nhập ghi chú..."></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày hiệu lực</label>
                                        <input type="date" class="form-control" value="2024-03-15">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Cập nhật tồn kho</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Return Detail Modal -->
        <div class="modal fade modal-modern" id="returnModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-undo me-2"></i>Chi tiết yêu cầu đổi trả #12345</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header">
                                        <h6><i class="fas fa-shopping-cart me-2"></i>Thông tin đơn hàng</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p><strong>Mã đơn hàng:</strong> #12345</p>
                                                <p><strong>Khách hàng:</strong> Nguyễn Văn A</p>
                                                <p><strong>Email:</strong> customer@email.com</p>
                                                <p><strong>Sản phẩm:</strong> RG Strike Freedom Gundam</p>
                                            </div>
                                            <div class="col-md-6">
                                                <p><strong>Ngày mua:</strong> 10/03/2024</p>
                                                <p><strong>Ngày yêu cầu:</strong> 15/03/2024</p>
                                                <p><strong>Giá trị:</strong> 850,000₫</p>
                                                <p><strong>Trạng thái:</strong> <span
                                                        class="status-badge status-pending">Chờ xử lý</span></p>
                                            </div>
                                        </div>
                                        <hr>
                                        <h6>Lý do đổi trả:</h6>
                                        <p>Sản phẩm bị lỗi khi nhận hàng. Một số chi tiết bị gãy và hộp bị móp méo.
                                        </p>

                                        <h6 class="mt-3">Hình ảnh:</h6>
                                        <div class="d-flex gap-2">
                                            <img src="https://via.placeholder.com/80x80" class="rounded"
                                                alt="Return evidence">
                                            <img src="https://via.placeholder.com/80x80" class="rounded"
                                                alt="Return evidence">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h6><i class="fas fa-cogs me-2"></i>Xử lý yêu cầu</h6>
                                    </div>
                                    <div class="card-body">
                                        <form>
                                            <div class="mb-3">
                                                <label class="form-label">Quyết định</label>
                                                <select class="form-select">
                                                    <option>Chọn quyết định...</option>
                                                    <option>Phê duyệt đổi hàng</option>
                                                    <option>Phê duyệt hoàn tiền</option>
                                                    <option>Từ chối</option>
                                                    <option>Yêu cầu thêm thông tin</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Ghi chú</label>
                                                <textarea class="form-control" rows="4"
                                                    placeholder="Nhập ghi chú xử lý..."></textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Phí xử lý</label>
                                                <input type="number" class="form-control" placeholder="0" value="0">
                                            </div>
                                            <button type="button" class="btn btn-success w-100 mb-2">Phê
                                                duyệt</button>
                                            <button type="button" class="btn btn-danger w-100">Từ chối</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Detail Modal -->
            <div class="modal fade modal-modern" id="orderDetailModal" tabindex="-1">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-shopping-cart me-2"></i>Chi tiết đơn hàng
                                #ORD001</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6><i class="fas fa-list me-2"></i>Sản phẩm trong đơn hàng</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Sản phẩm</th>
                                                            <th>SKU</th>
                                                            <th>Số lượng</th>
                                                            <th>Đơn giá</th>
                                                            <th>Thành tiền</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <img src="https://via.placeholder.com/40x40"
                                                                        class="rounded me-2">
                                                                    <span>RG Strike Freedom Gundam</span>
                                                                </div>
                                                            </td>
                                                            <td>RG-001</td>
                                                            <td>1</td>
                                                            <td>850,000₫</td>
                                                            <td>850,000₫</td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <img src="https://via.placeholder.com/40x40"
                                                                        class="rounded me-2">
                                                                    <span>Gundam Panel Line Marker</span>
                                                                </div>
                                                            </td>
                                                            <td>TOOL-001</td>
                                                            <td>1</td>
                                                            <td>100,000₫</td>
                                                            <td>100,000₫</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <hr>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h6>Thông tin khách hàng:</h6>
                                                    <p><strong>Tên:</strong> Nguyễn Văn A</p>
                                                    <p><strong>Email:</strong> customer@email.com</p>
                                                    <p><strong>Điện thoại:</strong> 0123456789</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <h6>Địa chỉ giao hàng:</h6>
                                                    <p>123 Đường ABC, Quận 1<br>TP. Hồ Chí Minh<br>Việt Nam</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6><i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng</h6>
                                        </div>
                                        <div class="card-body">
                                            <p><strong>Mã đơn hàng:</strong> #ORD001</p>
                                            <p><strong>Ngày đặt:</strong> 15/03/2024</p>
                                            <p><strong>Trạng thái:</strong> <span
                                                    class="status-badge status-pending">Chờ xác nhận</span></p>
                                            <p><strong>Phương thức thanh toán:</strong> COD</p>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <span>Tạm tính:</span>
                                                <span>950,000₫</span>
                                            </div>
                                            <div class="d-flex justify-content-between">
                                                <span>Phí vận chuyển:</span>
                                                <span>0₫</span>
                                            </div>
                                            <div class="d-flex justify-content-between">
                                                <span>Giảm giá:</span>
                                                <span>0₫</span>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <strong>Tổng cộng:</strong>
                                                <strong>950,000₫</strong>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card mt-3">
                                        <div class="card-header">
                                            <h6><i class="fas fa-truck me-2"></i>Cập nhật trạng thái</h6>
                                        </div>
                                        <div class="card-body">
                                            <form>
                                                <div class="mb-3">
                                                    <label class="form-label">Trạng thái mới</label>
                                                    <select class="form-select">
                                                        <option>Chờ xác nhận</option>
                                                        <option>Đã xác nhận</option>
                                                        <option>Đang chuẩn bị</option>
                                                        <option>Đang giao</option>
                                                        <option>Hoàn thành</option>
                                                        <option>Đã hủy</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">Ghi chú</label>
                                                    <textarea class="form-control" rows="3"
                                                        placeholder="Ghi chú cập nhật..."></textarea>
                                                </div>
                                                <button type="button" class="btn btn-primary w-100">Cập nhật trạng
                                                    thái</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Create Order Modal -->
            <div class="modal fade modal-modern" id="orderModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Tạo đơn hàng mới</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-user me-2"></i>Thông tin khách hàng</h6>
                                        <div class="mb-3">
                                            <label class="form-label">Họ tên</label>
                                            <input type="text" class="form-control" placeholder="Nhập họ tên...">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Email</label>
                                            <input type="email" class="form-control" placeholder="email@example.com">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Điện thoại</label>
                                            <input type="tel" class="form-control" placeholder="0123456789">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Địa chỉ</label>
                                            <textarea class="form-control" rows="3"
                                                placeholder="Nhập địa chỉ giao hàng..."></textarea>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-box me-2"></i>Sản phẩm</h6>
                                        <div class="mb-3">
                                            <label class="form-label">Chọn sản phẩm</label>
                                            <select class="form-select">
                                                <option>Chọn sản phẩm...</option>
                                                <option>RG Strike Freedom Gundam - 850,000₫</option>
                                                <option>MG Barbatos - 1,200,000₫</option>
                                                <option>PG Unicorn Gundam - 4,500,000₫</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Số lượng</label>
                                            <input type="number" class="form-control" value="1" min="1">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Phương thức thanh toán</label>
                                            <select class="form-select">
                                                <option>COD (Thanh toán khi nhận hàng)</option>
                                                <option>Chuyển khoản</option>
                                                <option>Ví điện tử</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Ghi chú</label>
                                            <textarea class="form-control" rows="3"
                                                placeholder="Ghi chú đơn hàng..."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary">Tạo đơn hàng</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Message Modal -->
            <div class="modal fade modal-modern" id="quickMessageModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="fas fa-bolt me-2"></i>Tin nhắn nhanh</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="mb-3">
                                    <label class="form-label">Mẫu tin nhắn</label>
                                    <select class="form-select" id="messageTemplate">
                                        <option value="">Chọn mẫu tin nhắn...</option>
                                        <option value="order_confirm">Xác nhận đơn hàng</option>
                                        <option value="shipping_info">Thông tin vận chuyển</option>
                                        <option value="thank_you">Cảm ơn khách hàng</option>
                                        <option value="follow_up">Theo dõi sau bán hàng</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Người nhận</label>
                                    <input type="email" class="form-control" placeholder="email@example.com">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nội dung</label>
                                    <textarea class="form-control" rows="5" id="messageContent"
                                        placeholder="Nhập nội dung tin nhắn..."></textarea>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="button" class="btn btn-primary">Gửi tin nhắn</button>
                        </div>
                    </div>
                </div>
            </div>
        </div> <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="js/staff.js"></script>
        <script src="<%=request.getContextPath()%>/js/auth.js"></script>
        <script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>

        <!-- Chat WebSocket Scripts -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

        <style>
            /* Staff Chat Styles */
            .customer-list-container {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                height: 500px;
                overflow: hidden;
            }

            .customer-list {
                height: calc(100% - 60px);
                overflow-y: auto;
            }

            .customer-item {
                padding: 12px 15px;
                border-bottom: 1px solid #f0f0f0;
                cursor: pointer;
                transition: all 0.2s ease;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .customer-item:hover {
                background-color: #f8f9fa;
            }

            .customer-item.active {
                background-color: #007bff;
                color: white;
            }

            .customer-item.active .text-muted {
                color: rgba(255, 255, 255, 0.8) !important;
            }

            .customer-avatar {
                width: 40px;
                height: 40px;
                background: #007bff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                flex-shrink: 0;
            }

            .customer-item.active .customer-avatar {
                background: rgba(255, 255, 255, 0.2);
            }

            .customer-info {
                flex: 1;
                min-width: 0;
            }

            .customer-info h6 {
                margin: 0;
                font-size: 14px;
                font-weight: 600;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .customer-info small {
                font-size: 12px;
                opacity: 0.8;
            }

            .unread-indicator {
                width: 8px;
                height: 8px;
                background: #dc3545;
                border-radius: 50%;
                flex-shrink: 0;
            }

            .chat-area {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                height: 500px;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .chat-header {
                padding: 15px 20px;
                border-bottom: 1px solid #e0e0e0;
                background: #f8f9fa;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-messages {
                flex: 1;
                padding: 15px;
                overflow-y: auto;
                overflow-x: hidden;
                background: #fafafa;
                max-height: 350px;
                scroll-behavior: smooth;
            }

            /* Custom scrollbar cho staff chat */
            .chat-messages::-webkit-scrollbar {
                width: 8px;
            }

            .chat-messages::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            .chat-messages::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 4px;
            }

            .chat-messages::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }

            .chat-messages::after {
                content: "";
                display: table;
                clear: both;
            }

            .empty-chat {
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                text-align: center;
            }

            .staff-message {
                margin-bottom: 15px;
                display: flex;
                gap: 10px;
                width: 100%;
            }

            .staff-message.sent {
                flex-direction: row-reverse;
            }

            .staff-message.sent .message-bubble {
                background: #007bff;
                color: white;
                border-radius: 18px 18px 4px 18px;
                float: right;
                clear: both;
            }

            .staff-message.received .message-bubble {
                background: white;
                color: #333;
                border: 1px solid #e0e0e0;
                border-radius: 18px 18px 18px 4px;
                float: left;
                clear: both;
            }

            .message-bubble {
                max-width: 85%;
                padding: 12px 16px;
                word-wrap: break-word;
                word-break: break-word;
                overflow-wrap: break-word;
                white-space: pre-wrap;
                font-size: 14px;
                line-height: 1.4;
                display: inline-block;
            }

            .message-time {
                font-size: 11px;
                color: #999;
                margin-top: 6px;
                text-align: center;
                font-style: italic;
                opacity: 0.7;
            }

            .chat-input {
                padding: 15px 20px;
                border-top: 1px solid #e0e0e0;
                background: white;
            }

            .chat-input .input-group {
                gap: 10px;
            }

            .chat-input input {
                border-radius: 20px;
                border: 1px solid #ddd;
                padding: 10px 15px;
            }

            .chat-input button {
                border-radius: 50%;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            #staff-connection-status.bg-success {
                background-color: #28a745 !important;
            }

            #staff-connection-status.bg-warning {
                background-color: #ffc107 !important;
                color: #212529 !important;
            }

            #staff-connection-status.bg-danger {
                background-color: #dc3545 !important;
            }
        </style>

        <script>
            let staffStompClient = null;
            let staffCurrentUserId = null;
            let staffCurrentUserType = 'STAFF';
            let selectedCustomerId = null;
            let customerListData = [];

            // Khởi tạo staff chat
            function initStaffChat(userId, userType) {
                staffCurrentUserId = userId;
                staffCurrentUserType = userType;

                if (userType === 'STAFF') {
                    connectStaffChat();
                    loadCustomerList();
                }
            }

            // Kết nối WebSocket cho staff
            function connectStaffChat() {
                const statusElement = document.getElementById('staff-connection-status');
                statusElement.textContent = 'Đang kết nối...';
                statusElement.className = 'badge bg-warning';

                console.log('🔌 Connecting staff chat WebSocket for user:', staffCurrentUserId);

                const socket = new SockJS('/ws-chat');
                staffStompClient = Stomp.over(socket);

                staffStompClient.connect({}, function (frame) {
                    console.log('✅ Staff chat connected:', frame);

                    // Subscribe để nhận tin nhắn
                    const subscriptionUrl = '/user/' + staffCurrentUserId + '/queue/messages';
                    console.log('📡 Subscribing to:', subscriptionUrl);

                    staffStompClient.subscribe(subscriptionUrl, function (message) {
                        console.log('📩 Staff received message:', message.body);
                        const messageData = JSON.parse(message.body);
                        handleStaffIncomingMessage(messageData);
                    });

                    // Cập nhật trạng thái kết nối
                    statusElement.textContent = 'Đã kết nối';
                    statusElement.className = 'badge bg-success';

                    // Enable input nếu đã chọn customer
                    if (selectedCustomerId) {
                        enableStaffInput();
                    }

                }, function (error) {
                    console.error('❌ Staff chat connection error:', error);
                    statusElement.textContent = 'Mất kết nối';
                    statusElement.className = 'badge bg-danger';
                });
            }

            // Load danh sách customer
            function loadCustomerList() {
                console.log('🔍 Loading customer list...');
                fetch('/api/chat/customers')
                    .then(response => {
                        console.log('📡 Customer API response status:', response.status);
                        return response.json();
                    })
                    .then(customers => {
                        console.log('👥 Customers received:', customers);
                        customerListData = customers;
                        displayCustomerList(customers);
                    })
                    .catch(error => {
                        console.error('❌ Error loading customers:', error);
                        document.getElementById('customer-list').innerHTML = `
                                <div class="text-center p-3 text-danger">
                                    <i class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                                    <p>Không thể tải danh sách khách hàng</p>
                                    <small>Error: ${error.message}</small>
                                </div>
                            `;
                    });
            }

            // Hiển thị danh sách customer
            function displayCustomerList(customers) {
                const listContainer = document.getElementById('customer-list');

                if (customers.length === 0) {
                    listContainer.innerHTML = `
                            <div class="text-center p-3 text-muted">
                                <i class="fas fa-users fa-2x mb-2"></i>
                                <p>Chưa có khách hàng nào</p>
                            </div>
                        `;
                    return;
                }

                listContainer.innerHTML = customers.map(customer =>
                    '<div class="customer-item" onclick="selectCustomer(' + customer.id + ', \'' + customer.fullName + '\', \'' + customer.email + '\')">' +
                    '<div class="customer-avatar">' +
                    '<i class="fas fa-user"></i>' +
                    '</div>' +
                    '<div class="customer-info">' +
                    '<h6>' + customer.fullName + '</h6>' +
                    '<small class="text-muted">' + customer.email + '</small>' +
                    '</div>' +
                    '</div>'
                ).join('');
            }

            // Chọn customer để chat
            function selectCustomer(customerId, customerName, customerEmail) {
                // Remove active class from all items
                document.querySelectorAll('.customer-item').forEach(item => {
                    item.classList.remove('active');
                });

                // Add active class to selected item
                event.currentTarget.classList.add('active');

                selectedCustomerId = customerId;

                // Update chat header
                document.getElementById('selected-customer-name').textContent = customerName;
                document.getElementById('selected-customer-email').textContent = customerEmail;
                document.getElementById('chat-header').style.display = 'flex';
                document.getElementById('staff-chat-input').style.display = 'block';

                // Clear messages and load history
                const messagesContainer = document.getElementById('staff-chat-messages');
                messagesContainer.innerHTML = '';

                // Enable input if connected
                if (staffStompClient && staffStompClient.connected) {
                    enableStaffInput();
                }

                // Load chat history for this customer (from any staff)
                loadCustomerChatHistory(customerId);
            }

            // Load lịch sử chat của customer với bất kỳ staff nào
            function loadCustomerChatHistory(customerId) {
                console.log('📚 Loading chat history for customer:', customerId);
                fetch('/api/chat/customer-messages/' + customerId)
                    .then(response => response.json())
                    .then(messages => {
                        console.log('📝 Customer chat history loaded:', messages.length, 'messages');
                        messages.forEach(message => {
                            displayStaffMessage(message, false);
                        });
                        scrollStaffChatToBottom();
                    })
                    .catch(error => {
                        console.error('❌ Error loading customer chat history:', error);
                    });
            }

            // Hiển thị tin nhắn trong staff chat
            function displayStaffMessage(message, isNew = true) {
                const messagesContainer = document.getElementById('staff-chat-messages');
                const messageWrapper = document.createElement('div');
                messageWrapper.style.width = '100%';
                messageWrapper.style.marginBottom = '10px';
                messageWrapper.style.display = 'block';

                const messageDiv = document.createElement('div');

                const isSent = message.senderId == staffCurrentUserId;
                messageDiv.className = 'staff-message ' + (isSent ? 'sent' : 'received');

                const avatar = isSent ? `
                        <div class="customer-avatar" style="background: #28a745;">
                            <i class="fas fa-user-tie"></i>
                        </div>
                    ` : `
                        <div class="customer-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                    `;

                // Escape HTML và xử lý text properly
                const messageText = escapeStaffHtml(message.message);
                const formattedTime = new Date(message.timestamp).toLocaleTimeString('vi-VN', {
                    hour: '2-digit',
                    minute: '2-digit'
                });

                messageDiv.innerHTML = `
                        ` + avatar + `
                        <div>
                            <div class="message-bubble">
                                <div style="word-break: break-word; overflow-wrap: break-word; hyphens: none;">` + messageText + `</div>
                            </div>
                            <div class="message-time">
                                ` + formattedTime + `
                                ` + (isSent && message.isRead ? ' ✓✓' : '') + `
                            </div>
                        </div>
                    `;

                messageWrapper.appendChild(messageDiv);
                messagesContainer.appendChild(messageWrapper);

                if (isNew) {
                    scrollStaffChatToBottom();
                }
            }

            // Helper function để escape HTML cho staff
            function escapeStaffHtml(unsafe) {
                if (!unsafe) return '';
                return unsafe
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#039;");
            }

            // Gửi tin nhắn từ staff
            function sendStaffMessage() {
                const input = document.getElementById('staff-message-input');
                const message = input.value.trim();

                if (message && staffStompClient && selectedCustomerId) {
                    const messageData = {
                        senderId: staffCurrentUserId,
                        receiverId: selectedCustomerId,
                        message: message,
                        senderType: 'STAFF',
                        receiverType: 'CUSTOMER'
                    };

                    // Temporarily disable button và clear input
                    const sendButton = document.getElementById('staff-send-button');
                    sendButton.disabled = true;
                    input.value = '';

                    staffStompClient.send("/app/chat.sendMessage", {}, JSON.stringify(messageData));

                    // Hiển thị tin nhắn vừa gửi lên UI ngay lập tức
                    displayStaffMessage({
                        senderId: staffCurrentUserId,
                        message: message,
                        timestamp: new Date()
                    }, true);

                    // Re-enable button sau 1 giây
                    setTimeout(() => {
                        sendButton.disabled = false;
                    }, 1000);
                }
            }

            // Xử lý tin nhắn đến cho staff
            function handleStaffIncomingMessage(messageData) {
                // Nếu đang chat với customer này, hiển thị tin nhắn
                if (selectedCustomerId && messageData.senderId == selectedCustomerId) {
                    displayStaffMessage(messageData);
                }

                // Update notification badge if needed
                // This could be enhanced to show unread count per customer
            }

            // Enable staff input
            function enableStaffInput() {
                document.getElementById('staff-message-input').disabled = false;
                document.getElementById('staff-send-button').disabled = false;
            }

            // Refresh customer list
            function refreshCustomerList() {
                loadCustomerList();
            }

            // Scroll to bottom
            function scrollStaffChatToBottom() {
                const messagesContainer = document.getElementById('staff-chat-messages');
                if (messagesContainer) {
                    const scrollHeight = messagesContainer.scrollHeight;
                    const height = messagesContainer.clientHeight;
                    const maxScrollTop = scrollHeight - height;

                    // Smooth scroll animation
                    messagesContainer.scrollTo({
                        top: maxScrollTop,
                        behavior: 'smooth'
                    });

                    // Fallback for older browsers
                    setTimeout(() => {
                        messagesContainer.scrollTop = maxScrollTop;
                    }, 100);
                }
            }

            // Search customers
            document.addEventListener('DOMContentLoaded', function () {
                const searchInput = document.getElementById('customer-search');
                if (searchInput) {
                    searchInput.addEventListener('input', function (e) {
                        const searchTerm = e.target.value.toLowerCase();
                        const filteredCustomers = customerListData.filter(customer =>
                            customer.fullName.toLowerCase().includes(searchTerm) ||
                            customer.email.toLowerCase().includes(searchTerm)
                        );
                        displayCustomerList(filteredCustomers);
                    });
                }

                // Enter to send message
                const messageInput = document.getElementById('staff-message-input');
                if (messageInput) {
                    messageInput.addEventListener('keypress', function (e) {
                        if (e.key === 'Enter') {
                            sendStaffMessage();
                        }
                    });
                }
            });
        </script>

        <script>
            // Staff logout function using enhanced logout system
            function logout() {
                console.log('🚪 Staff logout initiated');
                
                // Use the enhanced logout from unified-navbar-manager.js
                if (typeof handleLogout === 'function') {
                    handleLogout();
                } else {
                    // Fallback if unified logout not available
                    console.log('⚠️ Unified logout not available, using fallback');
                    
                    // Clear all client-side data
                    localStorage.clear();
                    sessionStorage.clear();
                    
                    // Clear cookies
                    document.cookie.split(";").forEach(function(c) { 
                        document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
                    });
                    
                    // Logout from server and redirect
                    fetch('<%=request.getContextPath()%>/logout', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        }
                    }).then(() => {
                        window.location.href = '<%=request.getContextPath()%>/index.jsp?logout=1&t=' + Date.now();
                    }).catch(() => {
                        // Force redirect even if logout fails
                        window.location.href = '<%=request.getContextPath()%>/index.jsp?logout=1&t=' + Date.now();
                    });
                }
            }

            // Check staff access on page load and initialize chat
            document.addEventListener('DOMContentLoaded', function () {
                checkPageAccess('STAFF');

                // Initialize staff chat with Staff Member (ID: 8) from session
                console.log('🔍 Initializing staff chat for logged in staff...');

                // Staff info from login session: Staff Member (staff@gundam.com) - ID: 8
                const staffUserId = 8; // Staff Member ID from database
                const staffUserType = 'STAFF';

                // Set sessionStorage for consistency
                sessionStorage.setItem('userId', staffUserId.toString());
                sessionStorage.setItem('userType', staffUserType);
                sessionStorage.setItem('userName', 'Staff Member');
                sessionStorage.setItem('userEmail', 'staff@gundam.com');

                console.log('✅ Staff session set:', {
                    userId: staffUserId,
                    userType: staffUserType,
                    userName: 'Staff Member',
                    userEmail: 'staff@gundam.com'
                });

                // Initialize staff chat
                initStaffChat(staffUserId, staffUserType);
                console.log('✅ Staff chat initialized with ID:', staffUserId);
            });
        </script>
    </body>

    </html>