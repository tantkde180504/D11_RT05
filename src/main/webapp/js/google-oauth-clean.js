// Clean Google OAuth Handler
class GoogleOAuthHandler {
    constructor() {
        this.init();
    }

    init() {
        console.log('Google OAuth Handler initialized');
        this.bindEvents();
        
        // Check login status after a short delay
        setTimeout(() => {
            this.checkLoginStatus();
        }, 300);
    }

    bindEvents() {
        // Google Sign In button
        const googleSignInBtn = document.getElementById('google-sign-in-btn');
        if (googleSignInBtn) {
            googleSignInBtn.addEventListener('click', () => {
                this.signInWithGoogle();
            });
            console.log('Google sign-in button event bound');
        }
    }

    signInWithGoogle() {
        console.log('Redirecting to Google OAuth...');
        window.location.href = '/oauth2/authorization/google';
    }
    
    async checkLoginStatus() {
        try {
            console.log('Checking OAuth login status...');
            const response = await fetch('/oauth2/user-info', {
                method: 'GET',
                credentials: 'same-origin'
            });

            if (response.ok) {
                const data = await response.json();
                console.log('OAuth user data:', data);
                
                if (data.isLoggedIn && data.name) {
                    this.handleLoggedInUser(data);
                } else {
                    this.handleLoggedOutUser();
                }
            } else {
                console.log('No OAuth session found');
                this.handleLoggedOutUser();
            }
        } catch (error) {
            console.error('OAuth check error:', error);
            this.handleLoggedOutUser();
        }
    }
    
    handleLoggedInUser(userData) {
        console.log('Handling logged in OAuth user:', userData.name);
        
        // Update localStorage with correct field names
        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', userData.name);
        localStorage.setItem('userEmail', userData.email || '');
        localStorage.setItem('userRole', userData.role || 'CUSTOMER');
        localStorage.setItem('userAvatar', userData.picture || ''); // Save Google avatar
        
        // Dispatch event for navbar manager to handle - using same format as login.js
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: userData.name,
                email: userData.email || '',
                role: userData.role || 'CUSTOMER',
                avatarUrl: userData.picture || ''
            }
        }));
        
        // Force auth sync if available
        if (window.authSyncManager) {
            window.authSyncManager.forceRefresh();
        }
        
        console.log('OAuth user logged in successfully');
    }
    
    handleLoggedOutUser() {
        console.log('Handling logged out user');
        
        // Clear localStorage
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');
        
        // Dispatch event for navbar manager to handle
        window.dispatchEvent(new CustomEvent('userLoggedOut'));
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.googleOAuthHandler = new GoogleOAuthHandler();
});