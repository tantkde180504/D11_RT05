/**
 * Authentication Debug Helper
 * Debug script để kiểm tra authentication state
 */

window.debugAuth = {
    checkState: function() {
        console.log('=== AUTH STATE DEBUG ===');
        
        // Check localStorage
        const localStorageData = {
            userLoggedIn: localStorage.getItem('userLoggedIn'),
            userName: localStorage.getItem('userName'),
            userEmail: localStorage.getItem('userEmail'),
            userRole: localStorage.getItem('userRole')
        };
        
        console.log('LocalStorage:', localStorageData);
        
        // Check DOM elements
        const navElements = {
            navUserInfo: document.getElementById('nav-user-info'),
            navLoginBtn: document.getElementById('nav-login-btn'),
            userDisplayName: document.getElementById('userDisplayName'),
            userFullName: document.getElementById('userFullName')
        };
        
        console.log('Nav Elements:', {
            navUserInfo: navElements.navUserInfo ? 'EXISTS' : 'MISSING',
            navLoginBtn: navElements.navLoginBtn ? 'EXISTS' : 'MISSING',
            userDisplayName: navElements.userDisplayName ? 'EXISTS' : 'MISSING',
            userFullName: navElements.userFullName ? 'EXISTS' : 'MISSING'
        });
        
        // Check visibility
        if (navElements.navUserInfo && navElements.navLoginBtn) {
            console.log('Element Visibility:', {
                navUserInfo: window.getComputedStyle(navElements.navUserInfo).display,
                navLoginBtn: window.getComputedStyle(navElements.navLoginBtn).display
            });
        }
        
        // Check managers
        console.log('Managers:', {
            navbarManager: window.navbarManager ? 'EXISTS' : 'MISSING',
            googleOAuthHandler: window.googleOAuthHandler ? 'EXISTS' : 'MISSING',
            authSyncManager: window.authSyncManager ? 'EXISTS' : 'MISSING'
        });
        
        console.log('=== END AUTH DEBUG ===');
    },
    
    triggerLogin: function(name, email, role) {
        console.log('Triggering test login event...');
        
        // Set localStorage
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', name || 'Test User');
        localStorage.setItem('userEmail', email || 'test@example.com');
        localStorage.setItem('userRole', role || 'CUSTOMER');
        
        // Dispatch event
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: name || 'Test User',
                email: email || 'test@example.com',
                role: role || 'CUSTOMER'
            }
        }));
        
        console.log('Test login event dispatched');
    },
    
    triggerLogout: function() {
        console.log('Triggering test logout event...');
        
        // Clear localStorage
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        
        // Dispatch event
        window.dispatchEvent(new CustomEvent('userLoggedOut'));
        
        console.log('Test logout event dispatched');
    }
};

// Auto-check on page load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        window.debugAuth.checkState();
    }, 1000);
});

console.log('Auth Debug Helper loaded. Use debugAuth.checkState() to check current state.');
