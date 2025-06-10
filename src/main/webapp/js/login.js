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
    
    // Login form validation
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const isAdmin = document.getElementById('isAdmin').checked;
            
            if (!email || !password) {
                showAlert('Vui lòng điền đầy đủ thông tin!', 'danger');
                return;
            }
            
            if (!isValidEmail(email)) {
                showAlert('Email không hợp lệ!', 'danger');
                return;
            }
            
            // Show loading state
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            
            // Simulate API call
            setTimeout(() => {
                // Here you would normally send the request to your server
                console.log('Login attempt:', { email, password, isAdmin });
                
                // Store login info
                if (typeof(Storage) !== "undefined") {
                    if (isAdmin) {
                        localStorage.setItem('isAdmin', 'true');
                        window.location.href = 'dashboard.jsp';
                    } else {
                        // Set user as logged in
                        const userName = email.split('@')[0]; // Use part before @ as username
                        setUserLoggedIn(userName, email);
                        
                        setTimeout(() => {
                            window.location.href = 'index.jsp';
                        }, 1000);
                    }
                }
            }, 1500);
        });
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

// Show alert messages
function showAlert(message, type) {
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
    form.insertBefore(alertDiv, form.firstChild);
    
    // Auto dismiss after 5 seconds
    setTimeout(() => {
        if (alertDiv && alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
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
