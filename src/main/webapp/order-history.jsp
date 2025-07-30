<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <div id="custom-toast-container" class="toast-container position-fixed top-0 start-50 translate-middle-x mt-4" style="z-index: 9999;"></div>
        <title>Sản phẩm yêu thích - 43 Gundam Hobby</title>
        <%@ include file="/includes/unified-css.jsp" %>
            <link rel="stylesheet" href="css/order-history.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            <!-- Modal hiển thị chi tiết đơn hàng cho khách hàng -->
            <div class="modal fade" id="customerOrderDetailModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header modal-header-gradient">
                            <h5 class="modal-title order-detail-title"><i class="fas fa-shopping-cart"></i> Chi tiết đơn
                                hàng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div id="customer-order-detail-body">
                                <!-- JavaScript sẽ render nội dung tại đây -->
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
            <script>
                async function loadOrderHistory() {
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
                                '<td>' + (product.name && product.productId ? ('<a href="product-detail.jsp?id=' + product.productId + '">' + product.name + '</a>') : (product.name || '<span class="text-muted">Không có</span>')) + '</td>' +
                                '<td>' + formattedDate + '</td>' +
                                '<td>' + renderStatus(order.status) + '</td>' +
                                '<td class="text-danger fw-bold">' + formatCurrency(order.totalAmount) + '₫</td>' +
                                '<td>' + renderCancelBtn(order) +
                                ' <button class="btn btn-info btn-sm" onclick="showOrderDetail(' + order.id + ')"><i class="fas fa-eye"></i></button>' +
                                '</td>' +
                                '</tr>';
                        });
                    } catch (e) {
                        console.error("Lỗi tải lịch sử đơn hàng:", e);
                        tbody.innerHTML = '<tr><td colspan="7" class="text-danger text-center">Lỗi tải dữ liệu!</td></tr>';
                    }
                }

                document.addEventListener('DOMContentLoaded', function () {
                    loadOrderHistory();                    // lần đầu khi trang load
                    setInterval(loadOrderHistory, 5000);   // gọi lại mỗi 5 giây
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
                // Tiến trình trạng thái đơn hàng với icon
                function renderOrderProgress(status) {
                    // Các trạng thái và icon tương ứng
                    const steps = [
                        { key: 'PENDING', label: 'Chờ xác nhận', icon: 'fa-regular fa-clock' },
                        { key: 'CONFIRMED', label: 'Đã xác nhận', icon: 'fa-solid fa-check-circle' },
                        { key: 'PROCESSING', label: 'Đang giao', icon: 'fa-solid fa-motorcycle' },
                        { key: 'DELIVERED', label: 'Hoàn thành', icon: 'fa-solid fa-gift' },
                        { key: 'CANCELLED', label: 'Đã huỷ', icon: 'fa-solid fa-times-circle' }
                    ];
                    // Nếu là huỷ thì không hiển thị tiến trình
                    if (status === 'CANCELLED') return '';
                    // Xác định index trạng thái hiện tại
                    let currentIdx = steps.findIndex(s => s.key === status);
                    if (currentIdx === -1) currentIdx = 0;
                    // Chỉ lấy 4 bước đầu (không lấy huỷ)
                    const progressSteps = steps.slice(0, 4);
                    let html = '<div class="order-progress-bar">';
                    progressSteps.forEach((step, idx) => {
                        const active = idx === currentIdx ? 'active' : (idx < currentIdx ? 'done' : '');
                        html += `<div class="order-progress-step ${active}">
                            <div class="icon"><i class="${step.icon}"></i></div>
                            <div class="label">${step.label}</div>
                        </div>`;
                        if (idx < progressSteps.length - 1) {
                            html += '<div class="order-progress-line"></div>';
                        }
                    });
                    html += '</div>';
                    return html;
                }

                function renderStatus(status) {
                    // Chỉ hiển thị badge trạng thái, không còn tiến trình
                    return '<span class="order-status ' + status + '">' + status + '</span>';
                }
                function renderCancelBtn(order) {
                    if (["PENDING", "CONFIRMED", "PROCESSING"].includes(order.status)) {
                        return '<button class="btn btn-danger btn-sm" onclick="cancelOrder(' + order.id + ', this)" title="Hủy đơn"><i class="fas fa-trash-alt"></i></button>';
                    } else if (order.status === "DELIVERED") {
                        return '<button class="btn btn-warning btn-sm" onclick="sendComplaint(' + order.id + ', this)" title="Gửi khiếu nại"><i class="fas fa-exclamation-circle"></i></button>';
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
                            showToast('Gửi khiếu nại thành công!');
                            bootstrap.Modal.getInstance(document.getElementById('complaintModal')).hide();
                        } else {
                            showToast(data.message || 'Gửi khiếu nại thất bại!');
                        }
                    } catch (err) {
                        showToast('Lỗi kết nối máy chủ!');
                    }
                });
                function showToast(message, type = "success") {
                    const container = document.getElementById("custom-toast-container");
                    const toastId = "toast_" + Date.now();
                    const toast = document.createElement("div");

                    toast.className = `toast align-items-center text-white bg-${type} border-0 show mb-2`;
                    toast.setAttribute("role", "alert");
                    toast.setAttribute("aria-live", "assertive");
                    toast.setAttribute("aria-atomic", "true");
                    toast.setAttribute("id", toastId);
                    toast.innerHTML = `
                    <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                `;

                    container.appendChild(toast);

                    setTimeout(() => {
                        const el = document.getElementById(toastId);
                        if (el) el.remove();
                    }, 5000);
                }



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
                            // ...existing code...
                            const productImage = c.productImage || 'img/logo.png';
                            const productName = c.productName || 'N/A';
                            const totalItems = c.totalItems || '1';
                            const orderNumber = c.orderNumber || '-';
                            const category = c.category || '-';
                            const content = c.content || '-';
                            const status = c.status || 'UNKNOWN';
                            const staffResponse = c.staffResponse || '-';
                            let createdAt = c.createdAt || '-';
                            // Định dạng lại thời gian: chỉ lấy yyyy-MM-dd HH:mm
                            if (createdAt && typeof createdAt === 'string' && createdAt.length > 15) {
                                // Nếu có dấu chấm (mili giây/thập phân), cắt bỏ
                                const idx = createdAt.indexOf('.');
                                if (idx > 0) createdAt = createdAt.substring(0, idx);
                                // Nếu vẫn còn thừa, chỉ lấy 16 ký tự đầu (yyyy-MM-dd HH:mm)
                                createdAt = createdAt.substring(0, 16).replace('T', ' ');
                            }
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

                function showOrderDetail(orderId) {
                    fetch('/api/orders/detail?id=' + orderId)
                        .then(res => res.json())
                        .then(data => {
                            if (!data || !data.id) {
                                document.getElementById('customer-order-detail-body').innerHTML = '<div class="text-danger">Không tìm thấy đơn hàng!</div>';
                                return;
                            }
                            // Helper to show empty string if value is false/null/undefined
                            function safe(val) {
                                return (val === false || val === null || val === undefined) ? '' : val;
                            }
                            // Render tiến trình giao hàng (5 giai đoạn, có icon, sáng bước hiện tại)
                            function renderOrderProgressModal(status) {
                                // 4 bước: Chờ xác nhận, Đã xác nhận, Đang giao, Đã đến nhà
                                const steps = [
                                    { key: 'PENDING', label: 'Chờ xác nhận', icon: 'fa fa-clock' },
                                    { key: 'CONFIRMED', label: 'Đã xác nhận', icon: 'fa fa-check-circle' },
                                    { key: 'PROCESSING', label: 'Đang giao', icon: 'fa fa-truck' },
                                    { key: 'DELIVERED', label: 'Đã đến nhà', icon: 'fa fa-home' }
                                ];
                                if (status === 'CANCELLED') return '';
                                let currentIdx = steps.findIndex(s => s.key === status);
                                if (currentIdx === -1) currentIdx = 0;
                                let html = '<div class="order-progress-bar order-progress-modal">';
                                steps.forEach((step, idx) => {
                                    const state = idx === currentIdx ? 'active' : (idx < currentIdx ? 'done' : '');
                                    html += `<div class="order-progress-step ${state}">
                        <div class="icon"><i class="${step.icon} icon-state"></i></div>
                        <div class="label">${step.label}</div>
                    </div>`;
                                    if (idx < steps.length - 1) {
                                        html += '<div class="order-progress-line"></div>';
                                    }
                                });
                                html += '</div>';
                                return html;
                            }
                            // Render danh sách sản phẩm bằng JS, không dùng template string với .map() trực tiếp trong html
                            let productListHtml = '';
                            if (data.items && Array.isArray(data.items) && data.items.length > 0) {
                                productListHtml = '<ul>' + data.items.map(function (item) {
                                    return '<li>' + safe(item.name) + ' x' + safe(item.quantity) + '</li>';
                                }).join('') + '</ul>';
                            } else {
                                productListHtml = '<div>Không có sản phẩm</div>';
                            }
                            var html = '';
                            // Thêm tiến trình giao hàng phía trên
                            html += renderOrderProgressModal(safe(data.status));
                            html += '<p><strong>Mã đơn hàng:</strong> #' + safe(data.orderNumber) + '</p>';
                            html += '<p><strong>Khách hàng:</strong> ' + safe(data.shippingName) + '</p>';
                            html += '<p><strong>Điện thoại:</strong> ' + safe(data.shippingPhone) + '</p>';
                            html += '<p><strong>Email:</strong> ' + safe(data.email) + '</p>';
                            html += '<p><strong>Địa chỉ:</strong> ' + safe(data.shippingAddress) + '</p>';
                            html += '<p><strong>Phương thức thanh toán:</strong> ' + safe(data.paymentMethod) + '</p>';
                            html += '<p><strong>Trạng thái:</strong> ' + safe(data.status) + '</p>';
                            html += '<p><strong>Ngày đặt:</strong> ' + safe(data.orderDate) + '</p>';
                            html += '<p><strong>Tổng tiền:</strong> ' + safe(data.totalAmount) + '₫</p>';
                            html += '<h6>Sản phẩm:</h6>';
                            html += productListHtml;
                            document.getElementById('customer-order-detail-body').innerHTML = html;
                            var modal = new bootstrap.Modal(document.getElementById('customerOrderDetailModal'));
                            modal.show();
                        })
                        .catch(() => {
                            document.getElementById('customer-order-detail-body').innerHTML = '<div class="text-danger">Lỗi khi tải chi tiết đơn hàng!</div>';
                        });
                }
            </script>

            <%@ include file="/includes/unified-scripts.jsp" %>

                <!-- Order History specific script -->
                <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    </body>

    </html>