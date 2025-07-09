/**
 * Anti-Flickering Auth Manager
 * Ngăn chặn hiện tượng nhấp nháy của navbar khi load trang
 */

class AntiFlickerAuthManager {
    constructor() {
        this.authChecked = false;
        this.navbarLocked = false;
        this.init();
    }

    init() {
        console.log('🔒 Anti-Flicker Auth Manager initializing...');
        
        // Lock navbar immediately to prevent flickering
        this.lockNavbar();
        
        // Quick auth check before DOM ready
        this.quickAuthCheck();
        
        // DOM ready handler
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.handleDOMReady();
            });
        } else {
            this.handleDOMReady();
        }
    }

    lockNavbar() {
        console.log('🔐 Locking navbar to prevent flickering...');
        this.navbarLocked = true;
        
        // Hide both menus initially to prevent flicker
        const style = document.createElement('style');
        style.id = 'anti-flicker-style';
        style.textContent = `
            #nav-user-info,
            #nav-login-btn {
                visibility: hidden !important;
                opacity: 0 !important;
                transition: none !important;
            }
        `;
        document.head.appendChild(style);
        
        console.log('✅ Navbar locked, elements hidden');
    }

    unlockNavbar() {
        console.log('🔓 Unlocking navbar...');
        this.navbarLocked = false;
        
        // Remove anti-flicker styles
        const antiFlickerStyle = document.getElementById('anti-flicker-style');
        if (antiFlickerStyle) {
            antiFlickerStyle.remove();
        }
        
        // Force visibility with smooth transition
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (navUserInfo) {
            navUserInfo.style.visibility = 'visible';
            navUserInfo.style.opacity = '1';
            navUserInfo.style.transition = 'opacity 0.3s ease-in-out';
        }
        
        if (navLoginBtn) {
            navLoginBtn.style.visibility = 'visible';
            navLoginBtn.style.opacity = '1';
            navLoginBtn.style.transition = 'opacity 0.3s ease-in-out';
        }
        
        console.log('✅ Navbar unlocked, smooth transition applied');
    }

    quickAuthCheck() {
        console.log('⚡ Performing quick auth check...');
        
        // Check if this is a post-login redirect
        const justLoggedIn = localStorage.getItem('justLoggedIn') === 'true';
        if (justLoggedIn) {
            console.log('🎯 Detected post-login redirect, prioritizing user menu');
            localStorage.removeItem('justLoggedIn'); // Clean up marker
        }
        
        // Synchronous check of localStorage
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        
        console.log('Quick auth result:', { isLoggedIn, userName, justLoggedIn });
        
        if (isLoggedIn && userName) {
            console.log('✅ User is logged in, preparing user menu');
            this.prepareUserMenu();
        } else {
            console.log('❌ User not logged in, preparing guest menu');
            this.prepareGuestMenu();
        }
        
        this.authChecked = true;
    }

    handleDOMReady() {
        console.log('🚀 DOM ready, finalizing auth state...');
        
        // Quick re-check in case something changed
        if (!this.authChecked) {
            this.quickAuthCheck();
        }
        
        // Apply final auth state
        this.applyAuthState();
        
        // Unlock navbar after a short delay
        setTimeout(() => {
            this.unlockNavbar();
        }, 100);
        
        // Set up event listeners
        this.setupEventListeners();
        
        // Final verification after unlock
        setTimeout(() => {
            this.verifyNavbarState();
        }, 500);
    }

    prepareUserMenu() {
        console.log('👤 Preparing user menu...');
        
        // Set the correct initial classes without animation
        document.addEventListener('DOMContentLoaded', () => {
            const navUserInfo = document.getElementById('nav-user-info');
            const navLoginBtn = document.getElementById('nav-login-btn');
            
            if (navUserInfo) {
                navUserInfo.classList.remove('d-none');
                navUserInfo.style.display = 'block';
            }
            
            if (navLoginBtn) {
                navLoginBtn.classList.add('d-none');
                navLoginBtn.style.display = 'none';
            }
        });
    }

    prepareGuestMenu() {
        console.log('🕵️ Preparing guest menu...');
        
        // Set the correct initial classes without animation
        document.addEventListener('DOMContentLoaded', () => {
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
        });
    }

    applyAuthState() {
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        const userEmail = localStorage.getItem('userEmail');
        const userAvatar = localStorage.getItem('userAvatar');
        
        console.log('🎯 Applying final auth state:', { isLoggedIn, userName });
        
        if (isLoggedIn && userName) {
            this.showUserMenu(userName, userEmail, userAvatar);
        } else {
            this.showGuestMenu();
        }
    }

    showUserMenu(userName, userEmail, userAvatar) {
        console.log('👤 Showing user menu:', userName);
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (navUserInfo && navLoginBtn) {
            // Show user menu
            navUserInfo.classList.remove('d-none');
            navUserInfo.style.display = 'block';
            
            // Hide login button
            navLoginBtn.classList.add('d-none');
            navLoginBtn.style.display = 'none';
            
            // Update user info
            this.updateUserInfo(userName, userEmail, userAvatar);
            
            console.log('✅ User menu shown successfully');
        }
    }

    showGuestMenu() {
        console.log('🕵️ Showing guest menu');
        
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        if (navUserInfo && navLoginBtn) {
            // Hide user menu
            navUserInfo.classList.add('d-none');
            navUserInfo.style.display = 'none';
            
            // Show login button
            navLoginBtn.classList.remove('d-none');
            navLoginBtn.style.display = 'block';
            
            console.log('✅ Guest menu shown successfully');
        }
    }

    updateUserInfo(userName, userEmail, userAvatar) {
        console.log('📝 Updating user info display');
        
        // Update display names
        const userDisplayName = document.getElementById('userDisplayName');
        const userDisplayNameMobile = document.getElementById('userDisplayNameMobile');
        const userFullName = document.getElementById('userFullName');
        
        if (userName) {
            const firstName = userName.split(' ')[0];
            
            if (userDisplayName) userDisplayName.textContent = firstName;
            if (userDisplayNameMobile) userDisplayNameMobile.textContent = firstName;
            if (userFullName) userFullName.textContent = userName;
        }
        
        // Update avatars
        if (userAvatar || userEmail) {
            this.updateAvatars(userAvatar, userName, userEmail);
        }
    }

    updateAvatars(avatarUrl, userName, userEmail) {
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

    setupEventListeners() {
        console.log('🎧 Setting up anti-flicker event listeners...');
        
        // Listen for auth events but prevent multiple rapid changes
        let eventTimeout = null;
        
        window.addEventListener('userLoggedIn', (event) => {
            if (eventTimeout) clearTimeout(eventTimeout);
            eventTimeout = setTimeout(() => {
                console.log('👥 Login event received in anti-flicker manager');
                this.handleLoginEvent(event.detail);
            }, 50);
        });
        
        window.addEventListener('userLoggedOut', () => {
            if (eventTimeout) clearTimeout(eventTimeout);
            eventTimeout = setTimeout(() => {
                console.log('🚪 Logout event received in anti-flicker manager');
                this.showGuestMenu();
            }, 50);
        });
    }

    handleLoginEvent(detail) {
        console.log('🔄 Handling login event:', detail);
        
        // Update localStorage
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', detail.fullName || '');
        localStorage.setItem('userEmail', detail.email || '');
        localStorage.setItem('userRole', detail.role || 'CUSTOMER');
        localStorage.setItem('userAvatar', detail.avatarUrl || '');
        
        // Update navbar
        this.showUserMenu(detail.fullName, detail.email, detail.avatarUrl);
    }

    verifyNavbarState() {
        console.log('🔍 Verifying final navbar state...');
        
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        
        const userMenuVisible = navUserInfo && !navUserInfo.classList.contains('d-none');
        const loginBtnHidden = navLoginBtn && navLoginBtn.classList.contains('d-none');
        
        console.log('Final state verification:', {
            isLoggedIn,
            userName: !!userName,
            userMenuVisible,
            loginBtnHidden,
            stateCorrect: isLoggedIn === userMenuVisible && isLoggedIn === loginBtnHidden
        });
        
        // If state is incorrect, fix it
        if (isLoggedIn && userName && (!userMenuVisible || !loginBtnHidden)) {
            console.log('⚠️ State incorrect, applying fix...');
            this.showUserMenu(userName, localStorage.getItem('userEmail'), localStorage.getItem('userAvatar'));
        } else if (!isLoggedIn && (userMenuVisible || !navLoginBtn || navLoginBtn.classList.contains('d-none'))) {
            console.log('⚠️ State incorrect, showing guest menu...');
            this.showGuestMenu();
        } else {
            console.log('✅ Navbar state is correct');
        }
    }

    // Public method to force fix
    forceFixNavbar() {
        console.log('🔧 Force fixing navbar through anti-flicker manager...');
        this.quickAuthCheck();
        this.applyAuthState();
        setTimeout(() => {
            this.verifyNavbarState();
        }, 100);
    }
}

// Initialize immediately - before DOM ready
console.log('🚀 Initializing Anti-Flicker Auth Manager...');
window.antiFlickerAuthManager = new AntiFlickerAuthManager();

// Export for global access
window.AntiFlickerAuthManager = AntiFlickerAuthManager;
