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
                
                // Create user object for unified navbar manager
                const userObj = {
                    fullName: data.fullName || 'User',
                    name: data.fullName || 'User',
                    email: email,
                    role: data.role || 'CUSTOMER',
                    avatarUrl: data.avatarUrl || '',
                    picture: data.avatarUrl || '',
                    loginType: 'email'
                };
                
                // Save user info to localStorage (legacy format)
                localStorage.setItem('userLoggedIn', 'true');
                localStorage.setItem('userName', data.fullName || 'User');
                localStorage.setItem('userEmail', email);
                localStorage.setItem('userRole', data.role || 'CUSTOMER');
                localStorage.setItem('userAvatar', data.avatarUrl || '');
                
                // Save user info to unified format for navbar manager
                localStorage.setItem('currentUser', JSON.stringify(userObj));
                
                console.log('✅ User data saved to localStorage:', userObj);
                
                console.log('Dispatching login event...');
                
                // Dispatch event for navbar manager - với user object đã tạo
                // Dispatch immediately
                window.dispatchEvent(new CustomEvent('userLoggedIn', {
                    detail: userObj
                }));
                
                // Dispatch again after short delay to ensure navbar is ready
                setTimeout(() => {
                    console.log('Re-dispatching login event...');
                    window.dispatchEvent(new CustomEvent('userLoggedIn', {
                        detail: userObj
                    }));
                }, 100);
                
                // Force unified navbar refresh
                setTimeout(() => {
                    if (window.unifiedNavbarManager) {
                        console.log('🔄 Forcing unified navbar refresh...');
                        window.unifiedNavbarManager.refreshNavbar();
                    }
                }, 200);
                
                // Force auth sync multiple times
                const forceAuthSync = () => {
                    if (window.authSyncManager) {
                        console.log('Forcing auth sync...');
                        window.authSyncManager.forceRefresh();
                    }
                };
                
                forceAuthSync();
                setTimeout(forceAuthSync, 200);
                setTimeout(forceAuthSync, 500);
                
                console.log('Event dispatched, preparing to show success popup...');
                
                // Show success popup instead of alert and redirect
                if (window.loginPopupManager) {
                    console.log('✅ Showing login success popup for:', userObj.fullName);
                    window.loginPopupManager.showSuccessPopup(userObj);
                } else {
                    console.warn('⚠️ Login popup manager not available, falling back to alert and redirect');
                    alert('Đăng nhập thành công! Chào mừng ' + (data.fullName || 'bạn'));
                    
                    // Fallback redirect after short delay
                    setTimeout(() => {
                        const redirectUrl = data.redirectUrl || ((window.APP_CONTEXT_PATH || contextPath) || '/');
                        console.log('Fallback redirecting to:', redirectUrl);
                        window.location.href = redirectUrl;
                    }, 1500);
                }
                
            } else {
                if (data.banReason) {
                    document.querySelectorAll('.ban-reason-box').forEach(e => e.remove());
                    const banBox = document.createElement('div');
                    banBox.className = 'ban-reason-box';
                    banBox.style.position = 'fixed';
                    banBox.style.bottom = '32px';
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
                    alert(data.message || 'Đăng nhập thất bại!');
                }
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
