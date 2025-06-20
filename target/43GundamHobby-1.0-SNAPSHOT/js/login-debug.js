// Debug Login JavaScript
console.log('Login debug script loaded!');

document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM Content Loaded!');
    
    const loginForm = document.getElementById('loginForm');
    console.log('Login form found:', loginForm);
    
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            console.log('Form submit intercepted!');
            e.preventDefault();
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            console.log('Email:', email);
            console.log('Password:', password);
            
            if (!email || !password) {
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }
            
            // Show loading
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = 'Đang đăng nhập...';
            submitBtn.disabled = true;
            
            console.log('Sending request to /api/login...');
            
            fetch('/api/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`
            })
            .then(response => {
                console.log('Response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('Response data:', data);
                
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                
                if (data.success === true) {
                    alert(`Đăng nhập thành công! Chào mừng ${data.fullName} (${data.role})`);
                    
                    // Save to localStorage
                    localStorage.setItem('userName', data.fullName);
                    localStorage.setItem('userRole', data.role);
                    
                    // Redirect based on role
                    setTimeout(() => {
                        const role = data.role ? data.role.toUpperCase() : '';
                        let targetPage = '';
                        
                        if (role === 'ADMIN') {
                            targetPage = '/dashboard.jsp';
                        } else if (role === 'STAFF') {
                            targetPage = '/staffsc.jsp';
                        } else {
                            targetPage = '/index.jsp';
                        }
                        
                        console.log('Redirecting to:', targetPage);
                        window.location.href = targetPage;
                    }, 1000);
                } else {
                    alert(data.message || 'Sai email hoặc mật khẩu!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                
                alert('Lỗi kết nối máy chủ!');
            });
        });
    } else {
        console.error('Login form not found!');
    }
});
