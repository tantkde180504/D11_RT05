/**
 * Anti-Flicker Authentication System for Unified Navbar
 * Prevents navbar flickering by quickly setting the correct state
 */
class AntiFlickerAuth {
    constructor() {
        this.contextPath = window.contextPath || '';
        this.init();
    }

    init() {
        console.log('🛡️ Anti-Flicker Auth initialized');
        
        // Apply anti-flicker immediately
        this.applyAntiFlicker();
        
        // Re-check after a short delay for any late updates
        setTimeout(() => {
            this.applyAntiFlicker();
        }, 50);
    }

    applyAntiFlicker() {
        console.log('🔍 Anti-Flicker: Checking auth state...');
        
        const unifiedMenu = document.getElementById('unified-account-menu');
        if (!unifiedMenu) {
            console.log('⚠️ Unified account menu not found, retrying...');
            setTimeout(() => this.applyAntiFlicker(), 100);
            return;
        }

        // Quick check for any user data
        const hasStoredUser = localStorage.getItem('currentUser');
        const hasGoogleUser = localStorage.getItem('googleUser');
        const justLoggedIn = localStorage.getItem('justLoggedIn');
        
        console.log('📦 Anti-Flicker: Auth data found:', {
            hasStoredUser: !!hasStoredUser,
            hasGoogleUser: !!hasGoogleUser,
            justLoggedIn: !!justLoggedIn
        });

        if (hasStoredUser || hasGoogleUser || justLoggedIn) {
            console.log('✅ Anti-Flicker: User detected, preparing for logged-in state');
            this.prepareForLoggedInUser();
        } else {
            console.log('👤 Anti-Flicker: No user detected, preparing for guest state');
            this.prepareForGuestUser();
        }
    }

    prepareForLoggedInUser() {
        const dropdown = document.getElementById('unifiedAccountDropdown');
        if (dropdown) {
            // Pre-set the style to prevent flicker
            dropdown.className = 'btn btn-outline-success dropdown-toggle d-flex align-items-center';
            console.log('✅ Anti-Flicker: Pre-configured for logged-in user');
        }
    }

    prepareForGuestUser() {
        const dropdown = document.getElementById('unifiedAccountDropdown');
        if (dropdown) {
            // Pre-set the style to prevent flicker
            dropdown.className = 'btn btn-outline-primary dropdown-toggle';
            console.log('✅ Anti-Flicker: Pre-configured for guest user');
        }
    }
}

// Initialize anti-flicker immediately
console.log('🛡️ Starting Anti-Flicker Auth...');

// Run as soon as possible
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        new AntiFlickerAuth();
    });
} else {
    new AntiFlickerAuth();
}

console.log('📦 Anti-Flicker Auth script loaded');
