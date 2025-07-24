// Fallback Login Handler - For when API is not available
console.log('=== FALLBACK LOGIN SCRIPT LOADING ===');

document.addEventListener('DOMContentLoaded', function() {
    console.log('Fallback login handler ready');
    
    // Check if main login script failed to load
    setTimeout(() => {
        const loginForm = document.getElementById('loginForm');
        if (!loginForm) return;
        
        // Check if form already has event listener (from main script)
        if (loginForm.dataset.handlerAttached) {
            console.log('Main login handler is working, fallback not needed');
            return;
        }
        
        console.log('Main login handler not detected, activating fallback...');
        
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('=== FALLBACK LOGIN SUBMIT ===');
            
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!email || !password) {
                alert('Vui lòng điền đầy đủ email và mật khẩu!');
                return;
            }
            
            // Simulate login for testing
            console.log('Fallback: Simulating login for testing...');
            alert('Fallback Mode: Login form submitted. Email: ' + email);
            
            // Mock successful login
            localStorage.setItem('userLoggedIn', 'true');
            localStorage.setItem('userName', 'Test User (Fallback)');
            localStorage.setItem('userEmail', email);
            localStorage.setItem('userRole', 'CUSTOMER');
            localStorage.setItem('userAvatar', '');
            
            // Dispatch login event
            window.dispatchEvent(new CustomEvent('userLoggedIn', {
                detail: {
                    fullName: 'Test User (Fallback)',
                    email: email,
                    role: 'CUSTOMER',
                    avatarUrl: ''
                }
            }));
            
            // Redirect after delay
            setTimeout(() => {
                const contextPath = window.location.pathname.split('/')[1] || '';
                const redirectUrl = contextPath ? `/${contextPath}/` : '/';
                console.log('Fallback: Redirecting to:', redirectUrl);
                window.location.href = redirectUrl;
            }, 1000);
        });
        
        loginForm.dataset.handlerAttached = 'fallback';
        console.log('Fallback login handler attached');
        
    }, 3000); // Wait 3 seconds for main script
});

console.log('=== FALLBACK LOGIN SCRIPT LOADED ===');
