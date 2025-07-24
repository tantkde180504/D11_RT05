<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán đơn hàng | 43 Gundam Hobby</title>
    <%@ include file="/includes/unified-css.jsp" %>
    
</head>

<body style="background:#f5f5f5;">
    <!-- Header Section -->
     
    <%@ include file="/includes/unified-header.jsp" %>

    <div class="container mt-4">
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
            <div class="col-lg-7 mb-4">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-header bg-white border-0 pb-0">
                        <h4 class="mb-0 fw-bold text-primary"><i class="fas fa-receipt me-2"></i>Thông tin thanh toán</h4>
                    </div>
                    <div class="card-body pt-3">
                        <form id="checkout-form">
                            <div class="row g-3 mb-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control rounded-3" placeholder="Nhập họ và tên" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                                    <input type="tel" class="form-control rounded-3" placeholder="Nhập số điện thoại" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Địa chỉ nhận hàng <span class="text-danger">*</span></label>
                                <div class="input-group mb-2">
                                    <input type="text" class="form-control rounded-3" placeholder="Nhập địa chỉ nhận hàng" required id="checkoutAddressInput">
                                    <button type="button" class="btn btn-outline-primary" id="chooseAddressBtn" title="Chọn từ sổ địa chỉ">
                                        <i class="fas fa-book me-1"></i> Sổ địa chỉ
                                    </button>
                                </div>
                            </div>
                            <div id="shippingTypeSection" style="display:none" class="mb-3">
                                <label class="form-label">Chọn loại giao hàng:</label>
                                <div>
                                    <input type="radio" id="fastShipping" name="shippingType" value="hỏa tốc" checked>
                                    <label for="fastShipping">Giao hỏa tốc (trong ngày)</label>
                                </div>
                                <div>
                                    <input type="radio" id="normalShipping" name="shippingType" value="thường">
                                    <label for="normalShipping">Giao hàng thường</label>
                                </div>
                            </div>
                            <div id="shippingTypeNotice" class="alert alert-info" style="display:none"></div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Ghi chú đơn hàng</label>
                                <textarea class="form-control rounded-3" rows="3" placeholder="Ghi chú thêm (nếu có)"></textarea>
                            </div>
                            <div class="mb-4 payment-method">
                                <label class="form-label fw-semibold mb-2">Phương thức thanh toán</label>
                                <div class="d-flex gap-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="payment" id="cod" checked>
                                        <label class="form-check-label" for="cod">
                                            <i class="fas fa-money-bill-wave me-1 text-success"></i> Thanh toán khi nhận hàng (COD)
                                        </label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="payment" id="bank">
                                        <label class="form-check-label" for="bank">
                                            <i class="fas fa-credit-card me-1 text-primary"></i> Thanh toán qua PayOS
                                        </label>
                                    </div>
                                </div>
                                <div id="payos-section" class="mt-3" style="display:none;">
                                    <div class="alert alert-info py-2 mb-2 rounded-3">
                                        <i class="fas fa-credit-card me-2"></i>
                                        Bạn sẽ được chuyển đến cổng thanh toán PayOS để hoàn tất giao dịch.
                                    </div>                                  
                                </div>
                            </div>
                            <button type="submit" class="btn btn-danger w-100 py-3 fs-5 rounded-3 shadow-sm">Đặt hàng</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-5 mb-4">
                <div class="card shadow-lg border-0 rounded-4">
                    <div class="card-header bg-white border-0 pb-0">
                        <h4 class="mb-0 fw-bold text-primary"><i class="fas fa-list-ul me-2"></i>Đơn hàng của bạn</h4>
                    </div>
                    <div class="card-body pt-3">
                        <div id="order-summary-list">
                            <div class="text-muted">Đang tải giỏ hàng...</div>
                        </div>
                    </div>
                </div>
                <a href="cart.jsp" class="btn btn-outline-secondary w-100 mt-3 rounded-3 shadow-sm" onclick="goBackToPrevious()">
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

    <!-- Modal chọn địa chỉ giao hàng -->
    <div class="modal fade" id="addressBookModal" tabindex="-1" aria-labelledby="addressBookModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="addressBookModalLabel">Chọn địa chỉ giao hàng</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
          </div>
          <div class="modal-body" id="addressBookList">
            <!-- Danh sách địa chỉ sẽ được render ở đây -->
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
            
            // Lấy loại giao hàng từ form
            let shippingTypeInput = document.querySelector('input[name="shippingType"]:checked');
            let shippingType = shippingTypeInput ? shippingTypeInput.value : null;
            payload.shippingType = shippingType;

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

    const nameInput = document.querySelector('input[placeholder="Nhập họ và tên"]');
    const phoneInput = document.querySelector('input[placeholder="Nhập số điện thoại"]');
    const addressInput = document.getElementById('checkoutAddressInput');
    const chooseBtn = document.getElementById('chooseAddressBtn');

    // Chọn địa chỉ từ sổ địa chỉ và autofill
    chooseBtn.addEventListener('click', async function() {
        try {
            const resp = await fetch('/api/addresses');
            const data = await resp.json();
            let html = '';
            if (data.success && Array.isArray(data.addresses) && data.addresses.length > 0) {
                data.addresses.forEach(addr => {
                    const fullAddress = (addr.houseNumber || '') + ', ' + (addr.ward || '') + ', ' + (addr.district || '') + ', ' + (addr.province || '');
                    const addrStr = encodeURIComponent(JSON.stringify(addr));
                    html +=
                        "<div class='card mb-2'><div class='card-body'>" +
                        "<div><strong>" + (addr.recipientName || '') + "</strong> - " + (addr.phone || '') + "</div>" +
                        "<div>" + fullAddress + "</div>" +
                        "<button class='btn btn-sm btn-primary mt-2' onclick='window.selectAddressForCheckout(\"" + addrStr + "\")'>Chọn địa chỉ này</button>" +
                        "</div></div>";
                });
            } else {
                html = '<div class="alert alert-info">Bạn chưa có địa chỉ nào trong sổ địa chỉ.</div>';
            }
            document.getElementById('addressBookList').innerHTML = html;
            new bootstrap.Modal(document.getElementById('addressBookModal')).show();
        } catch (e) {
            document.getElementById('addressBookList').innerHTML = '<div class="alert alert-danger">Không thể tải sổ địa chỉ!</div>';
            new bootstrap.Modal(document.getElementById('addressBookModal')).show();
        }
    });

    // Hàm kiểm tra và hiện/ẩn vùng chọn loại giao hàng
    function checkShippingTypeByProvince(province) {
        const shippingSection = document.getElementById('shippingTypeSection');
        const notice = document.getElementById('shippingTypeNotice');
        if (province && province.trim().toLowerCase() === 'đà nẵng') {
            shippingSection.style.display = '';
            notice.style.display = 'none';
        } else {
            shippingSection.style.display = 'none';
            notice.style.display = '';
            notice.textContent = 'Chỉ áp dụng giao hỏa tốc cho đơn hàng tại Đà Nẵng.';
        }
    }

    // Khi chọn địa chỉ từ sổ địa chỉ
    window.selectAddressForCheckout = function(addrStr) {
        const addr = JSON.parse(decodeURIComponent(addrStr));
        if (nameInput) nameInput.value = addr.recipientName || '';
        if (phoneInput) phoneInput.value = addr.phone || '';
        if (addressInput) addressInput.value = (addr.houseNumber || '') + ', ' + (addr.ward || '') + ', ' + (addr.district || '') + ', ' + (addr.province || '');
        checkShippingTypeByProvince(addr.province);
        bootstrap.Modal.getInstance(document.getElementById('addressBookModal')).hide();
    };

    // Khi nhập tay địa chỉ
    addressInput.addEventListener('blur', function() {
        const val = this.value;
        const province = val.split(',').pop().trim();
        checkShippingTypeByProvince(province);
    });
});
</script>
</div> <!-- End container -->

<%@ include file="/includes/unified-scripts.jsp" %>
</body>
</html>