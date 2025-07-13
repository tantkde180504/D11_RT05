<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực OTP - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/login.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/layout-sizing.css" rel="stylesheet">
    <style>
        .otp-container {
            max-width: 450px;
            margin: 0 auto;
            padding: 2rem;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .otp-input {
            width: 50px;
            height: 60px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border: 2px solid #ddd;
            border-radius: 10px;
            margin: 0 5px;
            transition: all 0.3s ease;
        }
        
        .otp-input:focus {
            border-color: #FF6600;
            box-shadow: 0 0 10px rgba(255, 102, 0, 0.3);
            outline: none;
        }
        
        .countdown {
            font-size: 18px;
            color: #FF6600;
            font-weight: bold;
        }
        
        .expired {
            color: #dc3545;
        }
        
        .verification-icon {
            font-size: 4rem;
            color: #FF6600;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container d-flex align-items-center justify-content-center min-vh-100">
        <div class="otp-container">
            <!-- Header -->
            <div class="text-center mb-4">
                <i class="fas fa-shield-alt verification-icon"></i>
                <h2 class="fw-bold text-dark">Xác thực OTP</h2>
                <p class="text-muted">Chúng tôi đã gửi mã 6 số đến email của bạn</p>
                <p class="fw-bold text-primary" id="emailDisplay"></p>
            </div>

            <!-- OTP Form -->
            <form id="otpForm">
                <div class="mb-4">
                    <div class="d-flex justify-content-center">
                        <input type="text" class="otp-input" maxlength="1" id="otp1" />
                        <input type="text" class="otp-input" maxlength="1" id="otp2" />
                        <input type="text" class="otp-input" maxlength="1" id="otp3" />
                        <input type="text" class="otp-input" maxlength="1" id="otp4" />
                        <input type="text" class="otp-input" maxlength="1" id="otp5" />
                        <input type="text" class="otp-input" maxlength="1" id="otp6" />
                    </div>
                </div>

                <!-- Countdown Timer -->
                <div class="text-center mb-3">
                    <p class="countdown" id="countdown">Mã có hiệu lực trong: <span id="timer">10:00</span></p>
                </div>

                <!-- Submit Button -->
                <div class="d-grid mb-3">
                    <button type="submit" class="btn btn-primary btn-lg" id="verifyBtn">
                        <i class="fas fa-check-circle me-2"></i>Xác thực
                    </button>
                </div>

                <!-- Resend OTP -->
                <div class="text-center">
                    <p class="text-muted">Không nhận được mã?</p>
                    <button type="button" class="btn btn-outline-secondary" id="resendBtn" disabled>
                        <i class="fas fa-redo me-2"></i>Gửi lại mã (<span id="resendTimer">60</span>s)
                    </button>
                </div>

                <!-- Back to Register -->
                <div class="text-center mt-3">
                    <a href="<%=request.getContextPath()%>/register.jsp" class="text-decoration-none">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại đăng ký
                    </a>
                </div>
            </form>

            <!-- Alert Messages -->
            <div id="alertContainer" class="mt-3"></div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Get email from URL parameters or localStorage
        const urlParams = new URLSearchParams(window.location.search);
        const email = urlParams.get('email') || localStorage.getItem('otpEmail') || '';
        
        if (!email) {
            window.location.href = '<%=request.getContextPath()%>/register.jsp';
        }
        
        document.getElementById('emailDisplay').textContent = email;

        // OTP Input functionality
        const otpInputs = document.querySelectorAll('.otp-input');
        
        otpInputs.forEach((input, index) => {
            input.addEventListener('input', (e) => {
                const value = e.target.value;
                if (value && index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            });
            
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    otpInputs[index - 1].focus();
                }
            });
        });

        // Timer functionality
        let timeLeft = 600; // 10 minutes in seconds
        let resendTimeLeft = 60; // 60 seconds for resend

        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            document.getElementById('timer').textContent = 
                `${minutes}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft <= 0) {
                document.getElementById('countdown').innerHTML = 
                    '<span class="expired">Mã OTP đã hết hạn!</span>';
                document.getElementById('verifyBtn').disabled = true;
                return;
            }
            
            timeLeft--;
        }

        function updateResendTimer() {
            document.getElementById('resendTimer').textContent = resendTimeLeft;
            
            if (resendTimeLeft <= 0) {
                document.getElementById('resendBtn').disabled = false;
                document.getElementById('resendBtn').innerHTML = 
                    '<i class="fas fa-redo me-2"></i>Gửi lại mã';
                return;
            }
            
            resendTimeLeft--;
        }

        // Start timers
        updateTimer();
        updateResendTimer();
        const timerInterval = setInterval(updateTimer, 1000);
        const resendTimerInterval = setInterval(updateResendTimer, 1000);

        // Form submission
        document.getElementById('otpForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const otp = Array.from(otpInputs).map(input => input.value).join('');
            
            if (otp.length !== 6) {
                showAlert('Vui lòng nhập đầy đủ 6 số!', 'warning');
                return;
            }

            const verifyBtn = document.getElementById('verifyBtn');
            const originalText = verifyBtn.innerHTML;
            verifyBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xác thực...';
            verifyBtn.disabled = true;

            try {
                const formData = new URLSearchParams();
                formData.append('email', email);
                formData.append('otp', otp);

                const response = await fetch('<%=request.getContextPath()%>/api/verify-otp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                });

                const result = await response.json();

                if (result.success) {
                    showAlert(result.message, 'success');
                    setTimeout(() => {
                        window.location.href = '<%=request.getContextPath()%>/login.jsp';
                    }, 2000);
                } else {
                    showAlert(result.message, 'danger');
                    // Clear OTP inputs on error
                    otpInputs.forEach(input => input.value = '');
                    otpInputs[0].focus();
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert('Có lỗi xảy ra khi xác thực!', 'danger');
            } finally {
                verifyBtn.innerHTML = originalText;
                verifyBtn.disabled = false;
            }
        });

        // Resend OTP
        document.getElementById('resendBtn').addEventListener('click', async () => {
            const resendBtn = document.getElementById('resendBtn');
            const originalText = resendBtn.innerHTML;
            resendBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
            resendBtn.disabled = true;

            try {
                const formData = new URLSearchParams();
                formData.append('email', email);

                const response = await fetch('<%=request.getContextPath()%>/api/resend-otp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: formData
                });

                const result = await response.json();

                if (result.success) {
                    showAlert(result.message, 'success');
                    // Reset timers
                    timeLeft = 600;
                    resendTimeLeft = 60;
                    clearInterval(timerInterval);
                    clearInterval(resendTimerInterval);
                    const newTimerInterval = setInterval(updateTimer, 1000);
                    const newResendTimerInterval = setInterval(updateResendTimer, 1000);
                } else {
                    showAlert(result.message, 'danger');
                }
            } catch (error) {
                console.error('Error:', error);
                showAlert('Có lỗi xảy ra khi gửi lại mã!', 'danger');
            } finally {
                resendBtn.innerHTML = originalText;
            }
        });

        // Show alert function
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertHtml = `
                <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            alertContainer.innerHTML = alertHtml;

            // Auto dismiss after 5 seconds
            setTimeout(() => {
                const alert = alertContainer.querySelector('.alert');
                if (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        }

        // Focus first input on load
        otpInputs[0].focus();
    </script>
</body>
</html>
