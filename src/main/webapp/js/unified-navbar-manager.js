/**
 * Unified Navbar Manager - Single Account Button for All Login Methods
 * This replaces the old dual-button system with a single, unified account button
 */
class UnifiedNavbarManager {
    constructor() {
        this.contextPath = window.contextPath || '';
        this.currentUser = null;
        this.init();
        // Tự động cập nhật navbar và cart-count khi script được load trên bất kỳ trang nà    refreshNavbar() {
        console.log('🔄 Forced navbar refresh requested');
        this.checkAuthState();
        
        // Also force avatar refresh after a delay
        this.contextPath = window.contextPath || '';
        this.currentUser = null;
        this.init();
        // Tự động cập nhật navbar và cart-count khi script được load trên bất kỳ trang nào
        if (document.readyState !== 'loading') {
            this.checkAuthState();
            setTimeout(() => this.refreshNavbar(), 1000);
        } else {
            document.addEventListener('DOMContentLoaded', () => {
                this.checkAuthState();
                setTimeout(() => this.refreshNavbar(), 1000);
            });
        }
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

        // Listen for localStorage changes
        window.addEventListener('storage', (event) => {
            if (event.key === 'currentUser' || event.key === 'googleUser') {
                console.log('📦 localStorage changed, refreshing auth state');
                this.checkAuthState();
            }
        });

        // Handle logout button clicks (using event delegation)
        document.addEventListener('click', (event) => {
            if (event.target.id === 'unifiedLogoutBtn' || 
                event.target.closest('#unifiedLogoutBtn')) {
                event.preventDefault();
                this.handleLogout();
            }
            
            // Handle chat button clicks
            if (event.target.closest('[data-action="openChat"]')) {
                event.preventDefault();
                if (window.openChatWidget) {
                    window.openChatWidget();
                }
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
            const response = await fetch(`${this.contextPath}/oauth2/user-info`, {
                method: 'GET',
                credentials: 'include',
                headers: {
                    'Accept': 'application/json'
                }
            });
            
            if (response.ok) {
                const data = await response.json();
                console.log('📡 Server response:', data);
                // Nếu bị ban thì hiển thị bảng thông báo và không cho đăng nhập
                if (data.success === false && data.banReason) {
                    document.querySelectorAll('.ban-reason-box').forEach(e => e.remove());
                    const banBox = document.createElement('div');
                    banBox.className = 'ban-reason-box';
                    banBox.style.position = 'fixed';
                    banBox.style.bottom = '32px';
                    banBox.style.right = '32px';
                    banBox.style.zIndex = '9999';
                    banBox.style.background = '#fff0f0';
                    banBox.style.border = '2px solid #d9534f';
                    banBox.style.color = '#d9534f';
                    banBox.style.padding = '20px 28px';
                    banBox.style.borderRadius = '12px';
                    banBox.style.maxWidth = '360px';
                    banBox.style.boxShadow = '0 4px 16px rgba(0,0,0,0.12)';
                    banBox.style.textAlign = 'center';
                    banBox.style.fontFamily = 'inherit';
                    banBox.innerHTML = `
                      <div style='font-size:32px;margin-bottom:8px;'>⚠️</div>
                      <h3 style='margin:0 0 8px 0;font-size:22px;'>Tài khoản của bạn đã bị cấm</h3>
                      <div style='font-size:16px;margin-bottom:8px;'><b>Lý do:</b> <span>${data.banReason}</span></div>
                      <div style='font-size:14px;margin-bottom:8px;'>Bạn sẽ được chuyển về trang đăng nhập sau vài giây...</div>
                      <button onclick="this.parentElement.remove()" style="margin-top:8px;padding:6px 18px;border:none;background:#d9534f;color:#fff;border-radius:5px;cursor:pointer;font-size:15px;">Đóng</button>
                    `;
                    document.body.appendChild(banBox);
                    // Xóa user khỏi localStorage, không cho đăng nhập
                    localStorage.removeItem('currentUser');
                    localStorage.removeItem('googleUser');
                    this.currentUser = null;
                    this.updateNavbarForGuest();
                    // Tự động redirect về trang đăng nhập sau 3 giây
                    setTimeout(() => {
                        window.location.replace(this.contextPath + '/login.jsp?banned=1');
                    }, 3000);
                    return Promise.reject('Banned user');
                }
                if (data.isLoggedIn) {
                    console.log('✅ Server session found:', data);
                    // Convert server data to client format
                    this.currentUser = {
                        id: data.email, // Use email as ID for chat system
                        fullName: data.name,
                        name: data.name,
                        email: data.email,
                        role: data.role,
                        picture: data.picture,
                        avatarUrl: data.picture,
                        loginType: data.loginType || 'server'
                    };
                    // Also save to localStorage for consistency
                    localStorage.setItem('currentUser', JSON.stringify(this.currentUser));
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
        
        // Nếu có bất kỳ user nào trong localStorage, luôn kiểm tra trạng thái ban với server
        if (storedUser || googleUser) {
            let userObj = null;
            try {
                userObj = storedUser ? JSON.parse(storedUser) : JSON.parse(googleUser);
                this.currentUser = userObj;
            } catch (e) {
                localStorage.removeItem('currentUser');
                localStorage.removeItem('googleUser');
                this.currentUser = null;
            }
            // Luôn gọi lại API để kiểm tra trạng thái ban
            fetch(`${this.contextPath}/oauth2/user-info`, {
                method: 'GET',
                credentials: 'include',
                headers: { 'Accept': 'application/json' }
            }).then(async (response) => {
                if (response.ok) {
                    const data = await response.json();
                    if (data.success === false && data.banReason) {
                        document.querySelectorAll('.ban-reason-box').forEach(e => e.remove());
                        const banBox = document.createElement('div');
                        banBox.className = 'ban-reason-box';
                        banBox.style.position = 'fixed';
                        banBox.style.bottom = '32px';
                        banBox.style.right = '32px';
                        banBox.style.zIndex = '9999';
                        banBox.style.background = '#fff0f0';
                        banBox.style.border = '2px solid #d9534f';
                        banBox.style.color = '#d9534f';
                        banBox.style.padding = '20px 28px';
                        banBox.style.borderRadius = '12px';
                        banBox.style.maxWidth = '360px';
                        banBox.style.boxShadow = '0 4px 16px rgba(0,0,0,0.12)';
                        banBox.style.textAlign = 'center';
                        banBox.style.fontFamily = 'inherit';
                        banBox.innerHTML = `
                          <div style='font-size:32px;margin-bottom:8px;'>⚠️</div>
                          <h3 style='margin:0 0 8px 0;font-size:22px;'>Tài khoản của bạn đã bị cấm</h3>
                          <div style='font-size:16px;margin-bottom:8px;'><b>Lý do:</b> <span>${data.banReason}</span></div>
                          <div style='font-size:14px;margin-bottom:8px;'>Bạn sẽ được chuyển về trang đăng nhập sau vài giây...</div>
                          <button onclick="this.parentElement.remove()" style="margin-top:8px;padding:6px 18px;border:none;background:#d9534f;color:#fff;border-radius:5px;cursor:pointer;font-size:15px;">Đóng</button>
                        `;
                        document.body.appendChild(banBox);
                        // Gọi luôn handleLogout để xóa sạch session phía client và server
                        if (typeof this.handleLogout === 'function') {
                            this.handleLogout();
                        } else if (window.unifiedNavbarManager && typeof window.unifiedNavbarManager.handleLogout === 'function') {
                            window.unifiedNavbarManager.handleLogout();
                        }
                        setTimeout(() => {
                            window.location.replace(this.contextPath + '/login.jsp?banned=1');
                        }, 3000);
                        return;
                    }
                    // Nếu không bị ban thì cho đăng nhập bình thường
                    localStorage.setItem('currentUser', JSON.stringify(this.currentUser));
                    console.log('✅ User found:', this.currentUser);
                    this.updateNavbarForLoggedInUser();
                    return;
                }
            }).catch((e) => {
                console.error('❌ Error checking user ban status:', e);
                localStorage.removeItem('googleUser');
                localStorage.removeItem('currentUser');
            });
            return;
        }

        // No user found
        console.log('👤 No authenticated user found');
        this.updateNavbarForGuest();
    }

    updateNavbarForLoggedInUser() {
        console.log('🔄 Updating navbar for logged in user');
        
        // Set session storage for chat widget
        if (this.currentUser) {
            // Use email as userId for chat system to match backend logic
            const userId = this.currentUser.email || this.currentUser.id || this.currentUser.customerId || '1';
            sessionStorage.setItem('userId', userId);
            sessionStorage.setItem('userType', 'CUSTOMER');
            sessionStorage.setItem('userName', this.currentUser.name || this.currentUser.fullName || 'User');
            console.log('✅ Session storage set:', {
                userId: userId,
                userType: 'CUSTOMER',
                userName: this.currentUser.name || this.currentUser.fullName
            });
        }
        
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
            <span class="account-text d-none d-md-inline">${displayName}</span>
            <span class="d-md-none">
                <i class="fas fa-user"></i>
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
            <li><a class="dropdown-item" href="${this.contextPath}/order-history.jsp">
                <i class="fas fa-shopping-bag me-2"></i>Đơn hàng của tôi
            </a></li>
            <li><a class="dropdown-item" href="${this.contextPath}/favorites.jsp">
                <i class="fas fa-heart me-2"></i>Sản phẩm yêu thích
            </a></li>
            <li><a class="dropdown-item" href="#" data-action="openChat">
                <i class="fas fa-comments me-2"></i>Chat hỗ trợ
                <span id="navbar-chat-badge" class="badge bg-danger ms-1" style="display: none;">0</span>
            </a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="#" id="unifiedLogoutBtn">
                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
            </a></li>
        `;
        
        // Show/hide work dashboard button based on user role
        this.updateWorkDashboardButton();
        this.updateCartCountFromAPI();
        
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
        
        // Hide work dashboard button for guests
        this.hideWorkDashboardButton();
        this.updateCartCountFromAPI();
        
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
        
        // If user already has picture/avatar URL, use it
        if (this.currentUser.picture || this.currentUser.avatar || this.currentUser.avatarUrl) {
            return this.currentUser.picture || this.currentUser.avatar || this.currentUser.avatarUrl;
        }
        
        // For email users, generate Gravatar
        if (this.currentUser.email) {
            if (window.md5) {
                const emailHash = window.md5(this.currentUser.email.trim().toLowerCase());
                return `https://www.gravatar.com/avatar/${emailHash}?s=200&d=identicon`;
            }
            
            // Fallback to initials avatar
            const fullName = this.currentUser.fullName || this.currentUser.name || this.currentUser.email.split('@')[0];
            return `https://ui-avatars.com/api/?name=${encodeURIComponent(fullName)}&size=200&background=0d6efd&color=ffffff&bold=true`;
        }
        
        // Ultimate fallback
        return `${this.contextPath}/img/placeholder.jpg`;
    }

    async handleLogout() {
        console.log('🚪 Handling logout...');
        
        try {
            // First, call server logout to invalidate session
            console.log('🌐 Calling server logout...');
            
            try {
                const response = await fetch(`${this.contextPath}/oauth2/logout`, {
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
            
            // Clear ALL client-side user data
            console.log('🧹 Clearing ALL client-side data...');
            localStorage.clear(); // Clear everything
            sessionStorage.clear(); // Clear session storage too
            
            // Remove specific items to be extra sure
            localStorage.removeItem('currentUser');
            localStorage.removeItem('googleUser');
            localStorage.removeItem('userRole');
            localStorage.removeItem('justLoggedIn');
            localStorage.removeItem('userName');
            localStorage.removeItem('userEmail');
            localStorage.removeItem('userPicture');
            localStorage.removeItem('userLoggedIn');
            
            sessionStorage.removeItem('userId');
            sessionStorage.removeItem('userType');
            sessionStorage.removeItem('userName');
            
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
            
            // Force redirect to home page with cache busting and immediate reload
            console.log('🏠 Redirecting to home page with force reload...');
            
            // Add a small delay to ensure all cleanup is done
            setTimeout(() => {
                // Use replace instead of href to prevent back button issues
                window.location.replace(this.contextPath + '/?logout=1&t=' + Date.now());
            }, 100);
            
        } catch (error) {
            console.error('❌ Error during logout:', error);
            
            // Even if there's an error, still try to clean up and redirect
            this.currentUser = null;
            localStorage.clear();
            sessionStorage.clear();
            this.updateNavbarForGuest();
            
            // Force redirect even on error
            setTimeout(() => {
                window.location.replace(this.contextPath + '/?logout=1&error=1&t=' + Date.now());
            }, 100);
        }
    }

    // Public method to manually refresh navbar state
    refreshNavbar() {
        console.log('🔄 Manual navbar refresh requested');
        this.checkAuthState();
        
        // Also force avatar refresh after a delay
        setTimeout(() => {
            if (this.currentUser) {
                console.log('🖼️ Force refreshing avatar for user:', this.currentUser);
                const avatarUrl = this.getUserAvatarUrl();
                console.log('🖼️ Generated avatar URL:', avatarUrl);
                this.updateNavbarForLoggedInUser();
            }
        }, 500);
    }

    // Public method to get current user
    getCurrentUser() {
        return this.currentUser;
    }
    
    // Debug method
    debugAuthState() {
        console.log('🔍 UNIFIED NAVBAR DEBUG STATE:');
        console.log('- Current User:', this.currentUser);
        console.log('- localStorage.currentUser:', localStorage.getItem('currentUser'));
        console.log('- localStorage.googleUser:', localStorage.getItem('googleUser'));
        console.log('- localStorage.userLoggedIn:', localStorage.getItem('userLoggedIn'));
        console.log('- Context Path:', this.contextPath);
        
        // Test server endpoint
        fetch(`${this.contextPath}/oauth2/user-info`, {
            method: 'GET',
            credentials: 'include',
            headers: { 'Accept': 'application/json' }
        })
        .then(response => response.json())
        .then(data => {
            console.log('- Server Response:', data);
        })
        .catch(error => {
            console.log('- Server Error:', error);
        });
    }

    // Thêm hàm mới cập nhật số lượng giỏ hàng từ API
    updateCartCountFromAPI() {
        const cartCountElem = document.querySelector('.cart-count');
        if (!cartCountElem) return;
        fetch(`${this.contextPath}/api/cart`, {
            method: 'GET',
            credentials: 'include',
            headers: { 'Accept': 'application/json' }
        })
        .then(res => {
            if (!res.ok) throw new Error('Not logged in or error');
            return res.json();
        })
        .then(data => {
            if (data && Array.isArray(data.cartItems)) {
                cartCountElem.textContent = data.cartItems.length;
            } else {
                cartCountElem.textContent = '0';
            }
        })
        .catch(() => {
            cartCountElem.textContent = '0';
        });
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

// Khởi tạo global để script luôn chạy
window.unifiedNavbarManager = new UnifiedNavbarManager();

// Make it globally available
window.UnifiedNavbarManager = UnifiedNavbarManager;
window.unifiedNavbarManager = unifiedNavbarManager;

// Legacy support - redirect old function calls
window.userLogout = function() {
    if (unifiedNavbarManager) {
        unifiedNavbarManager.handleLogout();
    }
};

// Global openChatWidget function for dropdown menu
window.openChatWidget = function() {
    console.log('🔗 openChatWidget called from dropdown menu');
    console.log('📊 Current sessionStorage:', {
        userId: sessionStorage.getItem('userId'),
        userType: sessionStorage.getItem('userType'),
        userName: sessionStorage.getItem('userName')
    });
    
    const userId = sessionStorage.getItem('userId');
    const userType = sessionStorage.getItem('userType');
    
    console.log('Auth check - userId:', userId, 'userType:', userType);
    
    if (!userId || userType !== 'CUSTOMER') {
        console.log('❌ Auth failed - userId:', userId, 'userType:', userType);
        alert('Vui lòng đăng nhập để sử dụng chat hỗ trợ!');
        return false; // Prevent navigation
    }
    
    // Check if we're on index.jsp
    const currentPath = window.location.pathname;
    if (!currentPath.includes('index.jsp') && currentPath !== '/') {
        console.log('🔄 Redirecting to index.jsp to access chat widget...');
        window.location.href = window.contextPath + '/index.jsp#chat';
        return false;
    }
    
    // Directly call toggleChatWidget function
    if (typeof toggleChatWidget === 'function') {
        console.log('✅ Calling toggleChatWidget function...');
        toggleChatWidget();
    } else {
        console.log('❌ toggleChatWidget function not found');
        alert('Chat widget không khả dụng. Vui lòng refresh trang!');
    }
    
    return false; // Prevent navigation
};

// Function to update work dashboard button based on user role
UnifiedNavbarManager.prototype.updateWorkDashboardButton = function() {
    const workDashboardBtn = document.getElementById('workDashboardBtn');
    const workDashboardLink = document.getElementById('workDashboardLink');
    
    if (!workDashboardBtn || !workDashboardLink) {
        console.log('⚠️ Work dashboard button elements not found');
        return;
    }
    
    // Check if user has staff/admin/shipper role
    const userRole = this.currentUser?.role;
    const workRoles = ['STAFF', 'ADMIN', 'SHIPPER'];
    
    if (userRole && workRoles.includes(userRole.toUpperCase())) {
        console.log('✅ Showing work dashboard button for role:', userRole);
        
        // Show the button
        workDashboardBtn.style.display = 'block';
        
        // Set the appropriate link based on role
        let workUrl = '';
        let buttonText = '';
        let buttonIcon = '';
        
        switch (userRole.toUpperCase()) {
            case 'STAFF':
                workUrl = this.contextPath + '/staffsc.jsp';
                buttonText = 'Trang Staff';
                buttonIcon = 'fas fa-user-tie';
                break;
            case 'ADMIN':
                workUrl = this.contextPath + '/dashboard.jsp';
                buttonText = 'Trang Admin';
                buttonIcon = 'fas fa-user-shield';
                break;
            case 'SHIPPER':
                workUrl = this.contextPath + '/shippersc.jsp';
                buttonText = 'Trang Shipper';
                buttonIcon = 'fas fa-truck';
                break;
            default:
                workUrl = this.contextPath + '/dashboard.jsp';
                buttonText = 'Trang làm việc';
                buttonIcon = 'fas fa-briefcase';
        }
        
        // Update link and button content
        workDashboardLink.href = workUrl;
        workDashboardLink.innerHTML = `
            <i class="${buttonIcon} me-1"></i>
            <span class="d-none d-lg-inline">${buttonText}</span>
        `;
        
        // Update button color based on role
        workDashboardLink.className = userRole.toUpperCase() === 'ADMIN' ? 
            'btn btn-danger' : 
            userRole.toUpperCase() === 'STAFF' ? 
                'btn btn-success' : 
                'btn btn-info';
        
        console.log(`✅ Work dashboard button configured: ${buttonText} -> ${workUrl}`);
    } else {
        // Hide the button for regular customers
        workDashboardBtn.style.display = 'none';
        console.log('ℹ️ Work dashboard button hidden for role:', userRole);
    }
};

// Debug function to test avatar generation
window.debugAvatarGeneration = function(email, name) {
    console.log('🔍 Debug Avatar Generation:');
    console.log('Email:', email);
    console.log('Name:', name);
    
    if (window.md5) {
        const emailHash = window.md5(email.trim().toLowerCase());
        const gravatarUrl = `https://www.gravatar.com/avatar/${emailHash}?s=200&d=identicon`;
        console.log('Gravatar URL:', gravatarUrl);
        
        // Test if gravatar exists
        const img = new Image();
        img.onload = () => console.log('✅ Gravatar loaded successfully');
        img.onerror = () => console.log('❌ Gravatar failed to load');
        img.src = gravatarUrl;
    }
    
    const initialsUrl = `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&size=200&background=0d6efd&color=ffffff&bold=true`;
    console.log('Initials Avatar URL:', initialsUrl);
};

// Function to hide work dashboard button (called when user logs out)
UnifiedNavbarManager.prototype.hideWorkDashboardButton = function() {
    const workDashboardBtn = document.getElementById('workDashboardBtn');
    if (workDashboardBtn) {
        workDashboardBtn.style.display = 'none';
        console.log('✅ Work dashboard button hidden');
    }
};

console.log('📦 Unified Navbar Manager script loaded');
