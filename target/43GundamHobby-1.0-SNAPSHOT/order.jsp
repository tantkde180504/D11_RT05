<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body style="background:#f5f5f5;">
    <div class="container py-5">
        <h2 class="mb-4"><i class="fas fa-box-open me-2"></i>Đơn hàng của tôi</h2>
        <div class="table-responsive shadow-sm bg-white rounded">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Ngày đặt</th>
                        <th>Sản phẩm</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu mẫu, bạn có thể thay bằng dữ liệu động từ backend -->
                    <tr>
                        <td>#1001</td>
                        <td>15/06/2025</td>
                        <td>RG RX-78-2 Gundam x1</td>
                        <td>650.000₫</td>
                        <td><span class="badge bg-success">Đã xác nhận</span></td>
                        <td>
                            <a href="order-detail.jsp?id=1001" class="btn btn-sm btn-outline-primary">
                                Xem
                            </a>
                        </td>
                    </tr>
                    <tr>
                        <td>#1000</td>
                        <td>10/06/2025</td>
                        <td>HG Barbatos x1</td>
                        <td>350.000₫</td>
                        <td><span class="badge bg-secondary">Đã giao</span></td>
                        <td>
                            <a href="order-detail.jsp?id=1000" class="btn btn-sm btn-outline-primary">
                                Xem
                            </a>
                        </td>
                    </tr>
                    <!-- Kết thúc dữ liệu mẫu -->
                </tbody>
            </table>
        </div>
        <a href="index.jsp" class="btn btn-outline-secondary mt-4"><i class="fas fa-arrow-left me-1"></i>Quay về trang chủ</a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>