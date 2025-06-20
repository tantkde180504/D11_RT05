<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mycompany.CartItem" %>
<%
    // Lấy cartItems từ model (Spring Controller truyền qua request attribute)
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
    <form action="UpdateCartServlet" method="post">
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
            <% for (CartItem item : cartItems) {
                double total = item.getPrice() * item.getQuantity();
                grandTotal += total;
            %>
                <tr>
                    <td><img class="cart-img" src="<%=item.getImageUrl()%>" alt="<%=item.getProductName()%>"></td>
                    <td style="text-align:left; font-weight:500;"> <%=item.getProductName()%> </td>
                    <td><%=String.format("%,.0f", item.getPrice())%>₫</td>
                    <td>
                        <button class="qty-btn" type="submit" name="action" value="decrease-<%=item.getProductId()%>">-</button>
                        <input class="qty-input" type="text" name="quantity-<%=item.getProductId()%>" value="<%=item.getQuantity()%>" readonly>
                        <button class="qty-btn" type="submit" name="action" value="increase-<%=item.getProductId()%>">+</button>
                    </td>
                    <td><%=String.format("%,.0f", total)%>₫</td>
                    <td>
                        <button class="remove-btn" type="submit" name="action" value="remove-<%=item.getProductId()%>">Xóa</button>
                    </td>
                </tr>
            <% } %>
            <% if (cartItems.isEmpty()) { %>
                <tr>
                    <td colspan="6">Giỏ hàng của bạn đang trống.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </form>
    <div class="cart-summary">
        <strong>Tổng cộng: <%=String.format("%,.0f", grandTotal)%>₫</strong>
    </div>
    <div style="text-align:right; margin-top:20px;">
        <form action="CheckoutServlet" method="post">
            <button class="checkout-btn" type="submit" <%=cartItems.isEmpty() ? "disabled" : ""%>>Thanh toán</button>
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
document.addEventListener('DOMContentLoaded', function() {
    function formatCurrency(num) {
        return num.toLocaleString('vi-VN', {style: 'decimal', maximumFractionDigits: 0}) + '₫';
    }
    function renderCart(cartItems, grandTotal) {
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
                        <button class="qty-btn" data-action="decrease" data-id="${'$'}{item.productId}">-</button>
                        <input class="qty-input" type="text" value="${'$'}{item.quantity}" readonly>
                        <button class="qty-btn" data-action="increase" data-id="${'$'}{item.productId}">+</button>
                    </td>
                    <td>${'$'}{formatCurrency(total)}</td>
                    <td><button class="remove-btn" data-action="remove" data-id="${'$'}{item.productId}">Xóa</button></td>
                </tr>`;
            });
        }
        tbody.innerHTML = html;
        document.querySelector('.cart-summary strong').textContent = 'Tổng cộng: ' + formatCurrency(grandTotal);
        document.querySelector('.checkout-btn').disabled = cartItems.length === 0;
    }
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
</script>
</body>
</html>