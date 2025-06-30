// Logout function - Common script for all pages
function logout() {
    if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        // Xóa thông tin đăng nhập khỏi localStorage
        localStorage.removeItem('userName');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userEmail');
        
        // Hiển thị thông báo đăng xuất
        alert('Đã đăng xuất thành công!');
        
        // Chuyển về trang chủ
        window.location.href = '/';
    }
}

// Check if user is logged in
function checkLoginStatus() {
    const userName = localStorage.getItem('userName');
    const userRole = localStorage.getItem('userRole');
    
    return {
        isLoggedIn: !!(userName && userRole),
        userName: userName,
        userRole: userRole
    };
}

// Redirect if not authorized for current page
function checkPageAccess(requiredRole) {
    const status = checkLoginStatus();
    
    if (!status.isLoggedIn) {
        alert('Vui lòng đăng nhập để truy cập trang này!');
        window.location.href = '/login.jsp';
        return false;
    }
    
    if (requiredRole && status.userRole !== requiredRole.toUpperCase()) {
        alert('Bạn không có quyền truy cập trang này!');
        window.location.href = '/';
        return false;
    }
    
    return true;
}

// Display user info on page load
function displayUserInfo() {
    const status = checkLoginStatus();
    
    if (status.isLoggedIn) {
        // Update any user display elements
        const userNameElements = document.querySelectorAll('.user-name, .username');
        const userRoleElements = document.querySelectorAll('.user-role');
        
        userNameElements.forEach(element => {
            element.textContent = status.userName;
        });
        
        userRoleElements.forEach(element => {
            element.textContent = getRoleDisplayName(status.userRole);
        });
    }
}

// Get role display name in Vietnamese
function getRoleDisplayName(role) {
    switch(role ? role.toUpperCase() : '') {
        case 'ADMIN':
            return 'Quản trị viên';
        case 'STAFF':
            return 'Nhân viên';
        case 'CUSTOMER':
            return 'Khách hàng';
        default:
            return 'Người dùng';
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    displayUserInfo();
});
