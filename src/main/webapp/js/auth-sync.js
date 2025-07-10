/**
 * Authentication Synchronization
 * Đồng bộ hóa authentication state giữa Google OAuth và login thường
 */

class AuthSyncManager {
    constructor() {
        this.initializeSync();
    }

    initializeSync() {
        console.log('Auth Sync Manager initialized');
        
        // Listen for storage changes (for multi-tab sync)
        window.addEventListener('storage', (event) => {
            if (event.key === 'userLoggedIn' || event.key === 'userName') {
                this.syncAuthState();
            }
        });

        // Check auth state on page load with multiple checks
        this.syncAuthState();
        
        // Additional checks to catch late updates
        setTimeout(() => {
            this.syncAuthState();
        }, 100);
        
        setTimeout(() => {
            this.syncAuthState();
        }, 500);
    }

    syncAuthState() {
        // First check unified format
        const currentUser = localStorage.getItem('currentUser');
        const googleUser = localStorage.getItem('googleUser');
        
        if (currentUser) {
            try {
                const user = JSON.parse(currentUser);
                console.log('✅ Found unified currentUser:', user);
                
                // Update unified navbar manager if available
                if (window.unifiedNavbarManager) {
                    window.unifiedNavbarManager.currentUser = user;
                    window.unifiedNavbarManager.updateNavbarForLoggedInUser();
                }
                return;
            } catch (e) {
                console.error('Error parsing currentUser:', e);
            }
        }
        
        if (googleUser) {
            try {
                const user = JSON.parse(googleUser);
                console.log('✅ Found unified googleUser:', user);
                
                // Update unified navbar manager if available
                if (window.unifiedNavbarManager) {
                    window.unifiedNavbarManager.currentUser = user;
                    window.unifiedNavbarManager.updateNavbarForLoggedInUser();
                }
                return;
            } catch (e) {
                console.error('Error parsing googleUser:', e);
            }
        }
        
        // Fallback: check legacy format
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        const userEmail = localStorage.getItem('userEmail');
        const userRole = localStorage.getItem('userRole');
        const userAvatar = localStorage.getItem('userAvatar');

        console.log('=== AUTH SYNC STATE (LEGACY) ===');
        console.log('Syncing auth state:', { isLoggedIn, userName, userEmail, userRole, userAvatar });
        console.log('================================');

        if (isLoggedIn && userName) {
            console.log('✅ User is logged in (legacy format), converting to unified format');
            
            // Convert to unified format
            const userObj = {
                fullName: userName,
                name: userName,
                email: userEmail,
                role: userRole || 'CUSTOMER',
                avatarUrl: userAvatar || '',
                picture: userAvatar || '',
                loginType: 'email'
            };
            
            // Save to unified format
            localStorage.setItem('currentUser', JSON.stringify(userObj));
            
            // Update unified navbar manager if available
            if (window.unifiedNavbarManager) {
                window.unifiedNavbarManager.currentUser = userObj;
                window.unifiedNavbarManager.updateNavbarForLoggedInUser();
            }
            
            // Dispatch event for legacy compatibility
            window.dispatchEvent(new CustomEvent('userLoggedIn', {
                detail: userObj
            }));
        } else {
            console.log('❌ No user logged in');
            // Update unified navbar manager for guest
            if (window.unifiedNavbarManager) {
                window.unifiedNavbarManager.currentUser = null;
                window.unifiedNavbarManager.updateNavbarForGuest();
            }
            // Trigger logout event
            window.dispatchEvent(new CustomEvent('userLoggedOut'));
        }
    }

    // Method để force refresh auth state
    forceRefresh() {
        console.log('Force refreshing auth state...');
        
        // Debug current state
        this.debugAuthState();
        
        // Clear and re-check with multiple attempts
        setTimeout(() => {
            this.syncAuthState();
        }, 50);
        
        setTimeout(() => {
            this.syncAuthState();
        }, 200);
        
        setTimeout(() => {
            this.syncAuthState();
        }, 500);
    }
    
    // Debug method
    debugAuthState() {
        const authData = {
            userLoggedIn: localStorage.getItem('userLoggedIn'),
            userName: localStorage.getItem('userName'),
            userEmail: localStorage.getItem('userEmail'),
            userRole: localStorage.getItem('userRole'),
            userAvatar: localStorage.getItem('userAvatar')
        };
        
        console.log('=== AUTH SYNC DEBUG ===');
        console.log('LocalStorage data:', authData);
        console.log('Is logged in:', authData.userLoggedIn === 'true');
        console.log('Has user name:', !!authData.userName);
        console.log('========================');
        
        return authData;
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.authSyncManager = new AuthSyncManager();
});

// Export for global access
window.AuthSyncManager = AuthSyncManager;
