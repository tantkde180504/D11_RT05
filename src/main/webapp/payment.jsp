<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Thanh toán đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/payment.css" rel="stylesheet">
</head>

<body style="background:#f5f5f5;">
    <script>
        // Khai báo contextPath để sử dụng trong JavaScript
        const contextPath = '<%= contextPath %>';
    </script>
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="checkout-section mb-4">
                    <div class="checkout-title"><i class="fas fa-receipt me-2"></i>Thông tin thanh toán</div>
                    <form id="checkout-form">
                        <div class="row mb-3">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" placeholder="Nhập họ và tên" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" placeholder="Nhập số điện thoại" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" placeholder="Nhập địa chỉ nhận hàng" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Ghi chú đơn hàng</label>
                            <textarea class="form-control" rows="3" placeholder="Ghi chú thêm (nếu có)"></textarea>
                        </div>
                        <div class="mb-4 payment-method">
                            <label class="form-label mb-2">Phương thức thanh toán</label>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="payment" id="cod" checked>
                                <label class="form-check-label" for="cod">
                                    Thanh toán khi nhận hàng (COD)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="payment" id="bank">
                                <label class="form-check-label" for="bank">
                                    Thanh toán qua PayOS
                                </label>
                            </div>
                            <div id="payos-section" class="mt-3" style="display:none;">
                                <div class="alert alert-info py-2 mb-2">
                                    <i class="fas fa-credit-card me-2"></i>
                                    Bạn sẽ được chuyển đến cổng thanh toán PayOS để hoàn tất giao dịch.
                                </div>
                                <div class="text-center">
                                    <img src="https://docs.payos.vn/img/logo.svg" 
                                         alt="PayOS Logo" style="max-width:150px;">
                                </div>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-danger w-100 py-2 fs-5">Đặt hàng</button>
                    </form>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="order-summary shadow-sm mb-4">
                    <h5 class="mb-3"><i class="fas fa-list-ul me-2"></i>Đơn hàng của bạn</h5>
                    <div id="order-summary-list">
                        <div class="text-muted">Đang tải giỏ hàng...</div>
                    </div>
                </div>
                <a href="cart.jsp" class="btn btn-outline-secondary w-100"><i class="fas fa-arrow-left me-1"></i>Quay lại giỏ hàng</a>
            </div>
        </div>
    </div>

    <!-- Modal Thanh toán thành công -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center">
                <div class="modal-header border-0">
                    <h5 class="modal-title w-100" id="successModalLabel">Thanh toán thành công!</h5>
                </div>
                <div class="modal-body">
                    <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
                    <p class="mb-4">Cảm ơn bạn đã đặt hàng. Đơn hàng của bạn đã được ghi nhận.</p>
                    <div class="d-grid gap-2">
                        <a href="index.jsp" class="btn btn-primary">Quay về trang chủ</a>
                        <a href="order-history.jsp" class="btn btn-outline-secondary">Đơn hàng</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
document.addEventListener('DOMContentLoaded', function() {
    const codRadio = document.getElementById('cod');
    const bankRadio = document.getElementById('bank');
    const payosSection = document.getElementById('payos-section');
    const checkoutForm = document.getElementById('checkout-form');

    function togglePayOS() {
        payosSection.style.display = bankRadio.checked ? 'block' : 'none';
    }

    codRadio.addEventListener('change', togglePayOS);
    bankRadio.addEventListener('change', togglePayOS);
    togglePayOS();

    checkoutForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        // Lấy dữ liệu form
        const fullName = checkoutForm.querySelector('input[placeholder="Nhập họ và tên"]').value.trim();
        const phone = checkoutForm.querySelector('input[placeholder="Nhập số điện thoại"]').value.trim();
        const address = checkoutForm.querySelector('input[placeholder="Nhập địa chỉ nhận hàng"]').value.trim();
        const note = checkoutForm.querySelector('textarea').value.trim();
        const paymentMethod = bankRadio.checked ? 'BANK_TRANSFER' : 'COD';

        // Validate form
        if (!fullName || !phone || !address) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }

        try {
            // Nếu chọn PayOS, chuyển đến PayOS payment
            if (paymentMethod === 'BANK_TRANSFER') {
                // Lấy thông tin giỏ hàng
                let cartItems = [];
                let grandTotal = 0;
                
                // Debug: Log để kiểm tra
                console.log('Checking localStorage for cartItems...');
                
                if (localStorage.getItem('cartItems')) {
                    try {
                        cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
                        grandTotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                        console.log('Found cart in localStorage:', cartItems, 'Total:', grandTotal);
                    } catch (e) { 
                        console.error('Error parsing localStorage cart:', e);
                        cartItems = []; 
                        grandTotal = 0; 
                    }
                } else {
                    console.log('No cart in localStorage, trying API...');
                    // Lấy từ API
                    try {
                        const resp = await fetch('/api/cart', { headers: { 'Accept': 'application/json' } });
                        const data = await resp.json();
                        if (data.success) {
                            cartItems = data.cartItems;
                            grandTotal = data.grandTotal;
                            console.log('Found cart from API:', cartItems, 'Total:', grandTotal);
                        } else {
                            console.log('API returned no cart data');
                        }
                    } catch (err) {
                        console.error('Error fetching cart from API:', err);
                    }
                }

                // Nếu vẫn không có cart, thử lấy từ order summary hiện tại
                if (!cartItems.length || grandTotal <= 0) {
                    console.log('No cart found, trying to get from DOM...');
                    // Fallback: lấy từ order summary đã render
                    const orderSummaryItems = document.querySelectorAll('#order-summary-list .d-flex');
                    if (orderSummaryItems.length > 0) {
                        // Lấy tổng tiền từ DOM
                        const totalElement = document.querySelector('#order-summary-list .text-danger .fw-bold');
                        if (totalElement) {
                            const totalText = totalElement.textContent.replace(/[^\d]/g, '');
                            grandTotal = parseInt(totalText) || 0;
                            console.log('Got total from DOM:', grandTotal);
                        }
                    }
                }

                // Nếu vẫn không có, dùng giá trị mặc định để test
                if (grandTotal <= 0) {
                    console.log('No valid cart found, using default values for testing...');
                    grandTotal = 299999; // Giá trị mặc định để test
                    cartItems = [{ name: 'Test Product', quantity: 1, price: 299999 }];
                }

                console.log('Final cart data:', cartItems, 'Final total:', grandTotal);

                // Tạo request để gửi đến PayOS
                const payosPayload = {
                    fullName: fullName,
                    phone: phone,
                    address: address,
                    note: note,
                    paymentMethod: 'BANK_TRANSFER'
                };

                console.log('Sending to PayOS with payload:', payosPayload);

                // Gửi request đến PayOS API
                const payosResponse = await fetch('/api/payment', {
                    method: 'POST',
                    headers: { 
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(payosPayload)
                });

                const payosData = await payosResponse.json();
                console.log('PayOS response:', payosData);
                console.log('PayOS response checkoutUrl:', payosData.checkoutUrl);
                console.log('PayOS response success:', payosData.success);

                if (payosData.success && payosData.checkoutUrl) {
                    console.log('Redirecting to PayOS:', payosData.checkoutUrl);
                    // Chuyển hướng đến PayOS checkout
                    window.location.href = payosData.checkoutUrl;
                } else {
                    console.error('PayOS error:', payosData);
                    alert('Lỗi tạo link thanh toán PayOS: ' + (payosData.message || 'Vui lòng thử lại'));
                }
                
            } else {
                // Xử lý COD
                const payload = {
                    fullName, phone, address, note, paymentMethod
                };
                
                const response = await fetch('/api/payment', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });
                
                const data = await response.json();
                
                if (data.success) {
                    const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                    successModal.show();
                } else {
                    alert(data.message || 'Đặt hàng thất bại!');
                }
            }
        } catch (error) {
            console.error('Error:', error);
            alert('Lỗi kết nối máy chủ!');
        }
    });

    // Render order summary
    async function renderOrderSummary() {
        const orderSummaryList = document.getElementById('order-summary-list');
        let cartItems = [];
        let grandTotal = 0;
        // Ưu tiên lấy cart từ localStorage nếu có
        if (localStorage.getItem('cartItems')) {
            try {
                cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
                grandTotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            } catch (e) { cartItems = []; grandTotal = 0; }
        } else {
            // Nếu không có localStorage thì lấy từ API
            try {
                const resp = await fetch('/api/cart', { headers: { 'Accept': 'application/json' } });
                const data = await resp.json();
                if (data.success) {
                    cartItems = data.cartItems;
                    grandTotal = data.grandTotal;
                }
            } catch (err) {}
        }
        if (!cartItems.length) {
            orderSummaryList.innerHTML = '<div class="text-danger">Giỏ hàng trống!</div>';
            return;
        }
        let html = '';
        cartItems.forEach(item => {
            html += '<div class="d-flex justify-content-between mb-2">'
                + '<span>' + (item.productName || item.name) + ' x ' + item.quantity + '</span>'
                + '<span>' + formatCurrency(item.price * item.quantity) + '₫</span>'
                + '</div>';
        });
        html += '<hr>';
        html += '<div class="d-flex justify-content-between mb-2">'
            + '<span class="fw-bold">Tạm tính</span>'
            + '<span class="fw-bold">' + formatCurrency(grandTotal) + '₫</span>'
            + '</div>';
        html += '<div class="d-flex justify-content-between mb-2">'
            + '<span>Phí vận chuyển</span>'
            + '<span>Miễn phí</span>'
            + '</div>';
        html += '<hr>';
        html += '<div class="d-flex justify-content-between mb-2">'
            + '<span class="fw-bold text-danger">Tổng cộng</span>'
            + '<span class="fw-bold fs-5 text-danger">' + formatCurrency(grandTotal) + '₫</span>'
            + '</div>';
        orderSummaryList.innerHTML = html;
    }
    function formatCurrency(num) {
        return num.toLocaleString('vi-VN');
    }
    renderOrderSummary();
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>