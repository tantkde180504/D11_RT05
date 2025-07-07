// Simple Google OAuth Handler - Fixed Version
class GoogleOAuthHandler {
    constructor() {
        this.init();
    }

    init() {
        console.log('🔐 Google OAuth Handler initialized');
        this.bindEvents();
        this.checkLoginStatus();
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
        console.log('🔍 Redirecting to Google OAuth...');
        window.location.href = '/oauth2/authorization/google';
    }
    
    async checkLoginStatus() {
        try {
            console.log('🔍 Checking OAuth login status...');
            const response = await fetch('/oauth2/user-info', {
                method: 'GET',
                credentials: 'same-origin',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });

            console.log('📡 OAuth response status:', response.status);

            if (response.ok) {
                const data = await response.json();
                console.log('📦 OAuth user data:', data);
                
                if (data.isLoggedIn && data.userName) {
                    this.handleOAuthUser(data);
                } else {
                    this.handleGuestUser();
                }
            } else {
                console.log('👤 No OAuth user session found');
                this.handleGuestUser();
            }
        } catch (error) {
            console.error('❌ OAuth status check error:', error);
            this.handleGuestUser();
        }
    }
    
    handleOAuthUser(userData) {
        console.log('✅ Handling OAuth user:', userData.userName);
        
        // Update localStorage for consistency
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', userData.userName);
        localStorage.setItem('userEmail', userData.userEmail || '');
        localStorage.setItem('userRole', userData.userRole || 'CUSTOMER');
        
        // Use unified navbar controller
        if (window.unifiedNavbarController) {
            console.log('📱 Using unified navbar controller for OAuth user');
            window.unifiedNavbarController.showUserNavbar(userData.userName);
        } else {
            console.log('⚠️ Unified navbar controller not available');
        }
        
        // Dispatch event
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: userData.userName,
                email: userData.userEmail || '',
                role: userData.userRole || 'CUSTOMER'
            }
        }));
    }
    
    handleGuestUser() {
        console.log('👤 Handling guest user');
        
        // Use unified navbar controller
        if (window.unifiedNavbarController) {
            window.unifiedNavbarController.showGuestNavbar();
        }
    }
    
    async logout() {
        try {
            console.log('🚪 Logging out...');
            
            // Clear localStorage
            localStorage.removeItem('userLoggedIn');
            localStorage.removeItem('userName');
            localStorage.removeItem('userEmail');
            localStorage.removeItem('userRole');
            
            // Trigger logout event
            window.dispatchEvent(new CustomEvent('userLoggedOut'));
            
            // Redirect to logout endpoint
            window.location.href = '/logout';
        } catch (error) {
            console.error('❌ Logout error:', error);
        }
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.googleOAuthHandler = new GoogleOAuthHandler();
});

// Export for global access
window.GoogleOAuthHandler = GoogleOAuthHandler;
