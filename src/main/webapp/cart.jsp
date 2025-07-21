<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.mycompany.model.CartItem" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    if (cartItems == null) cartItems = new ArrayList<>();
    double grandTotal = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng | LTStore Hobby</title>
    <link rel="stylesheet" href="css/layout-sizing.css">
    <link rel="stylesheet" href="css/cart.css">
    <link rel="stylesheet" href="css/styles.css">
    <meta charset="UTF-8">
    <%@ include file="/includes/unified-css.jsp" %>
</head>
<body>
    <%@ include file="/includes/unified-header.jsp" %>
    
    <div class="cart-container">
    <div class="cart-title">Giỏ hàng của bạn</div>
    <table class="cart-table" width="100%">
        <thead>
            <tr>
                <th><input type="checkbox" id="selectAllCartItems"></th>
                <th>Ảnh</th>
                <th>Sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng</th>
                <th>Xóa</th>
            </tr>
        </thead>
        <tbody>
        <!-- Cart rows are rendered dynamically by JavaScript. Do not add any sample rows here. -->
        </tbody>
    </table>
    <div class="cart-summary">
        <strong>Tổng cộng: 0₫</strong>
    </div>
    <div style="display:flex; justify-content:space-between; margin-top:20px; gap:10px;">
        <a href="/" class="btn back-btn" style="background:#ccc; color:#222;">Quay về trang chủ</a>
        <button class="btn update-btn" id="updateCartBtn">Cập nhật giỏ hàng</button>
        <form action="payment.jsp" method="post" style="display:inline;">
            <button class="checkout-btn" type="submit">Thanh toán</button>
        </form>
    </div>
    <div class="cart-info-boxes">
        <div class="cart-info-box">
            <div class="cart-info-title">Vận chuyển miễn phí</div>
            <div class="cart-info-desc">Hóa đơn thanh toán toàn bộ</div>
        </div>
        <div class="cart-info-box">
            <div class="cart-info-title">Bảo hành bổ sung</div>
            <div class="cart-info-desc">Nếu sản phẩm trùng hoặc thiếu</div>
        </div>
        <div class="cart-info-box">
            <div class="cart-info-title">100% Hoàn tiền</div>
            <div class="cart-info-desc">Nếu hãng ngừng sản xuất</div>
        </div>
        <div class="cart-info-box">
            <div class="cart-info-title">Hotline</div>
            <div class="cart-info-desc cart-hotline">0343970667</div>
        </div>
    </div>
    
</div>
<script>
let cartData = [];

function formatCurrency(num) {
    return num.toLocaleString('vi-VN', {style: 'decimal', maximumFractionDigits: 0}) + '₫';
}

function renderCart(cartItems, grandTotal) {
    cartData = cartItems.map(item => ({...item}));
    const tbody = document.querySelector('.cart-table tbody');
    let html = '';
    // Get selectedCartIds from localStorage or default to all
    let selectedCartIds = [];
    try {
        selectedCartIds = JSON.parse(localStorage.getItem('selectedCartIds')) || [];
    } catch { selectedCartIds = []; }
    if (cartItems.length === 0) {
        html = `<tr><td colspan="7">Giỏ hàng của bạn đang trống.</td></tr>`;
    } else {
        cartItems.forEach(item => {
            const total = item.price * item.quantity;
            const checked = selectedCartIds.length === 0 || selectedCartIds.includes(item.productId) ? 'checked' : '';
            html += `<tr>
                <td><input type="checkbox" class="cart-item-checkbox" data-id="\${item.productId}" \${checked}></td>
                <td><img class="cart-img" src="\${item.imageUrl}" alt="\${item.productName}"></td>
                <td style="text-align:left; font-weight:500;">\${item.productName}</td>
                <td>\${formatCurrency(item.price)}</td>
                <td>
                    <button class="qty-btn" type="button" data-action="decrease" data-id="\${item.productId}">-</button>
                    <input class="qty-input" type="text" value="\${item.quantity}" readonly data-id="\${item.productId}">
                    <button class="qty-btn" type="button" data-action="increase" data-id="\${item.productId}">+</button>
                </td>
                <td>\${formatCurrency(total)}</td>
                <td><button class="remove-btn" type="button" data-action="remove" data-id="\${item.productId}">Xóa</button></td>
            </tr>`;
        });
    }
    tbody.innerHTML = html;
    
    // Tính lại tổng tiền dựa trên sản phẩm được chọn
    recalcGrandTotal();
    
    document.querySelector('.checkout-btn').disabled = cartItems.length === 0;
    // Set select all checkbox state
    const selectAll = document.getElementById('selectAllCartItems');
    if (selectAll) {
        const allIds = cartItems.map(i => i.productId);
        selectAll.checked = selectedCartIds.length === 0 || allIds.every(id => selectedCartIds.includes(id));
    }
}

function recalcGrandTotal() {
    let total = 0;
    let selectedCartIds = [];
    
    try {
        selectedCartIds = JSON.parse(localStorage.getItem('selectedCartIds')) || [];
    } catch { selectedCartIds = []; }
    
    // Nếu không có sản phẩm nào được chọn, tính tất cả
    if (selectedCartIds.length === 0) {
        cartData.forEach(item => {
            total += item.price * item.quantity;
        });
    } else {
        // Chỉ tính tổng những sản phẩm được chọn
        cartData.forEach(item => {
            if (selectedCartIds.includes(item.productId)) {
                total += item.price * item.quantity;
            }
        });
    }
    
    document.querySelector('.cart-summary strong').textContent = 'Tổng cộng: ' + formatCurrency(total);
    document.querySelector('.checkout-btn').disabled = cartData.length === 0;
}


document.addEventListener('DOMContentLoaded', function() {
    fetch('/api/cart')
        .then(res => {
            if (res.status === 401) return {cartItems: [], grandTotal: 0};
            return res.json();
        })
        .then(data => {
            renderCart(data.cartItems || [], data.grandTotal || 0);
        })
        .catch(() => {
            renderCart([], 0);
        });

    // Checkbox selection logic
    document.querySelector('.cart-table').addEventListener('change', function(e) {
        if (e.target.classList.contains('cart-item-checkbox')) {
            // Update selectedCartIds in localStorage
            const checkboxes = document.querySelectorAll('.cart-item-checkbox');
            const selected = Array.from(checkboxes).filter(cb => cb.checked).map(cb => parseInt(cb.getAttribute('data-id')));
            localStorage.setItem('selectedCartIds', JSON.stringify(selected));
            // Update select all checkbox
            const selectAll = document.getElementById('selectAllCartItems');
            if (selectAll) {
                const allIds = cartData.map(i => i.productId);
                selectAll.checked = selected.length === allIds.length;
            }
            // Tính lại tổng tiền
            recalcGrandTotal();
        }
        if (e.target.id === 'selectAllCartItems') {
            const checked = e.target.checked;
            const checkboxes = document.querySelectorAll('.cart-item-checkbox');
            checkboxes.forEach(cb => { cb.checked = checked; });
            const allIds = cartData.map(i => i.productId);
            localStorage.setItem('selectedCartIds', checked ? JSON.stringify(allIds) : JSON.stringify([]));
            // Tính lại tổng tiền
            recalcGrandTotal();
        }
    });

    document.querySelector('.cart-table').addEventListener('click', function(e) {
        const btn = e.target;
        if (btn.classList.contains('qty-btn')) {
            const id = parseInt(btn.getAttribute('data-id'));
            const action = btn.getAttribute('data-action');
            const item = cartData.find(i => i.productId === id);
            if (!item) return;
            if (action === 'increase') item.quantity++;
            if (action === 'decrease') {
                if (item.quantity > 1) item.quantity--;
            }
            renderCart(cartData, cartData.reduce((sum, i) => sum + i.price * i.quantity, 0));
        }
        if (btn.classList.contains('remove-btn')) {
            const id = parseInt(btn.getAttribute('data-id'));
            // Gọi API xóa sản phẩm khỏi DB
            fetch('/api/cart/remove', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({productId: id})
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Sau khi xóa thành công, reload lại cart từ server
                    fetch('/api/cart')
                        .then(res => res.json())
                        .then(newData => {
                            renderCart(newData.cartItems || [], newData.grandTotal || 0);
                        });
                } else {
                    alert('Không thể xóa sản phẩm khỏi giỏ hàng!');
                }
            })
            .catch(() => {
                alert('Có lỗi khi xóa sản phẩm!');
            });
        }
    });

    document.getElementById('updateCartBtn').addEventListener('click', function() {
        // Debug: log cartData trước khi gửi lên server
        console.log('Cart data gửi lên server:', cartData);
        fetch('/api/cart/update', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({items: cartData.map(i => ({productId: i.productId, quantity: i.quantity}))})
        })
        .then(res => res.json())
        .then(data => {
            // Sau khi cập nhật thành công, reload lại cart từ server để đảm bảo đồng bộ
            fetch('/api/cart')
                .then(res => res.json())
                .then(newData => {
                    renderCart(newData.cartItems || [], newData.grandTotal || 0);
                    alert('Cập nhật giỏ hàng thành công!');
                });
        })
        .catch(() => {
            alert('Có lỗi khi cập nhật giỏ hàng!');
        });
    });

    // Checkout button: set selectedCartIds before submitting
    const checkoutBtn = document.querySelector('.checkout-btn');
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', function(e) {
            // Get selected product IDs
            const checkboxes = document.querySelectorAll('.cart-item-checkbox');
            const selected = Array.from(checkboxes).filter(cb => cb.checked).map(cb => parseInt(cb.getAttribute('data-id')));
            if (selected.length === 0) {
                e.preventDefault();
                alert('Vui lòng chọn ít nhất một sản phẩm để thanh toán!');
                return false;
            }
            localStorage.setItem('selectedCartIds', JSON.stringify(selected));
        });
    }
});

// Lắng nghe sự kiện khi người dùng quay lại trang (sau khi thanh toán)
window.addEventListener('focus', function() {
    // Reload giỏ hàng để cập nhật những sản phẩm đã bị xóa sau thanh toán
    fetch('/api/cart')
        .then(res => {
            if (res.status === 401) return {cartItems: [], grandTotal: 0};
            return res.json();
        })
        .then(data => {
            renderCart(data.cartItems || [], data.grandTotal || 0);
        })
        .catch(() => {
            renderCart([], 0);
        });
});

// Cũng reload khi trang được load lần đầu hoặc refresh
window.addEventListener('pageshow', function(event) {
    if (event.persisted) {
        // Trang được load từ cache, reload giỏ hàng
        fetch('/api/cart')
            .then(res => {
                if (res.status === 401) return {cartItems: [], grandTotal: 0};
                return res.json();
            })
            .then(data => {
                renderCart(data.cartItems || [], data.grandTotal || 0);
            })
            .catch(() => {
                renderCart([], 0);
            });
    }
});
</script>

<!-- Unified Scripts -->
<%@ include file="/includes/unified-scripts.jsp" %>

</body>
</html>