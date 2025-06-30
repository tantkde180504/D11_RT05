// Admin Dashboard JavaScript Functions

// Initialize charts when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
});

// Initialize Chart.js charts
function initializeCharts() {
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
            datasets: [{
                label: 'Doanh thu (triệu VNĐ)',
                data: [85, 92, 78, 105, 125, 110],
                borderColor: '#4e73df',
                backgroundColor: 'rgba(78, 115, 223, 0.1)',
                borderWidth: 2,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Product Chart
    const productCtx = document.getElementById('productChart').getContext('2d');
    new Chart(productCtx, {
        type: 'doughnut',
        data: {
            labels: ['Real Grade', 'Master Grade', 'Perfect Grade', 'High Grade'],
            datasets: [{
                data: [35, 28, 15, 22],
                backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e'],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}

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
