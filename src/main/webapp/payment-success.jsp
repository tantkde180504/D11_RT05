<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thành công | 43 Gundam Hobby</title>
    
    <jsp:include page="includes/unified-css.jsp" />
</head>
<body style="background:#f5f5f5;">
    <!-- Header -->
    <jsp:include page="includes/unified-header.jsp" />

    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card text-center">
                    <div class="card-body p-5">
                        <div class="text-success mb-4">
                            <i class="fas fa-check-circle fa-5x"></i>
                        </div>
                        <h2 class="text-success mb-3">Thanh toán thành công!</h2>
                        <p class="mb-4">Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được xử lý thành công.</p>
                        
                        <div class="mb-4">
                            <p><strong>Mã đơn hàng:</strong> ${orderNumber}</p>
                            <p><strong>Tổng tiền:</strong> ${totalAmount} VNĐ</p>
                        </div>
                        
                        <div class="d-grid gap-2">
                            <a href="<%= contextPath %>/order-history.jsp" class="btn btn-primary">
                                <i class="fas fa-history me-2"></i>Xem lịch sử đơn hàng
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
        // Xóa selectedCartIds sau khi thanh toán thành công
        console.log('Payment success page loaded - clearing selectedCartIds');
        localStorage.removeItem('selectedCartIds');
        localStorage.removeItem('buyNowItem');
        localStorage.removeItem('buyNowMode');
        
        // Gọi API để confirm payment nếu chưa được gọi
        const urlParams = new URLSearchParams(window.location.search);
        const orderCode = urlParams.get('orderCode');
        
        if (orderCode) {
            // Gọi API confirm payment
            fetch('/api/payment/payos/confirm', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    orderCode: orderCode,
                    status: 'PAID'
                })
            }).then(response => response.json())
              .then(data => {
                  console.log('Payment confirmation result:', data);
              }).catch(error => {
                  console.error('Error confirming payment:', error);
              });
        }
    </script>

    <!-- Scripts -->
    <jsp:include page="includes/unified-scripts.jsp" />
</body>
</html>





