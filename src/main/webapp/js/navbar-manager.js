// Simple Navbar Manager - Single Source of Truth
class NavbarManager {
    constructor() {
        this.init();
    }

    init() {
        console.log('Navbar Manager initialized');
        this.bindEvents();
        
        // Check initial state immediately and then after DOM is fully ready
        this.checkInitialState();
        
        // Also check after multiple delays to catch any late localStorage updates
        setTimeout(() => {
            console.log('Navbar Manager: 300ms delay check');
            this.checkInitialState();
        }, 300);
        
        setTimeout(() => {
            console.log('Navbar Manager: 800ms delay check');
            this.checkInitialState();
        }, 800);
        
        setTimeout(() => {
            console.log('Navbar Manager: 1.5s delay check');
            this.checkInitialState();
        }, 1500);
    }

    bindEvents() {
        // Listen for login events
        window.addEventListener('userLoggedIn', (event) => {
            console.log('User logged in event received', event.detail);
            const { fullName, email, role, avatarUrl } = event.detail;
            this.showUserMenu(fullName, email, avatarUrl);
        });

        // Listen for logout events  
        window.addEventListener('userLoggedOut', () => {
            console.log('User logged out event received');
            this.showGuestMenu();
        });

        // Bind logout button in navbar
        this.bindLogoutButton();
    }

    bindLogoutButton() {
        // Use event delegation to handle dynamically created logout buttons
        document.addEventListener('click', (event) => {
            if (event.target.matches('[onclick="userLogout()"]') || 
                event.target.closest('[onclick="userLogout()"]') ||
                event.target.id === 'nav-logout-btn' ||
                event.target.closest('#nav-logout-btn')) {
                event.preventDefault();
                this.logout();
            }
        });
    }

    checkInitialState() {
        console.log('Checking initial navbar state...');
        
        // Check localStorage first
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        const userEmail = localStorage.getItem('userEmail');
        const userAvatar = localStorage.getItem('userAvatar');
        
        console.log('Initial state:', { isLoggedIn, userName, userEmail, userAvatar });
        
        if (isLoggedIn && userName) {
            console.log('User is logged in, showing user menu');
            this.showUserMenu(userName, userEmail, userAvatar);
        } else {
            console.log('User is not logged in, showing guest menu');
            this.showGuestMenu();
            
            // Check OAuth as fallback after delay
            setTimeout(() => {
                if (window.googleOAuthHandler) {
                    console.log('Checking Google OAuth status as fallback');
                    window.googleOAuthHandler.checkLoginStatus();
                }
            }, 800);
        }
    }

    showUserMenu(userName, userEmail, avatarUrl) {
        console.log('=== SHOWING USER MENU ===');
        console.log('User:', userName, 'Email:', userEmail, 'Avatar:', avatarUrl);
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        console.log('Nav elements found:', {
            navUserInfo: !!navUserInfo,
            navLoginBtn: !!navLoginBtn
        });
        
        if (!navUserInfo || !navLoginBtn) {
            console.error('❌ Navbar elements not found');
            console.log('Available elements:', {
                'nav-user-info': document.getElementById('nav-user-info'),
                'nav-login-btn': document.getElementById('nav-login-btn')
            });
            return;
        }

        console.log('✅ Hiding login button and showing user menu...');
        
        // Hide login button
        navLoginBtn.classList.add('d-none');
        navLoginBtn.style.display = 'none';
        
        // Show user menu
        navUserInfo.classList.remove('d-none');
        navUserInfo.style.display = 'block';
        
        console.log('✅ Menu visibility toggled');
        console.log('NavUserInfo classes:', navUserInfo.classList.toString());
        console.log('NavLoginBtn classes:', navLoginBtn.classList.toString());
        
        // Update user name display
        const userDisplayName = document.getElementById('userDisplayName');
        const userDisplayNameMobile = document.getElementById('userDisplayNameMobile');
        const userFullName = document.getElementById('userFullName');
        
        const firstName = userName.split(' ')[0];
        
        console.log('Updating text elements:', {
            userDisplayName: !!userDisplayName,
            userDisplayNameMobile: !!userDisplayNameMobile,
            userFullName: !!userFullName,
            firstName: firstName
        });
        
        if (userDisplayName) {
            userDisplayName.textContent = firstName;
            console.log('Updated userDisplayName:', userDisplayName.textContent);
        }
        
        if (userDisplayNameMobile) {
            userDisplayNameMobile.textContent = firstName;
            console.log('Updated userDisplayNameMobile:', userDisplayNameMobile.textContent);
        }
        
        if (userFullName) {
            userFullName.textContent = userName;
            console.log('Updated userFullName:', userFullName.textContent);
        }
        
        // Update avatar images
        console.log('Updating avatar...');
        this.updateUserAvatar(avatarUrl, userName, userEmail);
        
        console.log('✅ User menu displayed successfully');
        
        // Force a DOM re-render to ensure changes are applied
        setTimeout(() => {
            navUserInfo.style.display = 'block';
            navUserInfo.classList.remove('d-none');
            navLoginBtn.style.display = 'none';
            navLoginBtn.classList.add('d-none');
            console.log('🔄 Forced DOM re-render completed');
        }, 50);
        
        console.log('=== END SHOWING USER MENU ===');
    }

    showGuestMenu() {
        console.log('Showing guest menu');
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (!navUserInfo || !navLoginBtn) {
            console.error('Navbar elements not found');
            return;
        }

        // Show login button
        navLoginBtn.classList.remove('d-none');
        navLoginBtn.style.display = 'block';
        
        // Hide user menu
        navUserInfo.classList.add('d-none');
        navUserInfo.style.display = 'none';
        
        console.log('Guest menu displayed successfully');
    }

    logout() {
        if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
            console.log('Logging out user...');
            
            // Clear localStorage
            localStorage.removeItem('userLoggedIn');
            localStorage.removeItem('userName');
            localStorage.removeItem('userEmail');
            localStorage.removeItem('userRole');
            localStorage.removeItem('userAvatar');
            
            // Dispatch logout event
            window.dispatchEvent(new CustomEvent('userLoggedOut'));
            
            // Show guest menu immediately
            this.showGuestMenu();
            
            // Try both logout endpoints
            Promise.all([
                fetch('/api/logout', { method: 'POST', credentials: 'same-origin' }).catch(() => null),
                fetch('/oauth2/logout', { method: 'POST', credentials: 'same-origin' }).catch(() => null)
            ]).then(() => {
                window.location.href = '/';
            }).catch(() => {
                window.location.href = '/';
            });
        }
    }

    updateUserAvatar(avatarUrl, userName, userEmail) {
        console.log('Updating user avatar:', avatarUrl);
        
        const avatarImage = document.getElementById('userAvatarImage');
        const avatarDropdown = document.getElementById('userAvatarDropdown');
        
        // Determine avatar source
        let finalAvatarUrl = avatarUrl;
        
        if (!finalAvatarUrl || finalAvatarUrl === '') {
            // Generate avatar based on user info
            finalAvatarUrl = this.generateDefaultAvatar(userName, userEmail);
        }
        
        // Update main avatar
        if (avatarImage) {
            avatarImage.src = finalAvatarUrl;
            avatarImage.alt = `${userName}'s Avatar`;
            avatarImage.onerror = () => {
                avatarImage.src = this.generateDefaultAvatar(userName, userEmail);
            };
        }
        
        // Update dropdown avatar
        if (avatarDropdown) {
            avatarDropdown.src = finalAvatarUrl;
            avatarDropdown.alt = `${userName}'s Avatar`;
            avatarDropdown.onerror = () => {
                avatarDropdown.src = this.generateDefaultAvatar(userName, userEmail);
            };
        }
        
        console.log('Avatar updated successfully');
    }
    
    generateDefaultAvatar(userName, userEmail) {
        if (window.AvatarUtils) {
            return window.AvatarUtils.generateDefaultAvatar(userName, userEmail);
        }
        
        // Fallback if AvatarUtils not available
        if (userEmail) {
            return `https://ui-avatars.com/api/?name=${encodeURIComponent(userEmail)}&size=128&background=6c757d&color=ffffff&bold=true&format=png`;
        }
        
        return `https://ui-avatars.com/api/?name=${encodeURIComponent(userName)}&size=128&background=28a745&color=ffffff&bold=true&format=png`;
    }
    
    getGravatarUrl(email, size = 128) {
        if (window.AvatarUtils) {
            return window.AvatarUtils.getGravatarUrl(email, size);
        }
        
        // Fallback
        return `https://ui-avatars.com/api/?name=${encodeURIComponent(email)}&size=${size}&background=6c757d&color=ffffff&bold=true&format=png`;
    }
    
    getInitials(name) {
        if (window.AvatarUtils) {
            return window.AvatarUtils.getInitials(name);
        }
        
        // Fallback
        return name
            .split(' ')
            .map(word => word.charAt(0))
            .join('')
            .substring(0, 2)
            .toUpperCase();
    }
    
    // Remove the MD5 function as it's now in AvatarUtils

    // Public method to refresh navbar state
    refresh() {
        this.checkInitialState();
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.navbarManager = new NavbarManager();
});

// Global logout function for compatibility
window.userLogout = function() {
    if (window.navbarManager) {
        window.navbarManager.logout();
    }
};
