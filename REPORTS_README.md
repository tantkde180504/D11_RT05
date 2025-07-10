# 📊 Hệ thống Báo cáo Dashboard 43 Gundam Hobby

## Tổng quan
Hệ thống báo cáo quản trị hoàn chỉnh cho cửa hàng mô hình Gundam với 7 loại báo cáo khác nhau và tính năng xuất file Excel, PDF, Print.

## ✨ Tính năng chính

### 🎯 7 Loại báo cáo được hỗ trợ:
1. **📈 Báo cáo doanh thu** - Theo ngày/tháng/năm
2. **📋 Báo cáo trạng thái đơn hàng** - Phân tích trạng thái 
3. **💳 Báo cáo phương thức thanh toán** - Thống kê các phương thức
4. **📊 Báo cáo tổng quan nâng cao** - Tổng hợp đầy đủ
5. **🏆 Báo cáo sản phẩm bán chạy** - Top products
6. **📂 Báo cáo doanh thu theo danh mục** - Phân tích category
7. **📝 Báo cáo chi tiết đơn hàng** - Chi tiết từng order

### 📤 Xuất báo cáo:
- **📊 Excel (.xlsx)** - Sử dụng SheetJS với styling
- **📄 PDF (.pdf)** - Sử dụng jsPDF với AutoTable
- **🖨️ Print** - In trực tiếp với CSS tối ưu

### 📊 Biểu đồ trực quan:
- Line chart cho doanh thu theo thời gian
- Doughnut chart cho phân bố trạng thái/danh mục
- Bar chart cho top products và payment methods
- Pie chart cho tổng quan

## 🛠️ Cấu trúc code

### Backend (Java Spring)
```
src/main/java/com/mycompany/
├── ReportsController.java    # REST API endpoints
├── ReportsService.java       # Business logic layer  
└── ReportsRepository.java    # Data access layer
```

### Frontend (JavaScript)
```
src/main/webapp/js/
└── reports-management.js     # Reports UI logic
```

### UI (JSP)
```
src/main/webapp/
└── dashboard.jsp            # Admin dashboard với reports tab
```

## 🎮 Cách sử dụng

### 1. Truy cập Dashboard
- URL: `http://localhost:8080/dashboard.jsp`
- Click tab **"Báo cáo"**

### 2. Tạo báo cáo
1. Chọn **Loại báo cáo** từ dropdown
2. Chọn **Nhóm theo** (cho báo cáo doanh thu): ngày/tháng/năm
3. Chọn **Từ ngày** và **Đến ngày**
4. Click **"Tạo báo cáo"**

### 3. Xuất báo cáo
Sau khi tạo báo cáo thành công:
- Click **Excel** để xuất file .xlsx
- Click **PDF** để xuất file .pdf  
- Click **In** để in trực tiếp

## 🔧 API Endpoints

### Báo cáo cơ bản
```http
GET /api/reports/revenue?startDate=2024-01-01&endDate=2024-12-31&periodType=month
GET /api/reports/status?startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/payment?startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/summary?startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/top-products?startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/category?startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/detailed?startDate=2024-01-01&endDate=2024-12-31
```

### Export endpoints
```http
GET /api/reports/export/excel?reportType=revenue&startDate=2024-01-01&endDate=2024-12-31
GET /api/reports/export/pdf?reportType=status&startDate=2024-01-01&endDate=2024-12-31
```

## 📋 Dữ liệu mẫu

Hệ thống sử dụng dữ liệu thực từ bảng `orders` với cấu trúc:
```sql
orders (
    id, order_number, order_date, total_amount, 
    status, payment_method, shipping_name, ...
)
```

Các trạng thái đơn hàng:
- `PENDING` - Chờ xử lý
- `CONFIRMED` - Đã xác nhận  
- `SHIPPING` - Đang giao
- `DELIVERED` - Đã giao
- `CANCELLED` - Đã hủy

Phương thức thanh toán:
- `COD` - Thanh toán khi nhận hàng
- `BANK_TRANSFER` - Chuyển khoản ngân hàng
- `MOMO` - Ví MoMo
- `VNPAY` - VNPay

## 🎨 Giao diện

### Desktop
- Layout responsive với sidebar navigation
- Charts được hiển thị bằng Chart.js
- Tables với Bootstrap styling
- Export buttons trong toolbar

### Print Layout
- CSS print-specific đã được tối ưu
- Header/footer tự động cho mỗi trang
- Ẩn các element không cần thiết
- Typography và spacing phù hợp cho in

## 🔍 Debugging

### Backend logs
```bash
# Check Spring Boot logs
tail -f logs/application.log

# Database query logs
# Enable SQL logging in application.properties
```

### Frontend debugging
```javascript
// Console logs available
console.log(currentReportData);

// Check network requests in DevTools
// Verify API responses in Network tab
```

## 📚 Dependencies

### Frontend Libraries
- **Chart.js 4.4.0** - Biểu đồ interactive
- **SheetJS 0.18.5** - Excel export
- **jsPDF 2.5.1** - PDF generation
- **jsPDF-AutoTable 3.5.31** - PDF tables
- **Bootstrap 5.3.2** - UI framework

### Backend Dependencies
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
    </dependency>
    <!-- MySQL connector, Jackson JSON, etc. -->
</dependencies>
```

## 🚀 Cải tiến trong tương lai

1. **Real-time updates** với WebSocket
2. **Scheduled reports** tự động gửi email
3. **Dashboard widgets** có thể tùy chỉnh
4. **Advanced filtering** với date ranges presets
5. **Mobile responsive** cho tablet/phone
6. **Role-based access** cho từng loại báo cáo
7. **Data visualization** nâng cao với D3.js

## 🐛 Troubleshooting

### Lỗi thường gặp:

1. **"Không có dữ liệu"**
   - Kiểm tra khoảng thời gian đã chọn
   - Verify database connection
   - Check data exists in orders table

2. **Export file không hoạt động**
   - Check browser supports file download
   - Verify libraries loaded (XLSX, jsPDF)
   - Check console for JavaScript errors

3. **Biểu đồ không hiển thị**
   - Check Chart.js library loaded
   - Verify canvas element exists
   - Check data format from API

4. **Print styles không đúng**
   - Check CSS print media queries
   - Verify no-print classes applied correctly
   - Test in print preview mode

## 📞 Hỗ trợ

Để được hỗ trợ kỹ thuật:
1. Check logs cho error messages
2. Verify database connection
3. Test API endpoints trực tiếp
4. Check browser console for JS errors

---

**🎯 Hệ thống báo cáo đã được hoàn thiện và sẵn sàng sử dụng!**

*Phiên bản: 1.0.0 | Cập nhật: 07/07/2025*
