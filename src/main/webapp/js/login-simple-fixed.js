// Simple Login Handler - No conflicts

document.addEventListener('DOMContentLoaded', function() {
    console.log('Login script loaded');
    
    const loginForm = document.getElementById('loginForm');
    
    if (loginForm) {
        console.log('Login form found');
        
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('Form submission started');
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            console.log('Email:', email);
            console.log('Password length:', password.length);
            
            // Basic validation
            if (!email || !password) {
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }
            
            if (!isValidEmail(email)) {
                alert('Email không hợp lệ!');
                return;
            }
            
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Đang đăng nhập...';
            submitBtn.disabled = true;
            
            console.log('Sending login request...');
            
            // Send login request
            fetch('/api/login', {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded' 
                },
                body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
            })
            .then(response => {
                console.log('Response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
                
                if (data.success === true) {
                    console.log('Login successful!');
                    
                    // Save user info to localStorage
                    localStorage.setItem('userLoggedIn', 'true');
                    localStorage.setItem('userName', data.fullName);
                    localStorage.setItem('userEmail', email);
                    localStorage.setItem('userRole', data.role || 'CUSTOMER');
                    
                    // Show success message
                    alert('Đăng nhập thành công! Chào mừng ' + data.fullName);
                    
                    // Update navbar if function exists
                    if (typeof window.showUserMenu === 'function') {
                        console.log('Updating navbar...');
                        window.showUserMenu(data.fullName);
                    }
                    
                    // Trigger login event
                    const loginEvent = new CustomEvent('userLoggedIn', {
                        detail: { 
                            fullName: data.fullName, 
                            email: email, 
                            role: data.role || 'CUSTOMER' 
                        }
                    });
                    window.dispatchEvent(loginEvent);
                    
                    // Redirect to appropriate page based on server response
                    setTimeout(() => {
                        const redirectUrl = data.redirectUrl || '/';
                        console.log('Redirecting to:', redirectUrl, '(Role:', data.role + ')');
                        window.location.href = redirectUrl;
                    }, 1000);
                    
                } else {
                    console.log('Login failed:', data.message);
                    alert(data.message || 'Sai email hoặc mật khẩu!');
                }
            })
            .catch(error => {
                console.error('Login error:', error);
                submitBtn.textContent = originalText;
                submitBtn.disabled = false;
                alert('Lỗi kết nối máy chủ!');
            });
        });
    } else {
        console.error('Login form not found!');
    }
});

// Email validation function
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// User login helper function
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

console.log('Simple login script loaded successfully');
