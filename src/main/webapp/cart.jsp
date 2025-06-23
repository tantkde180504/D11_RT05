<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mycompany.CartItem" %>
<%
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    if (cartItems == null) cartItems = new ArrayList<>();
    double grandTotal = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng | LTStore Hobby</title>
    <link rel="stylesheet" href="css/cart.css">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="cart-container">
    <div class="cart-title">Giỏ hàng của bạn</div>
    <table class="cart-table" width="100%">
        <thead>
            <tr>
                <th>Ảnh</th>
                <th>Sản phẩm</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Tổng</th>
                <th>Xóa</th>
            </tr>
        </thead>
        <tbody>
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
    <div class="cart-policy-links">
        <a href="https://ltstorehobby.com/chinh-sach" target="_blank">Chính sách bảo mật</a> |
        <a href="https://ltstorehobby.com/chinh-sach" target="_blank">Chính sách vận chuyển</a> |
        <a href="https://ltstorehobby.com/chinh-sach" target="_blank">Chính sách đổi trả</a> |
        <a href="https://ltstorehobby.com/dieu-khoan" target="_blank">Quy định sử dụng</a>
    </div>
    <div class="cart-policy-links" style="margin-top:10px;">
        <a href="https://www.facebook.com/LTSTORE24/" target="_blank">Facebook</a> |
        <a href="https://shope.ee/7pS5Ry0Zv9" target="_blank">Shopee</a> |
        <a href="#" target="_blank">Tiktok</a>
    </div>
    <div class="cart-payment-icons" style="margin-top:18px;">
        <img src="img/sale.png" alt="Payment 1">
        <img src="img/logo.png" alt="Payment 2">
        <!-- Thêm các icon thanh toán khác nếu có -->
    </div>
    <div class="cart-footer">
        © Bản quyền thuộc về LTStore | Cung cấp bởi Sapo
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
    if (cartItems.length === 0) {
        html = `<tr><td colspan="6">Giỏ hàng của bạn đang trống.</td></tr>`;
    } else {
        cartItems.forEach(item => {
            const total = item.price * item.quantity;
            html += `<tr>
                <td><img class="cart-img" src="${'$'}{item.imageUrl}" alt="${'$'}{item.productName}"></td>
                <td style="text-align:left; font-weight:500;">${'$'}{item.productName}</td>
                <td>${'$'}{formatCurrency(item.price)}</td>
                <td>
                    <button class="qty-btn" type="button" data-action="decrease" data-id="${'$'}{item.productId}">-</button>
                    <input class="qty-input" type="text" value="${'$'}{item.quantity}" readonly data-id="${'$'}{item.productId}">
                    <button class="qty-btn" type="button" data-action="increase" data-id="${'$'}{item.productId}">+</button>
                </td>
                <td>${'$'}{formatCurrency(total)}</td>
                <td><button class="remove-btn" type="button" data-action="remove" data-id="${'$'}{item.productId}">Xóa</button></td>
            </tr>`;
        });
    }
    tbody.innerHTML = html;
    document.querySelector('.cart-summary strong').textContent = 'Tổng cộng: ' + formatCurrency(grandTotal);
    document.querySelector('.checkout-btn').disabled = cartItems.length === 0;
}

function recalcGrandTotal() {
    let total = 0;
    cartData.forEach(item => {
        total += item.price * item.quantity;
    });
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
});
</script>
</body>
</html>