// Debug Script - Check Login Status and Authentication Flow
console.log('=== LOGIN DEBUG SCRIPT ===');

// Function to check localStorage
function checkAuthState() {
    console.log('=== AUTHENTICATION STATE ===');
    console.log('userLoggedIn:', localStorage.getItem('userLoggedIn'));
    console.log('userName:', localStorage.getItem('userName'));
    console.log('userEmail:', localStorage.getItem('userEmail'));
    console.log('userRole:', localStorage.getItem('userRole'));
    console.log('userAvatar:', localStorage.getItem('userAvatar'));
    console.log('===============================');
}

// Function to check navbar state
function checkNavbarState() {
    console.log('=== NAVBAR STATE ===');
    const userInfo = document.getElementById('nav-user-info');
    const loginBtn = document.getElementById('nav-login-btn');
    
    console.log('User Info Element:', userInfo);
    console.log('User Info Display:', userInfo ? userInfo.style.display : 'not found');
    console.log('Login Button Element:', loginBtn);
    console.log('Login Button Display:', loginBtn ? loginBtn.style.display : 'not found');
    console.log('===================');
}

// Function to test API endpoint
function testLoginAPI() {
    console.log('=== TESTING LOGIN API ===');
    const contextPath = window.location.pathname.split('/')[1] || '';
    const apiUrl = contextPath ? `/${contextPath}/api/login-status` : '/api/login-status';
    
    console.log('Testing API URL:', apiUrl);
    
    fetch(apiUrl)
        .then(response => {
            console.log('API Response Status:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('API Response Data:', data);
        })
        .catch(error => {
            console.error('API Error:', error);
        });
}

// Function to clear all auth data
function clearAuthData() {
    console.log('Clearing all authentication data...');
    localStorage.removeItem('userLoggedIn');
    localStorage.removeItem('userName');
    localStorage.removeItem('userEmail');
    localStorage.removeItem('userRole');
    localStorage.removeItem('userAvatar');
    console.log('Auth data cleared!');
    
    // Force refresh navbar
    if (window.authSyncManager) {
        window.authSyncManager.forceRefresh();
    }
}

// Function to simulate login
function simulateLogin() {
    console.log('Simulating successful login...');
    localStorage.setItem('userLoggedIn', 'true');
    localStorage.setItem('userName', 'Test User');
    localStorage.setItem('userEmail', 'test@example.com');
    localStorage.setItem('userRole', 'CUSTOMER');
    localStorage.setItem('userAvatar', '');
    
    // Dispatch login event
    window.dispatchEvent(new CustomEvent('userLoggedIn', {
        detail: {
            fullName: 'Test User',
            email: 'test@example.com',
            role: 'CUSTOMER',
            avatarUrl: ''
        }
    }));
    
    console.log('Login simulation complete!');
}

// Auto-run checks when script loads
document.addEventListener('DOMContentLoaded', function() {
    console.log('=== LOGIN DEBUG READY ===');
    console.log('Available functions:');
    console.log('- checkAuthState()');
    console.log('- checkNavbarState()');
    console.log('- testLoginAPI()');
    console.log('- clearAuthData()');
    console.log('- simulateLogin()');
    console.log('========================');
    
    // Auto-check state
    setTimeout(() => {
        checkAuthState();
        checkNavbarState();
    }, 1000);
});

// Make functions globally available
window.debugAuth = {
    checkAuthState,
    checkNavbarState,
    testLoginAPI,
    clearAuthData,
    simulateLogin
};

console.log('Debug functions available via window.debugAuth');
