// Forgot Password with OTP Handler for 43 Gundam Hobby
console.log('🔄 Loading Forgot Password OTP Script...');

document.addEventListener('DOMContentLoaded', function() {
    console.log('📦 DOM ready, initializing forgot password OTP flow...');
    
    // Form elements
    const step1Email = document.getElementById('step-1-email');
    const step2OTP = document.getElementById('step-2-otp');
    const step3Reset = document.getElementById('step-3-reset');
    const step4Success = document.getElementById('step-4-success');
    
    const forgotPasswordForm = document.getElementById('forgotPasswordForm');
    const otpVerificationForm = document.getElementById('otpVerificationForm');
    const resetPasswordForm = document.getElementById('resetPasswordForm');
    
    const emailDisplay = document.getElementById('email-display');
    const resendOtpBtn = document.getElementById('resend-otp');
    const backToEmailBtn = document.getElementById('back-to-email');
    
    // Global variables
    let currentEmail = '';
    let verificationToken = '';
    let otpResendTimer = null;
    let resendCountdown = 0;
    
    // Context path detection
    const contextPath = window.contextPath || getContextPath();
    
    console.log('📍 Context Path:', contextPath);
    
    // Step 1: Email submission
    if (forgotPasswordForm) {
        forgotPasswordForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('📧 Step 1: Email form submitted');
            
            const email = document.getElementById('email').value.trim();
            
            if (!validateEmail(email)) {
                alert('Vui lòng nhập email hợp lệ!');
                return;
            }
            
            currentEmail = email;
            sendOTPRequest(email);
        });
    }
    
    // Step 2: OTP verification
    if (otpVerificationForm) {
        otpVerificationForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('🔢 Step 2: OTP form submitted');
            
            const otp = document.getElementById('otp').value.trim();
            
            if (!validateOTP(otp)) {
                alert('Vui lòng nhập mã OTP gồm 6 chữ số!');
                return;
            }
            
            verifyOTP(currentEmail, otp);
        });
    }
    
    // Step 3: Password reset
    if (resetPasswordForm) {
        resetPasswordForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('🔐 Step 3: Password reset form submitted');
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmNewPassword').value;
            
            if (!validatePasswordReset(newPassword, confirmPassword)) {
                return;
            }
            
            resetPassword(verificationToken, newPassword);
        });
    }
    
    // Resend OTP button
    if (resendOtpBtn) {
        resendOtpBtn.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('🔄 Resending OTP...');
            sendOTPRequest(currentEmail, true);
        });
    }
    
    // Back to email button
    if (backToEmailBtn) {
        backToEmailBtn.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('⬅️ Going back to email step');
            showStep(1);
            currentEmail = '';
            document.getElementById('email').value = '';
            clearResendTimer();
        });
    }
    
    // Auto-format OTP input
    const otpInput = document.getElementById('otp');
    if (otpInput) {
        otpInput.addEventListener('input', function(e) {
            // Only allow numbers
            e.target.value = e.target.value.replace(/[^0-9]/g, '');
        });
        
        otpInput.addEventListener('paste', function(e) {
            // Handle paste events
            setTimeout(() => {
                e.target.value = e.target.value.replace(/[^0-9]/g, '').slice(0, 6);
            }, 10);
        });
    }
    
    // Functions
    function getContextPath() {
        const path = window.location.pathname;
        const segments = path.split('/');
        if (segments.length > 2 && segments[1] !== '') {
            return '/' + segments[1];
        }
        return '';
    }
    
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    function validateOTP(otp) {
        return /^[0-9]{6}$/.test(otp);
    }
    
    function validatePasswordReset(password, confirmPassword) {
        if (password.length < 6) {
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            return false;
        }
        
        if (password !== confirmPassword) {
            alert('Mật khẩu xác nhận không khớp!');
            return false;
        }
        
        return true;
    }
    
    function showStep(stepNumber) {
        console.log('👁️ Showing step:', stepNumber);
        
        // Hide all steps
        [step1Email, step2OTP, step3Reset, step4Success].forEach(step => {
            if (step) step.classList.add('d-none');
        });
        
        // Show current step
        switch(stepNumber) {
            case 1:
                if (step1Email) step1Email.classList.remove('d-none');
                break;
            case 2:
                if (step2OTP) step2OTP.classList.remove('d-none');
                break;
            case 3:
                if (step3Reset) step3Reset.classList.remove('d-none');
                break;
            case 4:
                if (step4Success) step4Success.classList.remove('d-none');
                break;
        }
    }
    
    function sendOTPRequest(email, isResend = false) {
        console.log('📤 Sending OTP request for:', email, 'Resend:', isResend);
        
        const submitBtn = forgotPasswordForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        
        submitBtn.textContent = isResend ? 'Đang gửi lại...' : 'Đang gửi...';
        submitBtn.disabled = true;
        
        fetch(`${contextPath}/api/forgot-password/send-otp`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ email: email })
        })
        .then(response => {
            console.log('📡 OTP send response:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('📋 OTP send result:', data);
            
            if (data.success) {
                emailDisplay.textContent = email;
                showStep(2);
                startResendTimer();
                
                if (!isResend) {
                    alert('Mã OTP đã được gửi đến email của bạn!');
                } else {
                    alert('Mã OTP mới đã được gửi!');
                }
            } else {
                alert(data.message || 'Có lỗi xảy ra khi gửi OTP!');
            }
        })
        .catch(error => {
            console.error('❌ OTP send error:', error);
            alert('Lỗi kết nối! Vui lòng thử lại.');
        })
        .finally(() => {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        });
    }
    
    function verifyOTP(email, otp) {
        console.log('🔢 Verifying OTP for:', email);
        
        const submitBtn = otpVerificationForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        
        submitBtn.textContent = 'Đang xác minh...';
        submitBtn.disabled = true;
        
        fetch(`${contextPath}/api/forgot-password/verify-otp`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ 
                email: email,
                otp: otp 
            })
        })
        .then(response => {
            console.log('📡 OTP verify response:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('📋 OTP verify result:', data);
            
            if (data.success) {
                verificationToken = data.token;
                document.getElementById('verification-token').value = verificationToken;
                showStep(3);
                clearResendTimer();
                alert('Mã OTP chính xác! Vui lòng nhập mật khẩu mới.');
            } else {
                alert(data.message || 'Mã OTP không chính xác!');
                document.getElementById('otp').value = '';
                document.getElementById('otp').focus();
            }
        })
        .catch(error => {
            console.error('❌ OTP verify error:', error);
            alert('Lỗi kết nối! Vui lòng thử lại.');
        })
        .finally(() => {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        });
    }
    
    function resetPassword(token, newPassword) {
        console.log('🔐 Resetting password...');
        
        const submitBtn = resetPasswordForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        
        submitBtn.textContent = 'Đang cập nhật...';
        submitBtn.disabled = true;
        
        fetch(`${contextPath}/api/forgot-password/reset-password`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify({ 
                token: token,
                newPassword: newPassword,
                email: currentEmail
            })
        })
        .then(response => {
            console.log('📡 Password reset response:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('📋 Password reset result:', data);
            
            if (data.success) {
                showStep(4);
                alert('Mật khẩu đã được cập nhật thành công!');
            } else {
                alert(data.message || 'Có lỗi xảy ra khi cập nhật mật khẩu!');
            }
        })
        .catch(error => {
            console.error('❌ Password reset error:', error);
            alert('Lỗi kết nối! Vui lòng thử lại.');
        })
        .finally(() => {
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
        });
    }
    
    function startResendTimer() {
        resendCountdown = 60; // 60 seconds
        resendOtpBtn.disabled = true;
        
        const updateTimer = () => {
            if (resendCountdown > 0) {
                resendOtpBtn.innerHTML = `<i class="fas fa-clock me-2"></i>Gửi lại sau ${resendCountdown}s`;
                resendCountdown--;
                otpResendTimer = setTimeout(updateTimer, 1000);
            } else {
                resendOtpBtn.innerHTML = '<i class="fas fa-refresh me-2"></i>Gửi lại mã OTP';
                resendOtpBtn.disabled = false;
            }
        };
        
        updateTimer();
    }
    
    function clearResendTimer() {
        if (otpResendTimer) {
            clearTimeout(otpResendTimer);
            otpResendTimer = null;
        }
        resendCountdown = 0;
        if (resendOtpBtn) {
            resendOtpBtn.innerHTML = '<i class="fas fa-refresh me-2"></i>Gửi lại mã OTP';
            resendOtpBtn.disabled = false;
        }
    }
    
    console.log('✅ Forgot Password OTP Script loaded successfully');
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
