# Hướng dẫn khắc phục lỗi PayOS Integration

## Lỗi đã sửa: CHECK Constraint Violation

### Vấn đề:
```
The INSERT statement conflicted with the CHECK constraint "CK__orders__payment___73BA3083". 
The conflict occurred in database "gundamhobby", table "dbo.orders", column 'payment_method'.
```

### Nguyên nhân:
Database có CHECK constraint chỉ cho phép các giá trị sau cho cột `payment_method`:
- `'COD'`
- `'BANK_TRANSFER'` 
- `'MOMO'`
- `'VNPAY'`
- `'CREDIT_CARD'`

Nhưng code đang cố gắng lưu giá trị `'PAYOS'` không có trong danh sách.

### Giải pháp đã áp dụng:

1. **Thay đổi PaymentController.java:**
   ```java
   // Từ:
   if ("PAYOS".equalsIgnoreCase(paymentMethod)) {
   
   // Thành:
   if ("BANK_TRANSFER".equalsIgnoreCase(paymentMethod)) {
   ```

2. **Thay đổi payment.jsp:**
   ```javascript
   // Từ:
   paymentMethod: 'PAYOS'
   
   // Thành:
   paymentMethod: 'BANK_TRANSFER'
   ```

3. **Logic hiện tại:**
   - Khi khách hàng chọn "PayOS" trên giao diện
   - Hệ thống sẽ lưu `payment_method = 'BANK_TRANSFER'` trong database
   - PayOS vẫn được sử dụng để xử lý thanh toán
   - Database constraint được tuân thủ

## Cách test sau khi sửa:

### 1. Test cấu hình PayOS:
```
GET /api/test/config
```

### 2. Test tạo payment link:
```
POST /api/test/payos
```

### 3. Test flow hoàn chỉnh:
1. Mở trang test: `http://localhost:8080/test-payos.html`
2. Click "Test Cấu hình"
3. Click "Test Tạo Payment Link"
4. Kiểm tra link PayOS có tạo thành công không

### 4. Test thanh toán thực tế:
1. Thêm sản phẩm vào giỏ hàng
2. Vào trang thanh toán (`payment.jsp`)
3. Chọn "Thanh toán qua PayOS"
4. Điền thông tin giao hàng
5. Click "Đặt hàng"
6. Kiểm tra có chuyển hướng tới PayOS không

## Lưu ý quan trọng:

1. **PayOS credentials:** Đảm bảo đã cập nhật đúng thông tin trong `application.properties`:
   ```properties
   payos.client-id=1e486ec0-9fac-4d03-9f38-c30f9987e1f0
   payos.api-key=0993fd87-b82f-4d17-8ebc-e47deb600a9a
   payos.checksum-key=882ff1d4a906a720c4c4ac414a2def108b0eea3f2735950dc96e80315502a8c7
   ```

2. **Database consistency:** Tất cả PayOS payments sẽ có `payment_method = 'BANK_TRANSFER'` trong database

3. **Business logic:** Có thể thêm trường riêng để phân biệt loại bank transfer (PayOS vs transfer thường) nếu cần

## Troubleshooting tiếp theo:

### Nếu vẫn gặp lỗi database:
1. Kiểm tra connection string
2. Kiểm tra user permissions
3. Restart application

### Nếu PayOS API không hoạt động:
1. Kiểm tra network connectivity
2. Kiểm tra PayOS credentials
3. Kiểm tra PayOS service status

### Nếu payment flow không hoàn chỉnh:
1. Kiểm tra success/cancel URLs
2. Kiểm tra JavaScript console errors
3. Kiểm tra application logs
