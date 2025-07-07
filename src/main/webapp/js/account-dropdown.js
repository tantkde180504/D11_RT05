// Account Dropdown Management - Fixed Version

document.addEventListener('DOMContentLoaded', function() {
    console.log('Account dropdown script loaded');
    
    // Debounce function để tránh spam
    function debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    // Improved login status check
    const checkUserLoginStatus = debounce(function() {
        console.log('Checking user login status...');
        try {
            const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
            const userName = localStorage.getItem('userName') || 'User';
            
            console.log('Login status:', { isLoggedIn, userName });
            
            if (isLoggedIn) {
                showUserMenu(userName);
            } else {
                showGuestMenu();
            }
        } catch (error) {
            console.error('Error checking login status:', error);
            showGuestMenu(); // Fallback to guest menu
        }
    }, 100);

    // Initial check
    checkUserLoginStatus();
    
    // Listen for user login events
    window.addEventListener('userLoggedIn', function(event) {
        console.log('User logged in event received:', event.detail);
        const userData = event.detail;
        if (userData && userData.fullName) {
            showUserMenu(userData.fullName);
        }
    });
    
    // Listen for user logout events
    window.addEventListener('userLoggedOut', function() {
        console.log('User logged out event received');
        showGuestMenu();
    });
    
    // Show menu for logged-in users - Fixed
    function showUserMenu(userName) {
        try {
            console.log('Showing user menu for:', userName);
            
            // Find elements
            const navLoginBtn = document.getElementById('nav-login-btn');
            const navUserInfo = document.getElementById('nav-user-info');
            
            console.log('Elements found:', { navLoginBtn, navUserInfo });
            
            // Hide guest menu
            if (navLoginBtn) {
                navLoginBtn.classList.add('d-none');
                navLoginBtn.style.display = 'none';
                console.log('Guest menu hidden');
            }
            
            // Show user menu
            if (navUserInfo) {
                navUserInfo.classList.remove('d-none');
                navUserInfo.style.display = 'block';
                
                // Update user name in display
                const userDisplayName = document.getElementById('userDisplayName');
                const userFullName = document.getElementById('userFullName');
                
                if (userDisplayName) {
                    // Hiển thị tên ngắn gọn (first name)
                    const firstName = userName.split(' ')[0];
                    userDisplayName.textContent = firstName;
                    console.log('Updated display name:', firstName);
                }
                
                if (userFullName) {
                    userFullName.textContent = userName;
                    console.log('Updated full name:', userName);
                }
                
                console.log('User menu shown successfully');
            } else {
                console.error('nav-user-info element not found');
            }
        } catch (error) {
            console.error('Error showing user menu:', error);
        }
    }

    // Show menu for guests - Fixed
    function showGuestMenu() {
        try {
            console.log('Showing guest menu');
            
            // Find elements
            const navLoginBtn = document.getElementById('nav-login-btn');
            const navUserInfo = document.getElementById('nav-user-info');
            
            console.log('Elements found:', { navLoginBtn, navUserInfo });
            
            // Show guest menu
            if (navLoginBtn) {
                navLoginBtn.classList.remove('d-none');
                navLoginBtn.style.display = 'block';
                console.log('Guest menu shown');
            } else {
                console.error('nav-login-btn element not found');
            }
            
            // Hide user menu
            if (navUserInfo) {
                navUserInfo.classList.add('d-none');
                navUserInfo.style.display = 'none';
                console.log('User menu hidden');
            }
            
            console.log('Guest menu shown successfully');
        } catch (error) {
            console.error('Error showing guest menu:', error);
        }
    }
    
    // Make functions globally available
    window.showUserMenu = showUserMenu;
    window.showGuestMenu = showGuestMenu;
    window.checkUserLoginStatus = checkUserLoginStatus;
});

// User logout function - Improved version
function userLogout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        try {
            // Show loading state
            const logoutBtn = document.querySelector('[onclick="userLogout()"]');
            if (logoutBtn) {
                logoutBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng xuất...';
                logoutBtn.disabled = true;
            }

            // Gọi API logout của Spring Security OAuth2
            fetch('/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                credentials: 'same-origin' // Include cookies
            }).then(response => {
                // Clear user session data regardless of response
                localStorage.clear();
                sessionStorage.clear();
                
                // Clear any stored tokens
                document.cookie.split(";").forEach(function(c) { 
                    document.cookie = c.replace(/^ +/, "").replace(/=.*/, "=;expires=" + new Date().toUTCString() + ";path=/"); 
                });
                
                // Trigger logout event
                const logoutEvent = new CustomEvent('userLoggedOut');
                window.dispatchEvent(logoutEvent);
                
                // Show success message
                showNotification('Đăng xuất thành công!', 'success');
                
                // Redirect to home page
                setTimeout(() => {
                    window.location.href = '/';
                }, 1000);
            }).catch(error => {
                console.error('Logout error:', error);
                
                // Clear data anyway and redirect
                localStorage.clear();
                sessionStorage.clear();
                
                // Trigger logout event
                const logoutEvent = new CustomEvent('userLoggedOut');
                window.dispatchEvent(logoutEvent);
                
                showNotification('Đã đăng xuất', 'info');
                
                setTimeout(() => {
                    window.location.href = '/';
                }, 1000);
            });
        } catch (error) {
            console.error('Logout error:', error);
            // Fallback: clear data and redirect
            localStorage.clear();
            sessionStorage.clear();
            window.location.href = '/';
        }
    }
}

// Global logout function để sử dụng từ mọi nơi
function logoutUser() {
    userLogout();
}

// Improved notification function
function showNotification(message, type = 'info') {
    try {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.notification-popup');
        existingNotifications.forEach(notification => notification.remove());
        
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} notification-popup`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            max-width: 500px;
            animation: slideInRight 0.3s ease-out;
        `;
        
        notification.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'} me-2"></i>
            ${message}
            <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
        `;
        
        // Add CSS for animation
        if (!document.querySelector('#notification-styles')) {
            const style = document.createElement('style');
            style.id = 'notification-styles';
            style.textContent = `
                @keyframes slideInRight {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                .notification-popup {
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                    border-radius: 8px;
                }
            `;
            document.head.appendChild(style);
        }
        
        // Add to page
        document.body.appendChild(notification);
        
        // Auto remove after 4 seconds
        setTimeout(() => {
            if (notification && notification.parentNode) {
                notification.style.animation = 'slideOutRight 0.3s ease-out';
                setTimeout(() => notification.remove(), 300);
            }
        }, 4000);
    } catch (error) {
        console.error('Error showing notification:', error);
    }
}

// Improved user login function
function setUserLoggedIn(userName, email) {
    try {
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', userName);
        localStorage.setItem('userEmail', email);
        
        // Update dropdown
        showUserMenu(userName);
        
        showNotification(`Xin chào ${userName}! Đăng nhập thành công.`, 'success');
    } catch (error) {
        console.error('Error setting user logged in:', error);
        showNotification('Đăng nhập thành công!', 'success');
    }
}
