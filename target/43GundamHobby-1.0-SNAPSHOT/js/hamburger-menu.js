/**
 * Hamburger Menu Functionality
 * Sử dụng cho tất cả các trang trong website
 */

document.addEventListener('DOMContentLoaded', function() {
    // Get elements
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const mobileSidebar = document.getElementById('mobileSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');
    const sidebarClose = document.getElementById('sidebarClose');
    
    // Check if elements exist
    if (!hamburgerBtn || !mobileSidebar || !mobileOverlay || !sidebarClose) {
        console.warn('Hamburger menu elements not found');
        return;
    }
    
    // Toggle sidebar function
    function toggleSidebar() {
        hamburgerBtn.classList.toggle('active');
        mobileSidebar.classList.toggle('active');
        mobileOverlay.classList.toggle('active');
        
        // Prevent body scroll when sidebar is open
        if (mobileSidebar.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
            document.body.style.paddingRight = getScrollbarWidth() + 'px';
        } else {
            document.body.style.overflow = '';
            document.body.style.paddingRight = '';
        }
    }
    
    // Close sidebar function
    function closeSidebar() {
        hamburgerBtn.classList.remove('active');
        mobileSidebar.classList.remove('active');
        mobileOverlay.classList.remove('active');
        document.body.style.overflow = '';
        document.body.style.paddingRight = '';
    }
    
    // Get scrollbar width to prevent layout shift
    function getScrollbarWidth() {
        return window.innerWidth - document.documentElement.clientWidth;
    }
    
    // Event listeners
    hamburgerBtn.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        toggleSidebar();
    });
    
    sidebarClose.addEventListener('click', function(e) {
        e.preventDefault();
        closeSidebar();
    });
    
    mobileOverlay.addEventListener('click', function(e) {
        e.preventDefault();
        closeSidebar();
    });
    
    // Close sidebar when clicking on sidebar links (except submenu toggles)
    const sidebarLinks = document.querySelectorAll('.sidebar-menu a:not([data-bs-toggle]), .category-list a');
    sidebarLinks.forEach(link => {
        link.addEventListener('click', function() {
            // Add small delay to allow navigation to start
            setTimeout(closeSidebar, 100);
        });
    });
    
    // Close sidebar on window resize if needed (optional behavior)
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(function() {
            // Hamburger menu now works on all screen sizes
            // You can customize this behavior if needed
            // For now, we keep the sidebar open/closed state unchanged on resize
        }, 250);
    });
    
    // Handle escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileSidebar.classList.contains('active')) {
            closeSidebar();
        }
    });
    
    // Prevent sidebar content clicks from bubbling to overlay
    mobileSidebar.addEventListener('click', function(e) {
        e.stopPropagation();
    });
    
    // Handle touch events for better mobile experience
    let startY = 0;
    let currentY = 0;
    let isDragging = false;
    
    mobileSidebar.addEventListener('touchstart', function(e) {
        startY = e.touches[0].clientY;
        isDragging = true;
    }, { passive: true });
    
    mobileSidebar.addEventListener('touchmove', function(e) {
        if (!isDragging) return;
        currentY = e.touches[0].clientY;
        const diffY = startY - currentY;
        
        // Allow natural scrolling within sidebar
        if (mobileSidebar.scrollTop === 0 && diffY < 0) {
            e.preventDefault();
        }
    }, { passive: false });
    
    mobileSidebar.addEventListener('touchend', function() {
        isDragging = false;
    });
    
    // Initialize accessibility attributes
    function initializeA11y() {
        hamburgerBtn.setAttribute('aria-expanded', 'false');
        hamburgerBtn.setAttribute('aria-controls', 'mobileSidebar');
        mobileSidebar.setAttribute('aria-hidden', 'true');
        
        // Update aria attributes when sidebar state changes
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                    const isActive = mobileSidebar.classList.contains('active');
                    hamburgerBtn.setAttribute('aria-expanded', isActive.toString());
                    mobileSidebar.setAttribute('aria-hidden', (!isActive).toString());
                }
            });
        });
        
        observer.observe(mobileSidebar, { attributes: true });
    }
    
    // Initialize
    initializeA11y();
    
    // Public API
    window.hamburgerMenu = {
        open: function() {
            if (!mobileSidebar.classList.contains('active')) {
                toggleSidebar();
            }
        },
        close: closeSidebar,
        toggle: toggleSidebar,
        isOpen: function() {
            return mobileSidebar.classList.contains('active');
        }
    };
});
