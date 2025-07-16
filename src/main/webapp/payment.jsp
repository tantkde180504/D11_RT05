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
        
        // Debug localStorage ngay khi trang load
        console.log('=== PAYMENT PAGE LOADED ===');
        console.log('URL:', window.location.href);
        console.log('localStorage buyNowMode:', localStorage.getItem('buyNowMode'));
        console.log('localStorage buyNowItem:', localStorage.getItem('buyNowItem'));
        console.log('URL params:', window.location.search);
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
                <a href="#" class="btn btn-outline-secondary w-100" onclick="goBackToPrevious()">
                    <i class="fas fa-arrow-left me-1"></i>
                    <span id="backButtonText">Quay lại giỏ hàng</span>
                </a>
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
                        <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary">Quay về trang chủ</a>
                        <a href="<%=request.getContextPath()%>/order-history.jsp" class="btn btn-outline-secondary">Lịch sử đơn hàng</a>
                        <a href="<%=request.getContextPath()%>/all-products.jsp" class="btn btn-outline-success">Tiếp tục mua sắm</a>
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
            const paymentMethod = bankRadio.checked ? 'BANK_TRANSFER' : 'COD';
            
            // Kiểm tra chế độ mua hàng
            const urlParams = new URLSearchParams(window.location.search);
            const isBuyNowMode = urlParams.get('mode') === 'buynow' || localStorage.getItem('buyNowMode') === 'true';
            
            // Chuẩn bị payload tùy theo chế độ
            let payload = {
                fullName, phone, address, note, paymentMethod
            };
            
            if (isBuyNowMode) {
                // Mua ngay - gửi thông tin sản phẩm trực tiếp
                const buyNowItem = localStorage.getItem('buyNowItem');
                if (!buyNowItem) {
                    alert('Không tìm thấy thông tin sản phẩm!');
                    return;
                }
                
                const item = JSON.parse(buyNowItem);
                payload.buyNowMode = true;
                payload.productId = item.productId || item.id;
                payload.quantity = item.quantity;
                payload.items = [item]; // Để PayOS tính tổng tiền
            } else {
                // Từ giỏ hàng - gửi thông tin các sản phẩm được chọn
                payload.buyNowMode = false;
                
                // Lấy danh sách sản phẩm được chọn từ localStorage
                let selectedCartIds = [];
                try {
                    selectedCartIds = JSON.parse(localStorage.getItem('selectedCartIds')) || [];
                } catch (e) { 
                    selectedCartIds = []; 
                }
                
                // Gửi danh sách ID sản phẩm được chọn để backend xử lý
                payload.selectedCartIds = selectedCartIds;
                
                // Lấy thông tin cart từ API để gửi kèm
                try {
                    const cartResponse = await fetch('/api/cart');
                    if (cartResponse.ok) {
                        const cartData = await cartResponse.json();
                        if (cartData.success) {
                            // Lọc chỉ những sản phẩm được chọn
                            let selectedItems = cartData.cartItems;
                            if (selectedCartIds.length > 0) {
                                selectedItems = cartData.cartItems.filter(item => 
                                    selectedCartIds.includes(item.productId)
                                );
                            }
                            payload.items = selectedItems;
                        }
                    }
                } catch (e) {
                    console.error('Failed to fetch cart for payment:', e);
                    payload.items = [];
                }
                
                console.log('Cart mode - Selected cart IDs:', selectedCartIds);
                console.log('Cart mode - Items being sent:', payload.items);
                console.log('Cart mode - Payload being sent:', payload);
            }
            
            // Gửi request đến API
            console.log('Sending payment request with payload:', payload);
            
            const response = await fetch('/api/payment', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(payload)
            });

            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            console.log('Payment response:', data);

            if (data.success) {
                if (paymentMethod === 'BANK_TRANSFER' && data.checkoutUrl) {
                    // PayOS - chuyển hướng đến checkout
                    console.log('Redirecting to PayOS:', data.checkoutUrl);
                    
                    // KHÔNG xóa selectedCartIds ở đây - cần giữ lại để xử lý khi thanh toán thành công
                    // selectedCartIds sẽ được xóa trong confirmPayOSPayment sau khi thanh toán thành công
                    
                    window.location.href = data.checkoutUrl;
                } else {
                    // COD - hiển thị modal thành công
                    // Xóa dữ liệu sau khi đặt hàng thành công
                    if (isBuyNowMode) {
                        localStorage.removeItem('buyNowItem');
                        localStorage.removeItem('buyNowMode');
                    } else {
                        // Xóa thông tin các sản phẩm đã thanh toán khỏi localStorage
                        localStorage.removeItem('selectedCartIds');
                    }
                    
                    const successModal = new bootstrap.Modal(document.getElementById('successModal'));
                    successModal.show();
                }
            } else {
                console.error('Payment error:', data);
                alert(data.message || 'Đặt hàng thất bại! Vui lòng thử lại.');
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
        
        // Kiểm tra nếu đang ở chế độ "Mua ngay"
        const urlParams = new URLSearchParams(window.location.search);
        const isBuyNowMode = urlParams.get('mode') === 'buynow' || localStorage.getItem('buyNowMode') === 'true';
        
        console.log('=== PAYMENT DEBUG ===');
        console.log('URL params mode:', urlParams.get('mode'));
        console.log('localStorage buyNowMode:', localStorage.getItem('buyNowMode'));
        console.log('isBuyNowMode:', isBuyNowMode);
        console.log('localStorage buyNowItem:', localStorage.getItem('buyNowItem'));
        
        if (isBuyNowMode) {
            // Lấy sản phẩm từ "Mua ngay"
            const buyNowItem = localStorage.getItem('buyNowItem');
            console.log('Buy now item from localStorage:', buyNowItem);
            
            if (buyNowItem) {
                try {
                    const item = JSON.parse(buyNowItem);
                    console.log('Parsed buy now item:', item);
                    cartItems = [item];
                    grandTotal = item.price * item.quantity;
                    
                    // Cập nhật text nút quay lại
                    const backButtonText = document.getElementById('backButtonText');
                    if (backButtonText) {
                        backButtonText.textContent = 'Quay lại sản phẩm';
                    }
                    console.log('Buy now cart setup successful:', cartItems, 'total:', grandTotal);
                } catch (e) {
                    console.error('Error parsing buyNowItem:', e);
                    cartItems = [];
                    grandTotal = 0;
                }
            } else {
                console.error('No buyNowItem found in localStorage!');
                
                // Thử phục hồi từ URL params
                const productId = urlParams.get('productId');
                const quantity = urlParams.get('quantity');
                const price = urlParams.get('price');
                
                if (productId && quantity && price) {
                    console.log('Trying to recover from URL params...');
                    try {
                        // Tạo lại item từ URL params
                        const recoveredItem = {
                            id: parseInt(productId),
                            productId: parseInt(productId),
                            name: 'Sản phẩm #' + productId, // Tên tạm thời
                            productName: 'Sản phẩm #' + productId,
                            price: parseFloat(price),
                            quantity: parseInt(quantity),
                            imageUrl: contextPath + '/img/RGStrikeGundam.jpg'
                        };
                        
                        // Lưu lại vào localStorage
                        localStorage.setItem('buyNowItem', JSON.stringify(recoveredItem));
                        localStorage.setItem('buyNowMode', 'true');
                        
                        cartItems = [recoveredItem];
                        grandTotal = recoveredItem.price * recoveredItem.quantity;
                        
                        console.log('Successfully recovered item from URL params:', recoveredItem);
                        
                        // Cập nhật text nút quay lại
                        const backButtonText = document.getElementById('backButtonText');
                        if (backButtonText) {
                            backButtonText.textContent = 'Quay lại sản phẩm';
                        }
                    } catch (e) {
                        console.error('Failed to recover from URL params:', e);
                        // Hiển thị thông báo lỗi
                        orderSummaryList.innerHTML = `
                            <div class="alert alert-warning text-center">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <div>Không thể khôi phục thông tin sản phẩm!</div>
                                <div class="mt-2">
                                    <a href="${contextPath}/all-products.jsp" class="btn btn-sm btn-primary">
                                        Quay lại mua sắm
                                    </a>
                                </div>
                            </div>
                        `;
                        return;
                    }
                } else {
                    // Hiển thị thông báo lỗi cụ thể cho chế độ mua ngay
                    orderSummaryList.innerHTML = `
                        <div class="alert alert-warning text-center">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <div>Không tìm thấy thông tin sản phẩm!</div>
                            <div class="mt-2">
                                <a href="${contextPath}/all-products.jsp" class="btn btn-sm btn-primary">
                                    Quay lại mua sắm
                                </a>
                            </div>
                        </div>
                    `;
                    return;
                }
            }
        } else {
            // Lấy cart từ API
            try {
                const resp = await fetch('/api/cart', { headers: { 'Accept': 'application/json' } });
                const data = await resp.json();
                if (data.success) {
                    const allCartItems = data.cartItems;
                    
                    // Lấy danh sách sản phẩm được chọn từ localStorage
                    let selectedCartIds = [];
                    try {
                        selectedCartIds = JSON.parse(localStorage.getItem('selectedCartIds')) || [];
                    } catch (e) { 
                        selectedCartIds = []; 
                    }
                    
                    // Nếu không có sản phẩm nào được chọn, mặc định chọn tất cả
                    if (selectedCartIds.length === 0) {
                        cartItems = allCartItems;
                    } else {
                        // Chỉ lấy những sản phẩm được chọn
                        cartItems = allCartItems.filter(item => 
                            selectedCartIds.includes(item.productId)
                        );
                    }
                    
                    grandTotal = cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
                    
                    console.log('Selected cart IDs:', selectedCartIds);
                    console.log('All cart items:', allCartItems);
                    console.log('Filtered cart items for payment:', cartItems);
                }
            } catch (err) {
                console.error('Error fetching cart:', err);
                cartItems = [];
                grandTotal = 0;
            }
        }
        
        if (!cartItems.length) {
            orderSummaryList.innerHTML = '<div class="text-danger">Không có sản phẩm nào!</div>';
            return;
        }
        
        let html = '';
        
        // Thêm thông báo nếu đang ở chế độ cart và có sản phẩm được chọn
        if (!isBuyNowMode) {
            let selectedCartIds = [];
            try {
                selectedCartIds = JSON.parse(localStorage.getItem('selectedCartIds')) || [];
            } catch (e) { selectedCartIds = []; }
            
            if (selectedCartIds.length > 0) {
                html += '<div class="alert alert-info text-center py-2 mb-3">';
                html += '<i class="fas fa-info-circle me-2"></i>';
                html += '<small>Bạn đang thanh toán ' + cartItems.length + ' sản phẩm đã chọn</small>';
                html += '</div>';
            }
        }
        
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
    
    // Function để xử lý nút quay lại
    function goBackToPrevious() {
        const urlParams = new URLSearchParams(window.location.search);
        const isBuyNowMode = urlParams.get('mode') === 'buynow' || localStorage.getItem('buyNowMode') === 'true';
        
        if (isBuyNowMode) {
            // Xóa dữ liệu "Mua ngay" khỏi localStorage
            localStorage.removeItem('buyNowItem');
            localStorage.removeItem('buyNowMode');
            
            // Quay lại trang trước đó hoặc trang chủ
            if (document.referrer && document.referrer.includes('/product-detail.jsp')) {
                window.location.href = document.referrer;
            } else {
                window.location.href = contextPath + '/all-products.jsp';
            }
        } else {
            // Quay lại giỏ hàng
            window.location.href = contextPath + '/cart.jsp';
        }
    }
    
    // Load order summary when page loads
    renderOrderSummary();
    
    // Also set timeout để đảm bảo load sau khi DOM sẵn sàng
    setTimeout(() => {
        console.log('Timeout - rendering order summary again...');
        renderOrderSummary();
    }, 100);
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>