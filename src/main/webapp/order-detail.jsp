<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết đơn hàng</title>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h3 class="mb-4">📄 Chi tiết đơn hàng</h3>
    <div id="order-detail" class="border rounded p-4 bg-light">Đang tải...</div>
    <a href="/staffsc.jsp" class="btn btn-secondary mt-3">← Quay lại</a>
</div>

<script>
    // Lấy orderId từ URL (query string ?orderId=...)
    const params = new URLSearchParams(window.location.search);
    const orderId = params.get("orderId");

    if (!orderId) {
        document.getElementById("order-detail").innerHTML = "❌ Thiếu orderId trên URL";
    } else {
        fetch(`/api/orders/detail?orderId=${orderId}`)
            .then(res => {
                if (!res.ok) throw new Error("Không tìm thấy đơn hàng");
                return res.json();
            })
            .then(data => {
                const html = `
                    <p><strong>Mã đơn hàng:</strong> #${data.orderNumber}</p>
                    <p><strong>Khách hàng:</strong> ${data.shippingName}</p>
                    <p><strong>Số điện thoại:</strong> ${data.shippingPhone}</p>
                    <p><strong>Địa chỉ:</strong> ${data.shippingAddress}</p>
                    <p><strong>Ngày đặt:</strong> ${data.orderDate}</p>
                    <p><strong>Trạng thái:</strong> ${data.status}</p>
                    <p><strong>Thanh toán:</strong> ${data.paymentMethod}</p>
                    <p><strong>Tổng tiền:</strong> <span class="text-danger fw-bold">${formatCurrency(data.totalAmount)}</span></p>
                `;
                document.getElementById("order-detail").innerHTML = html;
            })
            .catch(err => {
                document.getElementById("order-detail").innerHTML = `❌ ${err.message}`;
            });
    }

    function formatCurrency(amount) {
        return Number(amount).toLocaleString('vi-VN') + "₫";
    }
</script>
</body>
</html>
