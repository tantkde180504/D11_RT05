<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/order-history.css" rel="stylesheet">
</head>
<body style="background:#f5f5f5;">
    <div class="container py-5">
        <h2 class="mb-4">Lịch sử đơn hàng của bạn</h2>
        <div id="order-history-list">
            <div class="text-muted">Đang tải dữ liệu...</div>
        </div>
        <a href="index.jsp" class="btn btn-secondary mt-4">Quay về trang chủ</a>
    </div>
    <script>
    document.addEventListener('DOMContentLoaded', async function() {
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
                orderHistoryList.innerHTML = '<div class="text-warning">Bạn chưa có đơn hàng nào.</div>';
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
    });
    function formatCurrency(num) {
        if (!num) return '0';
        return Number(num).toLocaleString('vi-VN');
    }
    function renderStatus(status) {
        return '<span class="order-status ' + status + '">' + status + '</span>';
    }
    function renderCancelBtn(order) {
        if (["PENDING","CONFIRMED","PROCESSING"].includes(order.status)) {
            return '<button class="btn btn-danger btn-sm" onclick="cancelOrder(' + order.id + ', this)"><i class="fas fa-trash-alt me-1"></i>Hủy đơn</button>';
        }
        return '';
    }
    window.cancelOrder = async function(orderId, btn) {
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
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
