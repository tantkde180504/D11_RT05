// Admin Dashboard JavaScript Functions

// Initialize charts when page loads
document.addEventListener('DOMContentLoaded', function() {
    loadRevenueChart(document.getElementById('revenueType').value);
    loadBestsellerChart();
});
// Product Management Functions
function editProduct(productId) {
    alert('Chỉnh sửa sản phẩm ID: ' + productId);
    // Implement edit product functionality
}

function deleteProduct(productId) {
    if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
        alert('Xóa sản phẩm ID: ' + productId);
        // Implement delete product functionality
    }
}

function saveProduct() {
    // Get form data
    const productName = document.getElementById('productName').value;
    const productCategory = document.getElementById('productCategory').value;
    const productPrice = document.getElementById('productPrice').value;
    const productStock = document.getElementById('productStock').value;
    
    if (!productName || !productCategory || !productPrice || !productStock) {
        alert('Vui lòng điền đầy đủ thông tin!');
        return;
    }
    
    // Here you would send data to server
    alert('Sản phẩm đã được lưu thành công!');
    
    // Close modal and reset form
    const modal = bootstrap.Modal.getInstance(document.getElementById('addProductModal'));
    modal.hide();
    document.getElementById('addProductForm').reset();
}

// Report Functions
function generateReport() {
    const reportType = document.getElementById('reportType').value;
    const dateFrom = document.getElementById('dateFrom').value;
    const dateTo = document.getElementById('dateTo').value;
    
    alert(`Tạo báo cáo ${reportType} từ ${dateFrom} đến ${dateTo}`);
    // Implement report generation
}

function exportExcel() {
    alert('Xuất báo cáo Excel');
    // Implement Excel export
}

function exportPDF() {
    alert('Xuất báo cáo PDF');
    // Implement PDF export
}

function printReport() {
    window.print();
}

// Logout function
function logout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        // Clear any stored session data
        if (typeof(Storage) !== "undefined") {
            localStorage.removeItem('adminToken');
            localStorage.removeItem('isAdmin');
            sessionStorage.clear();
        }
        
        // Redirect to login page
        window.location.href = 'login.jsp';
    }
}

// Search and filter functions
function searchProducts() {
    // Implement product search
}

function filterByCategory(category) {
    // Implement category filtering
}

// Data refresh functions
function refreshDashboard() {
    location.reload();
}

// Notification system
function showNotification(message, type = 'success') {
    // You can implement a toast notification system here
    alert(message);
}
let revenueChartInstance = null;

//THỐNG KÊ DOANH THU THEO THỜI GIAN
function loadRevenueChart(type = "monthly") {
    const url = `${window.location.origin}/api/revenue?type=${type}`;
    fetch(url)
        .then(async res => {
            if (!res.ok) {
                const text = await res.text();
                throw new Error(`HTTP ${res.status}: ${text}`);
            }
            return res.json();
        })
        .then(data => {
            if (!data || data.length === 0) {
                console.warn("⚠️ Không có dữ liệu để hiển thị biểu đồ.");
                return;
            }

            const labels = data.map(r => {
                if (type === "daily") {
                    const date = new Date(r.label);
                    return date.toLocaleDateString('vi-VN');
                }
                return r.label;
            });

            const revenues = data.map(r => parseFloat(r.totalRevenue));
            const orders = data.map(r => r.totalOrders);

            if (revenueChartInstance) revenueChartInstance.destroy();

            const ctx = document.getElementById("revenueChart").getContext("2d");
            revenueChartInstance = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels,
                    datasets: [
                        {
                            label: "Doanh thu (VNĐ)",
                            data: revenues,
                            backgroundColor: "rgba(75, 192, 192, 0.6)",
                            borderColor: "rgba(75, 192, 192, 1)",
                            borderWidth: 1,
                            yAxisID: 'y',
                        },
                        {
                            label: "Số lượng đơn hàng",
                            data: orders,
                            backgroundColor: "rgba(255, 159, 64, 0.6)",
                            borderColor: "rgba(255, 159, 64, 1)",
                            borderWidth: 1,
                            yAxisID: 'y1',
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    stacked: false,
                    plugins: {
                        legend: { position: 'top' },
                        title: {
                            display: true,
                            text: `Thống kê doanh thu theo ${mapLabel(type)}`
                        }
                    },
                    scales: {
                        y: {
                            type: 'linear',
                            position: 'left',
                            title: { display: true, text: 'Doanh thu (VNĐ)' }
                        },
                        y1: {
                            type: 'linear',
                            position: 'right',
                            grid: { drawOnChartArea: false },
                            title: { display: true, text: 'Số đơn hàng' }
                        }
                    }
                }
            });
        })
        .catch(err => {
            console.error("❌ Lỗi khi tải dữ liệu thống kê doanh thu:", err.message);
        });
}


function mapLabel(type) {
    switch (type) {
        case "daily": return "ngày";
        case "monthly": return "tháng";
        case "quarterly": return "quý";
        case "yearly": return "năm";
        default: return "thời gian";
    }
}

function loadOrderChart() {
    fetch('/api/orders')
        .then(res => res.json())
        .then(data => {
            const labels = data.map(d => d.status);
            const counts = data.map(d => d.totalOrders || d.total); // ✅ linh hoạt

            if (orderChartInstance) orderChartInstance.destroy();

            orderChartInstance = new Chart(document.getElementById('orderChart'), {
                type: 'doughnut',
                data: {
                    labels,
                    datasets: [{
                        label: 'Trạng thái đơn hàng',
                        data: counts,
                        backgroundColor: ['#36A2EB', '#FFCE56', '#FF6384', '#4BC0C0']
                    }]
                }
            });
        });
}
function loadBestsellerChart() {
    fetch('/api/bestsellers')
        .then(res => res.json())
        .then(data => {
            const labels = data.map(p => p.name);
            const quantities = data.map(p => p.totalSold || p.total_sold); // ✅ nếu là raw SQL

            if (bestsellerChartInstance) bestsellerChartInstance.destroy();

            bestsellerChartInstance = new Chart(document.getElementById('bestsellerChart'), {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                        label: 'Sản phẩm bán chạy',
                        data: quantities,
                        backgroundColor: 'rgba(153, 102, 255, 0.6)'
                    }]
                }
            });
        });
}
