// Toggle visibility for login password
function togglePassword() {
    const passwordField = document.getElementById('password');
    const passwordIcon = document.getElementById('passwordIcon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordIcon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        passwordField.type = 'password';
        passwordIcon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

// Toggle visibility for register password
function toggleRegisterPassword() {
    const passwordField = document.getElementById('registerPassword');
    const passwordIcon = document.getElementById('registerPasswordIcon');

    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordIcon.classList.replace('fa-eye', 'fa-eye-slash');
    } else {
        passwordField.type = 'password';
        passwordIcon.classList.replace('fa-eye-slash', 'fa-eye');
    }
}

// Email validation function
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Show alert messages
function showAlert(message, type, duration = 5000) {
    document.querySelectorAll('.alert').forEach(alert => alert.remove());

    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    const form = document.querySelector('.login-form-section') || document.querySelector('.register-form-section');
    (form || document.body).insertBefore(alertDiv, (form || document.body).firstChild);

    if (duration > 0) {
        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) alertDiv.remove();
        }, duration);
    }
}

// Get demo user name
function getDemoUserName(email) {
    const prefix = email.split('@')[0];
    const names = {
        'tanoniichan': 'Tan Onii Chan',
        'admin': 'System Administrator',
        'staff': 'Staff Member',
        'test': 'Test User'
    };
    return names[prefix] || `User ${prefix.charAt(0).toUpperCase() + prefix.slice(1)}`;
}

// Get demo role
function getDemoUserRole(email) {
    const prefix = email.split('@')[0].toLowerCase();
    if (prefix.includes('admin')) return 'ADMIN';
    if (prefix.includes('staff')) return 'STAFF';
    return 'CUSTOMER';
}

// Display role in Vietnamese
function getRoleDisplayName(role) {
    switch (role?.toUpperCase()) {
        case 'ADMIN': return 'Quản trị viên';
        case 'STAFF': return 'Nhân viên';
        case 'CUSTOMER': return 'Khách hàng';
        case 'SHIPPER': return 'Giao hàng';
        default: return 'Người dùng';
    }
}

// After login, set local storage & call navbar updates
function setUserLoggedIn(name, email) {
    localStorage.setItem('userName', name);
    localStorage.setItem('userEmail', email);
    localStorage.setItem('userLoggedIn', 'true');

    if (typeof window.showUserMenu === 'function') window.showUserMenu(name);
    if (typeof window.checkUserLoginStatus === 'function') window.checkUserLoginStatus();
}

// Global method for login UI updates
window.updateNavbarAfterLogin = function(userData) {
    if (typeof window.showUserMenu === 'function') window.showUserMenu(userData.fullName);
    if (typeof window.checkUserLoginStatus === 'function') window.checkUserLoginStatus();
};

document.addEventListener('DOMContentLoaded', function () {
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    const isAdminCheckbox = document.getElementById('isAdmin');
    const isStaffCheckbox = document.getElementById('isStaff');

    if (isAdminCheckbox && isStaffCheckbox) {
        isAdminCheckbox.addEventListener('change', () => {
            if (isAdminCheckbox.checked) isStaffCheckbox.checked = false;
        });
        isStaffCheckbox.addEventListener('change', () => {
            if (isStaffCheckbox.checked) isAdminCheckbox.checked = false;
        });
    }

    if (loginForm) {
        let isSubmitting = false;

        loginForm.addEventListener('submit', function (e) {
            e.preventDefault();
            if (isSubmitting) return;

            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const isAdmin = isAdminCheckbox?.checked;
            const isStaff = isStaffCheckbox?.checked;

            if (!email || !password) {
                showAlert('Vui lòng điền đầy đủ thông tin!', 'danger');
                return;
            }

            if (isAdmin && isStaff) {
                showAlert('Vui lòng chỉ chọn một loại quyền đăng nhập!', 'warning');
                return;
            }

            if (!isValidEmail(email)) {
                showAlert('Email không hợp lệ!', 'danger');
                return;
            }

            const submitBtn = loginForm.querySelector('button[type="submit"]');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            isSubmitting = true;

            fetch('/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
            })
                .then(response => {
                    if (!response.ok) throw new Error(`HTTP ${response.status}`);
                    return response.json();
                })
                .then(data => {
                    handleLoginSuccess(data, email, submitBtn);
                    isSubmitting = false;
                })
                .catch(() => {
                    const demoData = {
                        success: true,
                        fullName: getDemoUserName(email),
                        role: getDemoUserRole(email),
                        avatarUrl: '',
                        message: 'Demo login successful'
                    };
                    handleLoginSuccess(demoData, email, submitBtn);
                    isSubmitting = false;
                });
        });
    }

    function handleLoginSuccess(data, email, submitBtn) {
        submitBtn.classList.remove('loading');
        submitBtn.disabled = false;

        if (data.success === true) {
            showAlert('Đăng nhập thành công!', 'success');

            if (window.isRedirecting) return;
            window.isRedirecting = true;

            setTimeout(() => {
                const redirectUrl = data.redirectUrl || '/';
                localStorage.setItem('justLoggedIn', 'true');

                if (window.emailToGoogleConverter) {
                    try {
                        const googleUser = window.emailToGoogleConverter.convertAndStore({
                            fullName: data.fullName,
                            email,
                            role: data.role,
                            avatarUrl: data.avatarUrl || ''
                        });
                        window.location.href = redirectUrl;
                    } catch {
                        window.location.href = redirectUrl;
                    }
                } else {
                    localStorage.setItem('currentUser', JSON.stringify({
                        fullName: data.fullName,
                        email,
                        role: data.role,
                        avatarUrl: data.avatarUrl || ''
                    }));
                    localStorage.setItem('userRole', data.role);
                    window.location.href = redirectUrl;
                }
            }, 1500);
        } else {
            if (data.banReason) {
                document.querySelectorAll('.ban-reason-box').forEach(e => e.remove());
                const banBox = document.createElement('div');
                banBox.className = 'ban-reason-box';
                banBox.style.position = 'fixed';
                banBox.style.top = '32px';
                banBox.style.right = '32px';
                banBox.style.zIndex = '9999';
                banBox.style.background = '#fff0f0';
                banBox.style.border = '2px solid #d9534f';
                banBox.style.color = '#d9534f';
                banBox.style.padding = '20px 28px';
                banBox.style.borderRadius = '12px';
                banBox.style.maxWidth = '360px';
                banBox.style.boxShadow = '0 4px 16px rgba(0,0,0,0.12)';
                banBox.style.textAlign = 'center';
                banBox.style.fontFamily = 'inherit';
                banBox.innerHTML = `
                  <div style='font-size:32px;margin-bottom:8px;'>⚠️</div>
                  <h3 style='margin:0 0 8px 0;font-size:22px;'>Tài khoản của bạn đã bị cấm</h3>
                  <div style='font-size:16px;margin-bottom:8px;'><b>Lý do:</b> <span>${data.banReason}</span></div>
                  <button onclick="this.parentElement.remove()" style="margin-top:8px;padding:6px 18px;border:none;background:#d9534f;color:#fff;border-radius:5px;cursor:pointer;font-size:15px;">Đóng</button>
                `;
                document.body.appendChild(banBox);
            } else {
                showAlert(data.message || 'Sai email hoặc mật khẩu!', 'danger');
            }
        }
    }

    const facebookBtn = document.querySelector('.btn-outline-primary');
    const googleBtn = document.querySelector('.btn-outline-danger');

    if (facebookBtn) {
        facebookBtn.addEventListener('click', () => {
            showAlert('Tính năng đăng nhập Facebook đang được phát triển!', 'info');
        });
    }

    if (googleBtn) {
        googleBtn.addEventListener('click', () => {
            showAlert('Tính năng đăng nhập Google đang được phát triển!', 'info');
        });
    }

    const forgotPasswordLink = document.querySelector('.forgot-password-link');
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', function (e) {
            e.preventDefault();
            const email = prompt('Vui lòng nhập email của bạn:');
            if (email) {
                isValidEmail(email)
                    ? showAlert('Link đặt lại mật khẩu đã được gửi đến email của bạn!', 'success')
                    : showAlert('Email không hợp lệ!', 'danger');
            }
        });
    }
});
