// Register Form Handler for 43 Gundam Hobby

// Global error handler
window.addEventListener('error', function(e) {
    console.error('Global JavaScript error in register.js:', {
        message: e.message,
        filename: e.filename,
        lineno: e.lineno,
        colno: e.colno,
        error: e.error
    });
});

// Debug flag
const DEBUG_MODE = true;

function debugLog(...args) {
    if (DEBUG_MODE) {
        console.log('[REGISTER DEBUG]', ...args);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    debugLog('DOM Content Loaded - Starting register.js');
    
    // Check if all required elements exist
    const requiredElements = [
        'registerForm',
        'register-form', 
        'success-message',
        'firstName',
        'lastName',
        'email',
        'password',
        'confirmPassword',
        'agreeTerms'
    ];
    
    const missingElements = [];
    requiredElements.forEach(id => {
        const element = document.getElementById(id);
        if (!element) {
            missingElements.push(id);
        }
    });
    
    if (missingElements.length > 0) {
        console.error('Missing required elements:', missingElements);
        showError('Trang web có lỗi. Vui lòng tải lại trang. (Missing elements: ' + missingElements.join(', ') + ')');
        return;
    }
    
    debugLog('All required elements found');
    
    const registerForm = document.getElementById('registerForm');
    const registerFormBox = document.getElementById('register-form');
    const successMessage = document.getElementById('success-message');
    
    debugLog('Form elements found:', {
        registerForm: !!registerForm,
        registerFormBox: !!registerFormBox,
        successMessage: !!successMessage
    });
    
    if (registerForm) {
        debugLog('Adding submit listener to register form');
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            debugLog('Form submitted!');
            
            try {
                const firstName = document.getElementById('firstName');
                const lastName = document.getElementById('lastName');
                const email = document.getElementById('email');
                const password = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');
                const phone = document.getElementById('phone');
                const agreeTerms = document.getElementById('agreeTerms');
                
                debugLog('Form fields found:', {
                    firstName: !!firstName,
                    lastName: !!lastName,
                    email: !!email,
                    password: !!password,
                    confirmPassword: !!confirmPassword,
                    phone: !!phone,
                    agreeTerms: !!agreeTerms
                });
                
                if (!firstName || !lastName || !email || !password || !confirmPassword || !agreeTerms) {
                    console.error('Some form fields are missing!');
                    showError('Có lỗi với form. Vui lòng tải lại trang.');
                    return;
                }
                
                const firstNameValue = firstName.value.trim();
                const lastNameValue = lastName.value.trim();
                const emailValue = email.value.trim();
                const passwordValue = password.value;
                const confirmPasswordValue = confirmPassword.value;
                const phoneValue = phone ? phone.value.trim() : '';
                const agreeTermsValue = agreeTerms.checked;
                
                debugLog('Form values:', {
                    firstName: firstNameValue,
                    lastName: lastNameValue,
                    email: emailValue,
                    phone: phoneValue,
                    agreeTerms: agreeTermsValue
                });
                
                // Client-side validation
                if (!validateForm(firstNameValue, lastNameValue, emailValue, passwordValue, confirmPasswordValue, agreeTermsValue)) {
                    debugLog('Validation failed');
                    return;
                }
                
                debugLog('Validation passed');
                
                // Prepare form data as URLSearchParams for application/x-www-form-urlencoded
                const formData = new URLSearchParams();
                formData.append('firstName', firstNameValue);
                formData.append('lastName', lastNameValue);
                formData.append('email', emailValue);
                formData.append('password', passwordValue);
                formData.append('confirmPassword', confirmPasswordValue);
                if (phoneValue) {
                    formData.append('phone', phoneValue);
                }
                
                debugLog('Submitting registration...');
                // Submit registration
                submitRegistration(formData);
                
            } catch (error) {
                console.error('Error in form submit handler:', error);
                showError('Có lỗi xảy ra khi xử lý form. Vui lòng thử lại.');
            }
        });
    } else {
        console.error('Register form not found!');
        showError('Không tìm thấy form đăng ký. Vui lòng tải lại trang.');
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
    debugLog('Starting form validation...');
    
    // Check required fields
    if (!firstName) {
        debugLog('Validation failed: firstName is empty');
        showError('Vui lòng nhập họ!');
        return false;
    }
    
    if (!lastName) {
        debugLog('Validation failed: lastName is empty');
        showError('Vui lòng nhập tên!');
        return false;
    }
    
    if (!email) {
        debugLog('Validation failed: email is empty');
        showError('Vui lòng nhập email!');
        return false;
    }
    
    if (!password) {
        debugLog('Validation failed: password is empty');
        showError('Vui lòng nhập mật khẩu!');
        return false;
    }
    
    if (!confirmPassword) {
        debugLog('Validation failed: confirmPassword is empty');
        showError('Vui lòng xác nhận mật khẩu!');
        return false;
    }
    
    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        debugLog('Validation failed: email format invalid');
        showError('Email không hợp lệ!');
        return false;
    }
    
    // Password validation
    if (password.length < 6) {
        debugLog('Validation failed: password too short');
        showError('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    
    // Password confirmation
    if (password !== confirmPassword) {
        debugLog('Validation failed: passwords do not match');
        showError('Mật khẩu xác nhận không khớp!');
        return false;
    }
    
    // Terms agreement
    if (!agreeTerms) {
        debugLog('Validation failed: terms not agreed');
        showError('Vui lòng đồng ý với điều khoản sử dụng!');
        return false;
    }
    
    // Validate name length
    if (firstName.length > 50) {
        debugLog('Validation failed: firstName too long');
        showError('Họ không được vượt quá 50 ký tự!');
        return false;
    }
    
    if (lastName.length > 50) {
        debugLog('Validation failed: lastName too long');
        showError('Tên không được vượt quá 50 ký tự!');
        return false;
    }
    
    debugLog('Form validation passed!');
    return true;
}

function submitRegistration(formData) {
    console.log('=== STARTING REGISTRATION SUBMISSION ===');
    
    const submitBtn = document.querySelector('button[type="submit"]');
    const originalText = submitBtn ? submitBtn.innerHTML : '';
    
    // Show loading state
    if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
    }
    
    console.log('Making fetch request to /api/register');
    
    fetch('/api/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData
    })
    .then(response => {
        console.log('Response received:', {
            status: response.status,
            statusText: response.statusText,
            ok: response.ok,
            headers: response.headers
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return response.json();
    })
    .then(data => {
        console.log('Response JSON parsed:', data);
        
        if (data.success) {
            console.log('Registration successful!');
            
            // Check if this is OTP flow
            if (data.nextStep === 'verify-otp') {
                console.log('OTP flow detected, storing email and redirecting...');
                // Store email for OTP verification
                localStorage.setItem('otpEmail', data.email);
                
                // Show success message and redirect to OTP page
                showSuccess(data.message + ' Đang chuyển hướng...');
                
                setTimeout(() => {
                    console.log('Redirecting to OTP page...');
                    window.location.href = '/verify-otp.jsp?email=' + encodeURIComponent(data.email);
                }, 2000);
            } else {
                console.log('Direct registration flow');
                // Original success flow (direct registration)
                const registerFormBox = document.getElementById('register-form');
                const successMessage = document.getElementById('success-message');
                
                if (registerFormBox && successMessage) {
                    registerFormBox.classList.add('d-none');
                    successMessage.classList.remove('d-none');
                }
                
                // Clear form
                const form = document.getElementById('registerForm');
                if (form) {
                    form.reset();
                }
                
                showSuccess('Đăng ký thành công! Bạn có thể đăng nhập ngay bây giờ.');
            }
        } else {
            console.log('Registration failed:', data.message);
            showError(data.message || 'Có lỗi xảy ra khi đăng ký!');
        }
    })
    .catch(error => {
        console.error('Registration error:', error);
        console.error('Error details:', {
            name: error.name,
            message: error.message,
            stack: error.stack
        });
        showError('Có lỗi xảy ra khi đăng ký! Vui lòng thử lại.');
    })
    .finally(() => {
        console.log('Request completed, restoring button state');
        // Restore button state
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    });
}

function showError(message) {
    console.log('Showing error message:', message);
    
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => {
        console.log('Removing existing alert');
        alert.remove();
    });
    
    // Create error alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-danger alert-dismissible fade show';
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert before form
    const form = document.getElementById('register-form');
    if (form && form.parentNode) {
        console.log('Inserting error alert before form');
        form.parentNode.insertBefore(alert, form);
    } else {
        console.log('Form not found, inserting at top of body');
        // Fallback: insert at top of body
        document.body.insertBefore(alert, document.body.firstChild);
    }
    
    // Auto dismiss after 5 seconds
    setTimeout(() => {
        if (alert && alert.parentNode) {
            alert.remove();
        }
    }, 5000);
}

function showSuccess(message) {
    console.log('Showing success message:', message);
    
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => {
        console.log('Removing existing alert');
        alert.remove();
    });
    
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
        console.log('Inserting success alert at top of container');
        container.insertBefore(alert, container.firstChild);
    } else {
        console.log('Container not found, inserting at top of body');
        // Fallback: insert at top of body
        document.body.insertBefore(alert, document.body.firstChild);
    }
    
    // Auto dismiss after 5 seconds (unless it's a redirect message)
    if (!message.includes('chuyển hướng')) {
        setTimeout(() => {
            if (alert && alert.parentNode) {
                alert.remove();
            }
        }, 5000);
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
