/**
 * Unified Navbar Debug Tool
 * Use this in browser console to check navbar state
 */

function debugUnifiedNavbar() {
    console.log('🔍 UNIFIED NAVBAR DEBUG REPORT');
    console.log('=====================================');
    
    // Check for old elements that should be removed
    const oldUserInfo = document.getElementById('nav-user-info');
    const oldLoginBtn = document.getElementById('nav-login-btn');
    
    console.log('❌ OLD ELEMENTS CHECK:');
    console.log('nav-user-info:', oldUserInfo ? 'STILL EXISTS (BAD)' : 'NOT FOUND (GOOD)');
    console.log('nav-login-btn:', oldLoginBtn ? 'STILL EXISTS (BAD)' : 'NOT FOUND (GOOD)');
    
    // Check for new unified elements
    const unifiedMenu = document.getElementById('unified-account-menu');
    const unifiedDropdown = document.getElementById('unifiedAccountDropdown');
    const unifiedDropdownMenu = document.getElementById('unifiedAccountDropdownMenu');
    
    console.log('✅ NEW UNIFIED ELEMENTS CHECK:');
    console.log('unified-account-menu:', unifiedMenu ? 'EXISTS (GOOD)' : 'NOT FOUND (BAD)');
    console.log('unifiedAccountDropdown:', unifiedDropdown ? 'EXISTS (GOOD)' : 'NOT FOUND (BAD)');
    console.log('unifiedAccountDropdownMenu:', unifiedDropdownMenu ? 'EXISTS (GOOD)' : 'NOT FOUND (BAD)');
    
    if (unifiedDropdown) {
        console.log('Unified button classes:', unifiedDropdown.className);
        console.log('Unified button content:', unifiedDropdown.innerHTML);
    }
    
    // Check localStorage
    console.log('📦 LOCALSTORAGE CHECK:');
    console.log('currentUser:', localStorage.getItem('currentUser'));
    console.log('googleUser:', localStorage.getItem('googleUser'));
    console.log('justLoggedIn:', localStorage.getItem('justLoggedIn'));
    
    // Check for managers
    console.log('🎯 MANAGER CHECK:');
    console.log('unifiedNavbarManager:', window.unifiedNavbarManager ? 'EXISTS' : 'NOT FOUND');
    console.log('navbarManager (old):', window.navbarManager ? 'EXISTS (SHOULD BE REMOVED)' : 'NOT FOUND');
    
    // Visual state check
    if (oldUserInfo || oldLoginBtn) {
        console.log('⚠️  WARNING: Old navbar elements still exist!');
        
        if (oldUserInfo) {
            console.log('Old user info display:', window.getComputedStyle(oldUserInfo).display);
            console.log('Old user info classes:', oldUserInfo.className);
        }
        
        if (oldLoginBtn) {
            console.log('Old login btn display:', window.getComputedStyle(oldLoginBtn).display);
            console.log('Old login btn classes:', oldLoginBtn.className);
        }
    }
    
    console.log('=====================================');
    
    return {
        hasOldElements: !!(oldUserInfo || oldLoginBtn),
        hasUnifiedElements: !!(unifiedMenu && unifiedDropdown && unifiedDropdownMenu),
        unifiedManager: window.unifiedNavbarManager,
        recommendation: (!oldUserInfo && !oldLoginBtn && unifiedMenu) ? 
            'Navbar is properly unified! ✅' : 
            'Navbar needs cleanup! ❌'
    };
}

// Run debug automatically
window.debugUnifiedNavbar = debugUnifiedNavbar;
console.log('🛠️ Unified Navbar Debug Tool loaded. Run debugUnifiedNavbar() to check state.');

// Auto-run after page loads
window.addEventListener('load', function() {
    setTimeout(() => {
        console.log('🚀 Auto-running unified navbar debug...');
        debugUnifiedNavbar();
    }, 2000);
});
