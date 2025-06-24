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
        console.log('=== UPDATE NAVBAR ===');
        const navUserInfo = document.getElementById('nav-user-info');
        const navLoginBtn = document.getElementById('nav-login-btn');
        const defaultNavItems = document.getElementById('default-nav-items');
        const isAdminPage = document.querySelector('.admin-header') !== null;

        console.log('navUserInfo element:', navUserInfo);
        console.log('navLoginBtn element:', navLoginBtn);
        console.log('userData:', userData);

        if (userData) {            if (navUserInfo) {
                console.log('Updating navUserInfo with userData:', userData);
                if (isAdminPage) {
                    // Admin panel styling
                    navUserInfo.innerHTML = `
                        <div class="dropdown">
                            <a class="nav-link dropdown-toggle admin-nav-link d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="${userData.picture || '/img/default-avatar.png'}" alt="Profile" class="nav-user-avatar me-2">
                                <span>Xin chào, ${userData.name.split(' ')[0]}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <div class="dropdown-item-text">
                                        <div class="d-flex align-items-center">
                                            <img src="${userData.picture || '/img/default-avatar.png'}" alt="Profile" class="rounded-circle me-2" width="40" height="40">
                                            <div>
                                                <div class="fw-bold">${userData.name}</div>
                                                <small class="text-muted">${userData.email}</small>
                                                <small class="text-success d-block">Role: ${userData.role || 'CUSTOMER'}</small>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/"><i class="fas fa-home me-2"></i>Về trang chủ</a></li>
                                <li><a class="dropdown-item" href="/profile.jsp"><i class="fas fa-user me-2"></i>Hồ sơ khách hàng</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" id="nav-logout-btn"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    `;
                    // Hide default nav items in admin panel when OAuth user is logged in
                    if (defaultNavItems) {
                        defaultNavItems.style.display = 'none';
                    }
                } else {
                    // Regular site styling
                    navUserInfo.innerHTML = `
                        <div class="dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="${userData.picture || '/img/default-avatar.png'}" alt="Profile" class="nav-user-avatar me-2">
                                <span>Xin chào, ${userData.name.split(' ')[0]}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <div class="dropdown-item-text">
                                        <div class="d-flex align-items-center">
                                            <img src="${userData.picture || '/img/default-avatar.png'}" alt="Profile" class="rounded-circle me-2" width="40" height="40">
                                            <div>
                                                <div class="fw-bold">${userData.name}</div>
                                                <small class="text-muted">${userData.email}</small>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/profile.jsp"><i class="fas fa-user me-2"></i>Hồ sơ khách hàng</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" id="nav-logout-btn"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                            </ul>
                        </div>
                    `;                }
                navUserInfo.style.display = 'block';
                console.log('navUserInfo display set to block');

                // Bind logout event for navbar
                const navLogoutBtn = document.getElementById('nav-logout-btn');
                if (navLogoutBtn) {
                    navLogoutBtn.addEventListener('click', (e) => {
                        e.preventDefault();
                        this.logout();
                    });
                }
            }            if (navLoginBtn) {
                navLoginBtn.style.display = 'none';
                console.log('navLoginBtn hidden');
            }
        } else {
            console.log('No userData, showing login button');
            if (navUserInfo) {
                navUserInfo.style.display = 'none';
                console.log('navUserInfo hidden');
            }
            if (navLoginBtn) {
                navLoginBtn.style.display = 'block';
                console.log('navLoginBtn shown');
            }
            if (defaultNavItems && isAdminPage) {
                defaultNavItems.style.display = 'flex';
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

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    window.googleOAuthHandler = new GoogleOAuthHandler();
});

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = GoogleOAuthHandler;
}
