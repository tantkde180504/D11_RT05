/**
 * Legacy Navbar Cleanup - Remove old navbar elements completely
 */
class LegacyNavbarCleanup {
    constructor() {
        this.init();
    }

    init() {
        console.log('🧹 Legacy Navbar Cleanup initialized');
        
        // Run cleanup immediately
        this.performCleanup();
        
        // Run cleanup on DOM ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.performCleanup();
            });
        }
        
        // Run cleanup after a delay
        setTimeout(() => {
            this.performCleanup();
        }, 500);
    }

    performCleanup() {
        console.log('🧹 Performing legacy navbar cleanup...');
        
        // Remove old navbar elements completely
        const oldElements = [
            'nav-user-info',
            'nav-login-btn',
            'userAccountDropdown', 
            'accountDropdown',
            'userDisplayName',
            'userDisplayNameMobile',
            'userFullName',
            'userAvatarImage',
            'userAvatarDropdown'
        ];
        
        oldElements.forEach(elementId => {
            const element = document.getElementById(elementId);
            if (element) {
                console.log(`🗑️ Removing old element: ${elementId}`);
                element.remove();
            }
        });
        
        // Disable old managers
        if (window.navbarManager) {
            console.log('🔇 Disabling old navbar manager');
            window.navbarManager = null;
        }
        
        if (window.authSyncManager) {
            console.log('🔇 Disabling old auth sync manager');
            window.authSyncManager = null;
        }
        
        // Remove anti-flicker styles that might be interfering
        const antiFlickerStyle = document.getElementById('anti-flicker-style');
        if (antiFlickerStyle) {
            console.log('🗑️ Removing old anti-flicker styles');
            antiFlickerStyle.remove();
        }
        
        // Clear any old event listeners
        this.clearOldEventListeners();
        
        console.log('✅ Legacy navbar cleanup completed');
    }

    clearOldEventListeners() {
        // Remove old event listeners that might interfere
        const oldEvents = ['userLoggedIn', 'userLoggedOut', 'loginSuccess'];
        
        oldEvents.forEach(eventType => {
            // We can't actually remove all listeners, but we can override the window functions
            if (window[eventType]) {
                console.log(`🔇 Clearing old ${eventType} handlers`);
                window[eventType] = null;
            }
        });
    }
}

// Initialize cleanup immediately
console.log('🧹 Starting Legacy Navbar Cleanup...');
new LegacyNavbarCleanup();

console.log('📦 Legacy Navbar Cleanup script loaded');
