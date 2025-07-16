<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán bị hủy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body style="background:#f5f5f5;">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="card-body p-5">
                        <div class="text-warning mb-4">
                            <i class="fas fa-exclamation-triangle fa-5x"></i>
                        </div>
                        <h2 class="text-warning mb-3">Thanh toán bị hủy</h2>
                        <p class="mb-4">Giao dịch của bạn đã bị hủy. Giỏ hàng vẫn được giữ nguyên để bạn có thể thử lại.</p>
                        
                        <div class="d-grid gap-2">
                            <a href="<%= contextPath %>/cart.jsp" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>Quay lại giỏ hàng
                            </a>
                            <a href="<%= contextPath %>/index.jsp" class="btn btn-outline-secondary">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Gọi API để cancel payment nếu có orderCode
        const urlParams = new URLSearchParams(window.location.search);
        const orderCode = urlParams.get('orderCode');
        
        if (orderCode) {
            // Gọi API confirm payment với status CANCELLED
            fetch('/api/payment/payos/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    orderCode: orderCode,
                    status: 'CANCELLED'
                })
            }).then(response => response.json())
              .then(data => {
                  console.log('Payment cancellation result:', data);
              }).catch(error => {
                  console.error('Error cancelling payment:', error);
              });
        }
    </script>
</body>
</html>
