/**
 * Navbar Fix JavaScript - Sửa lỗi giật và không phản hồi
 * Tối ưu hóa event handling và performance
 */

// Debounce function để tránh spam events
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Throttle function cho các events liên tục
function throttle(func, limit) {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    }
}

/**
 * Navbar Fix JavaScript - Sửa lỗi hamburger menu
 */

document.addEventListener('DOMContentLoaded', function() {
    setTimeout(initializeHamburgerMenuFix, 200);
});

function initializeHamburgerMenuFix() {
    console.log('Initializing hamburger menu fix...');
    
    const hamburgerBtn = document.getElementById('hamburgerBtn');
    const mobileSidebar = document.getElementById('mobileSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');
    const sidebarClose = document.getElementById('sidebarClose');

    if (!hamburgerBtn || !mobileSidebar || !mobileOverlay) {
        console.error('Required elements not found');
        return;
    }

    // Clone elements để xóa event listeners cũ
    const newHamburgerBtn = hamburgerBtn.cloneNode(true);
    hamburgerBtn.parentNode.replaceChild(newHamburgerBtn, hamburgerBtn);
    
    const newMobileOverlay = mobileOverlay.cloneNode(true);
    mobileOverlay.parentNode.replaceChild(newMobileOverlay, mobileOverlay);
    
    if (sidebarClose) {
        const newSidebarClose = sidebarClose.cloneNode(true);
        sidebarClose.parentNode.replaceChild(newSidebarClose, sidebarClose);
    }
    
    // Lấy references mới
    const hamburger = document.getElementById('hamburgerBtn');
    const sidebar = document.getElementById('mobileSidebar');
    const overlay = document.getElementById('mobileOverlay');
    const closeBtn = document.getElementById('sidebarClose');
    
    let isOpen = false;
    let scrollPosition = 0;
    
    function openSidebar() {
        if (isOpen) return;
        
        console.log('Opening sidebar...');
        isOpen = true;
        scrollPosition = window.scrollY;
        
        hamburger.classList.add('active');
        sidebar.classList.add('active');
        overlay.classList.add('active');
        
        document.body.classList.add('sidebar-open');
        document.body.style.top = `-${scrollPosition}px`;
    }
    
    function closeSidebar() {
        if (!isOpen) return;
        
        console.log('Closing sidebar...');
        isOpen = false;
        
        hamburger.classList.remove('active');
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
        
        document.body.classList.remove('sidebar-open');
        document.body.style.top = '';
        window.scrollTo(0, scrollPosition);
    }
    
    function toggleSidebar() {
        if (isOpen) {
            closeSidebar();
        } else {
            openSidebar();
        }
    }

    // Event listeners
    hamburger.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        console.log('Hamburger clicked');
        toggleSidebar();
    });

    overlay.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        closeSidebar();
    });

    if (closeBtn) {
        closeBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            closeSidebar();
        });
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && isOpen) {
            closeSidebar();
        }
    });

    sidebar.addEventListener('click', function(e) {
        e.stopPropagation();
    });

    const sidebarLinks = sidebar.querySelectorAll('a:not([data-bs-toggle])');
    sidebarLinks.forEach(function(link) {
        link.addEventListener('click', function() {
            setTimeout(closeSidebar, 200);
        });
    });

    window.addEventListener('resize', function() {
        if (window.innerWidth >= 992 && isOpen) {
            closeSidebar();
        }
    });
    
    window.hamburgerMenu = {
        open: openSidebar,
        close: closeSidebar,
        toggle: toggleSidebar,
        isOpen: function() { return isOpen; }
    };
    
    console.log('Hamburger menu fix initialized successfully');
}

window.addEventListener('beforeunload', function() {
    document.body.classList.remove('sidebar-open');
    document.body.style.top = '';
});
