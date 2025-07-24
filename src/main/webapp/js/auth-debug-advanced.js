/**
 * Authentication Debug Script
 * Script để test và debug authentication flow
 */

console.log('Loading Auth Debug Script...');

window.AuthDebug = {
    // Test login flow
    testLoginFlow: function() {
        console.log('=== TESTING LOGIN FLOW ===');
        
        // 1. Check initial state
        console.log('1. Initial localStorage state:');
        console.log('userLoggedIn:', localStorage.getItem('userLoggedIn'));
        console.log('userName:', localStorage.getItem('userName'));
        console.log('userEmail:', localStorage.getItem('userEmail'));
        console.log('userAvatar:', localStorage.getItem('userAvatar'));
        
        // 2. Check DOM elements
        console.log('2. DOM elements check:');
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        const userDisplayName = document.getElementById('userDisplayName');
        const userAvatarImage = document.getElementById('userAvatarImage');
        
        console.log('nav-user-info:', navUserInfo ? 'EXISTS' : 'MISSING');
        console.log('nav-login-btn:', navLoginBtn ? 'EXISTS' : 'MISSING');
        console.log('userDisplayName:', userDisplayName ? 'EXISTS' : 'MISSING');
        console.log('userAvatarImage:', userAvatarImage ? 'EXISTS' : 'MISSING');
        
        if (navUserInfo && navLoginBtn) {
            console.log('nav-user-info display:', window.getComputedStyle(navUserInfo).display);
            console.log('nav-login-btn display:', window.getComputedStyle(navLoginBtn).display);
            console.log('nav-user-info classes:', navUserInfo.className);
            console.log('nav-login-btn classes:', navLoginBtn.className);
        }
        
        // 3. Check managers
        console.log('3. Managers check:');
        console.log('navbarManager:', window.navbarManager ? 'EXISTS' : 'MISSING');
        console.log('authSyncManager:', window.authSyncManager ? 'EXISTS' : 'MISSING');
        console.log('googleOAuthHandler:', window.googleOAuthHandler ? 'EXISTS' : 'MISSING');
        console.log('AvatarUtils:', window.AvatarUtils ? 'EXISTS' : 'MISSING');
        
        console.log('=== END LOGIN FLOW TEST ===');
    },
    
    // Simulate successful login
    simulateLogin: function(name = 'Test User', email = 'test@example.com') {
        console.log('=== SIMULATING LOGIN ===');
        console.log('Name:', name);
        console.log('Email:', email);
        
        // Set localStorage
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', name);
        localStorage.setItem('userEmail', email);
        localStorage.setItem('userRole', 'CUSTOMER');
        localStorage.setItem('userAvatar', '');
        
        // Dispatch event
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: name,
                email: email,
                role: 'CUSTOMER',
                avatarUrl: ''
            }
        }));
        
        // Force auth sync
        if (window.authSyncManager) {
            window.authSyncManager.forceRefresh();
        }
        
        console.log('Login simulation completed');
        
        // Test again after 1 second
        setTimeout(() => {
            this.testLoginFlow();
        }, 1000);
    },
    
    // Clear login state
    clearLogin: function() {
        console.log('=== CLEARING LOGIN STATE ===');
        
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');
        
        window.dispatchEvent(new CustomEvent('userLoggedOut'));
        
        if (window.authSyncManager) {
            window.authSyncManager.forceRefresh();
        }
        
        console.log('Login state cleared');
    },
    
    // Force navbar update
    forceNavbarUpdate: function() {
        console.log('=== FORCING NAVBAR UPDATE ===');
        
        if (window.navbarManager) {
            window.navbarManager.checkInitialState();
        }
        
        if (window.authSyncManager) {
            window.authSyncManager.forceRefresh();
        }
        
        console.log('Navbar update forced');
    }
};

// Auto-run test on page load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        console.log('Auto-running auth debug test...');
        window.AuthDebug.testLoginFlow();
    }, 2000);
});

console.log('Auth Debug Script loaded. Use AuthDebug.testLoginFlow() to debug authentication.');
