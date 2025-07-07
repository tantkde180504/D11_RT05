// Simple Login Handler - Clean Version

console.log('=== LOGIN SCRIPT LOADING ===');

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM ready, initializing login...');
    
    const loginForm = document.getElementById('loginForm');
    
    if (!loginForm) {
        console.error('Login form not found!');
        return;
    }
    
    console.log('Login form found, adding event listener...');
    
    // Mark that main handler is attached
    loginForm.dataset.handlerAttached = 'main';
    
    loginForm.addEventListener('submit', function(e) {
        console.log('=== FORM SUBMIT EVENT ===');
        e.preventDefault();
        
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        
        if (!emailInput || !passwordInput) {
            console.error('Form inputs not found!');
            alert('Lỗi: Không tìm thấy form input!');
            return;
        }
        
        const email = emailInput.value.trim();
        const password = passwordInput.value.trim();
        
        console.log('Form data:', { email, passwordLength: password.length });
        
        // Validation
        if (!email || !password) {
            alert('Vui lòng điền đầy đủ email và mật khẩu!');
            return;
        }
        
        if (!isValidEmail(email)) {
            alert('Email không hợp lệ!');
            return;
        }
        
        // UI feedback
        const submitBtn = loginForm.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.textContent = 'Đang đăng nhập...';
        submitBtn.disabled = true;
        
        console.log('Sending login request...');
        
        // Get context path - prioritize JSP-provided value, fallback to detection
        let contextPath = '';
        
        if (window.APP_CONTEXT_PATH !== undefined) {
            contextPath = window.APP_CONTEXT_PATH;
            console.log('Using JSP context path:', contextPath);
        } else {
            // Fallback: detect from URL
            const fullPath = window.location.pathname;
            console.log('JSP context not available, detecting from pathname:', fullPath);
            
            if (fullPath.includes('/login.jsp')) {
                const pathParts = fullPath.split('/login.jsp')[0];
                contextPath = pathParts && pathParts !== '' ? pathParts : '';
            } else {
                const segments = fullPath.split('/').filter(Boolean);
                contextPath = segments.length > 0 ? '/' + segments[0] : '';
            }
            console.log('Detected context path:', contextPath);
        }
        
        const apiUrl = contextPath + '/api/login';
        console.log('Final API URL:', apiUrl);
        console.log('Full API URL:', window.location.origin + apiUrl);
        
        // Send request
        fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
        })
        .then(response => {
            console.log('Response received:', response.status, response.statusText);
            console.log('Response URL:', response.url);
            console.log('Response headers:', response.headers);
            
            // Check if response is actually JSON
            const contentType = response.headers.get('content-type');
            console.log('Content-Type:', contentType);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText} - URL: ${response.url}`);
            }
            
            if (!contentType || !contentType.includes('application/json')) {
                console.warn('Response is not JSON, might be an error page');
                return response.text().then(text => {
                    console.log('Response text:', text.substring(0, 500) + '...');
                    throw new Error('Server returned non-JSON response, possibly an error page');
                });
            }
            
            return response.json();
        })
        .then(data => {
            console.log('Login response:', data);
            
            // Reset button
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
            
            if (data.success === true) {
                console.log('Login successful!');
                
                // Save user info to localStorage
                localStorage.setItem('userLoggedIn', 'true');
                localStorage.setItem('userName', data.fullName || 'User');
                localStorage.setItem('userEmail', email);
                localStorage.setItem('userRole', data.role || 'CUSTOMER');
                localStorage.setItem('userAvatar', data.avatarUrl || ''); // Save avatar info
                
                // Success feedback
                alert('Đăng nhập thành công! Chào mừng ' + (data.fullName || 'bạn'));
                
                console.log('Dispatching login event...');
                
                // Dispatch event for navbar manager
                window.dispatchEvent(new CustomEvent('userLoggedIn', {
                    detail: {
                        fullName: data.fullName || 'User',
                        email: email,
                        role: data.role || 'CUSTOMER',
                        avatarUrl: data.avatarUrl || '' // Avatar sẽ được generate từ email
                    }
                }));
                
                // Force auth sync before redirect
                if (window.authSyncManager) {
                    console.log('Forcing auth sync...');
                    window.authSyncManager.forceRefresh();
                }
                
                console.log('Event dispatched, preparing redirect...');
                
                // Redirect with delay to ensure events are processed
                setTimeout(() => {
                    // Double-check localStorage before redirect
                    console.log('Pre-redirect localStorage check:', {
                        userLoggedIn: localStorage.getItem('userLoggedIn'),
                        userName: localStorage.getItem('userName'),
                        userEmail: localStorage.getItem('userEmail'),
                        userAvatar: localStorage.getItem('userAvatar')
                    });
                    
                    // Force one more auth sync
                    if (window.authSyncManager) {
                        window.authSyncManager.forceRefresh();
                    }
                    
                    // Use context path for redirect
                    const redirectPath = (window.APP_CONTEXT_PATH || contextPath) || '/';
                    console.log('Redirecting to:', redirectPath);
                    
                    window.location.href = redirectPath;
                }, 1500); // Increased delay
                
            } else {
                console.log('Login failed:', data.message);
                alert(data.message || 'Đăng nhập thất bại!');
            }
        })
        .catch(error => {
            console.error('Login error:', error);
            
            // Reset button
            submitBtn.textContent = originalText;
            submitBtn.disabled = false;
            
            alert('Lỗi kết nối: ' + error.message);
        });
    });
    
    console.log('Login form listener added successfully');
});

// Helper function
function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

console.log('=== LOGIN SCRIPT LOADED ===');
