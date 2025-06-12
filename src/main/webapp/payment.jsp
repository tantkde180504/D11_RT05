<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-7">
                    <div class="checkout-section mb-4">
                        <div class="checkout-title"><i class="fas fa-receipt me-2"></i>Thông tin thanh toán</div>
                        <form>
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
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" placeholder="Nhập email (nếu có)">
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
                                        Chuyển khoản ngân hàng
                                    </label>
                                </div>
                                <div id="qr-section" class="mt-3" style="display:none;">
                                    <div class="alert alert-info py-2 mb-2">
                                        Vui lòng quét mã QR bên dưới để chuyển khoản thanh toán.
                                    </div>
                                    <img src="https://img.vietqr.io/image/VCB-0123456789-compact2.jpg"
                                        alt="QR chuyển khoản" style="max-width:220px;display:block;margin:auto;">
                                    <div class="text-center mt-2 small text-muted">Nội dung chuyển khoản:
                                        <b>ThanhToanDonHang</b></div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-danger w-100 py-2 fs-5">Đặt hàng</button>
                        </form>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="order-summary shadow-sm mb-4">
                        <h5 class="mb-3"><i class="fas fa-list-ul me-2"></i>Đơn hàng của bạn</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span>RG RX-78-2 Gundam x 1</span>
                            <span>650.000₫</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="fw-bold">Tạm tính</span>
                            <span class="fw-bold">650.000₫</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phí vận chuyển</span>
                            <span>Miễn phí</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="fw-bold text-danger">Tổng cộng</span>
                            <span class="fw-bold fs-5 text-danger">650.000₫</span>
                        </div>
                    </div>
                    <a href="cart.jsp" class="btn btn-outline-secondary w-100"><i
                            class="fas fa-arrow-left me-1"></i>Quay lại giỏ hàng</a>
                </div>
            </div>
        </div>
    </body>

    </html>