<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipper Dashboard - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
    <link href="css/shipper-styles.css" rel="stylesheet">
</head>
<body class="shipper-body">
    <div class="shipper-container">
        <!-- Header -->
        <div class="shipper-header">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="mb-0"><i class="fas fa-truck text-success me-3"></i>Shipper Dashboard</h1>
                    <p class="mb-0 text-muted">Quản lý đơn hàng giao nhận</p>
                </div>
                <div class="col-md-6 text-end">
                    <div class="d-flex align-items-center justify-content-end">
                        <div class="me-3">
                            <span class="text-muted">Xin chào,</span>
                            <strong>Shipper ${shipperName}</strong>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-outline-success dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle me-2"></i>Tài khoản
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Hồ sơ</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Dashboard Stats -->
        <div class="row mt-4 mb-4" id="stats-cards">
            <div class="col-md-3 mb-3">
                <div class="stat-card stat-card-pending">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="stat-pending">0</h3>
                        <p class="stat-label">Chờ xử lý</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card stat-card-shipping">
                    <div class="stat-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="stat-shipping">0</h3>
                        <p class="stat-label">Đang giao</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card stat-card-delivered">
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="stat-delivered">0</h3>
                        <p class="stat-label">Đã giao</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stat-card stat-card-cancelled">
                    <div class="stat-icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-content">
                        <h3 class="stat-number" id="stat-cancelled">0</h3>
                        <p class="stat-label">Đã hủy</p>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Orders Table -->
        <div class="shipper-card mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h5><i class="fas fa-truck-moving me-2 text-success"></i>Đơn hàng cần giao</h5>
                    <div class="d-flex align-items-center mt-1">
                        <span class="location-badge me-2">
                            <i class="fas fa-map-marker-alt me-1"></i>
                            Khu vực Đà Nẵng
                        </span>
                        <small class="text-muted">Cập nhật realtime</small>
                    </div>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <button class="btn refresh-btn btn-sm" onclick="fetchShippingOrders()" title="Làm mới">
                        <i class="fas fa-sync-alt"></i>
                    </button>
                    <select id="order-status-filter" class="form-select form-select-sm" style="min-width:150px">
                        <option value="ALL">🔄 Tất cả</option>
                        <option value="PENDING">⏳ Chờ giao</option>
                        <option value="SHIPPING">🚚 Đang giao</option>
                        <option value="DELIVERED">✅ Đã giao</option>
                        <option value="CANCELLED">❌ Hủy giao</option>
                    </select>
                </div>
            </div>
            <div class="shipper-table table-responsive">
                <table class="table table-hover table-striped">
                    <thead class="table-success">
                        <tr>
                            <th><i class="fas fa-hashtag me-1"></i>Mã đơn hàng</th>
                            <th><i class="fas fa-user me-1"></i>Khách hàng</th>
                            <th><i class="fas fa-map-marker-alt me-1"></i>Địa chỉ giao</th>
                            <th><i class="fas fa-phone me-1"></i>Số điện thoại</th>
                            <th><i class="fas fa-info-circle me-1"></i>Trạng thái</th>
                            <th><i class="fas fa-calendar me-1"></i>Ngày giao</th>
                            <th><i class="fas fa-cogs me-1"></i>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="orders-table-body">
                        <!-- Dữ liệu shipping sẽ được render từ js/shipper.js -->
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal: Chi tiết đơn hàng -->
        <div class="modal fade" id="orderDetailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chi tiết đơn hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="order-detail-body">
                        <!-- Chi tiết sẽ được load từ JavaScript -->
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal: Cập nhật trạng thái -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Cập nhật trạng thái</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="update-status-form">
                            <input type="hidden" id="shipping-id" name="shippingId">
                            <div class="mb-3">
                                <label for="new-status" class="form-label">Trạng thái mới</label>
                                <select id="new-status" name="status" class="form-select" required>
                                    <option value="PENDING">Chờ giao</option>
                                    <option value="SHIPPING">Đang giao</option>
                                    <option value="DELIVERED">Đã giao</option>
                                    <option value="CANCELLED">Hủy giao</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="status-note" class="form-label">Ghi chú (tùy chọn)</label>
                                <textarea id="status-note" name="note" class="form-control" rows="3" placeholder="Ghi chú thêm về trạng thái..."></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button class="btn btn-primary" onclick="updateShippingStatus()">Cập nhật</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal: Camera -->
        <div class="modal fade" id="cameraModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chụp ảnh xác nhận giao hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="camera-container" class="text-center">
                            <video id="camera-video" width="100%" height="400" autoplay style="display: none;"></video>
                            <canvas id="camera-canvas" width="640" height="480" style="display: none;"></canvas>
                            <div id="captured-photo" style="display: none;">
                                <img id="photo-preview" class="img-fluid rounded" alt="Ảnh đã chụp">
                            </div>
                            <div id="camera-error" class="alert alert-danger" style="display: none;">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Không thể truy cập camera. Vui lòng cho phép truy cập camera để chụp ảnh.
                            </div>
                            <div id="camera-controls" class="mt-3">
                                <button id="capture-btn" class="btn btn-success btn-lg" onclick="capturePhoto()">
                                    <i class="fas fa-camera"></i> Chụp ảnh
                                </button>
                            </div>
                            <div id="photo-controls" style="display: none;" class="mt-3">
                                <button class="btn btn-primary btn-lg" onclick="savePhoto()">
                                    <i class="fas fa-save"></i> Lưu ảnh
                                </button>
                                <button class="btn btn-warning btn-lg ms-2" onclick="retakePhoto()">
                                    <i class="fas fa-redo"></i> Chụp lại
                                </button>
                                <button class="btn btn-secondary btn-lg ms-2" onclick="cancelPhoto()">
                                    <i class="fas fa-times"></i> Hủy
                                </button>
                            </div>
                        </div>
                        <div id="camera-error" style="display: none;" class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            <p class="mb-0">Không thể truy cập camera. Vui lòng kiểm tra quyền truy cập camera và thử lại.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Modal: Xem ảnh giao hàng -->
        <div class="modal fade" id="viewPhotoModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Ảnh xác nhận giao hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <div id="delivery-photos-container">
                            <!-- Ảnh sẽ được load từ JavaScript -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/shipper.js"></script>
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            checkPageAccess('SHIPPER');
            
            // Debug: kiểm tra Bootstrap dropdown
            console.log('🔧 Bootstrap version:', bootstrap);
            
            // Khởi tạo tất cả dropdown manually nếu cần
            const dropdownElements = document.querySelectorAll('.dropdown-toggle');
            dropdownElements.forEach(element => {
                new bootstrap.Dropdown(element);
                console.log('🎯 Dropdown initialized for:', element);
            });
        });
    </script>
</body>
</html>
