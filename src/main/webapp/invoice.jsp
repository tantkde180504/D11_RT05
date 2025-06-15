<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head><title>Hóa đơn</title></head>
<body>
    <h2>HÓA ĐƠN ĐƠN HÀNG</h2>
    <p>Mã đơn: #ORD${order.orderId}</p>
    <p>Ngày đặt: ${order.orderDate}</p>
    <p>Tổng tiền: ${order.totalAmount} VND</p>
    <p>Trạng thái: ${order.statusId}</p>
    <a href="/staff/orders">Quay lại</a>
</body>
</html>
