// Google OAuth Handler
class GoogleOAuthHandler {
    constructor() {
        this.init();
    }

    init() {
        // Kiểm tra trạng thái đăng nhập khi trang load
        this.checkLoginStatus();
        
        // Bind events
        this.bindEvents();
    }

    bindEvents() {
        // Google Sign In button
        const googleSignInBtn = document.getElementById('google-sign-in-btn');
        if (googleSignInBtn) {
            googleSignInBtn.addEventListener('click', () => {
                this.signInWithGoogle();
            });
        }

        // Logout button
        const logoutBtn = document.getElementById('logout-btn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => {
                this.logout();
            });
        }
    }

    signInWithGoogle() {
        console.log('Redirecting to Google OAuth...');
        // Chuyển hướng đến Spring Security OAuth2 endpoint
        window.location.href = '/oauth2/authorization/google';
    }    async checkLoginStatus() {
        try {
            console.log('Fetching from /oauth2/user-info...');
            const response = await fetch('/oauth2/user-info', {
                method: 'GET',
                credentials: 'same-origin',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });

            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (response.ok) {
                const contentType = response.headers.get('content-type');
                console.log('Content-Type:', contentType);
                
                if (contentType && contentType.includes('application/json')) {
                    const data = await response.json();
                    console.log('Login status:', data);
                    
                    if (data.isLoggedIn) {
                        this.handleLoginSuccess(data);
                    } else {
                        this.handleNotLoggedIn();
                    }
                } else {
                    console.error('Response is not JSON. Content-Type:', contentType);
                    const text = await response.text();
                    console.error('Response text:', text.substring(0, 200) + '...');
                    this.handleNotLoggedIn();
                }
            } else {
                console.error('HTTP error:', response.status, response.statusText);
                this.handleNotLoggedIn();
            }
        } catch (error) {
            console.error('Error checking login status:', error);
            this.handleNotLoggedIn();
        }
    }

    async getUserInfo() {
        try {
            const response = await fetch('/oauth2/user-info', {
                method: 'GET',
                credentials: 'same-origin'
            });

            if (response.ok) {
                const data = await response.json();
                console.log('User info:', data);
                return data;
            }
        } catch (error) {
            console.error('Error getting user info:', error);
        }
        return null;
    }    handleLoginSuccess(userData) {
        console.log('User logged in:', userData);
        
        // Cập nhật UI
        this.updateUIForLoggedInUser(userData);
        
        // Hiển thị thông báo chào mừng trên trang chủ
        if (window.location.pathname === '/' || window.location.pathname === '/index.jsp') {
            this.showWelcomeNotification(userData);
        }
          // Redirect nếu đang ở trang login
        if (window.location.pathname.includes('login')) {
            window.location.href = '/';
        }
    }

    handleNotLoggedIn() {
        console.log('User not logged in');
        this.updateUIForLoggedOutUser();
    }

    updateUIForLoggedInUser(userData) {
        // Ẩn form đăng nhập
        const loginForm = document.getElementById('login-form');
        if (loginForm) {
            loginForm.style.display = 'none';
        }

        // Hiển thị thông tin user
        const userInfo = document.getElementById('user-info');
        if (userInfo) {
            userInfo.innerHTML = `
                <div class="user-profile">
                    <img src="${userData.picture || '/img/default-avatar.png'}" alt="Profile" class="user-avatar">
                    <div class="user-details">
                        <p><strong>${userData.name}</strong></p>
                        <p>${userData.email}</p>
                        <p><small>Đăng nhập bằng ${userData.loginType}</small></p>
                    </div>
                    <button id="logout-btn" class="btn btn-secondary">Đăng xuất</button>
                </div>
            `;
            userInfo.style.display = 'block';
            
            // Re-bind logout event
            const logoutBtn = document.getElementById('logout-btn');
            if (logoutBtn) {
                logoutBtn.addEventListener('click', () => {
                    this.logout();
                });
            }
        }

        // Cập nhật navbar nếu có
        this.updateNavbar(userData);
    }

    updateUIForLoggedOutUser() {
        // Hiển thị form đăng nhập
        const loginForm = document.getElementById('login-form');
        if (loginForm) {
            loginForm.style.display = 'block';
        }

        // Ẩn thông tin user
        const userInfo = document.getElementById('user-info');
        if (userInfo) {
            userInfo.style.display = 'none';
        }

        // Cập nhật navbar
        this.updateNavbar(null);
    }    updateNavbar(userData) {
        console.log('=== UPDATE UNIFIED NAVBAR ===');
        
        if (userData) {
            console.log('Updating unified navbar for logged in user:', userData);
            
            // Store Google user data
            localStorage.setItem('googleUser', JSON.stringify(userData));
            localStorage.setItem('userRole', userData.role || 'CUSTOMER');
            
            // Dispatch login event for unified navbar
            window.dispatchEvent(new CustomEvent('userLoggedIn', {
                detail: {
                    fullName: userData.name,
                    email: userData.email,
                    role: userData.role || 'CUSTOMER',
                    avatarUrl: userData.picture || '',
                    googleId: userData.sub
                }
            }));
            
            // Notify unified navbar manager directly
            if (window.unifiedNavbarManager) {
                console.log('Notifying unified navbar manager for Google user...');
                window.unifiedNavbarManager.currentUser = {
                    fullName: userData.name,
                    email: userData.email,
                    role: userData.role || 'CUSTOMER',
                    avatarUrl: userData.picture || '',
                    googleId: userData.sub
                };
                window.unifiedNavbarManager.updateNavbarForLoggedInUser();
            }
            
        } else {
            console.log('Updating unified navbar for logged out user');
            
            // Clear Google user data
            localStorage.removeItem('googleUser');
            localStorage.removeItem('userRole');
            
            // Dispatch logout event
            window.dispatchEvent(new CustomEvent('userLoggedOut'));
            
            // Notify unified navbar manager
            if (window.unifiedNavbarManager) {
                window.unifiedNavbarManager.currentUser = null;
                window.unifiedNavbarManager.updateNavbarForGuest();
            }
        }
    }

    async logout() {
        try {
            const response = await fetch('/oauth2/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                credentials: 'same-origin'
            });

            if (response.ok) {
                console.log('Logged out successfully');
                // Redirect về trang chủ
                window.location.href = '/';
            }
        } catch (error) {
            console.error('Error during logout:', error);
        }
    }    // Utility method to show notifications
    showNotification(message, type = 'info') {
        // Tạo notification element
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show`;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(notification);

        // Tự động ẩn sau 5 giây
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 5000);
    }

    showWelcomeNotification(userData) {
        // Use popup instead of notification banner
        if (window.loginPopupManager) {
            console.log('✅ Showing OAuth login success popup for:', userData.name);
            window.loginPopupManager.showSuccessPopup(userData);
        } else {
            console.warn('⚠️ Login popup manager not available for OAuth, falling back to notification');
            
            // Fallback to original notification
            const notification = document.getElementById('oauth-success-notification');
            const welcomeMessage = document.getElementById('welcome-message');
            
            if (notification && welcomeMessage) {
                welcomeMessage.textContent = `Chào mừng ${userData.name} quay trở lại! Bạn đã đăng nhập thành công bằng Google.`;
                notification.style.display = 'block';
                notification.classList.add('show');
                
                // Tự động ẩn sau 8 giây
                setTimeout(() => {
                    notification.classList.remove('show');
                    setTimeout(() => {
                        notification.style.display = 'none';
                    }, 500);
                }, 8000);
            }
        }
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    window.googleOAuthHandler = new GoogleOAuthHandler();
});

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = GoogleOAuthHandler;
}
