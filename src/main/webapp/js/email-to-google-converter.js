/**
 * Email Login to Google Account Converter
 * Converts email/password login to Google account format
 */
class EmailToGoogleConverter {
    constructor() {
        this.init();
    }

    init() {
        console.log('📧➡️🔍 Email to Google Converter initialized');
    }

    /**
     * Convert regular login data to Google account format
     * @param {Object} loginData - Regular login response data
     * @returns {Object} Google account format data
     */
    convertToGoogleFormat(loginData) {
        console.log('🔄 Converting email login to Google format:', loginData);
        
        // Extract name parts
        const fullName = loginData.fullName || '';
        const nameParts = fullName.split(' ');
        const firstName = nameParts[0] || '';
        const lastName = nameParts.slice(1).join(' ') || '';
        
        // Generate Google-like user object
        const googleUser = {
            // Google OAuth standard fields
            sub: `email_user_${loginData.email.replace(/[^a-zA-Z0-9]/g, '_')}`, // Unique ID
            email: loginData.email,
            email_verified: true,
            name: fullName,
            given_name: firstName,
            family_name: lastName,
            picture: this.generateAvatarUrl(loginData.email, fullName),
            locale: 'vi',
            
            // Custom fields for our app
            role: loginData.role || 'CUSTOMER',
            loginType: 'email_converted_to_google',
            originalLoginMethod: 'email_password',
            
            // Compatibility fields
            fullName: fullName,
            avatarUrl: this.generateAvatarUrl(loginData.email, fullName),
            googleId: `email_user_${loginData.email.replace(/[^a-zA-Z0-9]/g, '_')}`
        };
        
        console.log('✅ Converted to Google format:', googleUser);
        return googleUser;
    }

    /**
     * Generate avatar URL for email user (Gravatar or initials)
     * @param {string} email - User email
     * @param {string} fullName - User full name
     * @returns {string} Avatar URL
     */
    generateAvatarUrl(email, fullName) {
        // Try to generate Gravatar URL
        if (email && window.md5) {
            const emailHash = window.md5(email.trim().toLowerCase());
            return `https://www.gravatar.com/avatar/${emailHash}?s=200&d=identicon`;
        }
        
        // Fallback to initials-based avatar
        if (fullName) {
            const initials = fullName.split(' ')
                .map(name => name.charAt(0))
                .join('')
                .toUpperCase()
                .substring(0, 2);
            
            // Generate a simple avatar with initials
            return `https://ui-avatars.com/api/?name=${encodeURIComponent(fullName)}&size=200&background=0d6efd&color=ffffff&bold=true`;
        }
        
        // Ultimate fallback
        return '/img/placeholder.jpg';
    }

    /**
     * Store converted user data as Google user
     * @param {Object} googleUser - Converted Google user data
     */
    storeAsGoogleUser(googleUser) {
        console.log('💾 Storing as Google user:', googleUser);
        
        // Clear any existing regular user data
        localStorage.removeItem('currentUser');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userAvatar');
        
        // Store as Google user
        localStorage.setItem('googleUser', JSON.stringify(googleUser));
        localStorage.setItem('userRole', googleUser.role);
        
        console.log('✅ User data stored as Google user');
    }

    /**
     * Main conversion function - call this after successful email login
     * @param {Object} loginData - Login response data
     */
    convertAndStore(loginData) {
        console.log('🚀 Starting email to Google conversion...');
        
        try {
            // Convert to Google format
            const googleUser = this.convertToGoogleFormat(loginData);
            
            // Store as Google user
            this.storeAsGoogleUser(googleUser);
            
            // Dispatch login event with Google format
            window.dispatchEvent(new CustomEvent('userLoggedIn', {
                detail: googleUser
            }));
            
            // Update unified navbar
            if (window.unifiedNavbarManager) {
                console.log('📊 Updating unified navbar with converted Google user...');
                window.unifiedNavbarManager.currentUser = googleUser;
                window.unifiedNavbarManager.updateNavbarForLoggedInUser();
            }
            
            console.log('✅ Email to Google conversion completed successfully');
            return googleUser;
            
        } catch (error) {
            console.error('❌ Error during email to Google conversion:', error);
            throw error;
        }
    }
}

// Make it globally available
window.EmailToGoogleConverter = EmailToGoogleConverter;
window.emailToGoogleConverter = new EmailToGoogleConverter();

console.log('📦 Email to Google Converter loaded');
