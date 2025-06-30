// Account Dropdown Management

document.addEventListener('DOMContentLoaded', function() {
    checkUserLoginStatus();
    
    // Update dropdown based on login status
    function checkUserLoginStatus() {
        // Check if user is logged in (you can modify this based on your session management)
        const isLoggedIn = localStorage.getItem('userLoggedIn') === 'true';
        const userName = localStorage.getItem('userName') || 'User';
        
        if (isLoggedIn) {
            showUserMenu(userName);
        } else {
            showGuestMenu();
        }
    }
    
    // Show menu for logged-in users
    function showUserMenu(userName) {
        // Hide guest elements
        document.getElementById('guestLoginOption').style.display = 'none';
        
        // Show user elements
        document.getElementById('userMenu').style.display = 'block';
        document.getElementById('userDivider').style.display = 'block';
        document.getElementById('userAccountOption').style.display = 'block';
        document.getElementById('userOrdersOption').style.display = 'block';
        document.getElementById('userLogoutOption').style.display = 'block';
        
        // Update user name
        document.getElementById('userName').textContent = userName;
        document.getElementById('accountText').textContent = userName;
    }
    
    // Show menu for guests
    function showGuestMenu() {
        // Show guest elements (only login option)
        document.getElementById('guestLoginOption').style.display = 'block';
        
        // Hide user elements
        document.getElementById('userMenu').style.display = 'none';
        document.getElementById('userDivider').style.display = 'none';
        document.getElementById('userAccountOption').style.display = 'none';
        document.getElementById('userOrdersOption').style.display = 'none';
        document.getElementById('userLogoutOption').style.display = 'none';
        
        // Reset account text
        document.getElementById('accountText').textContent = 'Tài khoản';
    }
    
    // Make functions globally available
    window.showUserMenu = showUserMenu;
    window.showGuestMenu = showGuestMenu;
    window.checkUserLoginStatus = checkUserLoginStatus;
});

// User logout function - cập nhật để hỗ trợ OAuth2
function userLogout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        // Gọi API logout của Spring Security OAuth2
        fetch('/logout', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        }).then(() => {
            // Clear user session data
            localStorage.clear();
            sessionStorage.clear();
            
            // Show success message
            showNotification('Đăng xuất thành công!', 'success');
            
            // Redirect to home page
            setTimeout(() => {
                window.location.href = '/';
            }, 1000);
        }).catch(error => {
            console.error('Logout error:', error);
            // Fallback: redirect về trang chủ dù có lỗi
            window.location.href = '/';
        });
    }
}

// Global logout function để sử dụng từ mọi nơi
function logoutUser() {
    userLogout();
}

// Notification function
function showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} notification-popup`;
    notification.innerHTML = `
        <i class="fas fa-info-circle me-2"></i>
        ${message}
        <button type="button" class="btn-close" onclick="this.parentElement.remove()"></button>
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Auto remove after 3 seconds
    setTimeout(() => {
        if (notification && notification.parentNode) {
            notification.remove();
        }
    }, 3000);
}

// Function to simulate user login (call this after successful login)
function setUserLoggedIn(userName, email) {
    localStorage.setItem('userLoggedIn', 'true');
    localStorage.setItem('userName', userName);
    localStorage.setItem('userEmail', email);
    
    // Update dropdown
    showUserMenu(userName);
    
    showNotification(`Xin chào ${userName}! Đăng nhập thành công.`, 'success');
}
