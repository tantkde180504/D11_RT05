/**
 * Login-Navbar Sync Handler
 * Đảm bảo navbar được cập nhật ngay sau khi đăng nhập email/password
 */

// Ensure navbar is updated immediately after login
function ensureNavbarUpdate() {
    console.log('🔄 Ensuring navbar is updated after login...');
    
    // Check if user is logged in
    const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
    const userName = localStorage.getItem('userName');
    const userEmail = localStorage.getItem('userEmail');
    const userAvatar = localStorage.getItem('userAvatar');
    
    console.log('Current login state:', { isLoggedIn, userName, userEmail, userAvatar });
    
    if (isLoggedIn && userName) {
        console.log('✅ User is logged in, forcing navbar update');
        
        // Force navbar manager to update
        if (window.navbarManager) {
            console.log('🎯 Calling navbarManager.showUserMenu directly');
            window.navbarManager.showUserMenu(userName, userEmail, userAvatar);
        }
        
        // Force auth sync
        if (window.authSyncManager) {
            console.log('🎯 Calling authSyncManager.forceRefresh');
            window.authSyncManager.forceRefresh();
        }
        
        // Dispatch event as backup
        console.log('🎯 Dispatching userLoggedIn event as backup');
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: userName,
                email: userEmail || '',
                role: localStorage.getItem('userRole') || 'CUSTOMER',
                avatarUrl: userAvatar || ''
            }
        }));
        
        // Check elements visibility
        setTimeout(() => {
            const navUserInfo = document.getElementById('nav-user-info');
            const navLoginBtn = document.getElementById('nav-login-btn');
            
            console.log('Navbar elements after update:', {
                navUserInfo_visible: navUserInfo && !navUserInfo.classList.contains('d-none'),
                navLoginBtn_hidden: navLoginBtn && navLoginBtn.classList.contains('d-none')
            });
            
            if (navUserInfo && navUserInfo.classList.contains('d-none')) {
                console.log('⚠️ User menu is still hidden, forcing manual show');
                navUserInfo.classList.remove('d-none');
                navUserInfo.style.display = 'block';
            }
            
            if (navLoginBtn && !navLoginBtn.classList.contains('d-none')) {
                console.log('⚠️ Login button is still showing, forcing manual hide');
                navLoginBtn.classList.add('d-none');
                navLoginBtn.style.display = 'none';
            }
        }, 100);
    } else {
        console.log('❌ User is not logged in');
    }
}

// Listen for page load and DOM ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Login-Navbar Sync Handler loaded');
    
    // Check after a short delay to ensure all other scripts are loaded
    setTimeout(ensureNavbarUpdate, 200);
    setTimeout(ensureNavbarUpdate, 500);
    setTimeout(ensureNavbarUpdate, 1000);
});

// Listen for login events
window.addEventListener('userLoggedIn', function(event) {
    console.log('🎯 userLoggedIn event received in sync handler', event.detail);
    setTimeout(ensureNavbarUpdate, 100);
});

// Export for global access
window.ensureNavbarUpdate = ensureNavbarUpdate;
