// Staff Dashboard JavaScript
document.addEventListener('DOMContentLoaded', function() {
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
});

// Tab switching functionality
function initTabSwitching() {
    document.querySelectorAll('.nav-link[data-tab]').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all links and contents
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            // Add active class to clicked link
            this.classList.add('active');
            
            // Show corresponding tab content
            const tabId = this.getAttribute('data-tab');
            document.getElementById(tabId).classList.add('active');

            // ✅ Gọi API khi đổi tab
            if (tabId === 'inventory') {
                loadInventoryFromAPI();
            }
            if (tabId === 'orders') {
                loadOrdersFromAPI(); // ✅ BỔ SUNG DÒNG NÀY
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
        input.addEventListener('input', function() {
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
        priority.addEventListener('click', function() {
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
        badge.addEventListener('click', function() {
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
        templateSelect.addEventListener('change', function() {
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
    document.addEventListener('keydown', function(e) {
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
    setInterval(function() {
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
            button.addEventListener('click', function() {
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
    window.addEventListener('resize', function() {
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
        
        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 300) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                reject(new Error(`Request failed with status ${xhr.status}`));
            }
        };
        
        xhr.onerror = function() {
            reject(new Error('Network error'));
        };
        
        xhr.send(data ? JSON.stringify(data) : null);
    });
}

// Auto-save functionality
function enableAutoSave(form, saveUrl) {
    let saveTimeout;
    
    form.addEventListener('input', function() {
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
document.addEventListener("DOMContentLoaded", () => {
    const s = document.querySelector("#order-status");
    if (!s) return;
    const status = s.textContent.trim().toUpperCase();
    if (status === "PENDING") s.className = "badge bg-secondary";
    else if (status === "CONFIRMED") s.className = "badge bg-primary";
    else if (status === "PROCESSING") s.className = "badge bg-warning text-dark";
    else if (status === "SHIPPING") s.className = "badge bg-info text-dark";
    else if (status === "DELIVERED") s.className = "badge bg-success";
    else s.className = "badge bg-dark";
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

window.notificationManager = notificationManager;
function loadOrdersFromAPI() {
    const status = document.getElementById('order-status-filter')?.value || 'ALL';
    fetch(`/api/orders?status=${status}`)
        .then(res => res.json())
        .then(data => {
            const tbody = document.getElementById('orders-body');
            tbody.innerHTML = '';

            data.forEach(o => {
                const productList = o.productNames?.join('<br>') || '';
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td><strong>#${o.orderNumber}</strong></td>
                    <td>${o.shippingName}</td>
                    <td>${productList}</td>
                    <td><strong>${formatCurrency(o.totalAmount)}</strong></td>
                    <td><span class="status-badge">${o.status}</span></td>
                    <td>${o.orderDate}</td>
                    <td>
    ${o.status === 'PENDING' ? `
    <button class="btn btn-sm btn-success me-1" onclick="confirmOrder(${o.id})">
        <i class="fas fa-check"></i>
    </button>` : ''}
    <button class="btn btn-sm btn-warning me-1"><i class="fas fa-edit"></i></button>
    <button class="btn btn-sm btn-info"><i class="fas fa-eye"></i></button>
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

function formatCurrency(price) {
    return Number(price).toLocaleString('vi-VN') + '₫';
}
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

