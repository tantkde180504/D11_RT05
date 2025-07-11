// Simple Login JavaScript
console.log('Simple login.js loaded!');

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM Content Loaded!');
    
    const loginForm = document.getElementById('loginForm');
    console.log('Login form found:', loginForm);
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            console.log('Form submit intercepted!');
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            console.log('Email:', email);
            console.log('Password:', password);
            
            // Basic validation
            if (!email || !password) {
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }
            
            if (!isValidEmail(email)) {
                alert('Email không hợp lệ!');
                return;
            }
            
            // Show loading
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = 'Đang đăng nhập...';
            submitBtn.disabled = true;
            
            console.log('Sending request to /api/login...');
            
            // Send login request
            fetch('/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
            })
            .then(response => {
                console.log('Response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                
                if (data.success === true) {
                    // Save user info to localStorage
                    localStorage.setItem('userName', data.fullName);
                    localStorage.setItem('userRole', data.role);
                    
                    // Show success message
                    const roleText = getRoleDisplayName(data.role);
                    showAlert(`🎉 Đăng nhập thành công! Chào mừng ${data.fullName} (${roleText})`, 'success');
                      // Redirect to appropriate page based on server response
                     setTimeout(() => {
                        // Use redirectUrl from server response if available, otherwise fallback to client-side logic
                        let targetPage = data.redirectUrl;
                        
                        if (!targetPage) {
                            // Fallback client-side logic
                            const role = data.role ? data.role.toUpperCase() : '';
                            if (role === 'ADMIN') {
                                targetPage = '/dashboard.jsp';
                            } else if (role === 'STAFF') {
                                targetPage = '/staffsc.jsp';
                            } else {
                                targetPage = '/index.jsp';
                            }
                        }
                        
                        console.log('Redirecting to:', targetPage, '(Role:', data.role + ')');
                        showAlert(`🚀 Đang chuyển đến trang chủ...`, 'info');
                        
                        setTimeout(() => {
                            window.location.href = targetPage;
                        }, 1000);
                    }, 2000);
                } else {
                    showAlert(data.message || 'Sai email hoặc mật khẩu!', 'danger');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                
                showAlert('Lỗi kết nối máy chủ!', 'danger');
            });
        });
    } else {
        console.error('Login form not found!');
    }
});

// Email validation
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Get role display name in Vietnamese
function getRoleDisplayName(role) {
    switch(role ? role.toUpperCase() : '') {
        case 'ADMIN':
            return 'Quản trị viên';
        case 'STAFF':
            return 'Nhân viên';
        case 'CUSTOMER':
            return 'Khách hàng';
        default:
            return 'Người dùng';
    }
}

// Show alert messages
function showAlert(message, type, duration = 4000) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.style.position = 'fixed';
    alertDiv.style.top = '20px';
    alertDiv.style.left = '50%';
    alertDiv.style.transform = 'translateX(-50%)';
    alertDiv.style.zIndex = '9999';
    alertDiv.style.minWidth = '300px';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Add to body
    document.body.appendChild(alertDiv);
    
    // Auto dismiss
    if (duration > 0) {
        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, duration);
    }
}

// Save user logged in state
function setUserLoggedIn(name, email) {
    localStorage.setItem('userName', name);
    localStorage.setItem('userEmail', email);
}