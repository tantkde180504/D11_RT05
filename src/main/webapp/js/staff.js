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
    // Auto-refresh notifications
    setInterval(function () {
        updateNotificationCounts();
        updateStats();
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
    fetch('/api/products/inventory') // ← endpoint từ backend Spring Boot
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

                fetch('/api/products/update-stock', {
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
    fetch(`/api/products/${productId}`)
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
