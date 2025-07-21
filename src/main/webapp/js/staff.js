// Staff Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function () {
    // Initialize all functionality
    initTabSwitching();
    initChart();
    initSearchFunctionality();
    initPriorityColors();
    initStatusBadges();
    initMessageTemplates();
    initKeyboardShortcuts();
    initRealTimeUpdates();
    initTooltips();
    initDropdownFix();
    showKeyboardShortcutsHint();
    loadInventoryFromAPI();
    loadComplaintsFromAPI();
    initInventoryFilters();
    checkLowStockAlert();
    loadOrdersFromAPI();
    initOrdersTab();
    loadReturns();
    loadDashboardStats() // Load returns mặc định
});

// Tab switching functionality
function initTabSwitching() {
    document.querySelectorAll('.nav-link[data-tab]').forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            // Remove active class from all links and contents
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));

            // Add active class to clicked link
            this.classList.add('active');

            // Show corresponding tab content
            const tabId = this.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');
            if (tabId === 'inventory') {
                loadInventoryFromAPI();
            } else if (tabId === 'complaints') {
                loadComplaintsFromAPI();
            }
        });
    });
}

// Initialize Chart
function initChart() {
    const ctx = document.getElementById('dailyStatsChart');
    if (ctx) {
        // Ensure the canvas container has proper dimensions
        const container = ctx.closest('.chart-container');
        if (container) {
            container.style.position = 'relative';
            container.style.height = '200px';
            container.style.width = '100%';
        }

        new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Hoàn thành', 'Đang xử lý', 'Chờ xử lý'],
                datasets: [{
                    data: [156, 24, 18],
                    backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12,
                            padding: 10,
                            font: {
                                size: 11
                            }
                        }
                    }
                },
                layout: {
                    padding: 10
                }
            }
        });
    }
}

// Search functionality
function initSearchFunctionality() {
    const searchInputs = document.querySelectorAll('.search-box input');
    searchInputs.forEach(input => {
        input.addEventListener('input', function () {
            const searchTerm = this.value.toLowerCase();
            const tabId = this.closest('.tab-content').id;

            if (tabId === 'messages') {
                searchMessages(searchTerm);
            } else if (tabId === 'inventory') {
                searchInventory(searchTerm);
            }
        });
    });
}

function searchMessages(term) {
    const messageItems = document.querySelectorAll('.message-item');
    messageItems.forEach(item => {
        const text = item.textContent.toLowerCase();
        if (text.includes(term)) {
            item.style.display = 'block';
            item.style.animation = 'fadeIn 0.3s ease';
        } else {
            item.style.display = 'none';
        }
    });
}

function searchInventory(term) {
    const tableRows = document.querySelectorAll('#inventory table tbody tr');
    tableRows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(term)) {
            row.style.display = 'table-row';
            row.style.animation = 'fadeIn 0.3s ease';
        } else {
            row.style.display = 'none';
        }
    });
}

// Priority color management
function initPriorityColors() {
    document.querySelectorAll('.message-priority').forEach(priority => {
        priority.addEventListener('click', function () {
            const priorities = ['priority-low', 'priority-medium', 'priority-high'];
            const labels = ['Thấp', 'Trung bình', 'Cao'];

            let currentIndex = priorities.findIndex(p => this.classList.contains(p));
            currentIndex = (currentIndex + 1) % priorities.length;

            // Remove all priority classes
            priorities.forEach(p => this.classList.remove(p));

            // Add new priority class
            this.classList.add(priorities[currentIndex]);
            this.textContent = labels[currentIndex];
        });
    });
}

// Status management
function initStatusBadges() {
    document.querySelectorAll('.status-badge').forEach(badge => {
        badge.addEventListener('click', function () {
            const statuses = ['status-pending', 'status-processing', 'status-completed', 'status-rejected'];
            const labels = ['Chờ xử lý', 'Đang xử lý', 'Hoàn thành', 'Từ chối'];

            let currentIndex = statuses.findIndex(s => this.classList.contains(s));
            currentIndex = (currentIndex + 1) % statuses.length;

            // Remove all status classes
            statuses.forEach(s => this.classList.remove(s));

            // Add new status class
            this.classList.add(statuses[currentIndex]);
            this.textContent = labels[currentIndex];
        });
    });
}

// Message template functionality
function initMessageTemplates() {
    const templateSelect = document.getElementById('messageTemplate');
    if (templateSelect) {
        templateSelect.addEventListener('change', function () {
            const templates = {
                'order_confirm': 'Xin chào!\n\nCảm ơn bạn đã đặt hàng tại 43 Gundam Hobby. Đơn hàng của bạn đã được xác nhận và sẽ được xử lý trong thời gian sớm nhất.\n\nChúng tôi sẽ thông báo cho bạn khi đơn hàng được giao.\n\nTrân trọng,\n43 Gundam Hobby Team',
                'shipping_info': 'Xin chào!\n\nĐơn hàng của bạn đã được giao cho đơn vị vận chuyển. Bạn có thể theo dõi tình trạng giao hàng qua mã vận đơn.\n\nDự kiến giao hàng trong 2-3 ngày làm việc.\n\nTrân trọng,\n43 Gundam Hobby Team',
                'thank_you': 'Xin chào!\n\nCảm ơn bạn đã mua sắm tại 43 Gundam Hobby. Chúng tôi hy vọng bạn hài lòng với sản phẩm.\n\nNếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.\n\nTrân trọng,\n43 Gundam Hobby Team',
                'follow_up': 'Xin chào!\n\nChúng tôi muốn biết ý kiến của bạn về sản phẩm đã mua. Đánh giá của bạn sẽ giúp chúng tôi cải thiện dịch vụ tốt hơn.\n\nCảm ơn bạn đã tin tưởng 43 Gundam Hobby!\n\nTrân trọng,\n43 Gundam Hobby Team'
            };

            const messageContent = document.getElementById('messageContent');
            if (messageContent && templates[this.value]) {
                messageContent.value = templates[this.value];
            }
        });
    }
}

// Keyboard shortcuts
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function (e) {
        // Ctrl+M for quick message
        if (e.ctrlKey && e.key === 'm') {
            e.preventDefault();
            const quickMessageModal = new bootstrap.Modal(document.getElementById('quickMessageModal'));
            quickMessageModal.show();
        }

        // Ctrl+N for new order
        if (e.ctrlKey && e.key === 'n') {
            e.preventDefault();
            const orderModal = new bootstrap.Modal(document.getElementById('orderModal'));
            orderModal.show();
        }

        // Ctrl+I for inventory update
        if (e.ctrlKey && e.key === 'i') {
            e.preventDefault();
            const inventoryModal = new bootstrap.Modal(document.getElementById('inventoryModal'));
            inventoryModal.show();
        }
    });
}

// Real-time stats update
function initRealTimeUpdates() {
    // Auto-refresh notifications, stats, and orders
    setInterval(function () {
        updateNotificationCounts();
        updateStats();
        
        // Auto-refresh orders if orders tab is active
        const ordersTab = document.getElementById('orders');
        if (ordersTab && ordersTab.classList.contains('active')) {
            loadOrdersFromAPI();
        }
    }, 30000); // Update every 30 seconds
}

function updateNotificationCounts() {
    const notificationDots = document.querySelectorAll('.notification-dot');
    notificationDots.forEach(dot => {
        // Simulate updating notification count
        const currentCount = parseInt(dot.textContent);
        if (Math.random() > 0.8) { // 20% chance to update
            dot.textContent = currentCount + Math.floor(Math.random() * 3);
        }
    });
}

function updateStats() {
    // Simulate real-time data updates
    const stats = [
        { selector: '.stat-card:nth-child(1) .number', min: 20, max: 30 },
        { selector: '.stat-card:nth-child(2) .number', min: 5, max: 12 },
        { selector: '.stat-card:nth-child(3) .number', min: 10, max: 20 },
        { selector: '.stat-card:nth-child(4) .number', min: 140, max: 180 }
    ];

    stats.forEach(stat => {
        const element = document.querySelector(stat.selector);
        if (element && Math.random() > 0.9) { // 10% chance to update
            const newValue = Math.floor(Math.random() * (stat.max - stat.min + 1)) + stat.min;
            element.textContent = newValue;
        }
    });
}

// Initialize tooltips
function initTooltips() {
    // Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    const tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

// Fix dropdown positioning
function initDropdownFix() {
    // Ensure dropdown menus have proper z-index and positioning
    const dropdowns = document.querySelectorAll('.dropdown');

    dropdowns.forEach(dropdown => {
        const button = dropdown.querySelector('[data-bs-toggle="dropdown"]');
        const menu = dropdown.querySelector('.dropdown-menu');

        if (button && menu) {
            button.addEventListener('click', function () {
                // Ensure the dropdown is positioned correctly
                setTimeout(() => {
                    const rect = button.getBoundingClientRect();
                    const nav = document.querySelector('.staff-nav');
                    const navRect = nav ? nav.getBoundingClientRect() : null;

                    // If dropdown would be behind nav, adjust z-index
                    if (navRect && rect.bottom > navRect.top) {
                        menu.style.zIndex = '1051';
                    }
                }, 10);
            });
        }
    });

    // Handle window resize for chart
    window.addEventListener('resize', function () {
        const chartContainer = document.querySelector('.chart-container');
        if (chartContainer) {
            // Force chart redraw on resize
            const chart = Chart.getChart('dailyStatsChart');
            if (chart) {
                chart.resize();
            }
        }
    });
}

// Show keyboard shortcuts hint
function showKeyboardShortcutsHint() {
    setTimeout(() => {
        const hint = document.createElement('div');
        hint.className = 'alert alert-info alert-dismissible fade show alert-floating';
        hint.innerHTML = `
            <strong>Phím tắt:</strong><br>
            Ctrl+M: Tin nhắn nhanh<br>
            Ctrl+N: Đơn hàng mới<br>
            Ctrl+I: Cập nhật tồn kho
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(hint);

        // Auto hide after 5 seconds
        setTimeout(() => {
            if (hint.parentNode) {
                hint.remove();
            }
        }, 5000);
    }, 2000);
}

// Export functionality
function exportData(type) {
    const data = {
        messages: 'Dữ liệu tin nhắn',
        complaints: 'Dữ liệu khiếu nại',
        inventory: 'Dữ liệu tồn kho',
        returns: 'Dữ liệu đổi trả',
        orders: 'Dữ liệu đơn hàng'
    };

    // Simulate export
    const blob = new Blob([data[type] || 'Không có dữ liệu'], { type: 'text/plain' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${type}_export_${new Date().toISOString().split('T')[0]}.txt`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
}

// Print functionality
function printReport(type) {
    const printWindow = window.open('', '_blank');
    const content = document.querySelector(`#${type}`).innerHTML;

    printWindow.document.write(`
        <html>
        <head>
            <title>Báo cáo ${type}</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body { font-family: 'Roboto', sans-serif; }
                .no-print { display: none; }
                @media print {
                    .staff-card { box-shadow: none; border: 1px solid #ddd; }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h2>Báo cáo ${type.toUpperCase()}</h2>
                <p>Ngày tạo: ${new Date().toLocaleDateString('vi-VN')}</p>
                ${content}
            </div>
        </body>
        </html>
    `);

    printWindow.document.close();
    printWindow.focus();
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 500);
}

// Show success message
function showSuccessMessage(message) {
    const alert = document.createElement('div');
    alert.className = 'alert alert-success alert-dismissible fade show alert-floating';
    alert.innerHTML = `
        <i class="fas fa-check-circle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alert);

    setTimeout(() => {
        if (alert.parentNode) {
            alert.remove();
        }
    }, 3000);
}

// Show error message
function showErrorMessage(message) {
    const alert = document.createElement('div');
    alert.className = 'alert alert-danger alert-dismissible fade show alert-floating';
    alert.innerHTML = `
        <i class="fas fa-exclamation-triangle me-2"></i>${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alert);

    setTimeout(() => {
        if (alert.parentNode) {
            alert.remove();
        }
    }, 5000);
}

// Loading state management
function showLoading(element) {
    const originalContent = element.innerHTML;
    element.innerHTML = '<span class="loading"></span> Đang xử lý...';
    element.disabled = true;

    return function hideLoading() {
        element.innerHTML = originalContent;
        element.disabled = false;
    };
}

// Form validation
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;

    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            isValid = false;
        } else {
            field.classList.remove('is-invalid');
        }
    });

    return isValid;
}

// AJAX helper function
function makeRequest(url, method = 'GET', data = null) {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open(method, url);
        xhr.setRequestHeader('Content-Type', 'application/json');

        xhr.onload = function () {
            if (xhr.status >= 200 && xhr.status < 300) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                reject(new Error(`Request failed with status ${xhr.status}`));
            }
        };

        xhr.onerror = function () {
            reject(new Error('Network error'));
        };

        xhr.send(data ? JSON.stringify(data) : null);
    });
}

// Auto-save functionality
function enableAutoSave(form, saveUrl) {
    let saveTimeout;

    form.addEventListener('input', function () {
        clearTimeout(saveTimeout);
        saveTimeout = setTimeout(() => {
            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());

            makeRequest(saveUrl, 'POST', data)
                .then(() => {
                    showSuccessMessage('Đã lưu tự động');
                })
                .catch(() => {
                    showErrorMessage('Lỗi lưu tự động');
                });
        }, 2000);
    });
}

// Dark mode toggle
function toggleDarkMode() {
    document.body.classList.toggle('dark-mode');
    localStorage.setItem('darkMode', document.body.classList.contains('dark-mode'));
}

// Initialize dark mode from localStorage
if (localStorage.getItem('darkMode') === 'true') {
    document.body.classList.add('dark-mode');
}

// Add print and export buttons to each tab
function addActionButtons() {
    document.querySelectorAll('.staff-card h5').forEach(header => {
        if (header.parentElement.querySelector('.table-modern')) {
            const actionGroup = document.createElement('div');
            actionGroup.className = 'btn-group ms-2';
            actionGroup.innerHTML = `
                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="fas fa-cog"></i>
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" onclick="exportData('${header.closest('.tab-content').id}')">
                        <i class="fas fa-download me-2"></i>Xuất dữ liệu
                    </a></li>
                    <li><a class="dropdown-item" href="#" onclick="printReport('${header.closest('.tab-content').id}')">
                        <i class="fas fa-print me-2"></i>In báo cáo
                    </a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="#" onclick="toggleDarkMode()">
                        <i class="fas fa-moon me-2"></i>Chế độ tối
                    </a></li>
                </ul>
            `;
            const flexContainer = header.parentElement.querySelector('.d-flex');
            if (flexContainer) {
                flexContainer.appendChild(actionGroup);
            } else {
                header.parentElement.appendChild(actionGroup);
            }
        }
    });
}

// Initialize action buttons when DOM is loaded
document.addEventListener('DOMContentLoaded', function () {
    setTimeout(addActionButtons, 100);
});

// Quick action handlers
function handleQuickCall() {
    showSuccessMessage('Tính năng gọi điện sẽ được triển khai sau');
}

function handleQuickNote() {
    const note = prompt('Nhập ghi chú nhanh:');
    if (note) {
        showSuccessMessage(`Đã lưu ghi chú: ${note}`);
    }
}

// Notification system
class NotificationManager {
    constructor() {
        this.notifications = [];
    }

    show(message, type = 'info', duration = 3000) {
        const notification = {
            id: Date.now(),
            message,
            type,
            duration
        };

        this.notifications.push(notification);
        this.render(notification);

        setTimeout(() => {
            this.remove(notification.id);
        }, duration);
    }

    render(notification) {
        const container = this.getContainer();
        const element = document.createElement('div');
        element.className = `alert alert-${notification.type} alert-dismissible fade show`;
        element.setAttribute('data-notification-id', notification.id);
        element.innerHTML = `
            ${notification.message}
            <button type="button" class="btn-close" onclick="notificationManager.remove(${notification.id})"></button>
        `;

        container.appendChild(element);
    }

    remove(id) {
        const element = document.querySelector(`[data-notification-id="${id}"]`);
        if (element) {
            element.remove();
        }
        this.notifications = this.notifications.filter(n => n.id !== id);
    }

    getContainer() {
        let container = document.querySelector('.notification-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'notification-container position-fixed top-0 end-0 p-3';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }
        return container;
    }
}

// Global notification manager instance
const notificationManager = new NotificationManager();

// Make functions globally available
window.exportData = exportData;
window.printReport = printReport;
window.showSuccessMessage = showSuccessMessage;
window.showErrorMessage = showErrorMessage;
window.toggleDarkMode = toggleDarkMode;
window.handleQuickCall = handleQuickCall;
window.handleQuickNote = handleQuickNote;
window.notificationManager = notificationManager;
function loadInventoryFromAPI() {
    fetch('/api/inventory/products') // ← endpoint từ backend Spring Boot
        .then(response => response.json())
        .then(data => {
            const tbody = document.querySelector('#inventory-body');
            tbody.innerHTML = ''; // Xóa dữ liệu cũ

            data.forEach(p => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><img src="${p.imageUrl}" width="50" height="50" class="rounded" alt=""></td>
                    <td><strong>${p.name}</strong><br><small class="text-muted">${p.brand}</small></td>
                    <td>${p.id}</td>
                    <td>${p.category}</td>
                    <td><strong>${p.stockQuantity}</strong></td>
                    <td><span class="status-badge ${getStockStatus(p.stockQuantity)}">${getStockLabel(p.stockQuantity)}</span></td>
                    <td>${formatCurrency(p.price)}</td>
                    <td>
                        <button class="btn btn-sm btn-warning me-1 btn-edit-stock"
                            data-name="${p.name}"
                            data-sku="${p.id}"
                            data-stock="${p.stockQuantity}"
                            data-image="${p.imageUrl}"
                            data-product-id="${p.id}"
                            title="Cập nhật">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-info btn-view-detail"
                            data-product-id="${p.id}"
                            title="Chi tiết">
                            <i class="fas fa-eye"></i>
                        </button>
                    </td>
                `;
                tbody.appendChild(row);
            });

            // Gắn sự kiện cho nút cập nhật (giữ nguyên phần cũ)
            bindUpdateStockButtons();

            // Gắn sự kiện xem chi tiết
            document.querySelectorAll('.btn-view-detail').forEach(btn => {
                const id = btn.getAttribute('data-product-id');
                btn.addEventListener('click', () => viewProductDetails(id));
            });

            filterInventory();
        })
        .catch(err => {
            console.error('Lỗi tải tồn kho:', err);
            showErrorMessage('Không thể tải dữ liệu tồn kho từ máy chủ');
        });
}
// COMPLAINTS KHIẾU NẠI
function loadComplaintsFromAPI() {
    fetch('/api/complaints')
        .then(res => res.json())
        .then(data => {
            console.log('Dữ liệu complaints nhận được:', data); // ← DÒNG NÀY
            const tbody = document.getElementById('complaint-table-body');
            tbody.innerHTML = '';

            data.forEach(c => {
                console.log('Thêm complaint:', c); // ← DÒNG NÀY

                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><strong>${c.complaintCode}</strong></td>
                    <td>${c.customerName}</td>
                    <td>${c.content}</td>
                    <td><span class="status-badge ${mapComplaintStatusClass(c.status)}">${mapComplaintStatusLabel(c.status)}</span></td>
                    <td>${formatDateTime(c.createdAt)}</td>
                    <td>
                        <button class="btn btn-sm btn-primary me-1" onclick="viewComplaintDetail('${c.complaintCode}')">
                            <i class="fas fa-eye"></i>
                        </button>
                        ${c.status === 'PROCESSING' ? `
                        <button class="btn btn-sm btn-success" onclick="handleCompleteComplaint('${c.complaintCode}')">
                            <i class="fas fa-check"></i>
                        </button>` : ''}
                    </td>
                `;
                tbody.appendChild(row);
            });

            filterComplaints();
        })
        .catch(err => {
            console.error('Lỗi khi tải khiếu nại:', err);
            showErrorMessage('Không thể tải danh sách khiếu nại từ máy chủ.');
        });
}

function mapComplaintStatusClass(status) {
    switch (status) {
        case 'PENDING': return 'status-pending';
        case 'PROCESSING': return 'status-processing';
        case 'COMPLETED': return 'status-completed';
        case 'REJECTED': return 'status-rejected';
        default: return '';
    }
}

function mapComplaintStatusLabel(status) {
    switch (status) {
        case 'PENDING': return 'Chờ xử lý';
        case 'PROCESSING': return 'Đang xử lý';
        case 'COMPLETED': return 'Hoàn thành';
        case 'REJECTED': return 'Từ chối';
        default: return status;
    }
}

function formatDateTime(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr); // ← sẽ parse chuỗi ISO như "2024-06-26T15:43:21"
    return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
}




document.addEventListener('DOMContentLoaded', function () {
    loadComplaintsFromAPI();
    document.getElementById('complaint-status-filter').addEventListener('change', filterComplaints);
});

function filterComplaints() {
    const selected = document.getElementById('complaint-status-filter').value;
    const rows = document.querySelectorAll('#complaint-table-body tr');

    rows.forEach(row => {
        const statusText = row.querySelector('td:nth-child(4)').textContent.trim();
        if (!selected || statusText === mapComplaintStatusLabel(selected)) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
// XỬ LÍ KHIẾU NẠI
function handleComplaintUpdate(status) {
    if (!window.currentComplaint || !window.currentComplaint.complaintCode) {
        showErrorMessage("Không tìm thấy dữ liệu khiếu nại hiện tại.");
        return;
    }

    const complaintCode = window.currentComplaint.complaintCode;
    const currentStatus = window.currentComplaint.status;
    const solution = document.getElementById("complaint-solution").value;
    const staffResponse = document.getElementById("complaint-staff-response").value;

    // ✅ Chỉ xử lý nếu trạng thái hiện tại là PENDING
    if (currentStatus !== "PENDING") {
        alert("Chỉ được xử lý khi khiếu nại đang ở trạng thái 'Chờ xử lý'.");
        return;
    }

    // Nếu phê duyệt → yêu cầu cả giải pháp và phản hồi
    if (status === "PROCESSING") {
        if (!solution || !staffResponse) {
            alert("Vui lòng chọn giải pháp và nhập phản hồi.");
            return;
        }
    }

    // Nếu từ chối → chỉ cần phản hồi
    if (status === "REJECTED" && !staffResponse) {
        alert("Vui lòng nhập phản hồi khi từ chối.");
        return;
    }

    fetch(`/api/complaints/${complaintCode}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            solution: solution,
            staffResponse: staffResponse,
            status: status
        })
    })
        .then(res => {
            if (!res.ok) throw new Error("Cập nhật thất bại");
            return res.text();
        })
        .then(message => {
            showSuccessMessage(message);
            loadComplaintsFromAPI();
            const modal = bootstrap.Modal.getInstance(document.getElementById('complaintModal'));
            if (modal) modal.hide();
        })
        .catch(err => {
            console.error(err);
            showErrorMessage("Lỗi khi cập nhật khiếu nại!");
        });
}


function getStockStatus(stock) {
    if (stock === 0) return 'status-rejected';
    if (stock <= 5) return 'status-pending';
    return 'status-completed';
}

function getStockLabel(stock) {
    if (stock === 0) return 'Hết hàng';
    if (stock <= 5) return 'Sắp hết';
    return 'Còn hàng';
}

function formatCurrency(price) {
    return price.toLocaleString('vi-VN') + '₫';
}
function bindUpdateStockButtons() {
    const buttons = document.querySelectorAll('.btn-edit-stock');
    buttons.forEach(btn => {
        btn.addEventListener('click', () => {
            const productId = btn.getAttribute('data-product-id');
            const name = btn.getAttribute('data-name');
            const sku = btn.getAttribute('data-sku');
            const stock = btn.getAttribute('data-stock');
            const image = btn.getAttribute('data-image');

            // Gán dữ liệu vào modal
            document.getElementById('update-product-image').src = image;
            document.getElementById('update-product-name').textContent = name;
            document.getElementById('update-product-sku').textContent = sku;
            document.getElementById('current-stock').value = stock;
            document.getElementById('new-stock').value = '';
            document.getElementById('update-reason').value = '';

            const updateBtn = document.getElementById('btn-update-stock');
            updateBtn.setAttribute('data-product-id', productId);

            // Gắn lại sự kiện nút Cập nhật
            updateBtn.onclick = function () {
                const newStock = document.getElementById('new-stock').value;
                const currentStock = parseInt(document.getElementById('current-stock').value);
                const reason = document.getElementById('update-reason').value.trim();
                const selectedProductId = parseInt(updateBtn.getAttribute('data-product-id'));

                if (!newStock || isNaN(newStock) || Number(newStock) < 0) {
                    showErrorMessage('Số lượng mới không hợp lệ!');
                    return;
                }

                const quantityDiff = parseInt(newStock) - currentStock;
                if (quantityDiff === 0) {
                    showErrorMessage('Không có thay đổi số lượng.');
                    return;
                }

                const hide = showLoading(updateBtn);

                fetch('/api/inventory/update-stock', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({
                        productId: selectedProductId,
                        quantity: Math.abs(quantityDiff),
                        type: quantityDiff > 0 ? 'IN' : 'OUT'
                    })
                })
                    .then(res => res.text())
                    .then(message => {
                        hide();
                        showSuccessMessage(message);

                        // Ẩn modal
                        const modalElement = document.getElementById('updateStockModal');
                        const modalInstance = bootstrap.Modal.getInstance(modalElement);
                        if (modalInstance) modalInstance.hide();

                        loadInventoryFromAPI(); // Tải lại bảng
                        checkLowStockAlert();  // Kiểm tra lại cảnh báo tồn kho
                    })
                    .catch(err => {
                        hide();
                        showErrorMessage('Lỗi cập nhật tồn kho: ' + err.message);
                    });
            };

            // Mở modal
            const modal = new bootstrap.Modal(document.getElementById('updateStockModal'));
            modal.show();
        });
    });
}
function filterInventory() {
    const searchTerm = document.querySelector('#inventory .search-box input').value.toLowerCase();
    const selectedCategory = document.getElementById('category-filter').value.trim().toUpperCase();
    const selectedStatus = document.getElementById('status-filter').value.trim();

    const rows = document.querySelectorAll('#inventory-body tr');

    rows.forEach(row => {
        const rowText = row.textContent.toLowerCase();
        const categoryText = row.querySelector('td:nth-child(4)')?.textContent.trim().toUpperCase();
        const statusText = row.querySelector('td:nth-child(6)')?.textContent.trim();

        const matchesSearch = rowText.includes(searchTerm);
        const matchesCategory = selectedCategory === '' || categoryText === selectedCategory;
        const matchesStatus = selectedStatus === '' || statusText === selectedStatus;

        if (matchesSearch && matchesCategory && matchesStatus) {
            row.style.display = 'table-row';
        } else {
            row.style.display = 'none';
        }
    });
}
function initInventoryFilters() {
    const searchInput = document.querySelector('#inventory .search-box input');
    const categorySelect = document.getElementById('category-filter');
    const statusSelect = document.getElementById('status-filter');

    searchInput.addEventListener('input', filterInventory);
    categorySelect.addEventListener('change', filterInventory);
    statusSelect.addEventListener('change', filterInventory);
}
// Định nghĩa hàm chi tiết
function viewProductDetails(productId) {
    fetch(`/api/inventory/products/${productId}`)
        .then(res => {
            if (!res.ok) throw new Error('Không tìm thấy sản phẩm');
            return res.json();
        })
        .then(product => {
            document.getElementById('detail-product-name').textContent = product.name;
            document.getElementById('detail-product-sku').textContent = product.id;
            document.getElementById('detail-product-price').textContent = formatCurrency(product.price);
            document.getElementById('detail-product-category').textContent = product.category;
            document.getElementById('detail-product-grade').textContent = product.grade;
            document.getElementById('detail-product-brand').textContent = product.brand;
            document.getElementById('detail-product-stock').textContent = product.stockQuantity;
            document.getElementById('detail-product-desc').textContent = product.description;
            document.getElementById('detail-product-image').src = product.imageUrl;

            const modal = new bootstrap.Modal(document.getElementById('productDetailModal'));
            modal.show();
        })
        .catch(err => {
            showErrorMessage(err.message || 'Lỗi tải chi tiết sản phẩm');
        });
}

// 👇 Gán vào window để dùng được qua `onclick`
function viewComplaintDetail(complaintCode) {
    fetch('/api/complaints')
        .then(res => res.json())
        .then(data => {
            const complaint = data.find(c => c.complaintCode === complaintCode);
            if (!complaint) {
                showErrorMessage('Không tìm thấy khiếu nại.');
                return;
            }

            // Gán vào biến toàn cục
            window.currentComplaint = complaint;

            // Gán thông tin
            document.querySelector('#complaintModal .modal-title').innerHTML =
                `<i class="fas fa-exclamation-triangle me-2"></i>Chi tiết khiếu nại #${complaint.complaintCode}`;
            document.getElementById('complaint-customer-name').textContent = complaint.customerName;
            document.getElementById('complaint-email').textContent = complaint.customerEmail;
            document.getElementById('complaint-phone').textContent = complaint.customerPhone;
            document.getElementById('complaint-order-number').textContent = complaint.orderNumber;
            document.getElementById('complaint-created-at').textContent = formatDateTime(complaint.createdAt);
            document.getElementById('complaint-category').textContent = complaint.category;
            document.getElementById('complaint-status').innerHTML =
                `<span class="status-badge ${mapComplaintStatusClass(complaint.status)}">
                    ${mapComplaintStatusLabel(complaint.status)}
                </span>`;
            document.getElementById('complaint-content').textContent = complaint.content;
            document.getElementById('complaint-staff-response').value = complaint.staffResponse || '';
            document.getElementById('complaint-solution').value = complaint.solution || '';

            // Ẩn hoặc hiển thị các nút xử lý
            const approveBtn = document.querySelector("#complaintModal .btn-success");
            const rejectBtn = document.querySelector("#complaintModal .btn-danger");

            if (complaint.status === "PENDING") {
                approveBtn.style.display = 'inline-block';
                rejectBtn.style.display = 'inline-block';
            } else {
                approveBtn.style.display = 'none';
                rejectBtn.style.display = 'none';
            }

            const modal = new bootstrap.Modal(document.getElementById('complaintModal'));
            modal.show();
        })
        .then(() => {
            // Sau khi hiển thị thông tin khiếu nại, load file đính kèm
            const gallery = document.getElementById('complaint-media-gallery');
            gallery.innerHTML = '<div class="text-muted">Đang tải file đính kèm...</div>';
            fetch(`/api/complaints/${complaintCode}/attachments`)
                .then(res => res.json())
                .then(data => {
                    if (!data.success || !Array.isArray(data.files) || data.files.length === 0) {
                        gallery.innerHTML = '<div class="text-muted">Không có file đính kèm.</div>';
                        return;
                    }
                    let html = '';
                    data.files.forEach(url => {
                        if (url.match(/\.(jpg|jpeg|png|gif)$/i)) {
                            html += `<a href="${url}" target="_blank"><img src="${url}" style="max-width:120px;max-height:120px;border-radius:8px;object-fit:cover;" class="border me-2 mb-2"></a>`;
                        } else if (url.match(/\.(mp4|webm|ogg)$/i)) {
                            html += `<video src="${url}" controls style="max-width:160px;max-height:120px;display:inline-block;border-radius:8px;" class="me-2 mb-2"></video>`;
                        } else {
                            html += `<a href="${url}" target="_blank">${url}</a>`;
                        }
                    });
                    gallery.innerHTML = html;
                })
                .catch(() => {
                    gallery.innerHTML = '<div class="text-danger">Lỗi tải file đính kèm.</div>';
                });
        })
        .catch(err => {
            console.error('Lỗi tải chi tiết khiếu nại:', err);
            showErrorMessage('Lỗi tải chi tiết khiếu nại');
        });
}

//xử lí hoàn thành khiếu nại
function handleCompleteComplaint(complaintCode) {
    if (!confirm("Bạn có chắc muốn đánh dấu khiếu nại này là đã hoàn thành?")) return;

    fetch(`/api/complaints/${complaintCode}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            solution: "Đã xử lý hoàn tất",
            staffResponse: "Khiếu nại đã được hoàn thành.",
            status: "COMPLETED"
        })
    })
        .then(res => {
            if (!res.ok) throw new Error("Không thể cập nhật");
            return res.text();
        })
        .then(msg => {
            showSuccessMessage(msg);
            loadComplaintsFromAPI();
        })
        .catch(err => {
            console.error(err);
            showErrorMessage("Lỗi khi cập nhật trạng thái khiếu nại.");
        });
}
// ⚠️ Kiểm tra và hiển thị cảnh báo sản phẩm sắp hết hàng
function checkLowStockAlert() {
    fetch('/api/notifications/low-stock')
        .then(res => res.json())
        .then(data => {
            const alertBox = document.getElementById('low-stock-alert');
            console.log("🔁 Dữ liệu tồn kho thấp:", data);

            if (data.length === 0 && alertBox) {
                alertBox.style.setProperty('display', 'none', 'important');
                console.log("✅ Không còn sản phẩm tồn kho thấp → Ẩn cảnh báo");
                localStorage.removeItem("lowStockNoticeShown");
            } else if (data.length > 0 && alertBox) {
                document.getElementById('low-stock-count').innerText = data.length;
                alertBox.style.display = 'flex';
                const today = new Date().toISOString().slice(0, 10);
                localStorage.setItem("lowStockNoticeShown", today);
                console.log("⚠️ Vẫn còn sản phẩm tồn kho thấp → Hiển thị cảnh báo");
            }
        })
        .catch(err => {
            console.error('❌ Lỗi khi kiểm tra tồn kho thấp:', err);
        });
}


// ✅ Khi staff click "Xem ngay"
function viewLowStockProducts() {
    // 1. Chuyển sang tab tồn kho
    document.querySelectorAll('.nav-link').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));

    const inventoryTab = document.querySelector('[data-tab="inventory"]');
    const inventoryContent = document.getElementById('inventory');

    if (inventoryTab && inventoryContent) {
        inventoryTab.classList.add('active');
        inventoryContent.classList.add('active');
    }

    // 2. Gọi lại dữ liệu tồn kho
    loadInventoryFromAPI();

    // 3. Lọc sản phẩm có stock <= 5
    setTimeout(() => {
        const rows = document.querySelectorAll('#inventory-body tr');
        rows.forEach(row => {
            const stockText = row.querySelector('td:nth-child(5)')?.textContent.trim();
            const stock = parseInt(stockText);

            if (!isNaN(stock) && stock <= 5) {
                row.style.display = 'table-row';
            } else {
                row.style.display = 'none';
            }
        });

        // Cập nhật dropdown filter về rỗng để user thấy rõ là đang dùng lọc tùy chỉnh
        const statusSelect = document.getElementById('status-filter');
        if (statusSelect) statusSelect.value = '';
    }, 200);

    history.replaceState(null, '', '#inventory');
}
window.viewLowStockProducts = viewLowStockProducts;
// ✅ Initialize orders tab
function initOrdersTab() {
    // Initialize filter change event
    const orderFilter = document.getElementById('order-status-filter');
    if (orderFilter) {
        orderFilter.addEventListener('change', loadOrdersFromAPI);
    }
}

// Function xác nhận hoàn thành đổi trả (PROCESSING → COMPLETED)
function confirmReturnComplete(returnId, returnCode) {
    // Hiển thị dialog xác nhận với thông tin rõ ràng
    const isConfirmed = confirm(
        "🔔 XÁC NHẬN HOÀN THÀNH ĐỔI TRẢ\n\n" +
        `Mã đơn đổi trả: ${returnCode}\n` +
        "Trạng thái hiện tại: Chờ xử lý\n" +
        "Trạng thái mới: Đã hoàn thành\n\n" +
        "⚠️ Sau khi xác nhận, đơn đổi trả sẽ được đánh dấu là hoàn thành.\n\n" +
        "Bạn có chắc chắn muốn hoàn thành đơn đổi trả này?"
    );

    if (!isConfirmed) return;

    // Gửi request cập nhật trạng thái sử dụng API có sẵn
    fetch(`/api/returns/complete?returnId=${returnId}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" }
    })
        .then(res => {
            if (!res.ok) throw new Error("Không thể cập nhật trạng thái");
            return res.text();
        })
        .then(msg => {
            showSuccessMessage("✅ Đã xác nhận hoàn thành đơn đổi trả thành công!");
            loadReturns(); // Reload để cập nhật giao diện
        })
        .catch(err => {
            console.error("Lỗi xác nhận hoàn thành đổi trả:", err);
            showErrorMessage("❌ Lỗi khi xác nhận hoàn thành đơn đổi trả. Vui lòng thử lại.");
        });
}

// Function load đơn hàng từ API với chức năng xem ảnh giao hàng
function loadOrdersFromAPI() {
    const status = document.getElementById('order-status-filter')?.value || 'ALL';
    console.log('🔄 Loading orders from API with status filter:', status);
    
    fetch(`/api/orders?status=${status}`)
        .then(res => res.json())
        .then(data => {
            console.log('📦 Orders API response:', data);
            
            const tbody = document.getElementById('orders-body');
            tbody.innerHTML = '';

            data.forEach((o, index) => {
                console.log(`📋 Order #${index + 1}:`, {
                    id: o.id,
                    orderNumber: o.orderNumber,
                    status: o.status,
                    mappedStatus: mapOrderStatus(o.status),
                    statusClass: getOrderStatusClass(o.status)
                });
                
                const productListHtml = (o.productNames?.length > 0)
                    ? `<ul class="mb-0 ps-3">${o.productNames.map(p => `<li>${p}</li>`).join('')}</ul>`
                    : '—';

                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><strong>#${o.orderNumber}</strong></td>
                    <td>${o.shippingName}</td>
                    <td>${productListHtml}</td>
                    <td><strong>${formatCurrency(o.totalAmount)}</strong></td>
                    <td><span class="status-badge ${getOrderStatusClass(o.status)}">${mapOrderStatus(o.status)}</span></td>
                    <td>${formatDate(o.orderDate)}</td>
                    <td>
                        ${o.status === 'PENDING' ? `
                            <button class="btn btn-sm btn-success me-1" onclick="confirmOrder(${o.id})">
                                <i class="fas fa-check"></i>
                            </button>` : ''}

                        ${o.status !== 'DELIVERED' && o.status !== 'CANCELLED' ? `
                            <button class="btn btn-sm btn-danger me-1" onclick="cancelOrder(${o.id})">
                                <i class="fas fa-times"></i>
                            </button>` : ''}
                        ${o.status === 'DELIVERED' ? `
                            <button class="btn btn-sm btn-primary me-1" onclick="viewDeliveryPhotos(${o.id})" title="Xem ảnh giao hàng">
                                <i class="fas fa-images"></i>
                            </button>` : ''}
                        <button class="btn btn-sm btn-warning me-1" onclick="showUpdateStatusModal(${o.id}, '${o.status}')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-info" onclick="viewOrderDetail(${o.id})">
                            <i class="fas fa-eye"></i>
                        </button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        })
        .catch(err => {
            console.error('Lỗi khi load đơn hàng:', err);
            showErrorMessage('Không thể tải đơn hàng từ máy chủ');
        });
}

// function formatCurrency(amount) {
//     return Number(amount).toLocaleString('vi-VN') + '₫';
// }

// function formatDate(dateStr) {
//     const date = new Date(dateStr);
//     return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
// }

// function mapOrderStatus(status) {
//     switch (status) {
//         case 'PENDING': return 'Chờ xác nhận';
//         case 'DELIVERED': return 'Đã giao';
//         case 'CANCELLED': return 'Đã hủy';
//         default: return status;
//     }
// }

function confirmOrder(orderId) {
    if (!confirm("Bạn có chắc muốn xác nhận đơn hàng này?")) return;

    fetch('/api/orders/confirm', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `orderId=${orderId}`
})
.then(res => {
    if (!res.ok) return res.text().then(text => { throw new Error(text); });
    return res.text();
})
.then(msg => {
    showSuccessMessage(msg);
    loadOrdersFromAPI();
})
.catch(err => {
    console.error('Xác nhận lỗi:', err.message);
    showErrorMessage(err.message || "❌ Không thể xác nhận đơn hàng.");
});

}
function showUpdateStatusModal(orderId, currentStatus) {
    const modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
    document.getElementById('update-order-id').value = orderId;
    document.getElementById('new-status').value = currentStatus;
    modal.show();
}
function updateOrderStatus() {
    const orderId = document.getElementById('update-order-id').value;
    const newStatus = document.getElementById('new-status').value;

    fetch('/api/orders/update-status', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `orderId=${orderId}&status=${newStatus}`
    })
    .then(res => {
        if (!res.ok) return res.text().then(text => { throw new Error(text); });
        return res.text();
    })
    .then(msg => {
        showSuccessMessage(msg);
        bootstrap.Modal.getInstance(document.getElementById('updateStatusModal')).hide();
        loadOrdersFromAPI();
    })
    .catch(err => {
        showErrorMessage(err.message || "❌ Không thể cập nhật trạng thái.");
    });
}
function viewOrderDetail(orderId) {
    fetch(`/api/orders/detail?id=${orderId}`)
        .then(res => {
            if (!res.ok) throw new Error("Không thể lấy dữ liệu đơn hàng");
            return res.json();
        })
        .then(order => {
            window.currentOrder = order;

            const productListHtml = (order.productNames || [])
                .map(name => `<li>${name}</li>`)
                .join('');

            const html = `
                <div class="mb-2"><strong>Mã đơn hàng:</strong> #${order.orderNumber}</div>
                <div class="mb-2"><strong>Sản phẩm:</strong>
                    <ul class="mb-1">${productListHtml || '<li>—</li>'}</ul>
                </div>
                <div class="mb-2"><strong>Khách hàng:</strong> ${order.shippingName}</div>
                <div class="mb-2"><strong>Điện thoại:</strong> ${order.shippingPhone}</div>
                <div class="mb-2"><strong>Email:</strong> ${order.email}</div>
                <div class="mb-2"><strong>Địa chỉ:</strong> ${order.shippingAddress}</div>
                <div class="mb-2"><strong>Phương thức thanh toán:</strong> ${order.paymentMethod}</div>
                <div class="mb-2"><strong>Trạng thái:</strong> ${order.status}</div>
                <div class="mb-2"><strong>Ngày đặt:</strong> ${formatDate(order.orderDate)}</div>
                <div class="mb-2"><strong>Tổng tiền:</strong> ${formatCurrency(order.totalAmount)}</div>
            `;

            document.getElementById('order-detail-body').innerHTML = html;
            new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
        })
        .catch(err => {
            console.error("Chi tiết đơn hàng lỗi:", err);
            showErrorMessage("❌ Không thể tải chi tiết đơn hàng.");
        });
}

function formatDate(dateStr) {
    const date = new Date(dateStr);
    if (isNaN(date)) return '—';
    return date.toLocaleDateString('vi-VN') + ' ' + date.toLocaleTimeString('vi-VN');
}

function printInvoice() {
    const order = window.currentOrder;
    if (!order) return alert('Không có dữ liệu hóa đơn.');

    const productListHtml = (order.items || [])
  .map(item => `
    <tr>
      <td>${item.name}</td>
      <td>${item.quantity}</td>
      <td>${formatCurrency(item.price)}</td>
      <td>${formatCurrency(item.price * item.quantity)}</td>
    </tr>
  `)
  .join('');

    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <html>
        <head>
            <title>Hóa đơn</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                body {
                    font-family: 'Segoe UI', sans-serif;
                    padding: 40px;
                    color: #333;
                }
                .header {
                    background-color: #f60;
                    color: white;
                    padding: 20px;
                    text-align: center;
                }
                .info-section {
                    display: flex;
                    justify-content: space-between;
                    margin-top: 30px;
                }
                .info-box {
                    width: 48%;
                }
                table {
                    width: 100%;
                    margin-top: 20px;
                    border-collapse: collapse;
                }
                th, td {
                    border-bottom: 1px solid #ddd;
                    padding: 8px;
                    text-align: left;
                }
                th {
                    background-color: #f60;
                    color: white;
                }
                .total-row {
                    font-weight: bold;
                    background-color: #eee;
                }
                .footer {
                    margin-top: 40px;
                    text-align: center;
                    font-size: 14px;
                    color: #555;
                }
            </style>
        </head>
        <body>
            <div class="header">
                <h2>HÓA ĐƠN</h2>
                <div>#${order.orderNumber}</div>
                <div>${formatDate(order.orderDate)}</div>
            </div>

            <div class="info-section">
                <div class="info-box">
                    <h5>KHÁCH HÀNG</h5>
                    <p>${order.shippingName}</p>
                    <p>${order.shippingAddress}</p>
                    <p>${order.email}</p>
                    <p>${order.shippingPhone}</p>
                </div>
                <div class="info-box">
                    <h5>THANH TOÁN</h5>
                    <p>Phương thức: ${order.paymentMethod}</p>
                    <p>Trạng thái: ${mapOrderStatus(order.status)}</p>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>MÔ TẢ</th>
                        <th>SỐ LƯỢNG</th>
                        <th>ĐƠN GIÁ</th>
                        <th>THÀNH TIỀN</th>
                    </tr>
                </thead>
                <tbody>
                    ${productListHtml}
                    <tr class="total-row">
                        <td colspan="3">TỔNG CỘNG</td>
                        <td>${formatCurrency(order.totalAmount)}</td>
                    </tr>
                </tbody>
            </table>

            <div class="footer">
                Cảm ơn bạn đã mua hàng!<br>
                Liên hệ: ${order.email} | ${order.shippingPhone}
            </div>
        </body>
        </html>
    `);

    printWindow.document.close();
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 300);
}


function cancelOrder(orderId) {
    if (!confirm("Bạn có chắc muốn hủy đơn hàng này?")) return;

    fetch('/api/orders/cancel', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `orderId=${orderId}`
    })
    .then(res => {
        if (!res.ok) return res.text().then(text => { throw new Error(text); });
        return res.text();
    })
    .then(msg => {
        showSuccessMessage(msg);
        loadOrdersFromAPI();
    })
    .catch(err => {
        console.error('Hủy đơn lỗi:', err.message);
        showErrorMessage(err.message || "❌ Không thể hủy đơn hàng.");
    });
}
function mapOrderStatus(status) {
    switch (status) {
        case 'PENDING': return 'Chờ xác nhận';
        case 'CONFIRMED': return 'Đã xác nhận';
        case 'SHIPPING': return 'Đang giao hàng';
        case 'DELIVERED': return 'Đã giao';
        case 'CANCELLED': return 'Đã hủy';
        default: return status;
    }
}

function getOrderStatusClass(status) {
    switch (status) {
        case 'PENDING': return 'status-warning';  // Vàng
        case 'CONFIRMED': return 'status-info';   // Xanh dương
        case 'SHIPPING': return 'status-primary'; // Xanh đậm
        case 'DELIVERED': return 'status-success'; // Xanh lá
        case 'CANCELLED': return 'status-danger';  // Đỏ
        default: return 'status-secondary';
    }
}

// ✅ Function xem ảnh giao hàng của đơn hàng
function viewDeliveryPhotos(orderId) {
    fetch(`/api/orders/${orderId}/delivery-photos`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to fetch delivery photos');
            }
            return response.json();
        })
        .then(data => {
            showDeliveryPhotosModal(data, orderId);
        })
        .catch(err => {
            console.error('Lỗi lấy ảnh:', err);
            alert('❌ Lỗi lấy ảnh giao hàng: ' + err.message);
        });
}

// ✅ Function hiển thị modal ảnh giao hàng
function showDeliveryPhotosModal(photos, orderId) {
    // Tạo modal nếu chưa có
    let modal = document.getElementById('deliveryPhotosModal');
    if (!modal) {
        createDeliveryPhotosModal();
        modal = document.getElementById('deliveryPhotosModal');
    }
    
    const modalTitle = modal.querySelector('.modal-title');
    const photosContainer = modal.querySelector('#delivery-photos-container');
    
    modalTitle.textContent = `Ảnh giao hàng - Đơn hàng #${orderId}`;
    
    if (photos && photos.length > 0) {
        let photosHtml = '<div class="row">';
        photos.forEach((photo, index) => {
            photosHtml += `
                <div class="col-md-6 mb-3">
                    <div class="card">
                        <img src="${photo.photoUrl}" class="card-img-top" alt="Ảnh giao hàng ${index + 1}" 
                             style="height: 300px; object-fit: cover; cursor: pointer;" 
                             onclick="showFullPhoto('${photo.photoUrl}')">
                        <div class="card-body p-2">
                            <small class="text-muted">
                                <i class="fas fa-clock"></i> ${photo.uploadedAt}
                            </small>
                        </div>
                    </div>
                </div>
            `;
        });
        photosHtml += '</div>';
        photosContainer.innerHTML = photosHtml;
    } else {
        photosContainer.innerHTML = `
            <div class="text-center text-muted py-4">
                <i class="fas fa-camera fa-3x mb-3"></i>
                <p>Chưa có ảnh giao hàng nào cho đơn hàng này.</p>
            </div>
        `;
    }
    
    new bootstrap.Modal(modal).show();
}

// ✅ Function tạo modal ảnh giao hàng
function createDeliveryPhotosModal() {
    const modalHtml = `
        <div class="modal fade" id="deliveryPhotosModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Ảnh giao hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div id="delivery-photos-container">
                            <!-- Photos will be loaded here -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    document.body.insertAdjacentHTML('beforeend', modalHtml);
}

// ✅ Function hiển thị ảnh full size
function showFullPhoto(photoUrl) {
    const fullPhotoHtml = `
        <div class="modal fade" id="fullPhotoModal" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Xem ảnh chi tiết</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center">
                        <img src="${photoUrl}" class="img-fluid" alt="Ảnh giao hàng" style="max-height: 80vh;">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <a href="${photoUrl}" download class="btn btn-primary">
                            <i class="fas fa-download"></i> Tải xuống
                        </a>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    const existingModal = document.getElementById('fullPhotoModal');
    if (existingModal) {
        existingModal.remove();
    }
    
    document.body.insertAdjacentHTML('beforeend', fullPhotoHtml);
    new bootstrap.Modal(document.getElementById('fullPhotoModal')).show();
}
// Load returns từ API
function loadReturns(status = 'ALL') {
    let url = '/api/returns';
    if (status !== 'ALL') {
        url += `?status=${status}`;
    }

    fetch(url)
        .then(response => response.json())
        .then(data => renderReturnsTable(data))
        .catch(error => console.error('Lỗi khi load returns:', error));
}

// Render danh sách returns vào bảng
function renderReturnsTable(returns) {
    const tableBody = document.getElementById('returns-table-body');
    if (!tableBody) return;
    tableBody.innerHTML = '';

    if (!returns || returns.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="8" class="text-center">Không có dữ liệu</td></tr>';
        return;
    }

    returns.forEach(ret => {
        const row = document.createElement('tr');

        row.innerHTML = `
            <td><strong>#${ret.orderNumber || ret.orderId}</strong></td>
            <td>${ret.customerName || 'Không rõ'}</td>
            <td>${ret.productName || 'Không rõ'}</td>
            <td>${ret.reason || ''}</td>
            <td><span class="status-badge ${mapReturnStatusClass(ret.status)}">${mapReturnStatusLabel(ret.status)}</span></td>
            <td>${ret.requestType || ''}</td>
            <td>${ret.createdAt || ''}</td>
            <td>
                <button class="btn btn-sm btn-info me-1" title="Xem chi tiết" onclick="viewReturnDetail(${ret.id})">
                    <i class="fas fa-eye"></i>
                </button>
                ${ret.status === 'PROCESSING' ? `
                <button class="btn btn-sm btn-success" title="Xác nhận hoàn thành" onclick="confirmReturnComplete(${ret.id}, '${ret.returnCode || ret.id}')">
                    <i class="fas fa-check"></i> Xác nhận
                </button>` : ''}
            </td>`;
        tableBody.appendChild(row);
    });
}

// Map class trạng thái
function mapReturnStatusClass(status) {
    if (status === 'PROCESSING') return 'status-processing';
    if (status === 'COMPLETED') return 'status-completed';
    return '';
}

// Map nhãn trạng thái
function mapReturnStatusLabel(status) {
    if (status === 'PROCESSING') return 'Chờ xử lý';
    if (status === 'COMPLETED') return 'Đã xác nhận';
    return status || '';
}

// Xem chi tiết return
function viewReturnDetail(returnId) {
    fetch(`/api/returns/detail?id=${returnId}`)
        .then(response => response.json())
        .then(ret => {
            document.getElementById('returnModalOrderNumber').innerText = `#${ret.orderNumber || ret.orderId}`;
            document.getElementById('returnModalUserId').innerText = ret.customerName || '';
            document.getElementById('returnModalProductId').innerText = ret.productName || '';
            document.getElementById('returnModalReason').innerText = ret.reason || '';
            document.getElementById('returnModalRequestType').innerText = ret.requestType || '';
            document.getElementById('returnModalStatus').innerText = mapReturnStatusLabel(ret.status);
            document.getElementById('returnModalCreatedAt').innerText = ret.createdAt || '';

            const modal = new bootstrap.Modal(document.getElementById('returnModal'));
            modal.show();
        })
        .catch(error => console.error('Lỗi khi xem chi tiết:', error));
}

document.addEventListener('DOMContentLoaded', function () {
    const filterElement = document.getElementById('filter-return-status');
    if (filterElement) {
        filterElement.addEventListener('change', function () {
            loadReturns(this.value);
        });
    }
});
function loadDashboardStats() {
    fetch('/api/complaints/summary') // Hoặc /api/dashboard/stats nếu bạn đổi tên
        .then(response => response.json())
        .then(data => {
            document.querySelector('.stat-card-2 .number').textContent = data.newComplaints ?? 0;
            document.querySelector('.stat-card-3 .number').textContent = data.returnRequests ?? 0;
            document.querySelector('.stat-card-4 .number').textContent = data.completedToday ?? 0;
        })
        .catch(error => {
            console.error('❌ Lỗi khi load thống kê dashboard:', error);
        });
}