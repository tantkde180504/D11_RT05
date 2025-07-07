/**
 * Quick Auth Debug Test
 * Add this to any page to test authentication
 */

console.log('🔧 Auth Quick Test loaded');

// Debug function
window.testAuth = function() {
    console.log('=== AUTH TEST ===');
    
    // Check localStorage
    const authData = {
        userLoggedIn: localStorage.getItem('userLoggedIn'),
        userName: localStorage.getItem('userName'),
        userEmail: localStorage.getItem('userEmail'),
        userAvatar: localStorage.getItem('userAvatar')
    };
    
    console.log('LocalStorage:', authData);
    
    // Check navbar elements
    const navElements = {
        'nav-user-info': document.getElementById('nav-user-info'),
        'nav-login-btn': document.getElementById('nav-login-btn'),
        'userDisplayName': document.getElementById('userDisplayName'),
        'userAvatarImage': document.getElementById('userAvatarImage')
    };
    
    console.log('Navbar elements:', navElements);
    
    // Check visibility
    const visibility = {
        userInfoVisible: navElements['nav-user-info'] ? !navElements['nav-user-info'].classList.contains('d-none') : false,
        loginBtnVisible: navElements['nav-login-btn'] ? !navElements['nav-login-btn'].classList.contains('d-none') : false
    };
    
    console.log('Visibility:', visibility);
    
    // Check managers
    const managers = {
        authSyncManager: !!window.authSyncManager,
        navbarManager: !!window.navbarManager
    };
    
    console.log('Managers:', managers);
    
    return {
        authData,
        navElements,
        visibility,
        managers
    };
};

// Auto-test after delay
setTimeout(() => {
    console.log('🔧 Running auto auth test...');
    window.testAuth();
}, 2000);

console.log('🔧 Type testAuth() in console to run manual test');
