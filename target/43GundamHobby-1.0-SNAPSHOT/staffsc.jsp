<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - 43 Gundam Hobby</title>
      <!-- CSS Files -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
                            <button class="btn btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-2"></i>Tài khoản
                            </button>                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Hồ sơ</a></li>
                                <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Cài đặt</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
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
                    <div class="number">8</div>
                    <div class="label">Khiếu nại mới</div>
                </div>
                <div class="stat-card stat-card-3">
                    <div class="icon"><i class="fas fa-undo"></i></div>
                    <div class="number">15</div>
                    <div class="label">Yêu cầu đổi trả</div>
                </div>
                <div class="stat-card stat-card-4">
                    <div class="icon"><i class="fas fa-check-circle"></i></div>
                    <div class="number">156</div>
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
                                    <p class="mb-0 text-muted small">Nguyễn Văn A hỏi về sản phẩm RG Strike Freedom</p>
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
                </div>                <div class="col-lg-4">
                    <div class="staff-card">
                        <h5><i class="fas fa-chart-pie me-2 text-primary"></i>Thống kê hôm nay</h5>
                        <div class="chart-container">
                            <canvas id="dailyStatsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Messages Tab -->
        <div id="messages" class="tab-content">
            <div class="staff-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5><i class="fas fa-comments me-2 text-primary"></i>Quản lý tin nhắn khách hàng</h5>
                    <button class="btn btn-primary action-btn" data-bs-toggle="modal" data-bs-target="#composeModal">
                        <i class="fas fa-plus me-2"></i>Soạn tin nhắn
                    </button>
                </div>

                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" class="form-control" placeholder="Tìm kiếm tin nhắn theo tên khách hàng, email...">
                </div>

                <div class="message-item">
                    <div class="message-header">
                        <div>
                            <h6 class="mb-1">Nguyễn Văn A</h6>
                            <small class="text-muted">customer@email.com</small>
                        </div>
                        <div>
                            <span class="message-priority priority-high">Ưu tiên cao</span>
                            <small class="text-muted ms-2">10:30 AM</small>
                        </div>
                    </div>
                    <p class="mb-3">Xin chào, tôi muốn hỏi về sản phẩm RG Strike Freedom Gundam. Sản phẩm này có còn hàng không ạ?</p>
                    <div class="d-flex gap-2">
                        <button class="btn btn-reply action-btn">
                            <i class="fas fa-reply me-2"></i>Trả lời
                        </button>
                        <button class="btn btn-close action-btn">
                            <i class="fas fa-check me-2"></i>Đóng
                        </button>
                    </div>
                </div>

                <div class="message-item">
                    <div class="message-header">
                        <div>
                            <h6 class="mb-1">Trần Thị B</h6>
                            <small class="text-muted">customer2@email.com</small>
                        </div>
                        <div>
                            <span class="message-priority priority-medium">Bình thường</span>
                            <small class="text-muted ms-2">09:15 AM</small>
                        </div>
                    </div>
                    <p class="mb-3">Đơn hàng của tôi đã được giao chưa? Mã đơn hàng là #12345.</p>
                    <div class="d-flex gap-2">
                        <button class="btn btn-reply action-btn">
                            <i class="fas fa-reply me-2"></i>Trả lời
                        </button>
                        <button class="btn btn-close action-btn">
                            <i class="fas fa-check me-2"></i>Đóng
                        </button>
                    </div>
                </div>

                <div class="message-item">
                    <div class="message-header">
                        <div>
                            <h6 class="mb-1">Lê Văn C</h6>
                            <small class="text-muted">customer3@email.com</small>
                        </div>
                        <div>
                            <span class="message-priority priority-low">Thấp</span>
                            <small class="text-muted ms-2">08:45 AM</small>
                        </div>
                    </div>
                    <p class="mb-3">Cảm ơn shop đã hỗ trợ tôi. Sản phẩm rất chất lượng!</p>
                    <div class="d-flex gap-2">
                        <button class="btn btn-reply action-btn">
                            <i class="fas fa-reply me-2"></i>Trả lời
                        </button>
                        <button class="btn btn-close action-btn">
                            <i class="fas fa-check me-2"></i>Đóng
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Complaints Tab -->
        <div id="complaints" class="tab-content">
            <div class="staff-card">                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5><i class="fas fa-exclamation-triangle me-2 text-warning"></i>Xử lý khiếu nại</h5>
                    <select class="form-select auto-width">
                        <option>Tất cả khiếu nại</option>
                        <option>Chờ xử lý</option>
                        <option>Đang xử lý</option>
                        <option>Đã hoàn thành</option>
                    </select>
                </div>

                <div class="table-responsive table-modern">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Mã khiếu nại</th>
                                <th>Khách hàng</th>
                                <th>Nội dung</th>
                                <th>Mức độ</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>#CP001</strong></td>
                                <td>Nguyễn Văn A</td>
                                <td>Sản phẩm bị lỗi khi nhận hàng</td>
                                <td><span class="message-priority priority-high">Cao</span></td>
                                <td><span class="status-badge status-pending">Chờ xử lý</span></td>
                                <td>15/03/2024</td>
                                <td>
                                    <button class="btn btn-sm btn-primary me-1" data-bs-toggle="modal" data-bs-target="#complaintModal">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-success">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#CP002</strong></td>
                                <td>Trần Thị B</td>
                                <td>Giao hàng chậm trễ</td>
                                <td><span class="message-priority priority-medium">Trung bình</span></td>
                                <td><span class="status-badge status-processing">Đang xử lý</span></td>
                                <td>14/03/2024</td>
                                <td>
                                    <button class="btn btn-sm btn-primary me-1" data-bs-toggle="modal" data-bs-target="#complaintModal">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-success">
                                        <i class="fas fa-check"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#CP003</strong></td>
                                <td>Lê Văn C</td>
                                <td>Sai thông tin sản phẩm</td>
                                <td><span class="message-priority priority-low">Thấp</span></td>
                                <td><span class="status-badge status-completed">Hoàn thành</span></td>
                                <td>13/03/2024</td>
                                <td>
                                    <button class="btn btn-sm btn-primary me-1" data-bs-toggle="modal" data-bs-target="#complaintModal">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn btn-sm btn-secondary" disabled>
                                        <i class="fas fa-check"></i>
                                    </button>
                                </td>
                            </tr>
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
                    <button class="btn btn-primary action-btn" data-bs-toggle="modal" data-bs-target="#inventoryModal">
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
                        <select class="form-select">
                            <option>Tất cả danh mục</option>
                            <option>Real Grade</option>
                            <option>Master Grade</option>
                            <option>Perfect Grade</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>Tất cả trạng thái</option>
                            <option>Còn hàng</option>
                            <option>Sắp hết</option>
                            <option>Hết hàng</option>
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
                        <tbody>
                            <tr>
                                <td>
                                    <img src="https://via.placeholder.com/50x50" alt="Product" class="rounded">
                                </td>
                                <td>
                                    <strong>RG Strike Freedom Gundam</strong><br>
                                    <small class="text-muted">Bandai</small>
                                </td>
                                <td>RG-001</td>
                                <td>Real Grade</td>
                                <td><strong>25</strong></td>
                                <td><span class="status-badge status-completed">Còn hàng</span></td>
                                <td>850,000₫</td>
                                <td>
                                    <button class="btn btn-sm btn-warning me-1" data-bs-toggle="modal" data-bs-target="#updateStockModal">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-info">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="https://via.placeholder.com/50x50" alt="Product" class="rounded">
                                </td>
                                <td>
                                    <strong>MG Barbatos</strong><br>
                                    <small class="text-muted">Bandai</small>
                                </td>
                                <td>MG-002</td>
                                <td>Master Grade</td>
                                <td><strong>5</strong></td>
                                <td><span class="status-badge status-pending">Sắp hết</span></td>
                                <td>1,200,000₫</td>
                                <td>
                                    <button class="btn btn-sm btn-warning me-1" data-bs-toggle="modal" data-bs-target="#updateStockModal">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-info">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <img src="https://via.placeholder.com/50x50" alt="Product" class="rounded">
                                </td>
                                <td>
                                    <strong>PG Unicorn Gundam</strong><br>
                                    <small class="text-muted">Bandai</small>
                                </td>
                                <td>PG-003</td>
                                <td>Perfect Grade</td>
                                <td><strong>0</strong></td>
                                <td><span class="status-badge status-rejected">Hết hàng</span></td>
                                <td>4,500,000₫</td>
                                <td>
                                    <button class="btn btn-sm btn-warning me-1" data-bs-toggle="modal" data-bs-target="#updateStockModal">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn btn-sm btn-info">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </td>
                            </tr>
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
<div class="modal fade" id="returnModal" tabindex="-1" aria-labelledby="returnModalLabel" aria-hidden="true">
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
                <select id="order-status-filter" class="form-select auto-width" onchange="loadOrdersFromAPI()">
                    <option value="ALL">Tất cả trạng thái</option>
                    <option value="PENDING">Chờ xác nhận</option>
                    <option value="CONFIRMED">Đã xác nhận</option>
                    <option value="SHIPPING">Đang giao</option>
                    <option value="DELIVERED">Hoàn thành</option>
                    <option value="CANCELLED">Đã huỷ</option>
                </select>
                <button class="btn btn-primary action-btn" data-bs-toggle="modal" data-bs-target="#orderModal">
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
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                                        Làm thế nào để xử lý khiếu nại?
                                    </button>
                                </h2>
                                <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
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
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
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
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <button class="quick-action-btn d-block" title="Tin nhắn nhanh" data-bs-toggle="modal" data-bs-target="#quickMessageModal">
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
                            <textarea class="form-control" rows="6" placeholder="Nhập nội dung tin nhắn..."></textarea>
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
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Chi tiết khiếu nại #CP001</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h6><i class="fas fa-info-circle me-2"></i>Thông tin khiếu nại</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Khách hàng:</strong> Nguyễn Văn A</p>
                                            <p><strong>Email:</strong> customer@email.com</p>
                                            <p><strong>Điện thoại:</strong> 0123456789</p>
                                            <p><strong>Đơn hàng:</strong> #12345</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Ngày tạo:</strong> 15/03/2024 10:30</p>
                                            <p><strong>Mức độ:</strong> <span class="message-priority priority-high">Cao</span></p>
                                            <p><strong>Danh mục:</strong> Sản phẩm lỗi</p>
                                            <p><strong>Trạng thái:</strong> <span class="status-badge status-pending">Chờ xử lý</span></p>
                                        </div>
                                    </div>
                                    <hr>
                                    <h6>Nội dung khiếu nại:</h6>
                                    <p>Tôi đã nhận được sản phẩm RG Strike Freedom Gundam nhưng khi mở hộp phát hiện một số chi tiết bị gãy và thiếu sticker. Tôi đã rất cẩn thận khi mở hộp và chắc chắn đây là lỗi từ quá trình sản xuất hoặc vận chuyển. Tôi mong shop có thể hỗ trợ đổi sản phẩm mới.</p>
                                    
                                    <h6 class="mt-3">Hình ảnh đính kèm:</h6>
                                    <div class="d-flex gap-2">
                                        <img src="https://via.placeholder.com/100x100" class="rounded" alt="Evidence 1">
                                        <img src="https://via.placeholder.com/100x100" class="rounded" alt="Evidence 2">
                                        <img src="https://via.placeholder.com/100x100" class="rounded" alt="Evidence 3">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6><i class="fas fa-history me-2"></i>Lịch sử xử lý</h6>
                                </div>
                                <div class="card-body">
                                    <div class="timeline">
                                        <div class="timeline-item">
                                            <div class="timeline-marker bg-primary"></div>
                                            <div class="timeline-content">
                                                <h6>Khiếu nại được tạo</h6>
                                                <p class="small text-muted">15/03/2024 10:30</p>
                                                <p class="small">Khách hàng gửi khiếu nại về sản phẩm bị lỗi</p>
                                            </div>
                                        </div>
                                        <div class="timeline-item">
                                            <div class="timeline-marker bg-info"></div>
                                            <div class="timeline-content">
                                                <h6>Đã tiếp nhận</h6>
                                                <p class="small text-muted">15/03/2024 11:00</p>
                                                <p class="small">Nhân viên A đã tiếp nhận và bắt đầu xử lý</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="card mt-3">
                                <div class="card-header">
                                    <h6><i class="fas fa-cog me-2"></i>Hành động</h6>
                                </div>
                                <div class="card-body">
                                    <form>
                                        <div class="mb-3">
                                            <label class="form-label">Trạng thái</label>
                                            <select class="form-select">
                                                <option>Chờ xử lý</option>
                                                <option>Đang xử lý</option>
                                                <option>Đã giải quyết</option>
                                                <option>Từ chối</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Phản hồi</label>
                                            <textarea class="form-control" rows="4" placeholder="Nhập phản hồi cho khách hàng..."></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Giải pháp</label>
                                            <select class="form-select">
                                                <option>Đổi sản phẩm mới</option>
                                                <option>Hoàn tiền</option>
                                                <option>Sửa chữa</option>
                                                <option>Giảm giá đơn hàng tiếp theo</option>
                                            </select>
                                        </div>
                                        <button type="button" class="btn btn-primary w-100">Cập nhật</button>
                                    </form>
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
                                    <textarea class="form-control" rows="3" placeholder="Nhập ghi chú..."></textarea>
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

    <!-- Update Stock Modal -->
    <div class="modal fade modal-modern" id="updateStockModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Cập nhật số lượng</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <img src="https://via.placeholder.com/100x100" class="rounded mb-3" alt="Product">
                        <h6>RG Strike Freedom Gundam</h6>
                        <p class="text-muted">SKU: RG-001</p>
                    </div>
                    <form>
                        <div class="mb-3">
                            <label class="form-label">Số lượng hiện tại</label>
                            <input type="number" class="form-control" value="25" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số lượng mới</label>
                            <input type="number" class="form-control" placeholder="Nhập số lượng mới">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Lý do thay đổi</label>
                            <textarea class="form-control" rows="3" placeholder="Nhập lý do..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">Cập nhật</button>
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
                                            <p><strong>Trạng thái:</strong> <span class="status-badge status-pending">Chờ xử lý</span></p>
                                        </div>
                                    </div>
                                    <hr>
                                    <h6>Lý do đổi trả:</h6>
                                    <p>Sản phẩm bị lỗi khi nhận hàng. Một số chi tiết bị gãy và hộp bị móp méo.</p>
                                    
                                    <h6 class="mt-3">Hình ảnh:</h6>
                                    <div class="d-flex gap-2">
                                        <img src="https://via.placeholder.com/80x80" class="rounded" alt="Return evidence">
                                        <img src="https://via.placeholder.com/80x80" class="rounded" alt="Return evidence">
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
                                            <textarea class="form-control" rows="4" placeholder="Nhập ghi chú xử lý..."></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Phí xử lý</label>
                                            <input type="number" class="form-control" placeholder="0" value="0">
                                        </div>
                                        <button type="button" class="btn btn-success w-100 mb-2">Phê duyệt</button>
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
                        <h5 class="modal-title"><i class="fas fa-shopping-cart me-2"></i>Chi tiết đơn hàng #ORD001</h5>
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
                                                                <img src="https://via.placeholder.com/40x40" class="rounded me-2">
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
                                                                <img src="https://via.placeholder.com/40x40" class="rounded me-2">
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
                                        <p><strong>Trạng thái:</strong> <span class="status-badge status-pending">Chờ xác nhận</span></p>
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
                                                <textarea class="form-control" rows="3" placeholder="Ghi chú cập nhật..."></textarea>
                                            </div>
                                            <button type="button" class="btn btn-primary w-100">Cập nhật trạng thái</button>
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
                                        <textarea class="form-control" rows="3" placeholder="Nhập địa chỉ giao hàng..."></textarea>
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
                                        <textarea class="form-control" rows="3" placeholder="Ghi chú đơn hàng..."></textarea>
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
                            <textarea class="form-control" rows="5" id="messageContent" placeholder="Nhập nội dung tin nhắn..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">Gửi tin nhắn</button>
                </div>
            </div>
        </div>
    </div>    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="js/staff.js"></script>
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    
    <script>
        // Check staff access on page load
        document.addEventListener('DOMContentLoaded', function() {
            checkPageAccess('STAFF');
        });
    </script>
    <script src="js/staff.js"></script>
</body>
</html>

