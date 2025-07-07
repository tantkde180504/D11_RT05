// Register Form Handler for 43 Gundam Hobby
document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    const registerFormBox = document.getElementById('register-form');
    const successMessage = document.getElementById('success-message');
    
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const firstName = document.getElementById('firstName').value.trim();
            const lastName = document.getElementById('lastName').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const phone = document.getElementById('phone').value.trim();
            const agreeTerms = document.getElementById('agreeTerms').checked;
            
            // Client-side validation
            if (!validateForm(firstName, lastName, email, password, confirmPassword, agreeTerms)) {
                return;
            }
            
            // Prepare form data
            const formData = new FormData();
            formData.append('firstName', firstName);
            formData.append('lastName', lastName);
            formData.append('email', email);
            formData.append('password', password);
            formData.append('confirmPassword', confirmPassword);
            if (phone) {
                formData.append('phone', phone);
            }
            
            // Submit registration
            submitRegistration(formData);
        });
    }
    
    // Password confirmation validation
    const confirmPasswordInput = document.getElementById('confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.setCustomValidity('Mật khẩu xác nhận không khớp!');
            } else {
                this.setCustomValidity('');
            }
        });
    }
    
    // Google Sign Up button handler
    const googleSignUpBtn = document.getElementById('google-sign-up-btn');
    if (googleSignUpBtn) {
        googleSignUpBtn.addEventListener('click', function() {
            // This would integrate with Google OAuth
            alert('Chức năng đăng ký bằng Google sẽ được triển khai sau.');
        });
    }
});

function validateForm(firstName, lastName, email, password, confirmPassword, agreeTerms) {
    // Check required fields
    if (!firstName) {
        showError('Vui lòng nhập họ!');
        return false;
    }
    
    if (!lastName) {
        showError('Vui lòng nhập tên!');
        return false;
    }
    
    if (!email) {
        showError('Vui lòng nhập email!');
        return false;
    }
    
    if (!password) {
        showError('Vui lòng nhập mật khẩu!');
        return false;
    }
    
    if (!confirmPassword) {
        showError('Vui lòng xác nhận mật khẩu!');
        return false;
    }
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showError('Email không hợp lệ!');
        return false;
    }
    
    // Password validation
    if (password.length < 6) {
        showError('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    
    // Password confirmation
    if (password !== confirmPassword) {
        showError('Mật khẩu xác nhận không khớp!');
        return false;
    }
    
    // Terms agreement
    if (!agreeTerms) {
        showError('Vui lòng đồng ý với điều khoản sử dụng!');
        return false;
    }
    
    return true;
}

function submitRegistration(formData) {
    const submitBtn = document.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Show loading state
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
    
    fetch('/api/register', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('Register response:', data);
        
        if (data.success) {
            // Hide form and show success message
            const registerFormBox = document.getElementById('register-form');
            const successMessage = document.getElementById('success-message');
            
            if (registerFormBox && successMessage) {
                registerFormBox.classList.add('d-none');
                successMessage.classList.remove('d-none');
            }
            
            // Clear form
            document.getElementById('registerForm').reset();
            
            showSuccess('Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.');
        } else {
            showError(data.message || 'Có lỗi xảy ra khi đăng ký!');
        }
    })
    .catch(error => {
        console.error('Register error:', error);
        showError('Có lỗi xảy ra khi đăng ký! Vui lòng thử lại.');
    })
    .finally(() => {
        // Restore button state
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
    });
}

function showError(message) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create error alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-danger alert-dismissible fade show';
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert before form
    const form = document.getElementById('register-form');
    if (form) {
        form.parentNode.insertBefore(alert, form);
    }
}

function showSuccess(message) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create success alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-success alert-dismissible fade show';
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert at top of container
    const container = document.querySelector('.container');
    if (container) {
        container.insertBefore(alert, container.firstChild);
    }
}

// Form field validation helpers
function setupFieldValidation() {
    const fields = {
        firstName: 'Họ không được để trống!',
        lastName: 'Tên không được để trống!',
        email: 'Email không hợp lệ!',
        password: 'Mật khẩu phải có ít nhất 6 ký tự!',
        confirmPassword: 'Mật khẩu xác nhận không khớp!'
    };
    
    Object.keys(fields).forEach(fieldName => {
        const field = document.getElementById(fieldName);
        if (field) {
            field.addEventListener('blur', function() {
                validateField(fieldName, this.value, fields[fieldName]);
            });
        }
    });
}

function validateField(fieldName, value, errorMessage) {
    const field = document.getElementById(fieldName);
    
    switch (fieldName) {
        case 'firstName':
        case 'lastName':
            if (!value.trim()) {
                field.setCustomValidity(errorMessage);
            } else {
                field.setCustomValidity('');
            }
            break;
        case 'email':
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(value)) {
                field.setCustomValidity(errorMessage);
            } else {
                field.setCustomValidity('');
            }
            break;
        case 'password':
            if (value.length < 6) {
                field.setCustomValidity(errorMessage);
            } else {
                field.setCustomValidity('');
            }
            break;
        case 'confirmPassword':
            const password = document.getElementById('password').value;
            if (value !== password) {
                field.setCustomValidity(errorMessage);
            } else {
                field.setCustomValidity('');
            }
            break;
    }
}

// Initialize field validation when page loads
document.addEventListener('DOMContentLoaded', setupFieldValidation);
