/**
 * Unified Navbar Manager - Single Account Button for All Login Methods
 * This replaces the old dual-button system with a single, unified account button
 */
class UnifiedNavbarManager {
    constructor() {
        this.contextPath = window.contextPath || '';
        this.currentUser = null;
        this.init();
    }

    init() {
        console.log('🔄 Unified Navbar Manager initialized');
        this.bindEvents();
        this.checkAuthState();
        
        // Multiple checks to handle race conditions
        setTimeout(() => this.checkAuthState(), 100);
        setTimeout(() => this.checkAuthState(), 500);
        setTimeout(() => this.checkAuthState(), 1000);
    }

    bindEvents() {
        // Listen for auth state changes
        window.addEventListener('userLoggedIn', (event) => {
            console.log('👤 User logged in event received', event.detail);
            this.currentUser = event.detail;
            this.updateNavbarForLoggedInUser();
        });

        window.addEventListener('userLoggedOut', () => {
            console.log('🚪 User logged out event received');
            this.currentUser = null;
            this.updateNavbarForGuest();
        });

        // Handle logout button clicks (using event delegation)
        document.addEventListener('click', (event) => {
            if (event.target.id === 'unifiedLogoutBtn' || 
                event.target.closest('#unifiedLogoutBtn')) {
                event.preventDefault();
                this.handleLogout();
            }
        });
    }

    checkAuthState() {
        console.log('🔍 Checking authentication state...');
        
        // First check server session (for email/password login)
        this.checkServerAuth().then(() => {
            // Then check localStorage for client-side auth data
            this.checkLocalStorageAuth();
        }).catch(() => {
            // If server check fails, fallback to localStorage only
            this.checkLocalStorageAuth();
        });
    }
    
    async checkServerAuth() {
        console.log('🌐 Checking server authentication...');
        
        try {
            const response = await fetch('/oauth2/user-info', {
                method: 'GET',
                credentials: 'include',
                headers: {
                    'Accept': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                console.log('📡 Server response:', data);
                
                if (data.isLoggedIn) {
                    console.log('✅ Server session found:', data);
                    
                    // Convert server data to client format
                    this.currentUser = {
                        fullName: data.name,
                        name: data.name,
                        email: data.email,
                        role: data.role,
                        picture: data.picture,
                        avatarUrl: data.picture,
                        loginType: data.loginType || 'server'
                    };
                    
                    this.updateNavbarForLoggedInUser();
                    return Promise.resolve();
                }
            }
            
            return Promise.reject('No server session');
            
        } catch (error) {
            console.log('⚠️ Server auth check failed:', error);
            return Promise.reject(error);
        }
    }

    checkLocalStorageAuth() {
        console.log('📦 Checking localStorage authentication...');
        
        // Check localStorage for auth data
        const storedUser = localStorage.getItem('currentUser');
        const googleUser = localStorage.getItem('googleUser');
        
        console.log('📦 Stored user:', storedUser);
        console.log('📦 Google user:', googleUser);
        
        if (storedUser) {
            try {
                this.currentUser = JSON.parse(storedUser);
                console.log('✅ Regular user found:', this.currentUser);
                this.updateNavbarForLoggedInUser();
                return;
            } catch (e) {
                console.error('❌ Error parsing stored user:', e);
                localStorage.removeItem('currentUser');
            }
        }
        
        if (googleUser) {
            try {
                this.currentUser = JSON.parse(googleUser);
                console.log('✅ Google user found:', this.currentUser);
                this.updateNavbarForLoggedInUser();
                return;
            } catch (e) {
                console.error('❌ Error parsing Google user:', e);
                localStorage.removeItem('googleUser');
            }
        }
        
        // No user found
        console.log('👤 No authenticated user found');
        this.updateNavbarForGuest();
    }

    updateNavbarForLoggedInUser() {
        console.log('🔄 Updating navbar for logged in user');
        
        const dropdown = document.getElementById('unifiedAccountDropdown');
        const menu = document.getElementById('unifiedAccountDropdownMenu');
        
        if (!dropdown || !menu) {
            console.error('❌ Navbar elements not found');
            return;
        }

        // Update button style and content
        dropdown.className = 'btn btn-outline-success dropdown-toggle d-flex align-items-center';
        
        // Get user display name
        const displayName = this.getUserDisplayName();
        const avatarUrl = this.getUserAvatarUrl();
        
        // Update button content with user info
        dropdown.innerHTML = `
            <div class="user-avatar-container me-2">
                <img src="${avatarUrl}" 
                     alt="User Avatar" 
                     class="user-avatar rounded-circle"
                     style="width: 32px; height: 32px; object-fit: cover;">
            </div>
            <span class="d-none d-md-inline">
                <span class="greeting-text">Xin chào</span>
                <span class="fw-bold">${displayName}</span>
            </span>
            <span class="d-md-none">
                <span class="fw-bold">${displayName}</span>
            </span>
        `;
        
        // Update dropdown menu for logged in user
        menu.innerHTML = `
            <li><h6 class="dropdown-header d-flex align-items-center">
                <img src="${avatarUrl}" 
                     alt="User Avatar" 
                     class="user-avatar-small rounded-circle me-2"
                     style="width: 24px; height: 24px; object-fit: cover;">
                <span>${this.currentUser.fullName || this.currentUser.name || 'User'}</span>
            </h6></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="${this.contextPath}/profile.jsp">
                <i class="fas fa-user-edit me-2"></i>Thông tin tài khoản
            </a></li>
            <li><a class="dropdown-item" href="#">
                <i class="fas fa-shopping-bag me-2"></i>Đơn hàng của tôi
            </a></li>
            <li><a class="dropdown-item" href="#">
                <i class="fas fa-heart me-2"></i>Sản phẩm yêu thích
            </a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="#" id="unifiedLogoutBtn">
                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
            </a></li>
        `;
        
        console.log('✅ Navbar updated for logged in user:', displayName);
    }

    updateNavbarForGuest() {
        console.log('🔄 Updating navbar for guest user');
        
        const dropdown = document.getElementById('unifiedAccountDropdown');
        const menu = document.getElementById('unifiedAccountDropdownMenu');
        
        if (!dropdown || !menu) {
            console.error('❌ Navbar elements not found');
            return;
        }

        // Update button style and content for guest
        dropdown.className = 'btn btn-outline-primary dropdown-toggle';
        dropdown.innerHTML = `
            <i class="fas fa-user me-1"></i>
            <span class="d-none d-md-inline">Tài khoản</span>
        `;
        
        // Update dropdown menu for guest
        menu.innerHTML = `
            <li><a class="dropdown-item" href="${this.contextPath}/login.jsp">
                <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
            </a></li>
            <li><a class="dropdown-item" href="${this.contextPath}/register.jsp">
                <i class="fas fa-user-plus me-2"></i>Đăng ký
            </a></li>
        `;
        
        console.log('✅ Navbar updated for guest user');
    }

    getUserDisplayName() {
        if (!this.currentUser) return 'User';
        
        // Try different name fields
        const fullName = this.currentUser.fullName || this.currentUser.name || this.currentUser.displayName;
        if (fullName) {
            // Return first name only
            return fullName.split(' ')[0];
        }
        
        return this.currentUser.email ? this.currentUser.email.split('@')[0] : 'User';
    }

    getUserAvatarUrl() {
        if (!this.currentUser) return `${this.contextPath}/img/placeholder.jpg`;
        
        return this.currentUser.picture || 
               this.currentUser.avatar || 
               this.currentUser.avatarUrl || 
               `${this.contextPath}/img/placeholder.jpg`;
    }

    async handleLogout() {
        console.log('🚪 Handling logout...');
        
        try {
            // First, call server logout to invalidate session
            console.log('🌐 Calling server logout...');
            
            try {
                const response = await fetch('/oauth2/logout', {
                    method: 'POST',
                    credentials: 'include',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    }
                });
                
                if (response.ok) {
                    console.log('✅ Server logout successful');
                } else {
                    console.warn('⚠️ Server logout failed, but continuing with client cleanup');
                }
            } catch (serverError) {
                console.warn('⚠️ Server logout error:', serverError, 'but continuing with client cleanup');
            }
            
            // Clear all client-side user data
            console.log('🧹 Clearing client-side data...');
            localStorage.removeItem('currentUser');
            localStorage.removeItem('googleUser');
            localStorage.removeItem('userRole');
            localStorage.removeItem('justLoggedIn');
            
            // Sign out from Google if it's a Google user
            if (this.currentUser && (this.currentUser.googleId || this.currentUser.sub)) {
                console.log('🔍 Google user detected, signing out from Google...');
                if (typeof google !== 'undefined' && google.accounts) {
                    google.accounts.id.disableAutoSelect();
                    console.log('✅ Google auto-select disabled');
                }
            }
            
            // Reset current user
            this.currentUser = null;
            
            // Update navbar immediately
            console.log('🔄 Updating navbar to guest state...');
            this.updateNavbarForGuest();
            
            // Dispatch logout event
            window.dispatchEvent(new CustomEvent('userLoggedOut'));
            
            console.log('✅ Logout completed successfully');
            
            // Redirect to home page immediately
            console.log('🏠 Redirecting to home page...');
            window.location.href = this.contextPath + '/';
            
        } catch (error) {
            console.error('❌ Error during logout:', error);
            
            // Even if there's an error, still try to clean up and redirect
            this.currentUser = null;
            localStorage.clear(); // Clear everything to be safe
            this.updateNavbarForGuest();
            window.location.href = this.contextPath + '/';
        }
    }

    // Public method to manually refresh navbar state
    refreshNavbar() {
        console.log('🔄 Manual navbar refresh requested');
        this.checkAuthState();
    }

    // Public method to get current user
    getCurrentUser() {
        return this.currentUser;
    }
}

// Initialize the unified navbar manager
let unifiedNavbarManager;

// Wait for DOM to be ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        unifiedNavbarManager = new UnifiedNavbarManager();
    });
} else {
    unifiedNavbarManager = new UnifiedNavbarManager();
}

// Make it globally available
window.UnifiedNavbarManager = UnifiedNavbarManager;
window.unifiedNavbarManager = unifiedNavbarManager;

// Legacy support - redirect old function calls
window.userLogout = function() {
    if (unifiedNavbarManager) {
        unifiedNavbarManager.handleLogout();
    }
};

console.log('📦 Unified Navbar Manager script loaded');
