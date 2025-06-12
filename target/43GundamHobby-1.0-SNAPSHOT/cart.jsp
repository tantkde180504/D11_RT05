<!-- filepath: c:\Users\ROG STRIX\Documents\RT05\D11_RT05\src\main\webapp\cart.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container py-5">
        <h2 class="mb-4 text-center"><i class="fas fa-shopping-cart me-2"></i>Giỏ hàng</h2>
        <div class="row">
            <div class="col-lg-8">
                <form>
                    <table class="table cart-table align-middle border">
                        <thead class="table-light">
                            <tr>
                                <th></th>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dữ liệu mẫu, thay bằng dữ liệu động sau -->
                            <tr>
                                <td>
                                    <img src="https://via.placeholder.com/70x70/cccccc/666666?text=RG+RX-78" alt="RG RX-78-2 Gundam">
                                </td>
                                <td>
                                    <a href="#" class="text-decoration-none text-dark fw-semibold">RG RX-78-2 Gundam</a>
                                </td>
                                <td>650.000₫</td>
                                <td style="max-width:100px;">
                                    <input type="number" class="form-control" value="1" min="1">
                                </td>
                                <td>650.000₫</td>
                                <td>
                                    <button type="button" class="btn btn-outline-danger btn-sm"><i class="fas fa-trash"></i></button>
                                </td>
                            </tr>
                            <!-- Hết dữ liệu mẫu -->
                        </tbody>
                    </table>
                    <div class="d-flex justify-content-between cart-actions mt-3">
                        <a href="index.jsp" class="btn btn-outline-secondary"><i class="fas fa-arrow-left me-1"></i>Tiếp tục mua hàng</a>
                        <button type="submit" class="btn btn-outline-primary">Cập nhật giỏ hàng</button>
                    </div>
                </form>
            </div>
            <div class="col-lg-4">
                <div class="cart-summary shadow-sm">
                    <h5 class="mb-3">Tổng đơn hàng</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span>Tạm tính:</span>
                        <span>650.000₫</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span>Phí vận chuyển:</span>
                        <span>Miễn phí</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between mb-4">
                        <span class="fw-bold">Tổng cộng:</span>
                        <span class="fw-bold fs-5 text-danger">650.000₫</span>
                    </div>
                    <a href="payment.jsp" class="btn btn-danger w-100 mb-2">Thanh toán</a>
                    <a href="index.jsp" class="btn btn-outline-secondary w-100">Tiếp tục mua hàng</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>