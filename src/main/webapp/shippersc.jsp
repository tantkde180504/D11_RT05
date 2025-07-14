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
    <link href="css/staff-styles.css" rel="stylesheet">
</head>
<body class="staff-body">
    <div class="staff-container">
        <!-- Header -->
        <div class="staff-header">
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
        <!-- Orders Table -->
        <div class="staff-card mt-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5><i class="fas fa-list me-2 text-success"></i>Đơn hàng cần giao</h5>
                <select id="order-status-filter" class="form-select auto-width" style="max-width:200px">
                    <option value="ALL">Tất cả</option>
                    <option value="PENDING">Chờ giao</option>
                    <option value="SHIPPING">Đang giao</option>
                    <option value="DELIVERED">Đã giao</option>
                    <option value="FAILED">Hủy giao hàng</option>
                    <option value="CANCELLED" style="display:none">Hủy giao hàng</option>
                </select>
            </div>
            <div class="table-responsive table-modern">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>Mã đơn hàng</th>
                            <th>Khách hàng</th>
                            <th>Địa chỉ giao</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th>Ngày giao</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody id="orders-table-body">
                        <!-- Dữ liệu shipping sẽ được render từ js/shipper.js -->
                    </tbody>
                </table>
            </div>
        </div>
        <!-- Modal: Cập nhật trạng thái đơn hàng -->
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
                                <option value="PENDING">Chờ giao</option>
                                <option value="SHIPPING">Đang giao</option>
                                <option value="DELIVERED">Đã giao</option>
                                <option value="FAILED">Hủy giao hàng</option>
                                <option value="CANCELLED" style="display:none">Hủy giao hàng</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú (nếu có):</label>
                            <textarea class="form-control" id="note" rows="2"></textarea>
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
              </div>
            </div>
          </div>
        </div>
        
        <!-- Modal: Chụp ảnh giao hàng -->
        <div class="modal fade" id="cameraModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Chụp ảnh xác nhận giao hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <div id="camera-container" style="display: none;">
                            <video id="camera-video" autoplay muted style="max-width: 100%; max-height: 400px; border-radius: 8px;"></video>
                            <div class="mt-3">
                                <button class="btn btn-success btn-lg" onclick="capturePhoto()">
                                    <i class="fas fa-camera"></i> Chụp ảnh
                                </button>
                                <button class="btn btn-secondary btn-lg ms-2" onclick="stopCamera()">
                                    <i class="fas fa-times"></i> Hủy
                                </button>
                            </div>
                        </div>
                        <div id="photo-preview" style="display: none;">
                            <img id="captured-image" style="max-width: 100%; max-height: 400px; border-radius: 8px; border: 2px solid #28a745;">
                            <div class="mt-3">
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
        });
    </script>
</body>
</html>