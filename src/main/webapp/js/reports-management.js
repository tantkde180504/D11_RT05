let currentReportData = null;
let reportChart = null;

// 🚀 KHỞI TẠO KHI TRANG LOAD
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 DOMContentLoaded - reports-management.js loaded!');
    
    updateReportTitle();
    
    // Event listeners
    document.getElementById('reportType').addEventListener('change', function() {
        updateReportTitle();
        togglePeriodType();
    });
    
    // ✅ THÊM EVENT LISTENER CHO BUTTON TẠO BÁO CÁO
    const generateBtn = document.getElementById('generateReport');
    if (generateBtn) {
        generateBtn.addEventListener('click', function() {
            console.log('🎯 Button clicked!');
            generateReport();
        });
        console.log('✅ Event listener đã được gắn vào button generateReport');
    } else {
        console.error('❌ Không tìm thấy button generateReport');
    }
    
    // Set default dates
    const today = new Date();
    const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
    
    document.getElementById('endDate').value = formatDate(today);
    document.getElementById('startDate').value = formatDate(lastWeek);
    
    // Set default month (current month) 
    const currentMonth = today.toISOString().slice(0, 7); // yyyy-MM format
    document.getElementById('monthPicker').value = currentMonth;
    
    // Set default year (current year)
    document.getElementById('yearPicker').value = today.getFullYear();
    
    updateReportTitle();
    togglePeriodType();
    showReportPlaceholder();

    // Thiết lập nút xuất Excel và In
    setupExportButtons();

    document.getElementById('periodType').addEventListener('change', function() {
        togglePeriodType();
    });
    document.getElementById('monthPicker').addEventListener('change', function() {
        const val = this.value; // yyyy-MM
        if (val) {
            const [year, month] = val.split('-');
            const firstDay = `${year}-${month}-01`;
            const lastDay = new Date(year, month, 0).toISOString().split('T')[0];
            document.getElementById('startDate').value = firstDay;
            document.getElementById('endDate').value = lastDay;
        }
    });
    document.getElementById('yearPicker').addEventListener('change', function() {
        const year = this.value;
        if (year) {
            document.getElementById('startDate').value = `${year}-01-01`;
            document.getElementById('endDate').value = `${year}-12-31`;
        }
    });
});

// 📋 CẬP NHẬT TIÊU ĐỀ BÁO CÁO
function updateReportTitle() {
    const reportType = document.getElementById('reportType').value;
    const titleElement = document.getElementById('reportTitle');
    
    const titles = {
        'revenue': '📈 Báo cáo doanh thu theo thời gian',
        'top-products': '🏆 Báo cáo sản phẩm bán chạy',
        'category': '📂 Báo cáo doanh thu theo danh mục'
    };
    
    titleElement.innerHTML = titles[reportType] || '📊 Báo cáo';
}

// 🔄 TOGGLE PERIOD TYPE CHO REVENUE REPORT
function togglePeriodType() {
    const reportType = document.getElementById('reportType').value;
    const periodType = document.getElementById('periodType').value;
    const periodTypeContainer = document.getElementById('periodTypeContainer');
    const monthPickerContainer = document.getElementById('monthPickerContainer');
    const yearPickerContainer = document.getElementById('yearPickerContainer');
    
    // Tìm các container của start/end date bằng query selector
    const startDateContainer = document.querySelector('.col-md-2.mb-3:has(#startDate)') || 
                              document.querySelector('input#startDate').closest('.col-md-2');
    const endDateContainer = document.querySelector('.col-md-2.mb-3:has(#endDate)') || 
                            document.querySelector('input#endDate').closest('.col-md-2');

    if (reportType === 'revenue' || reportType === 'category') {
        periodTypeContainer.style.display = 'block';
        
        if (periodType === 'month') {
            // Hiển thị month picker, ẩn date range
            if (monthPickerContainer) monthPickerContainer.style.display = 'block';
            if (yearPickerContainer) yearPickerContainer.style.display = 'none';
            if (startDateContainer) startDateContainer.style.display = 'none';
            if (endDateContainer) endDateContainer.style.display = 'none';
        } else if (periodType === 'year') {
            // Hiển thị year picker, ẩn date range
            if (yearPickerContainer) yearPickerContainer.style.display = 'block';
            if (monthPickerContainer) monthPickerContainer.style.display = 'none';
            if (startDateContainer) startDateContainer.style.display = 'none';
            if (endDateContainer) endDateContainer.style.display = 'none';
        } else {
            // Hiển thị date range (theo ngày), ẩn month/year picker
            if (monthPickerContainer) monthPickerContainer.style.display = 'none';
            if (yearPickerContainer) yearPickerContainer.style.display = 'none';
            if (startDateContainer) startDateContainer.style.display = 'block';
            if (endDateContainer) endDateContainer.style.display = 'block';
        }
    } else {
        // Với các loại báo cáo khác, ẩn period type và chỉ hiển thị date range
        periodTypeContainer.style.display = 'none';
        if (monthPickerContainer) monthPickerContainer.style.display = 'none';
        if (yearPickerContainer) yearPickerContainer.style.display = 'none';
        if (startDateContainer) startDateContainer.style.display = 'block';
        if (endDateContainer) endDateContainer.style.display = 'block';
    }
}

// 📅 FORMAT DATE CHO INPUT
function formatDate(date) {
    return date.toISOString().split('T')[0];
}

// 📅 FORMAT DATE CHO API
function formatDateForAPI(dateString) {
    if (!dateString) return '';
    
    if (dateString.match(/^\d{4}-\d{2}-\d{2}$/)) {
        return dateString;
    }
    
    const date = new Date(dateString);
    return date.toISOString().split('T')[0];
}

// 🎯 TẠO BÁO CÁO CHÍNH
function generateReport() {
    console.log('🚀 generateReport() được gọi!');
    
    const reportType = document.getElementById('reportType').value;
    const periodType = document.getElementById('periodType').value;
    let startDateInput = document.getElementById('startDate').value;
    let endDateInput = document.getElementById('endDate').value;
    
    if (periodType === 'month') {
        const val = document.getElementById('monthPicker').value;
        if (!val) {
            showError('Vui lòng chọn tháng');
            return;
        }
        const [year, month] = val.split('-');
        startDateInput = `${year}-${month}-01`;
        endDateInput = new Date(year, month, 0).toISOString().split('T')[0];
    } else if (periodType === 'year') {
        const year = document.getElementById('yearPicker').value;
        if (!year) {
            showError('Vui lòng chọn năm');
            return;
        }
        startDateInput = `${year}-01-01`;
        endDateInput = `${year}-12-31`;
    }

    console.log('=== GENERATE REPORT DEBUG ===');
    console.log('Report Type:', reportType);
    console.log('Start Date Input:', startDateInput);
    console.log('End Date Input:', endDateInput);
    
    if (!startDateInput || !endDateInput) {
        showError('Vui lòng chọn khoảng thời gian');
        return;
    }
    
    const startDate = formatDateForAPI(startDateInput);
    const endDate = formatDateForAPI(endDateInput);
    
    console.log('Formatted Start Date:', startDate);
    console.log('Formatted End Date:', endDate);
    
    if (new Date(startDate) > new Date(endDate)) {
        showError('Ngày bắt đầu không thể lớn hơn ngày kết thúc');
        return;
    }
    
    showLoading();
    
    let url = `/api/reports/${reportType}?startDate=${startDate}&endDate=${endDate}`;
    
    if (reportType === 'revenue' || reportType === 'category') {
        const periodType = document.getElementById('periodType').value;
        url += `&periodType=${periodType}`;
        console.log('Period Type:', periodType);
    }
    
    console.log('API URL:', url);
    
    fetch(url)
        .then(response => {
            console.log('Response Status:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('Response Data:', data);
            hideLoading();
            
            if (data.error) {
                showError(data.message || 'Có lỗi xảy ra khi tạo báo cáo');
                disableExportButtons();
            } else {
                console.log('🔍 DEBUG - Saving currentReportData:', data);
                console.log('🔍 DEBUG - Data type:', typeof data);
                console.log('🔍 DEBUG - Data length:', Array.isArray(data) ? data.length : 'Not array');
                currentReportData = data;
                displayReport(reportType, data);
                enableExportButtons();
                showSuccess('Tạo báo cáo thành công!');
            }
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            hideLoading();
            showError('Lỗi kết nối: ' + error.message);
        });
}

// 📊 HIỂN THỊ BÁO CÁO THEO LOẠI
function displayReport(reportType, data) {
    console.log('Displaying report type:', reportType);
    console.log('Data:', data);
    
    switch (reportType) {
        case 'revenue':
            displayRevenueReport(data);
            break;
        case 'top-products':
            displayTopProductsReport(data);
            break;
        case 'category':
            displayCategoryReport(data);
            break;
        default:
            showError('Loại báo cáo không được hỗ trợ: ' + reportType);
    }
}

// 📈 HIỂN THỊ BÁO CÁO DOANH THU
function displayRevenueReport(data) {
    console.log('🎯 DEBUG - data:', data);
    console.log('🎯 DEBUG - data keys:', Object.keys(data));
    console.log('🎯 DEBUG - periodRevenue:', data.periodRevenue);
    
    const reportContent = document.getElementById('reportContent');
    
    if (!data.periodRevenue || data.periodRevenue.length === 0) {
        showReportPlaceholder();
        return;
    }
    
    const periodType = data.periodType || 'day';
    const periodText = periodType === 'day' ? 'Ngày' : 
                      periodType === 'month' ? 'Tháng' : 'Năm';

    // 🎨 THỐNG KÊ TỔNG QUAN - HÀNG NGANG 4 CỘT (MÀU NỔI BẬT, ICON TO, CHỮ TRẮNG)
    let statsHTML = `
        <div style="display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 200px; background: linear-gradient(135deg, #ff9800 0%, #ff6600 100%); color: #fff; border-radius: 16px; box-shadow: 0 2px 12px rgba(255,102,0,0.08); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px 0;">
                <div style="font-size: 2.5rem; margin-bottom: 8px;"><i class="fas fa-shopping-cart"></i></div>
                <div style="font-size: 2.2rem; font-weight: bold;">${data.totalOrders || 0}</div>
                <div style="font-size: 1.1rem; margin-top: 4px;">Tổng đơn hàng</div>
            </div>
            <div style="flex: 1; min-width: 200px; background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); color: #fff; border-radius: 16px; box-shadow: 0 2px 12px rgba(67,233,123,0.08); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px 0;">
                <div style="font-size: 2.5rem; margin-bottom: 8px;"><i class="fas fa-dollar-sign"></i></div>
                <div style="font-size: 2.2rem; font-weight: bold;">${formatCurrency(data.totalRevenue || 0)}</div>
                <div style="font-size: 1.1rem; margin-top: 4px;">Tổng doanh thu</div>
            </div>
            <div style="flex: 1; min-width: 200px; background: linear-gradient(135deg, #2196f3 0%, #21cbf3 100%); color: #fff; border-radius: 16px; box-shadow: 0 2px 12px rgba(33,150,243,0.08); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px 0;">
                <div style="font-size: 2.5rem; margin-bottom: 8px;"><i class="fas fa-truck"></i></div>
                <div style="font-size: 2.2rem; font-weight: bold;">${data.deliveredOrders || 0}</div>
                <div style="font-size: 1.1rem; margin-top: 4px;">Đã giao hàng</div>
            </div>
            <div style="flex: 1; min-width: 200px; background: linear-gradient(135deg, #ffd600 0%, #ffea00 100%); color: #333; border-radius: 16px; box-shadow: 0 2px 12px rgba(255,214,0,0.08); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 24px 0;">
                <div style="font-size: 2.5rem; margin-bottom: 8px;"><i class="fas fa-chart-line"></i></div>
                <div style="font-size: 2.2rem; font-weight: bold;">${formatCurrency(data.averageOrderValue || 0)}</div>
                <div style="font-size: 1.1rem; margin-top: 4px;">Giá trị TB/đơn</div>
            </div>
        </div>
    `;

    // 📊 BẢNG CHI TIẾT THEO THỜI GIAN
    let tableHTML = `
        <div class="card shadow-sm border-0">
            <div class="card-header bg-dark text-white">
                <h5 class="mb-0">
                    <i class="fas fa-table me-2"></i>
                    Chi tiết doanh thu theo ${periodText.toLowerCase()}
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th class="py-3"><i class="fas fa-calendar-alt me-2 text-primary"></i>${periodText}</th>
                                <th class="py-3"><i class="fas fa-shopping-cart me-2 text-info"></i>Số đơn hàng</th>
                                <th class="py-3"><i class="fas fa-dollar-sign me-2 text-success"></i>Doanh thu</th>
                                <th class="py-3"><i class="fas fa-chart-line me-2 text-warning"></i>TB/đơn</th>
                            </tr>
                        </thead>
                        <tbody>
    `;
    
    data.periodRevenue.forEach((period, index) => {
        const orders = period.order_count || 0;
        const revenue = period.total_revenue || 0;
        const avgPerOrder = orders > 0 ? revenue / orders : 0;
        
        // Màu alternate cho mỗi row
        const rowClass = index % 2 === 0 ? '' : 'table-light';
        
        tableHTML += `
            <tr class="${rowClass}">
                <td class="py-3 fw-semibold">
                    <i class="fas fa-calendar-day me-2 text-muted"></i>
                    ${formatPeriodDate(period.period_date, periodType)}
                </td>
                <td class="py-3">
                    <span class="badge bg-primary fs-6 px-3 py-2">${orders}</span>
                </td>
                <td class="py-3">
                    <span class="text-success fw-bold fs-6">${formatCurrency(revenue)}</span>
                </td>
                <td class="py-3">
                    <span class="text-warning fw-semibold">${formatCurrency(avgPerOrder)}</span>
                </td>
            </tr>
        `;
    });

    tableHTML += `
                        </tbody>
                        <tfoot class="table-dark">
                            <tr class="fw-bold">
                                <td class="py-3">
                                    <i class="fas fa-calculator me-2"></i>
                                    TỔNG CỘNG
                                </td>
                                <td class="py-3">
                                    <span class="badge bg-light text-dark fs-6 px-3 py-2">${data.totalOrders || 0}</span>
                                </td>
                                <td class="py-3 text-warning">
                                    ${formatCurrency(data.totalRevenue || 0)}
                                </td>
                                <td class="py-3 text-info">
                                    ${formatCurrency(data.averageOrderValue || 0)}
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    `;
    
    // Hiển thị stats + table (BỎ BIỂU ĐỒ HOÀN TOÀN)
    reportContent.innerHTML = statsHTML + tableHTML;
    
    // Ẩn chart container
    const chartContainer = document.getElementById('chartContainer');
    if (chartContainer) {
        chartContainer.style.display = 'none';
    }
}

// 🏆 HIỂN THỊ BÁO CÁO SẢN PHẨM BÁN CHẠY
function displayTopProductsReport(data) {
    const reportContent = document.getElementById('reportContent');
    
    if (!data.topProducts || data.topProducts.length === 0) {
        showReportPlaceholder();
        return;
    }
    
    let tableHTML = `
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th><i class="fas fa-trophy me-1"></i>Hạng</th>
                        <th><i class="fas fa-tag me-1"></i>Tên sản phẩm</th>
                        <th><i class="fas fa-industry me-1"></i>Thương hiệu</th>
                        <th><i class="fas fa-shopping-cart me-1"></i>Số lượng bán</th>
                        <th><i class="fas fa-dollar-sign me-1"></i>Doanh thu</th>
                        <th><i class="fas fa-receipt me-1"></i>Số đơn</th>
                    </tr>
                </thead>
                <tbody>
    `;
    
    data.topProducts.forEach((product, index) => {
        const ranking = index + 1;
        const badge = ranking <= 3 ? 'bg-warning' : 'bg-secondary';
        const icon = ranking === 1 ? '🥇' : ranking === 2 ? '🥈' : ranking === 3 ? '🥉' : '';
        
        const quantity = product.total_sold || product.total_quantity || product.order_count || 0;
        const revenue = product.total_revenue || 0;
        const avgPrice = quantity > 0 ? revenue / quantity : 0;
        
        tableHTML += `
            <tr>
                <td><span class="badge ${badge} fs-6">${icon} ${ranking}</span></td>
                <td><strong>${product.name || product.product_name}</strong></td>
                <td>${product.brand || 'N/A'}</td>
                <td><span class="badge bg-primary">${quantity}</span></td>
                <td class="text-success fw-bold">${formatCurrency(revenue)}</td>
                <td class="text-muted">${formatCurrency(avgPrice)}</td>
            </tr>
        `;
    });
    
    tableHTML += `</tbody></table></div>`;
    
    reportContent.innerHTML = tableHTML;
    
    // Ẩn chart container
    const chartContainer = document.getElementById('chartContainer');
    if (chartContainer) {
        chartContainer.style.display = 'none';
    }
}

// 📂 HIỂN THỊ BÁO CÁO THEO DANH MỤC
function displayCategoryReport(data) {
    const reportContent = document.getElementById('reportContent');
    
    if (!data.categoryData || data.categoryData.length === 0) {
        showReportPlaceholder();
        return;
    }
    
    let tableHTML = `
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th><i class="fas fa-list me-1"></i>Danh mục</th>
                        <th><i class="fas fa-cubes me-1"></i>Số sản phẩm</th>
                        <th><i class="fas fa-shopping-cart me-1"></i>Số lượng bán</th>
                        <th><i class="fas fa-dollar-sign me-1"></i>Doanh thu</th>
                        <th><i class="fas fa-percentage me-1"></i>% Tổng doanh thu</th>
                    </tr>
                </thead>
                <tbody>
    `;
    
    const totalRevenue = data.categoryData.reduce((sum, cat) => sum + (cat.total_revenue || 0), 0);
    
    data.categoryData.forEach(category => {
        const revenue = category.total_revenue || 0;
        const percentage = totalRevenue > 0 ? (revenue / totalRevenue * 100).toFixed(1) : 0;
        
        tableHTML += `
            <tr>
                <td><strong>${category.category_name || category.name}</strong></td>
                <td><span class="badge bg-info">${category.products_sold || 0}</span></td>
                <td><span class="badge bg-primary">${category.total_quantity || 0}</span></td>
                <td class="text-success fw-bold">${formatCurrency(revenue)}</td>
                <td>
                    <div class="progress" style="height: 20px;">
                        <div class="progress-bar bg-success" style="width: ${percentage}%">${percentage}%</div>
                    </div>
                </td>
            </tr>
        `;
    });
    
    tableHTML += `</tbody></table></div>`;
    
    reportContent.innerHTML = tableHTML;
    
    // Ẩn chart container
    const chartContainer = document.getElementById('chartContainer');
    if (chartContainer) {
        chartContainer.style.display = 'none';
    }
}

// 🛠️ UTILITY FUNCTIONS 
function formatPeriodDate(dateString, periodType) {
    if (!dateString) return '';
    
    if (periodType === 'day') {
        const date = new Date(dateString);
        const weekdays = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
        return `${date.getDate().toString().padStart(2, '0')}/${(date.getMonth()+1).toString().padStart(2, '0')} (${weekdays[date.getDay()]})`;
    } else if (periodType === 'month') {
        const [year, month] = dateString.split('-');
        return `${month}/${year}`;
    } else if (periodType === 'year') {
        return dateString;
    }
    
    return dateString;
}

function formatCurrency(amount) {
    if (typeof amount !== 'number') {
        amount = parseFloat(amount) || 0;
    }
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function showLoading() {
    const loadingElement = document.getElementById('loadingOverlay');
    if (loadingElement) {
        loadingElement.style.display = 'flex';
    }
}

function hideLoading() {
    const loadingElement = document.getElementById('loadingOverlay');
    if (loadingElement) {
        loadingElement.style.display = 'none';
    }
}

function showSuccess(message) {
    console.log('✅ SUCCESS:', message);
    showNotification(message, 'success');
}

function showError(message) {
    console.error('❌ ERROR:', message);
    showNotification(message, 'error');
}

function showNotification(message, type = 'info') {
    // Tạo toast notification đơn giản
    const toast = document.createElement('div');
    toast.className = `alert alert-${type === 'error' ? 'danger' : type === 'success' ? 'success' : 'info'} alert-dismissible fade show position-fixed`;
    toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    toast.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(toast);
    
    // Tự động xóa sau 3 giây
    setTimeout(() => {
        if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
        }
    }, 3000);
}

function showReportPlaceholder() {
    const reportContent = document.getElementById('reportContent');
    if (reportContent) {
        reportContent.innerHTML = `
            <div class="report-placeholder" style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 180px; background: #fff7e6; border-radius: 12px; box-shadow: 0 2px 8px rgba(255,102,0,0.05);">
                <div style="font-size: 3rem; color: #ff9900; margin-bottom: 10px;"><i class="fas fa-file-alt"></i></div>
                <div style="font-size: 1.2rem; color: #ff6600; font-weight: 500;">Chưa có dữ liệu báo cáo</div>
                <div style="color: #888; margin-top: 4px;">Chọn loại báo cáo và nhấn <b>'Tạo báo cáo'</b> để xem dữ liệu</div>
            </div>
        `;
    }
}

// 📊 XUẤT EXCEL VÀ IN BÁO CÁO
function setupExportButtons() {
    // Nút xuất Excel
    const exportExcelBtn = document.getElementById('exportExcel');
    if (exportExcelBtn) {
        exportExcelBtn.addEventListener('click', exportToExcel);
    }
    
    // Nút in
    const exportPrintBtn = document.getElementById('exportPrintBtn');
    if (exportPrintBtn) {
        exportPrintBtn.addEventListener('click', printReport);
    }
}

// 📊 XUẤT EXCEL
function exportToExcel() {
    console.log('🔍 DEBUG exportToExcel:');
    console.log('currentReportData:', currentReportData);
    console.log('currentReportData type:', typeof currentReportData);
    
    // Kiểm tra dữ liệu - có thể là object chứa array hoặc trực tiếp là array
    let reportData = null;
    if (Array.isArray(currentReportData)) {
        reportData = currentReportData;
    } else if (currentReportData && typeof currentReportData === 'object') {
        // Xử lý theo loại báo cáo
        const reportType = document.getElementById('reportType').value;
        if (reportType === 'revenue' && currentReportData.periodRevenue) {
            reportData = currentReportData.periodRevenue;
        } else if (reportType === 'top-products' && currentReportData.topProducts) {
            reportData = currentReportData.topProducts;
        } else if (reportType === 'category' && Array.isArray(currentReportData.data)) {
            reportData = currentReportData.data;
        } else if (Array.isArray(currentReportData.data)) {
            reportData = currentReportData.data;
        } else {
            // Thử lấy property đầu tiên là array
            const keys = Object.keys(currentReportData);
            for (let key of keys) {
                if (Array.isArray(currentReportData[key])) {
                    reportData = currentReportData[key];
                    break;
                }
            }
        }
    }
    
    console.log('🔍 DEBUG reportData:', reportData);
    console.log('🔍 DEBUG reportData length:', reportData ? reportData.length : 'N/A');
    
    if (!reportData || !reportData.length) {
        alert('⚠️ Chưa có dữ liệu báo cáo để xuất!');
        return;
    }
    
    const reportType = document.getElementById('reportType').value;
    const fileName = getReportFileName(reportType, 'xlsx');
    
    try {
        // Tạo workbook và worksheet
        const wb = XLSX.utils.book_new();
        let ws_data = [];
        
        // Thêm tiêu đề báo cáo
        const reportTitle = getReportTitle(reportType);
        ws_data.push([reportTitle]);
        ws_data.push(['43 Gundam Hobby - Báo cáo tự động']);
        ws_data.push(['Ngày xuất: ' + new Date().toLocaleDateString('vi-VN')]);
        ws_data.push([]); // Dòng trống
        
        // Thêm header dựa trên loại báo cáo
        let headers = [];
        if (reportType === 'revenue') {
            headers = ['Thời gian', 'Tổng đơn hàng', 'Đơn giao thành công', 'Doanh thu (VNĐ)'];
        } else if (reportType === 'top-products') {
            headers = ['STT', 'Tên sản phẩm', 'Danh mục', 'Grade', 'Số lượng bán', 'Doanh thu (VNĐ)'];
        } else if (reportType === 'category') {
            headers = ['Danh mục', 'Số sản phẩm', 'Số lượng bán', 'Doanh thu (VNĐ)'];
        }
        ws_data.push(headers);
        
        // Thêm dữ liệu
        console.log('🔍 DEBUG - Adding data to Excel:');
        console.log('🔍 reportData:', reportData);
        console.log('🔍 reportData[0]:', reportData[0]);
        
        reportData.forEach((item, index) => {
            console.log(`🔍 Processing item ${index}:`, item);
            let row = [];
            if (reportType === 'revenue') {
                // Sử dụng field names chính xác từ backend
                let periodDate = item.period_date || item.period || '';
                
                // Format lại ngày cho dễ đọc
                if (periodDate && !isNaN(periodDate)) {
                    // Nếu là timestamp, convert sang date
                    const date = new Date(parseInt(periodDate));
                    const periodType = document.getElementById('periodType').value;
                    periodDate = formatPeriodDate(periodDate, periodType);
                } else if (typeof periodDate === 'string' && periodDate.includes('E')) {
                    // Nếu là scientific notation, convert
                    const timestamp = parseFloat(periodDate);
                    const date = new Date(timestamp);
                    const periodType = document.getElementById('periodType').value;
                    periodDate = formatPeriodDate(timestamp, periodType);
                }
                
                const orderCount = item.order_count || item.total_orders || 0;
                const deliveredCount = item.delivered_count || item.delivered_orders || 0;
                const totalRevenue = item.total_revenue || 0;
                
                row = [periodDate, orderCount, deliveredCount, totalRevenue];
            } else if (reportType === 'top-products') {
                // Sử dụng field names thực tế từ debug
                const productName = item.name || '';  // name, không phải product_name
                const categoryName = item.category || '';  // category, không phải category_name
                const grade = item.grade || '';
                const totalSold = item.total_sold || 0;
                const totalRevenue = item.total_revenue || 0;
                
                console.log('🔍 Final extracted values:', {productName, categoryName, grade, totalSold, totalRevenue});
                
                row = [index + 1, productName, categoryName, grade, totalSold, totalRevenue];
            } else if (reportType === 'category') {
                // Sử dụng field names chính xác từ displayCategoryReport
                const categoryName = item.category_name || item.name || '';
                const productsSold = item.products_sold || 0;  // Số sản phẩm
                const totalQuantity = item.total_quantity || 0;  // Số lượng bán
                const totalRevenue = item.total_revenue || 0;
                
                console.log('🔍 Category values:', {categoryName, productsSold, totalQuantity, totalRevenue});
                
                row = [categoryName, productsSold, totalQuantity, totalRevenue];
            }
            console.log(`🔍 Generated row:`, row);
            ws_data.push(row);
        });
        
        // Tạo worksheet
        const ws = XLSX.utils.aoa_to_sheet(ws_data);
        
        // Tự động điều chỉnh độ rộng cột
        const colWidths = [];
        ws_data.forEach(row => {
            row.forEach((cell, i) => {
                const cellLength = cell ? cell.toString().length : 10;
                colWidths[i] = Math.max(colWidths[i] || 10, cellLength + 2);
            });
        });
        ws['!cols'] = colWidths.map(w => ({wch: Math.min(w, 50)}));
        
        // Thêm worksheet vào workbook
        XLSX.utils.book_append_sheet(wb, ws, 'Báo cáo');
        
        // Xuất file
        XLSX.writeFile(wb, fileName);
        
        showNotification('✅ Xuất Excel thành công!', 'success');
    } catch (error) {
        console.error('❌ Lỗi xuất Excel:', error);
        alert('❌ Có lỗi khi xuất Excel: ' + error.message);
    }
}

// 🖨️ IN BÁO CÁO
function printReport() {
    // Kiểm tra dữ liệu tương tự như exportToExcel
    let reportData = null;
    if (Array.isArray(currentReportData)) {
        reportData = currentReportData;
    } else if (currentReportData && typeof currentReportData === 'object') {
        // Xử lý theo loại báo cáo
        const reportType = document.getElementById('reportType').value;
        if (reportType === 'revenue' && currentReportData.periodRevenue) {
            reportData = currentReportData.periodRevenue;
        } else if (reportType === 'category' && Array.isArray(currentReportData.data)) {
            reportData = currentReportData.data;
        } else if (Array.isArray(currentReportData.data)) {
            reportData = currentReportData.data;
        } else {
            // Thử lấy property đầu tiên là array
            const keys = Object.keys(currentReportData);
            for (let key of keys) {
                if (Array.isArray(currentReportData[key])) {
                    reportData = currentReportData[key];
                    break;
                }
            }
        }
    }
    
    if (!reportData || !reportData.length) {
        alert('⚠️ Chưa có dữ liệu báo cáo để in!');
        return;
    }
    
    const reportType = document.getElementById('reportType').value;
    const reportTitle = getReportTitle(reportType);
    
    // Tạo nội dung in
    let printContent = `
        <div class="reports-print-header">
            <h1>43 GUNDAM HOBBY</h1>
            <h2>${reportTitle}</h2>
            <p>Ngày in: ${new Date().toLocaleDateString('vi-VN')} ${new Date().toLocaleTimeString('vi-VN')}</p>
        </div>
        
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
    `;
    
    // Thêm header
    if (reportType === 'revenue') {
        printContent += `
            <th>Thời gian</th>
            <th>Tổng đơn hàng</th>
            <th>Đơn giao thành công</th>
            <th>Doanh thu (VNĐ)</th>
        `;
    } else if (reportType === 'top-products') {
        printContent += `
            <th>STT</th>
            <th>Tên sản phẩm</th>
            <th>Danh mục</th>
            <th>Grade</th>
            <th>Số lượng bán</th>
            <th>Doanh thu (VNĐ)</th>
        `;
    } else if (reportType === 'category') {
        printContent += `
            <th>Danh mục</th>
            <th>Số sản phẩm</th>
            <th>Số lượng bán</th>
            <th>Doanh thu (VNĐ)</th>
        `;
    }
    
    printContent += `
                </tr>
            </thead>
            <tbody>
    `;
    
    // Thêm dữ liệu
    reportData.forEach((item, index) => {
        printContent += '<tr>';
        if (reportType === 'revenue') {
            let periodDate = item.period_date || item.period || '';
            
            // Format lại ngày cho dễ đọc
            if (periodDate && !isNaN(periodDate)) {
                const periodType = document.getElementById('periodType').value;
                periodDate = formatPeriodDate(periodDate, periodType);
            } else if (typeof periodDate === 'string' && periodDate.includes('E')) {
                const timestamp = parseFloat(periodDate);
                const periodType = document.getElementById('periodType').value;
                periodDate = formatPeriodDate(timestamp, periodType);
            }
            
            const orderCount = item.order_count || item.total_orders || 0;
            const deliveredCount = item.delivered_count || item.delivered_orders || 0;
            const totalRevenue = item.total_revenue || 0;
            
            printContent += `
                <td>${periodDate}</td>
                <td>${orderCount}</td>
                <td>${deliveredCount}</td>
                <td>${formatCurrency(totalRevenue)}</td>
            `;
        } else if (reportType === 'top-products') {
            const productName = item.name || '';  // name, không phải product_name
            const categoryName = item.category || '';  // category, không phải category_name
            const grade = item.grade || '';
            const totalSold = item.total_sold || 0;
            const totalRevenue = item.total_revenue || 0;
            
            printContent += `
                <td>${index + 1}</td>
                <td>${productName}</td>
                <td>${categoryName}</td>
                <td>${grade}</td>
                <td>${totalSold}</td>
                <td>${formatCurrency(totalRevenue)}</td>
            `;
        } else if (reportType === 'category') {
            printContent += `
                <td>${item.category_name || item.name}</td>
                <td>${item.products_sold || 0}</td>
                <td>${item.total_quantity || 0}</td>
                <td>${formatCurrency(item.total_revenue || 0)}</td>
            `;
        }
        printContent += '</tr>';
    });
    
    printContent += `
            </tbody>
        </table>
        
        <div class="reports-print-footer">
            <p><strong>Tổng cộng:</strong> ${reportData.length} bản ghi</p>
            <p><em>Báo cáo được tạo tự động bởi hệ thống 43 Gundam Hobby</em></p>
        </div>
    `;
    
    // Mở cửa sổ in
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>${reportTitle} - 43 Gundam Hobby</title>
            <meta charset="UTF-8">
            <style>
                @page { margin: 2cm; size: A4; }
                body { font-family: Arial, sans-serif; color: #000; background: white; margin: 0; padding: 20px; }
                .reports-print-header { text-align: center; margin-bottom: 30px; border-bottom: 2px solid #333; padding-bottom: 20px; }
                .reports-print-header h1 { color: #ff6600; font-size: 24px; margin-bottom: 10px; }
                .reports-print-header h2 { color: #333; font-size: 18px; margin-bottom: 10px; }
                .reports-print-footer { margin-top: 30px; border-top: 1px solid #ccc; padding-top: 20px; text-align: center; }
                table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                th, td { border: 1px solid #333; padding: 8px; text-align: left; }
                th { background-color: #333; color: white; font-weight: bold; }
                tr:nth-child(even) { background-color: #f9f9f9; }
                .text-end { text-align: right; }
            </style>
        </head>
        <body>
            ${printContent}
        </body>
        </html>
    `);
    
    printWindow.document.close();
    printWindow.focus();
    
    // In sau khi load xong
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 500);
    
    showNotification('✅ Đã mở cửa sổ in!', 'success');
}

// HELPER FUNCTIONS
function getReportTitle(reportType) {
    switch(reportType) {
        case 'revenue': return 'Báo cáo doanh thu';
        case 'top-products': return 'Báo cáo sản phẩm bán chạy';
        case 'category': return 'Báo cáo doanh thu theo danh mục';
        default: return 'Báo cáo';
    }
}

function getReportFileName(reportType, extension) {
    const title = getReportTitle(reportType).toLowerCase().replace(/\s+/g, '-');
    const date = new Date().toISOString().slice(0, 10); // yyyy-mm-dd
    return `${title}-${date}.${extension}`;
}

function enableExportButtons() {
    const exportExcelBtn = document.getElementById('exportExcel');
    if (exportExcelBtn) {
        exportExcelBtn.disabled = false;
    }
}

function disableExportButtons() {
    const exportExcelBtn = document.getElementById('exportExcel');
    if (exportExcelBtn) {
        exportExcelBtn.disabled = true;
    }
}
