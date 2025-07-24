/* Mobile Sidebar Debug and Fix Script */
/* This script ensures mobile sidebar always appears correctly */

// Debug function to check z-index
function debugZIndex() {
    console.log('=== Z-INDEX DEBUG ===');
    const elements = [
        '.modern-header',
        '.mobile-sidebar',
        '.mobile-overlay',
        '.sidebar-close',
        '.hamburger-menu'
    ];
    
    elements.forEach(selector => {
        const element = document.querySelector(selector);
        if (element) {
            const zIndex = window.getComputedStyle(element).zIndex;
            console.log(`${selector}: z-index = ${zIndex}`);
        }
    });
}

// Force z-index on mobile sidebar
function forceTopZIndex() {
    const sidebar = document.querySelector('.mobile-sidebar');
    const overlay = document.querySelector('.mobile-overlay');
    const closeBtn = document.querySelector('.sidebar-close');
    const hamburger = document.querySelector('.hamburger-menu');
    
    if (sidebar) {
        sidebar.style.zIndex = '999999';
        sidebar.style.position = 'fixed';
    }
    
    if (overlay) {
        overlay.style.zIndex = '999998';
        overlay.style.position = 'fixed';
    }
    
    if (closeBtn) {
        closeBtn.style.zIndex = '999999';
        closeBtn.style.position = 'absolute';
    }
    
    if (hamburger) {
        hamburger.style.zIndex = '999999';
        hamburger.style.position = 'relative';
    }
    
    console.log('Z-index forced on mobile sidebar elements');
}

// Run when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Debug z-index values
    debugZIndex();
    
    // Force z-index
    forceTopZIndex();
    
    // Add event listener to hamburger menu
    const hamburger = document.querySelector('.hamburger-menu');
    if (hamburger) {
        hamburger.addEventListener('click', function() {
            setTimeout(() => {
                forceTopZIndex();
                debugZIndex();
            }, 100);
        });
    }
    
    // Add body class when sidebar is open
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                const sidebar = document.querySelector('.mobile-sidebar');
                if (sidebar && sidebar.classList.contains('active')) {
                    document.body.classList.add('sidebar-open');
                    forceTopZIndex();
                } else {
                    document.body.classList.remove('sidebar-open');
                }
            }
        });
    });
    
    const sidebar = document.querySelector('.mobile-sidebar');
    if (sidebar) {
        observer.observe(sidebar, { attributes: true });
    }
});

// Additional safety check every 500ms when sidebar is active
setInterval(function() {
    const sidebar = document.querySelector('.mobile-sidebar');
    if (sidebar && sidebar.classList.contains('active')) {
        forceTopZIndex();
    }
}, 500);
