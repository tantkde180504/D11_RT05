// Unified Navbar Controller - Single Source of Truth for Navbar State
class UnifiedNavbarController {
    constructor() {
        this.isInitialized = false;
        this.currentUser = null;
        this.init();
    }

    init() {
        if (this.isInitialized) return;
        
        console.log('🚀 Initializing Unified Navbar Controller');
        
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
        
        this.isInitialized = true;
    }
    
    setup() {
        console.log('📝 Setting up navbar controller');
        
        // Bind events
        this.bindEvents();
        
        // Initial status check
        this.checkAndUpdateNavbar();
        
        // Periodic check (backup)
        setTimeout(() => this.checkAndUpdateNavbar(), 1000);
    }
    
    bindEvents() {
        // Listen for login events
        window.addEventListener('userLoggedIn', (event) => {
            console.log('👤 User logged in event received:', event.detail);
            this.handleUserLogin(event.detail);
        });
        
        // Listen for logout events
        window.addEventListener('userLoggedOut', () => {
            console.log('👋 User logged out event received');
            this.handleUserLogout();
        });
        
        // Listen for storage changes (other tabs)
        window.addEventListener('storage', (event) => {
            if (event.key === 'userLoggedIn' || event.key === 'userName') {
                this.checkAndUpdateNavbar();
            }
        });
    }
    
    checkAndUpdateNavbar() {
        console.log('🔍 Checking navbar status...');
        
        // Check localStorage first
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName');
        
        console.log('💾 LocalStorage check:', { isLoggedIn, userName });
        
        if (isLoggedIn && userName) {
            this.showUserNavbar(userName);
            return;
        }
        
        // Check OAuth session as fallback
        this.checkOAuthSession();
    }
    
    checkOAuthSession() {
        console.log('🔐 Checking OAuth session...');
        
        fetch('/oauth2/user-info', {
            method: 'GET',
            credentials: 'same-origin'
        })
        .then(response => response.json())
        .then(data => {
            console.log('🌐 OAuth session check result:', data);
            
            if (data.isLoggedIn && data.userName) {
                // Update localStorage to sync state
                localStorage.setItem('userLoggedIn', 'true');
                localStorage.setItem('userName', data.userName);
                localStorage.setItem('userEmail', data.userEmail || '');
                
                this.showUserNavbar(data.userName);
            } else {
                this.showGuestNavbar();
            }
        })
        .catch(error => {
            console.error('❌ OAuth session check error:', error);
            this.showGuestNavbar();
        });
    }
    
    showUserNavbar(userName) {
        console.log('✅ Showing user navbar for:', userName);
        
        const navLoginBtn = document.getElementById('nav-login-btn');
        const navUserInfo = document.getElementById('nav-user-info');
        
        if (!navLoginBtn || !navUserInfo) {
            console.error('❌ Navbar elements not found');
            return;
        }
        
        // Hide guest menu
        navLoginBtn.classList.add('d-none');
        navLoginBtn.style.display = 'none';
        
        // Show user menu
        navUserInfo.classList.remove('d-none');
        navUserInfo.style.display = 'block';
        
        // Update user name display
        const userDisplayName = document.getElementById('userDisplayName');
        const userFullName = document.getElementById('userFullName');
        
        if (userDisplayName) {
            const firstName = userName.split(' ')[0];
            userDisplayName.textContent = firstName;
        }
        
        if (userFullName) {
            userFullName.textContent = userName;
        }
        
        this.currentUser = userName;
        console.log('✅ User navbar displayed successfully');
    }
    
    showGuestNavbar() {
        console.log('🔓 Showing guest navbar');
        
        const navLoginBtn = document.getElementById('nav-login-btn');
        const navUserInfo = document.getElementById('nav-user-info');
        
        if (!navLoginBtn || !navUserInfo) {
            console.error('❌ Navbar elements not found');
            return;
        }
        
        // Show guest menu
        navLoginBtn.classList.remove('d-none');
        navLoginBtn.style.display = 'block';
        
        // Hide user menu
        navUserInfo.classList.add('d-none');
        navUserInfo.style.display = 'none';
        
        this.currentUser = null;
        console.log('✅ Guest navbar displayed successfully');
    }
    
    handleUserLogin(userData) {
        console.log('🎯 Handling user login:', userData);
        
        if (userData && userData.fullName) {
            this.showUserNavbar(userData.fullName);
        }
    }
    
    handleUserLogout() {
        console.log('🎯 Handling user logout');
        
        // Clear localStorage
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        
        this.showGuestNavbar();
    }
    
    // Public methods
    getCurrentUser() {
        return this.currentUser;
    }
    
    forceRefresh() {
        this.checkAndUpdateNavbar();
    }
}

// Initialize unified controller
const unifiedNavbarController = new UnifiedNavbarController();

// Export for global access
window.unifiedNavbarController = unifiedNavbarController;

// Legacy compatibility functions
window.showUserMenu = (userName) => unifiedNavbarController.showUserNavbar(userName);
window.showGuestMenu = () => unifiedNavbarController.showGuestNavbar();
window.checkUserLoginStatus = () => unifiedNavbarController.checkAndUpdateNavbar();
