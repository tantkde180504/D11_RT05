/**
 * Auth State Test & Debug Console Commands
 * Cung cấp các lệnh debug trong Console để test auth state
 */

// Test functions
window.authDebug = {
    // Check current auth state
    checkState: function() {
        console.log('=== AUTH STATE DEBUG ===');
        
        // LocalStorage data
        const authData = {
            userLoggedIn: localStorage.getItem('userLoggedIn'),
            userName: localStorage.getItem('userName'),
            userEmail: localStorage.getItem('userEmail'),
            userRole: localStorage.getItem('userRole'),
            userAvatar: localStorage.getItem('userAvatar'),
            justLoggedIn: localStorage.getItem('justLoggedIn')
        };
        
        console.log('1. LocalStorage:', authData);
        
        // DOM elements
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        const domState = {
            navUserInfo: {
                exists: !!navUserInfo,
                visible: navUserInfo && !navUserInfo.classList.contains('d-none'),
                display: navUserInfo?.style.display,
                visibility: navUserInfo?.style.visibility,
                opacity: navUserInfo?.style.opacity
            },
            navLoginBtn: {
                exists: !!navLoginBtn,
                hidden: navLoginBtn && navLoginBtn.classList.contains('d-none'),
                display: navLoginBtn?.style.display,
                visibility: navLoginBtn?.style.visibility,
                opacity: navLoginBtn?.style.opacity
            }
        };
        
        console.log('2. DOM State:', domState);
        
        // Manager states
        const managers = {
            antiFlickerManager: !!window.antiFlickerAuthManager,
            navbarManager: !!window.navbarManager,
            authSyncManager: !!window.authSyncManager,
            comprehensiveManager: !!window.comprehensiveAuthManager
        };
        
        console.log('3. Managers:', managers);
        
        // State consistency check
        const isLoggedIn = authData.userLoggedIn === 'true';
        const hasUserName = !!authData.userName;
        const shouldShowUserMenu = isLoggedIn && hasUserName;
        const isShowingUserMenu = domState.navUserInfo.visible;
        const isHidingLoginBtn = domState.navLoginBtn.hidden;
        
        const consistency = {
            shouldShowUserMenu,
            isShowingUserMenu,
            isHidingLoginBtn,
            stateCorrect: shouldShowUserMenu === isShowingUserMenu && shouldShowUserMenu === isHidingLoginBtn
        };
        
        console.log('4. Consistency:', consistency);
        console.log('========================');
        
        return { authData, domState, managers, consistency };
    },
    
    // Force login simulation
    simulateLogin: function(name = 'Test User', email = 'test@example.com') {
        console.log('🧪 Simulating login for:', name, email);
        
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
        
        console.log('✅ Login simulation dispatched');
    },
    
    // Force logout simulation
    simulateLogout: function() {
        console.log('🧪 Simulating logout...');
        
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');
        localStorage.removeItem('justLoggedIn');
        
        // Dispatch event
        window.dispatchEvent(new CustomEvent('userLoggedOut'));
        
        console.log('✅ Logout simulation dispatched');
    },
    
    // Force fix navbar
    fixNavbar: function() {
        console.log('🔧 Attempting to fix navbar...');
        
        let fixed = false;
        
        if (window.antiFlickerAuthManager && typeof window.antiFlickerAuthManager.forceFixNavbar === 'function') {
            console.log('Using anti-flicker manager...');
            window.antiFlickerAuthManager.forceFixNavbar();
            fixed = true;
        }
        
        if (window.navbarManager && typeof window.navbarManager.refresh === 'function') {
            console.log('Using navbar manager...');
            window.navbarManager.refresh();
            fixed = true;
        }
        
        if (window.forceFixNavbar) {
            console.log('Using force fix function...');
            window.forceFixNavbar();
            fixed = true;
        }
        
        if (!fixed) {
            console.log('No fix methods available, manual fix...');
            const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
            const userName = localStorage.getItem('userName');
            
            if (isLoggedIn && userName) {
                const navUserInfo = document.getElementById('nav-user-info');
                const navLoginBtn = document.getElementById('nav-login-btn');
                
                if (navUserInfo && navLoginBtn) {
                    navUserInfo.classList.remove('d-none');
                    navUserInfo.style.display = 'block';
                    navLoginBtn.classList.add('d-none');
                    navLoginBtn.style.display = 'none';
                    console.log('✅ Manual fix applied');
                }
            }
        }
        
        // Check result
        setTimeout(() => {
            this.checkState();
        }, 100);
    },
    
    // Reset everything
    reset: function() {
        console.log('🔄 Resetting all auth state...');
        
        // Clear localStorage
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');
        localStorage.removeItem('justLoggedIn');
        
        // Reset DOM
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (navUserInfo) {
            navUserInfo.classList.add('d-none');
            navUserInfo.style.display = 'none';
        }
        
        if (navLoginBtn) {
            navLoginBtn.classList.remove('d-none');
            navLoginBtn.style.display = 'block';
        }
        
        console.log('✅ Reset complete');
        
        // Check result
        setTimeout(() => {
            this.checkState();
        }, 100);
    }
};

// Add console helper message
console.log(`
🔧 AUTH DEBUG COMMANDS AVAILABLE:
- authDebug.checkState() - Check current auth state
- authDebug.simulateLogin('Name', 'email@test.com') - Simulate login
- authDebug.simulateLogout() - Simulate logout  
- authDebug.fixNavbar() - Force fix navbar
- authDebug.reset() - Reset all auth state

Example: authDebug.simulateLogin('John Doe', 'john@example.com')
`);

// Auto-check on page load
document.addEventListener('DOMContentLoaded', function() {
    setTimeout(() => {
        console.log('🔍 Auto-checking auth state on page load...');
        window.authDebug.checkState();
    }, 2000);
});
