// Forgot Password Handler for 43 Gundam Hobby
document.addEventListener('DOMContentLoaded', function() {
    const forgotPasswordForm = document.getElementById('forgotPasswordForm');
    const resetPasswordForm = document.getElementById('resetPasswordForm');
    const forgotPasswordFormBox = document.getElementById('forgot-password-form');
    const resetPasswordFormBox = document.getElementById('reset-password-form');
    const successMessage = document.getElementById('success-message');
    const resetSuccessMessage = document.getElementById('reset-success-message');
    
    // Check URL for reset token
    const urlParams = new URLSearchParams(window.location.search);
    const resetToken = urlParams.get('token');
    
    if (resetToken) {
        // If token exists in URL, verify it and show reset password form
        verifyResetToken(resetToken);
    }
    
    // Forgot Password Form Handler
    if (forgotPasswordForm) {
        forgotPasswordForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const email = document.getElementById('email').value.trim();
            
            // Client-side validation
            if (!validateEmail(email)) {
                return;
            }
            
            // Submit forgot password request
            submitForgotPassword(email);
        });
    }
    
    // Reset Password Form Handler
    if (resetPasswordForm) {
        resetPasswordForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const token = document.getElementById('resetToken').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmNewPassword = document.getElementById('confirmNewPassword').value;
            
            // Client-side validation
            if (!validateResetPassword(newPassword, confirmNewPassword)) {
                return;
            }
            
            // Submit reset password request
            submitResetPassword(token, newPassword, confirmNewPassword);
        });
        
        // Password confirmation validation
        const confirmNewPasswordInput = document.getElementById('confirmNewPassword');
        if (confirmNewPasswordInput) {
            confirmNewPasswordInput.addEventListener('input', function() {
                const newPassword = document.getElementById('newPassword').value;
                const confirmNewPassword = this.value;
                
                if (confirmNewPassword && newPassword !== confirmNewPassword) {
                    this.setCustomValidity('Mật khẩu xác nhận không khớp!');
                } else {
                    this.setCustomValidity('');
                }
            });
        }
    }
});

function validateEmail(email) {
    if (!email) {
        showError('Vui lòng nhập email!');
        return false;
    }
    
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showError('Email không hợp lệ!');
        return false;
    }
    
    return true;
}

function validateResetPassword(newPassword, confirmNewPassword) {
    if (!newPassword) {
        showError('Vui lòng nhập mật khẩu mới!');
        return false;
    }
    
    if (newPassword.length < 6) {
        showError('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    
    if (!confirmNewPassword) {
        showError('Vui lòng xác nhận mật khẩu mới!');
        return false;
    }
    
    if (newPassword !== confirmNewPassword) {
        showError('Mật khẩu xác nhận không khớp!');
        return false;
    }
    
    return true;
}

function submitForgotPassword(email) {
    const submitBtn = document.querySelector('#forgotPasswordForm button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Show loading state
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
    
    const formData = new FormData();
    formData.append('email', email);
    
    fetch('/api/forgot-password', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('Forgot password response:', data);
        
        if (data.success) {
            // Hide form and show success message
            const forgotPasswordFormBox = document.getElementById('forgot-password-form');
            const successMessage = document.getElementById('success-message');
            
            if (forgotPasswordFormBox && successMessage) {
                forgotPasswordFormBox.classList.add('d-none');
                successMessage.classList.remove('d-none');
            }
            
            // Clear form
            document.getElementById('forgotPasswordForm').reset();
            
            showSuccess('Email hướng dẫn đặt lại mật khẩu đã được gửi!');
            
            // For testing: if resetToken is returned, show it
            if (data.resetToken) {
                console.log('Reset token for testing:', data.resetToken);
                const testLink = window.location.origin + window.location.pathname + '?token=' + data.resetToken;
                console.log('Test reset link:', testLink);
                
                // Add test link to success message for development
                const successDiv = document.querySelector('#success-message .text-center');
                if (successDiv) {
                    const testLinkDiv = document.createElement('div');
                    testLinkDiv.className = 'alert alert-warning mt-3';
                    testLinkDiv.innerHTML = `
                        <strong>For Testing:</strong><br>
                        <a href="${testLink}" class="btn btn-sm btn-warning">Test Reset Link</a>
                    `;
                    successDiv.appendChild(testLinkDiv);
                }
            }
        } else {
            showError(data.message || 'Có lỗi xảy ra khi gửi email!');
        }
    })
    .catch(error => {
        console.error('Forgot password error:', error);
        showError('Có lỗi xảy ra khi gửi email! Vui lòng thử lại.');
    })
    .finally(() => {
        // Restore button state
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
    });
}

function verifyResetToken(token) {
    console.log('Verifying reset token:', token);
    
    fetch(`/api/verify-reset-token?token=${encodeURIComponent(token)}`)
    .then(response => response.json())
    .then(data => {
        console.log('Token verification response:', data);
        
        if (data.success) {
            // Token is valid, show reset password form
            showResetPasswordForm(token, data.email);
        } else {
            // Token is invalid or expired
            showError('Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn!');
        }
    })
    .catch(error => {
        console.error('Token verification error:', error);
        showError('Có lỗi xảy ra khi xác minh liên kết!');
    });
}

function showResetPasswordForm(token, email) {
    // Hide forgot password form
    const forgotPasswordFormBox = document.getElementById('forgot-password-form');
    if (forgotPasswordFormBox) {
        forgotPasswordFormBox.classList.add('d-none');
    }
    
    // Show reset password form
    const resetPasswordFormBox = document.getElementById('reset-password-form');
    if (resetPasswordFormBox) {
        resetPasswordFormBox.classList.remove('d-none');
        
        // Set token in hidden field
        const resetTokenInput = document.getElementById('resetToken');
        if (resetTokenInput) {
            resetTokenInput.value = token;
        }
        
        // Update title
        const titleElement = document.querySelector('.login-title');
        if (titleElement) {
            titleElement.textContent = 'Đặt lại mật khẩu';
        }
        
        // Add email info
        const resetForm = document.getElementById('resetPasswordForm');
        if (resetForm && !resetForm.querySelector('.email-info')) {
            const emailInfo = document.createElement('div');
            emailInfo.className = 'alert alert-info email-info';
            emailInfo.innerHTML = `<i class="fas fa-info-circle me-2"></i>Đặt lại mật khẩu cho: <strong>${email}</strong>`;
            resetForm.insertBefore(emailInfo, resetForm.firstChild);
        }
    }
}

function submitResetPassword(token, newPassword, confirmNewPassword) {
    const submitBtn = document.querySelector('#resetPasswordForm button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // Show loading state
    submitBtn.disabled = true;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
    
    const formData = new FormData();
    formData.append('token', token);
    formData.append('newPassword', newPassword);
    formData.append('confirmNewPassword', confirmNewPassword);
    
    fetch('/api/reset-password', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('Reset password response:', data);
        
        if (data.success) {
            // Hide form and show success message
            const resetPasswordFormBox = document.getElementById('reset-password-form');
            const resetSuccessMessage = document.getElementById('reset-success-message');
            
            if (resetPasswordFormBox && resetSuccessMessage) {
                resetPasswordFormBox.classList.add('d-none');
                resetSuccessMessage.classList.remove('d-none');
            }
            
            // Clear form
            document.getElementById('resetPasswordForm').reset();
            
            showSuccess('Mật khẩu đã được đặt lại thành công!');
        } else {
            showError(data.message || 'Có lỗi xảy ra khi đặt lại mật khẩu!');
        }
    })
    .catch(error => {
        console.error('Reset password error:', error);
        showError('Có lỗi xảy ra khi đặt lại mật khẩu! Vui lòng thử lại.');
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
    existingAlerts.forEach(alert => {
        if (!alert.classList.contains('alert-info') && !alert.classList.contains('email-info')) {
            alert.remove();
        }
    });
    
    // Create error alert
    const alert = document.createElement('div');
    alert.className = 'alert alert-danger alert-dismissible fade show';
    alert.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Insert before visible form
    const visibleForm = document.querySelector('.login-form-box:not(.d-none)');
    if (visibleForm) {
        visibleForm.parentNode.insertBefore(alert, visibleForm);
    }
}

function showSuccess(message) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert-danger');
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

// Utility function to get URL parameter
function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    const regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    const results = regex.exec(location.search);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}
