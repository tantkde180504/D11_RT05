/**
 * Login Debug Script - Kiểm tra và sửa lỗi navbar sau khi đăng nhập
 */
console.log('🔧 Login Debug Script loaded');

// Function để debug navbar state
function debugNavbarState() {
    console.log('=== NAVBAR DEBUG STATE ===');
    
    // Check localStorage
    const authData = {
        userLoggedIn: localStorage.getItem('userLoggedIn'),
        userName: localStorage.getItem('userName'),
        userEmail: localStorage.getItem('userEmail'),
        userRole: localStorage.getItem('userRole'),
        userAvatar: localStorage.getItem('userAvatar')
    };
    
    console.log('LocalStorage:', authData);
    
    // Check DOM elements
    const navUserInfo = document.getElementById('nav-user-info');
    const navLoginBtn = document.getElementById('nav-login-btn');
    
    console.log('DOM Elements:', {
        navUserInfo: {
            exists: !!navUserInfo,
            visible: navUserInfo && !navUserInfo.classList.contains('d-none'),
            display: navUserInfo?.style.display,
            classes: navUserInfo?.classList.toString()
        },
        navLoginBtn: {
            exists: !!navLoginBtn,
            hidden: navLoginBtn && navLoginBtn.classList.contains('d-none'),
            display: navLoginBtn?.style.display,
            classes: navLoginBtn?.classList.toString()
        }
    });
    
    console.log('========================');
    return { authData, navUserInfo, navLoginBtn };
}

// Function để force fix navbar
function forceFixNavbar() {
    console.log('🛠️ Force fixing navbar...');
    
    const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
    const userName = localStorage.getItem('userName');
    
    if (isLoggedIn && userName) {
        console.log('✅ User is logged in, forcing navbar to show user menu');
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (navUserInfo && navLoginBtn) {
            // Force show user menu
            navUserInfo.classList.remove('d-none');
            navUserInfo.style.display = 'block';
            
            // Force hide login button
            navLoginBtn.classList.add('d-none');
            navLoginBtn.style.display = 'none';
            
            // Update user display names
            const userDisplayName = document.getElementById('userDisplayName');
            const userDisplayNameMobile = document.getElementById('userDisplayNameMobile');
            const userFullName = document.getElementById('userFullName');
            
            const firstName = userName.split(' ')[0];
            
            if (userDisplayName) userDisplayName.textContent = firstName;
            if (userDisplayNameMobile) userDisplayNameMobile.textContent = firstName;
            if (userFullName) userFullName.textContent = userName;
            
            console.log('✅ Navbar manually fixed');
            return true;
        } else {
            console.log('❌ Navbar elements not found');
            return false;
        }
    } else {
        console.log('❌ User not logged in');
        return false;
    }
}

// Auto-fix function với multiple attempts
function autoFixNavbar() {
    console.log('🔄 Auto-fixing navbar with multiple attempts...');
    
    let attempts = 0;
    const maxAttempts = 5;
    
    function tryFix() {
        attempts++;
        console.log(`Attempt ${attempts}/${maxAttempts}`);
        
        const debug = debugNavbarState();
        const isLoggedIn = debug.authData.userLoggedIn === 'true';
        const hasUserName = !!debug.authData.userName;
        const userMenuVisible = debug.navUserInfo && !debug.navUserInfo.classList.contains('d-none');
        const loginBtnHidden = debug.navLoginBtn && debug.navLoginBtn.classList.contains('d-none');
        
        if (isLoggedIn && hasUserName && (!userMenuVisible || !loginBtnHidden)) {
            console.log('🔧 Navbar needs fixing...');
            const fixed = forceFixNavbar();
            
            if (!fixed && attempts < maxAttempts) {
                console.log(`❌ Fix failed, retrying in ${attempts * 200}ms...`);
                setTimeout(tryFix, attempts * 200);
            } else if (fixed) {
                console.log('✅ Navbar fixed successfully!');
            } else {
                console.log('❌ Could not fix navbar after all attempts');
            }
        } else if (isLoggedIn && hasUserName && userMenuVisible && loginBtnHidden) {
            console.log('✅ Navbar is already correct');
        } else {
            console.log('ℹ️ User not logged in or navbar state is correct');
        }
    }
    
    tryFix();
}

// Listen for login events
window.addEventListener('userLoggedIn', function(event) {
    console.log('🎯 userLoggedIn event received in debug script', event.detail);
    setTimeout(() => {
        autoFixNavbar();
    }, 200);
});

// Auto-check when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Login Debug Script: DOM ready');
    
    // Multiple checks with increasing delays
    setTimeout(() => {
        debugNavbarState();
        autoFixNavbar();
    }, 500);
    
    setTimeout(() => {
        debugNavbarState();
        autoFixNavbar();
    }, 1000);
    
    setTimeout(() => {
        debugNavbarState();
        autoFixNavbar();
    }, 2000);
});

// Export functions for manual debugging
window.debugNavbarState = debugNavbarState;
window.forceFixNavbar = forceFixNavbar;
window.autoFixNavbar = autoFixNavbar;

console.log('🔧 Login Debug Script ready - Use debugNavbarState(), forceFixNavbar(), or autoFixNavbar() in console');
