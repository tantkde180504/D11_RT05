// Debug script for navbar issues
console.log('🔍 Debug Navbar Script Loading...');

// Check for script conflicts
window.addEventListener('DOMContentLoaded', function() {
    console.log('🔍 Checking for navbar conflicts...');
    
    // Check for multiple instances of key functions
    const keyFunctions = [
        'unifiedNavbarManager',
        'legacyNavbarCleanup', 
        'antiFlickerUnified',
        'hamburgerMenu'
    ];
    
    keyFunctions.forEach(func => {
        const instances = window[func];
        if (instances) {
            console.log('✅', func, 'loaded correctly');
        } else {
            console.warn('⚠️', func, 'not found');
        }
    });
    
    // Check for duplicate scripts
    const scripts = document.querySelectorAll('script[src*="js/"]');
    const scriptPaths = {};
    
    scripts.forEach(script => {
        const src = script.src;
        if (scriptPaths[src]) {
            console.error('❌ Duplicate script detected:', src);
        } else {
            scriptPaths[src] = true;
        }
    });
    
    // Check header elements
    const headers = document.querySelectorAll('header');
    if (headers.length > 1) {
        console.warn('⚠️ Multiple headers detected:', headers.length);
    }
    
    const accountButtons = document.querySelectorAll('[id*="Account"]');
    if (accountButtons.length > 1) {
        console.warn('⚠️ Multiple account buttons:', accountButtons.length);
    }
    
    console.log('🔍 Debug check complete');
});
