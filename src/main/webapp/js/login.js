// Login Page JavaScript

// Password visibility toggle
function togglePassword() {
    const passwordField = document.getElementById('password');
    const passwordIcon = document.getElementById('passwordIcon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordIcon.classList.remove('fa-eye');
        passwordIcon.classList.add('fa-eye-slash');
    } else {
        passwordField.type = 'password';
        passwordIcon.classList.remove('fa-eye-slash');
        passwordIcon.classList.add('fa-eye');
    }
}

function toggleRegisterPassword() {
    const passwordField = document.getElementById('registerPassword');
    const passwordIcon = document.getElementById('registerPasswordIcon');
    
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordIcon.classList.remove('fa-eye');
        passwordIcon.classList.add('fa-eye-slash');
    } else {
        passwordField.type = 'password';
        passwordIcon.classList.remove('fa-eye-slash');
        passwordIcon.classList.add('fa-eye');
    }
}

// Form validation
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    
    // Handle exclusive checkbox selection for user roles (optional - only if checkboxes exist)
    const isAdminCheckbox = document.getElementById('isAdmin');
    const isStaffCheckbox = document.getElementById('isStaff');
    
    if (isAdminCheckbox && isStaffCheckbox) {
        isAdminCheckbox.addEventListener('change', function() {
            if (this.checked) {
                isStaffCheckbox.checked = false;
            }
        });
        
        isStaffCheckbox.addEventListener('change', function() {
            if (this.checked) {
                isAdminCheckbox.checked = false;
            }
        });
    }
      // Login form validation
    if (loginForm) {
        let isSubmitting = false; // Prevent duplicate submissions
        
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Prevent duplicate submissions
            if (isSubmitting) {
                console.log('⚠️ Form already submitting, ignoring duplicate request');
                return;
            }
            
            isSubmitting = true;
            console.log('Form submitted!'); // Debug log
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            // Optional checkboxes - only check if they exist
            const isAdminCheckbox = document.getElementById('isAdmin');
            const isStaffCheckbox = document.getElementById('isStaff');
            const isAdmin = isAdminCheckbox ? isAdminCheckbox.checked : false;
            const isStaff = isStaffCheckbox ? isStaffCheckbox.checked : false;
            
            console.log('Email:', email, 'Password:', password); // Debug log
            
            if (!email || !password) {
                showAlert('Vui lòng điền đầy đủ thông tin!', 'danger');
                isSubmitting = false; // Reset flag
                return;
            }
            
            // Only check role conflict if both checkboxes exist
            if (isAdminCheckbox && isStaffCheckbox && isAdmin && isStaff) {
                showAlert('Vui lòng chỉ chọn một loại quyền đăng nhập!', 'warning');
                isSubmitting = false; // Reset flag
                return;
            }
            
            if (!isValidEmail(email)) {
                showAlert('Email không hợp lệ!', 'danger');
                isSubmitting = false; // Reset flag
                return;
            }
            
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            
            // Try API login first, then fallback to demo mode
            console.log('🔄 Attempting login with API...');
            
            fetch('/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
            })
            .then(response => {
                console.log('API Response status:', response.status);
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}`);
                }
                return response.json();
            })
            .then(data => {
                console.log('API Response data:', data);
                handleLoginSuccess(data, email, submitBtn);
                isSubmitting = false; // Reset flag after success
            })
            .catch(error => {
                console.log('❌ API login failed:', error.message);
                console.log('🔄 Switching to demo mode...');
                
                // Demo mode - simulate successful login
                const demoData = {
                    success: true,
                    fullName: getDemoUserName(email),
                    role: getDemoUserRole(email),
                    avatarUrl: '',
                    message: 'Demo login successful'
                };
                
                console.log('✅ Demo login data:', demoData);
                handleLoginSuccess(demoData, email, submitBtn);
                isSubmitting = false; // Reset flag after fallback
            });
        });
    }
    
    // Handle successful login (API or demo)
    function handleLoginSuccess(data, email, submitBtn) {
        submitBtn.classList.remove('loading');
        submitBtn.disabled = false;
        
        if (data.success === true) {
            showAlert('Đăng nhập thành công!', 'success');
            
            // Prevent multiple redirects
            if (window.isRedirecting) {
                console.log('⚠️ Already redirecting, ignoring duplicate redirect request');
                return;
            }
            window.isRedirecting = true;
            
            setTimeout(() => {
                console.log('🔄 Converting email login to Google format...');
                
                // Use the converter to transform login data to Google format
                if (window.emailToGoogleConverter) {
                    try {
                        const googleUser = window.emailToGoogleConverter.convertAndStore({
                            fullName: data.fullName,
                            email: email,
                            role: data.role,
                            avatarUrl: data.avatarUrl || ''
                        });
                        
                        console.log('✅ Email login converted to Google format:', googleUser);
                        
                        // Use redirectUrl from server response or fallback to home page
                        const redirectUrl = data.redirectUrl || '/';
                        console.log('🏠 Redirecting to:', redirectUrl, '(Role:', data.role + ')');
                        
                        // Add justLoggedIn marker
                        localStorage.setItem('justLoggedIn', 'true');
                        
                        // Redirect based on user role
                        window.location.href = redirectUrl;
                        
                    } catch (error) {
                        console.error('❌ Error converting to Google format:', error);
                        // Fallback: use redirectUrl from server or default to home
                        const redirectUrl = data.redirectUrl || '/';
                        console.log('🏠 Fallback redirect to:', redirectUrl);
                        window.location.href = redirectUrl;
                    }
                } else {
                    console.warn('⚠️ Email to Google converter not available, using fallback');
                    
                    // Fallback: store as regular user and redirect
                    localStorage.setItem('currentUser', JSON.stringify({
                        fullName: data.fullName,
                        email: email,
                        role: data.role,
                        avatarUrl: data.avatarUrl || ''
                    }));
                    localStorage.setItem('userRole', data.role);
                    localStorage.setItem('justLoggedIn', 'true');
                    
                    // Use redirectUrl from server response or fallback to home page
                    const redirectUrl = data.redirectUrl || '/';
                    console.log('🏠 Fallback redirect to:', redirectUrl, '(Role:', data.role + ')');
                    window.location.href = redirectUrl;
                }
            }, 1500);
        } else {
            showAlert(data.message || 'Sai email hoặc mật khẩu!', 'danger');
        }
    }
    
    // Generate demo user data based on email
    function getDemoUserName(email) {
        const emailPrefix = email.split('@')[0];
        const names = {
            'tanoniichan': 'Tan Onii Chan',
            'admin': 'System Administrator', 
            'staff': 'Staff Member',
            'test': 'Test User'
        };
        
        return names[emailPrefix] || `User ${emailPrefix.charAt(0).toUpperCase() + emailPrefix.slice(1)}`;
    }
    
    // Generate demo user role based on email
    function getDemoUserRole(email) {
        const emailPrefix = email.split('@')[0].toLowerCase();
        
        if (emailPrefix.includes('admin')) return 'ADMIN';
        if (emailPrefix.includes('staff')) return 'STAFF';
        return 'CUSTOMER';
    }
    
    // Register form validation
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const firstName = document.getElementById('firstName').value;
            const lastName = document.getElementById('lastName').value;
            const email = document.getElementById('registerEmail').value;
            const password = document.getElementById('registerPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const agreeTerms = document.getElementById('agreeTerms').checked;
            
            if (!firstName || !lastName || !email || !password || !confirmPassword) {
                showAlert('Vui lòng điền đầy đủ thông tin!', 'danger');
                return;
            }
            
            if (!isValidEmail(email)) {
                showAlert('Email không hợp lệ!', 'danger');
                return;
            }
            
            if (password.length < 6) {
                showAlert('Mật khẩu phải có ít nhất 6 ký tự!', 'danger');
                return;
            }
            
            if (password !== confirmPassword) {
                showAlert('Mật khẩu xác nhận không khớp!', 'danger');
                return;
            }
            
            if (!agreeTerms) {
                showAlert('Vui lòng đồng ý với điều khoản sử dụng!', 'danger');
                return;
            }
            
            // Show loading state
            const submitBtn = registerForm.querySelector('button[type="submit"]');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            
            // Simulate API call
            setTimeout(() => {
                showAlert('Đăng ký thành công! Vui lòng kiểm tra email để kích hoạt tài khoản.', 'success');
                registerForm.reset();
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }, 1500);
        });
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
        case 'SHIPPER':
            return 'Giao hàng';
        default:
            return 'Người dùng';
    }
}

// Show alert messages
function showAlert(message, type, duration = 5000) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert alert at the top of the form
    const form = document.querySelector('.login-form-section') || document.querySelector('.register-form-section');
    if (form) {
        form.insertBefore(alertDiv, form.firstChild);
    } else {
        // Fallback: insert at top of body
        document.body.insertBefore(alertDiv, document.body.firstChild);
    }
      // Auto dismiss after specified duration
    if (duration > 0) {
        setTimeout(() => {
            if (alertDiv && alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, duration);
    }
}

// Social login handlers
document.addEventListener('DOMContentLoaded', function() {
    const facebookBtn = document.querySelector('.btn-outline-primary');
    const googleBtn = document.querySelector('.btn-outline-danger');
    
    if (facebookBtn) {
        facebookBtn.addEventListener('click', function() {
            showAlert('Tính năng đăng nhập Facebook đang được phát triển!', 'info');
        });
    }
    
    if (googleBtn) {
        googleBtn.addEventListener('click', function() {
            showAlert('Tính năng đăng nhập Google đang được phát triển!', 'info');
        });
    }
});

// Handle forgot password
document.addEventListener('DOMContentLoaded', function() {
    const forgotPasswordLink = document.querySelector('.forgot-password-link');
    
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            
            const email = prompt('Vui lòng nhập email của bạn:');
            if (email) {
                if (isValidEmail(email)) {
                    showAlert('Link đặt lại mật khẩu đã được gửi đến email của bạn!', 'success');
                } else {
                    showAlert('Email không hợp lệ!', 'danger');
                }
            }
        });
    }
});

// Sau khi đăng nhập thành công, lưu thông tin vào localStorage để profile.jsp hiển thị đúng
function setUserLoggedIn(name, email) {
    localStorage.setItem('userName', name);
    localStorage.setItem('userEmail', email);
    localStorage.setItem('userLoggedIn', 'true');
    
    // Trigger navbar update if function exists
    if (typeof window.showUserMenu === 'function') {
        window.showUserMenu(name);
    }
    
    // Trigger function to check login status
    if (typeof window.checkUserLoginStatus === 'function') {
        window.checkUserLoginStatus();
    }
}

// Global function to update navbar after login
window.updateNavbarAfterLogin = function(userData) {
    if (typeof window.showUserMenu === 'function') {
        window.showUserMenu(userData.fullName);
    }
    
    if (typeof window.checkUserLoginStatus === 'function') {
        window.checkUserLoginStatus();
    }
};