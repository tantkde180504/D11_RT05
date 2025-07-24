﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sản phẩm yêu thích - 43 Gundam Hobby</title>
        <%@ include file="/includes/unified-css.jsp" %>
            <link rel="stylesheet" href="css/order-history.css">
    </head>

    <body style="background:#f5f5f5;">
        <!-- Header -->
        <%@ include file="/includes/unified-header.jsp" %>

            <div class="container py-5">
                <div class="order-history-title">Lịch sử đơn hàng của bạn</div>
                <div class="order-history-card">
                    <div class="card-body p-0">
                        <div class="table-responsive" style="min-height:350px;">
                            <table class="order-history-table table mb-0" id="order-history-table">
                                <thead>
                                    <tr>
                                        <th>Hình ảnh</th>
                                        <th>Mã đơn</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Ngày đặt</th>
                                        <th>Trạng thái</th>
                                        <th>Tổng tiền</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody id="order-history-tbody">
                                    <tr>
                                        <td colspan="7" class="order-history-loading" id="order-history-loading">Đang
                                            tải dữ liệu...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="order-history-actions">
                    <a href="index.jsp" class="btn btn-secondary">Quay về trang chủ</a>
                    <a href="#" class="btn btn-outline-info" onclick="loadMyComplaints()">Xem khiếu nại của tôi</a>
                </div>
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
                            <div class="mb-3">
                                <label for="complaintMedia" class="form-label">Ảnh/Video kèm theo (tùy chọn)</label>
                                <input class="form-control" type="file" id="complaintMedia" name="mediaFiles"
                                    accept="image/*,video/*" multiple>
                                <div class="form-text">Chỉ hỗ trợ ảnh (jpg, png) và video (mp4). Có thể chọn nhiều file.
                                </div>
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
                    const tbody = document.getElementById('order-history-tbody');
                    const loadingRow = document.getElementById('order-history-loading');
                    try {
                        const resp = await fetch('/api/orders/history', { headers: { 'Accept': 'application/json' } });
                        if (!resp.ok) throw new Error('Lỗi xác thực hoặc máy chủ');
                        const data = await resp.json();
                        tbody.innerHTML = '';
                        if (!Array.isArray(data)) {
                            tbody.innerHTML = '<tr><td colspan="7" class="text-danger text-center">' + (data.message || 'Không lấy được dữ liệu!') + '</td></tr>';
                            return;
                        }
                        if (data.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="7" class="text-warning text-center">Bạn chưa có đơn hàng nào.</td></tr>';
                            return;
                        }
                        data.forEach(order => {
                            const product = order.firstProduct || {};
                            const orderDate = parseDateArray(order.orderDate);
                            const formattedDate = orderDate ? orderDate.toLocaleString('vi-VN') : 'Ngày không hợp lệ';

                            tbody.innerHTML += '<tr>' +
                                '<td style="width:70px">' + (product.image ? '<img src="' + product.image + '" alt="Ảnh" style="max-width:60px;max-height:60px;object-fit:cover;border-radius:8px;">' : '<span class="text-muted">Không có</span>') + '</td>' +
                                '<td class="fw-bold">' + order.orderNumber + '</td>' +
                                '<td>' + (product.name || '<span class="text-muted">Không có</span>') + '</td>' +
                                '<td>' + formattedDate + '</td>' +
                                '<td>' + renderStatus(order.status) + '</td>' +
                                '<td class="text-danger fw-bold">' + formatCurrency(order.totalAmount) + '₫</td>' +
                                '<td>' + renderCancelBtn(order) + '</td>' +
                                '</tr>';
                        });
                    } catch (e) {
                        console.error("Lỗi tải lịch sử đơn hàng:", e);
                        tbody.innerHTML = '<tr><td colspan="7" class="text-danger text-center">Lỗi tải dữ liệu!</td></tr>';
                    }
                });
                function formatCurrency(num) {
                    if (!num) return '0';
                    return Number(num).toLocaleString('vi-VN');
                }
                function parseDateArray(dateArray) {
                if (!Array.isArray(dateArray) || dateArray.length < 6) {
                    return null;
                }
                // Dữ liệu từ Jackson là [năm, tháng, ngày, giờ, phút, giây, nano giây]
                // Tháng trong JavaScript Date bắt đầu từ 0 (0-11), nên cần trừ đi 1.
                const year = dateArray[0];
                const month = dateArray[1] - 1;
                const day = dateArray[2];
                const hour = dateArray[3];
                const minute = dateArray[4];
                const second = dateArray[5];
                const ms = dateArray.length > 6 ? Math.floor(dateArray[6] / 1000000) : 0;
                return new Date(year, month, day, hour, minute, second, ms);
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
                    const mediaInput = document.getElementById('complaintMedia');

                    if (!content) {
                        alert('Vui lòng nhập nội dung khiếu nại!');
                        return;
                    }

                    const formData = new FormData();
                    formData.append('orderId', orderId);
                    formData.append('category', category);
                    formData.append('content', content);
                    // Thêm các file nếu có
                    if (mediaInput && mediaInput.files && mediaInput.files.length > 0) {
                        for (let i = 0; i < mediaInput.files.length; i++) {
                            formData.append('mediaFiles', mediaInput.files[i]);
                        }
                    }

                    try {
                        const resp = await fetch('/api/complaints/create', {
                            method: 'POST',
                            body: formData
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
                        console.log("===> Bắt đầu gọi API /api/complaints/my");
                        const resp = await fetch('/api/complaints/my', {
                            method: 'GET',
                            headers: {
                                'Accept': 'application/json'
                            },
                            credentials: 'include'
                        });

                        console.log("===> Response status:", resp.status);
                        console.log("===> Response ok:", resp.ok);

                        //const data = await resp.json();
                        const text = await resp.text();
                        console.log("===> complaints response text:", text);

                        let data;
                        try {
                            data = JSON.parse(text);
                            console.log("===> Parsed data:", data);
                            console.log("===> Is array:", Array.isArray(data));
                        } catch (parseError) {
                            console.error("===> Lỗi JSON.parse:", parseError);
                            section.innerHTML = '<div class="text-danger">Phản hồi không hợp lệ! Raw response: ' + text + '</div>';
                            return;
                        }

                        if (!Array.isArray(data)) {
                            console.error("===> Data is not array:", data);
                            section.innerHTML = '<div class="text-danger">' + (data.message || 'Không lấy được dữ liệu!') + '</div>';
                            return;
                        }

                        if (data.length === 0) {
                            section.innerHTML = '<div class="text-warning">Bạn chưa gửi khiếu nại nào.</div>';
                            return;
                        }

                        console.log("===> Found", data.length, "complaints");
                        let html = '<h5 class="mt-4">Các khiếu nại đã gửi</h5>' +
                            '<div class="complaints-table-wrapper">' +
                            '<div class="table-responsive">' +
                            '<table class="table table-bordered align-middle text-center mt-2"><thead class="table-light">' +
                            '<tr><th>Sản phẩm</th><th>Mã đơn</th><th>Danh mục</th><th>Nội dung</th><th>Trạng thái</th><th>Phản hồi</th><th>Thời gian</th></tr></thead><tbody>';

                        data.forEach(c => {
                            console.log("📦 Complaint object:", c);

                            // Xử lý an toàn cho các field
                            const productImage = c.productImage || 'img/logo.png';
                            const productName = c.productName || 'N/A';
                            const totalItems = c.totalItems || '1';
                            const orderNumber = c.orderNumber || '-';
                            const category = c.category || '-';
                            const content = c.content || '-';
                            const status = c.status || 'UNKNOWN';
                            const staffResponse = c.staffResponse || '-';
                            const createdAt = c.createdAt || '-';

                            html += '<tr>' +
                                '<td><div class="d-flex align-items-center"><img src="' + productImage + '" alt="' + productName + '" style="width: 50px; height: 50px; object-fit: cover; margin-right: 10px;"><div class="text-start"><strong>' + productName + '</strong><br><small class="text-muted">SL: ' + totalItems + '</small></div></div></td>' +
                                '<td>' + orderNumber + '</td>' +
                                '<td>' + category + '</td>' +
                                '<td class="text-start">' + content + '</td>' +
                                '<td><span class="badge bg-' + renderStatusColor(status) + '">' + status + '</span></td>' +
                                '<td class="text-start">' + staffResponse + '</td>' +
                                '<td>' + createdAt + '</td>' +
                                '</tr>';
                        });

                        html += '</tbody></table></div></div>';
                        section.innerHTML = html;
                        console.log("===> Đã hiển thị thành công!");
                    } catch (err) {
                        console.error("===> Lỗi tải khiếu nại:", err);
                        section.innerHTML = '<div class="text-danger">Lỗi tải khiếu nại: ' + err.message + '</div>';
                    }
                }

                function renderStatusColor(status) {
                    switch (status) {
                        case 'PENDING': return 'warning';
                        case 'PROCESSING': return 'info';
                        case 'COMPLETED': return 'success';
                        case 'REJECTED': return 'danger';
                        default: return 'secondary';
                    }
                }
            </script>

            <%@ include file="/includes/unified-scripts.jsp" %>

                <!-- Order History specific script -->
                <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    </body>

</html>