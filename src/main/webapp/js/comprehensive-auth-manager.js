/**
 * Comprehensive Auth State Manager
 * Đảm bảo authentication state luôn được đồng bộ đúng cách
 */

class ComprehensiveAuthManager {
    constructor() {
        this.initialized = false;
        this.checkInterval = null;
        this.init();
    }

    init() {
        console.log('🔄 Comprehensive Auth Manager initializing...');
        
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.start();
            });
        } else {
            this.start();
        }
    }

    start() {
        console.log('🚀 Comprehensive Auth Manager starting...');
        
        this.initialized = true;
        
        // Check if anti-flicker manager is present and defer to it initially
        if (window.antiFlickerAuthManager) {
            console.log('🔒 Anti-flicker manager detected, deferring initial setup...');
            // Wait longer before starting to avoid conflicts
            setTimeout(() => {
                this.startAfterAntiFlicker();
            }, 1000);
        } else {
            this.startAfterAntiFlicker();
        }
    }

    startAfterAntiFlicker() {
        console.log('🚀 Starting comprehensive manager after anti-flicker...');
        
        // Listen for auth events
        window.addEventListener('userLoggedIn', (event) => {
            console.log('🎯 userLoggedIn event received in comprehensive manager', event.detail);
            // Add delay to avoid conflict with anti-flicker manager
            setTimeout(() => {
                this.handleUserLoggedIn(event.detail);
            }, 100);
        });

        window.addEventListener('userLoggedOut', () => {
            console.log('🚪 userLoggedOut event received in comprehensive manager');
            // Add delay to avoid conflict with anti-flicker manager
            setTimeout(() => {
                this.handleUserLoggedOut();
            }, 100);
        });

        // Check current state after delay
        setTimeout(() => {
            this.checkAuthState();
        }, 500);

        // Set up periodic check with longer interval to reduce conflicts
        this.startPeriodicCheck();
    }

    checkAuthState() {
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        const userEmail = localStorage.getItem('userEmail');
        const userAvatar = localStorage.getItem('userAvatar');

        console.log('🔍 Checking auth state:', { isLoggedIn, userName, userEmail, userAvatar });

        if (isLoggedIn && userName) {
            this.ensureUserMenuVisible(userName, userEmail, userAvatar);
        } else {
            this.ensureGuestMenuVisible();
        }
    }

    handleUserLoggedIn(detail) {
        console.log('✅ Handling user logged in:', detail);
        
        // Update localStorage with all data
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', detail.fullName || '');
        localStorage.setItem('userEmail', detail.email || '');
        localStorage.setItem('userRole', detail.role || 'CUSTOMER');
        localStorage.setItem('userAvatar', detail.avatarUrl || '');

        // Ensure navbar is updated
        setTimeout(() => {
            this.ensureUserMenuVisible(detail.fullName, detail.email, detail.avatarUrl);
        }, 100);

        setTimeout(() => {
            this.ensureUserMenuVisible(detail.fullName, detail.email, detail.avatarUrl);
        }, 300);
    }

    handleUserLoggedOut() {
        console.log('🚪 Handling user logged out');
        
        // Clear localStorage
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');

        // Ensure navbar shows guest menu
        this.ensureGuestMenuVisible();
    }

    ensureUserMenuVisible(userName, userEmail, userAvatar) {
        console.log('👤 Ensuring user menu is visible for:', userName);
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');

        if (!navUserInfo || !navLoginBtn) {
            console.log('❌ Navbar elements not found');
            return false;
        }

        // Show user menu
        navUserInfo.classList.remove('d-none');
        navUserInfo.style.display = 'block';

        // Hide login button
        navLoginBtn.classList.add('d-none');
        navLoginBtn.style.display = 'none';

        // Update user display names
        const userDisplayName = document.getElementById('userDisplayName');
        const userDisplayNameMobile = document.getElementById('userDisplayNameMobile');
        const userFullName = document.getElementById('userFullName');

        if (userName) {
            const firstName = userName.split(' ')[0];
            
            if (userDisplayName) {
                userDisplayName.textContent = firstName;
            }
            if (userDisplayNameMobile) {
                userDisplayNameMobile.textContent = firstName;
            }
            if (userFullName) {
                userFullName.textContent = userName;
            }
        }

        // Update avatar if available
        if (userAvatar || userEmail) {
            this.updateAvatar(userAvatar, userName, userEmail);
        }

        console.log('✅ User menu ensured visible');
        return true;
    }

    ensureGuestMenuVisible() {
        console.log('🕵️ Ensuring guest menu is visible');
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');

        if (!navUserInfo || !navLoginBtn) {
            console.log('❌ Navbar elements not found');
            return false;
        }

        // Hide user menu
        navUserInfo.classList.add('d-none');
        navUserInfo.style.display = 'none';

        // Show login button
        navLoginBtn.classList.remove('d-none');
        navLoginBtn.style.display = 'block';

        console.log('✅ Guest menu ensured visible');
        return true;
    }

    updateAvatar(avatarUrl, userName, userEmail) {
        const userAvatarImage = document.getElementById('userAvatarImage');
        const userAvatarDropdown = document.getElementById('userAvatarDropdown');

        let finalAvatarUrl = avatarUrl;
        if (!finalAvatarUrl && userEmail) {
            finalAvatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(userEmail)}&size=128&background=28a745&color=ffffff&bold=true&format=png`;
        } else if (!finalAvatarUrl && userName) {
            finalAvatarUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(userName)}&size=128&background=28a745&color=ffffff&bold=true&format=png`;
        }

        if (userAvatarImage && finalAvatarUrl) {
            userAvatarImage.src = finalAvatarUrl;
            userAvatarImage.alt = `${userName}'s Avatar`;
        }

        if (userAvatarDropdown && finalAvatarUrl) {
            userAvatarDropdown.src = finalAvatarUrl;
            userAvatarDropdown.alt = `${userName}'s Avatar`;
        }
    }

    startPeriodicCheck() {
        // Check every 2 seconds to ensure navbar state is correct
        this.checkInterval = setInterval(() => {
            this.checkAuthState();
        }, 2000);
    }

    stopPeriodicCheck() {
        if (this.checkInterval) {
            clearInterval(this.checkInterval);
            this.checkInterval = null;
        }
    }

    // Force fix method for manual calling
    forceFixNavbar() {
        console.log('🔧 Force fixing navbar through comprehensive manager...');
        this.checkAuthState();
        return true;
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.comprehensiveAuthManager = new ComprehensiveAuthManager();
});

// Export for global access
window.ComprehensiveAuthManager = ComprehensiveAuthManager;

console.log('🔧 Comprehensive Auth Manager loaded');
