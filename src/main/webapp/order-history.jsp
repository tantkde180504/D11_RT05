<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <title>Lịch sử đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/order-history.css" rel="stylesheet">
    </head>

    <body style="background:#f5f5f5;">
        <div class="container py-5">
            <h2 class="mb-4">Lịch sử đơn hàng của bạn</h2>
            <div id="order-history-list">
                <div class="text-muted">Đang tải dữ liệu...</div>
            </div>
            <a href="index.jsp" class="btn btn-secondary mt-4">Quay về trang chủ</a>
            <a href="#" class="btn btn-outline-info mt-3" onclick="loadMyComplaints()">Xem khiếu nại của tôi</a>
            <div id="my-complaints-section" class="mt-4"></div>
        </div>
        <!-- Modal Gửi Khiếu Nại -->
        <div class="modal fade" id="complaintModal" tabindex="-1" aria-labelledby="complaintModalLabel"
            aria-hidden="true">
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
        <script>
            document.addEventListener('DOMContentLoaded', async function () {
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

            document.getElementById('complaintForm').addEventListener('submit', async function (e) {
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
            });



            async function loadMyComplaints() {
                const section = document.getElementById('my-complaints-section');
                section.innerHTML = '<div class="text-muted">Đang tải danh sách khiếu nại...</div>';
                try {
                    const resp = await fetch('/api/complaints/my', {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/json'
                        },
                        credentials: 'include'
                    });

                    //const data = await resp.json();
                    const text = await resp.text();
                    console.log("===> complaints response text:", text);
                    let data;
                    try {
                        data = JSON.parse(text);
                    } catch (parseError) {
                        console.error("===> Lỗi JSON.parse:", parseError);
                        section.innerHTML = '<div class="text-danger">Phản hồi không hợp lệ!</div>';
                        return;
                    }

                    if (!Array.isArray(data)) {
                        section.innerHTML = '<div class="text-danger">' + (data.message || 'Không lấy được dữ liệu!') + '</div>';
                        return;
                    }

                    if (data.length === 0) {
                        section.innerHTML = '<div class="text-warning">Bạn chưa gửi khiếu nại nào.</div>';
                        return;
                    }

                    let html = '<h5 class="mt-4">Các khiếu nại đã gửi</h5><div class="table-responsive"><table class="table table-bordered align-middle text-center mt-2"><thead class="table-light">' +
                        '<tr><th>Mã đơn</th><th>Danh mục</th><th>Nội dung</th><th>Trạng thái</th><th>Phản hồi</th><th>Thời gian</th></tr></thead><tbody>';

                    data.forEach(c => {
                        console.log("📦 Complaint object:", c);
                        html += '<tr>' +
                            '<td>' + (c.order_number || '-') + '</td>' +
                            '<td>' + (c.category || '-') + '</td>' +
                            '<td class="text-start">' + c.content + '</td>' +
                            '<td><span class="badge bg-' + renderStatusColor(c.status) + '">' + c.status + '</span></td>' +
                            '<td class="text-start">' + (c.staffResponse || '-') + '</td>' +
                            '<td>' + c.createdAt + '</td>' +
                            '</tr>';
                    });

                    html += '</tbody></table></div>';
                    section.innerHTML = html;
                } catch (err) {
                    section.innerHTML = '<div class="text-danger">Lỗi tải khiếu nại!</div>';
                }
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>