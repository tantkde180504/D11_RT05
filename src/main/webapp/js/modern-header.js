// Modern Header JavaScript Interactions

document.addEventListener('DOMContentLoaded', function() {
    
    // Header scroll effects
    const header = document.querySelector('.modern-header');
    const searchInput = document.querySelector('.modern-search-input');
    const searchBtn = document.querySelector('.modern-search-btn');
    const cartBtn = document.querySelector('.modern-cart-btn');
    const cartCount = document.querySelector('.modern-cart-count');
    const cartNotification = document.querySelector('.cart-notification');
    
    // Header scroll shadow effect
    window.addEventListener('scroll', function() {
        if (window.scrollY > 50) {
            header.classList.add('scrolled', 'enhanced-shadow');
        } else {
            header.classList.remove('scrolled', 'enhanced-shadow');
        }
    });
    
    // Search functionality enhancements
    if (searchInput) {
        const inputGroup = searchInput.closest('.modern-input-group');
        
        // Focus effects
        searchInput.addEventListener('focus', function() {
            inputGroup.classList.add('active');
            this.parentElement.style.transform = 'scale(1.02)';
        });
        
        searchInput.addEventListener('blur', function() {
            inputGroup.classList.remove('active');
            this.parentElement.style.transform = 'scale(1)';
        });
        
        // Live search suggestions (mock implementation)
        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            if (query.length > 2) {
                showSearchSuggestions(query);
            } else {
                hideSearchSuggestions();
            }
        });
        
        // Search form submission
        const searchForm = searchInput.closest('form');
        if (searchForm) {
            searchForm.addEventListener('submit', function(e) {
                if (searchInput.value.trim() === '') {
                    e.preventDefault();
                    searchInput.focus();
                    searchInput.style.animation = 'shake 0.5s ease-in-out';
                    setTimeout(() => {
                        searchInput.style.animation = '';
                    }, 500);
                } else {
                    // Success animation
                    searchBtn.classList.add('search-success');
                    setTimeout(() => {
                        searchBtn.classList.remove('search-success');
                    }, 600);
                }
            });
        }
    }
    
    // Ripple effect for buttons
    function createRipple(event) {
        const button = event.currentTarget;
        const ripple = button.querySelector('.btn-ripple');
        
        if (ripple) {
            ripple.style.width = '0';
            ripple.style.height = '0';
            
            setTimeout(() => {
                ripple.style.width = '300px';
                ripple.style.height = '300px';
            }, 10);
            
            setTimeout(() => {
                ripple.style.width = '0';
                ripple.style.height = '0';
            }, 600);
        }
    }
    
    // Add ripple effect to all modern buttons
    document.querySelectorAll('.modern-account-btn, .modern-work-btn, .modern-cart-btn').forEach(btn => {
        btn.addEventListener('click', createRipple);
    });
    
    // Cart functionality
    if (cartBtn && cartCount) {
        // Cart count animation
        function updateCartCount(newCount) {
            cartCount.style.animation = 'cartPulse 0.6s ease';
            cartCount.textContent = newCount;
            
            // Show notification
            if (cartNotification) {
                cartNotification.classList.add('show');
                setTimeout(() => {
                    cartNotification.classList.remove('show');
                }, 2000);
            }
            
            setTimeout(() => {
                cartCount.style.animation = '';
            }, 600);
        }
        
        // Mock cart update (you can integrate with your actual cart system)
        cartBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const currentCount = parseInt(cartCount.textContent) || 0;
            // This is just for demo - replace with actual cart logic
            console.log('Cart clicked - current count:', currentCount);
        });
    }
    
    // Logo hover effect
    const logo = document.querySelector('.modern-logo');
    if (logo) {
        logo.addEventListener('mouseenter', function() {
            this.style.animation = 'float 1s ease-in-out infinite';
        });
        
        logo.addEventListener('mouseleave', function() {
            this.style.animation = '';
        });
    }
    
    // Hamburger menu animation
    const hamburger = document.querySelector('.modern-hamburger');
    if (hamburger) {
        hamburger.addEventListener('click', function() {
            this.style.animation = 'bounce 0.6s ease';
            setTimeout(() => {
                this.style.animation = '';
            }, 600);
        });
    }
    
    // Search suggestions functionality
    function showSearchSuggestions(query) {
        // Mock suggestions - replace with actual API call
        const suggestions = [
            'Gundam Model Kit',
            'Action Figure',
            'Collectible',
            'Anime Merchandise',
            'Scale Model'
        ].filter(item => item.toLowerCase().includes(query.toLowerCase()));
        
        let suggestionsContainer = document.querySelector('.modern-suggestions');
        if (!suggestionsContainer) {
            suggestionsContainer = document.createElement('div');
            suggestionsContainer.className = 'modern-suggestions position-absolute w-100';
            suggestionsContainer.style.zIndex = '10003'; // High z-index for suggestions
            searchInput.parentElement.appendChild(suggestionsContainer);
        }
        
        if (suggestions.length > 0) {
            suggestionsContainer.innerHTML = suggestions.slice(0, 5).map(suggestion => 
                `<div class="suggestion-item" data-suggestion="${suggestion}">
                    <i class="fas fa-search me-2"></i>
                    ${suggestion}
                 </div>`
            ).join('');
            
            suggestionsContainer.style.display = 'block';
            
            // Add click handlers to suggestions
            suggestionsContainer.querySelectorAll('.suggestion-item').forEach(item => {
                item.addEventListener('click', function() {
                    searchInput.value = this.dataset.suggestion;
                    hideSearchSuggestions();
                    searchInput.focus();
                });
            });
        }
    }
    
    function hideSearchSuggestions() {
        const suggestionsContainer = document.querySelector('.modern-suggestions');
        if (suggestionsContainer) {
            suggestionsContainer.style.display = 'none';
        }
    }
    
    // Hide suggestions when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.modern-search')) {
            hideSearchSuggestions();
        }
    });
    
    // Dropdown functionality
    document.querySelectorAll('[data-bs-toggle="dropdown"]').forEach(dropdown => {
        dropdown.addEventListener('shown.bs.dropdown', function() {
            const dropdownMenu = this.nextElementSibling;
            if (dropdownMenu && dropdownMenu.classList.contains('modern-dropdown')) {
                dropdownMenu.style.animation = 'fadeInDown 0.3s ease';
                dropdownMenu.style.zIndex = '10001'; // Ensure high z-index
            }
        });
        
        // Fix z-index issues on show
        dropdown.addEventListener('show.bs.dropdown', function() {
            const dropdownMenu = this.nextElementSibling;
            if (dropdownMenu) {
                dropdownMenu.style.zIndex = '10001';
                dropdownMenu.style.position = 'absolute';
            }
        });
    });
    
    // Additional dropdown z-index fix
    document.addEventListener('DOMContentLoaded', function() {
        // Fix all dropdowns in header
        document.querySelectorAll('.modern-header .dropdown-menu').forEach(menu => {
            menu.style.zIndex = '10001';
        });
    });
    
    // Keyboard navigation for accessibility
    document.addEventListener('keydown', function(e) {
        // Escape key to close suggestions
        if (e.key === 'Escape') {
            hideSearchSuggestions();
        }
        
        // Enter key on suggestions
        if (e.key === 'Enter' && e.target.classList.contains('suggestion-item')) {
            e.target.click();
        }
    });
    
    // Loading state simulation for search
    function showSearchLoading() {
        if (searchBtn) {
            const originalText = searchBtn.innerHTML;
            searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            searchBtn.disabled = true;
            
            setTimeout(() => {
                searchBtn.innerHTML = originalText;
                searchBtn.disabled = false;
            }, 1500);
        }
    }
    
    // Performance optimization - throttle scroll events
    let scrollTimeout;
    function throttleScroll() {
        if (scrollTimeout) {
            clearTimeout(scrollTimeout);
        }
        scrollTimeout = setTimeout(function() {
            // Scroll-dependent operations
        }, 16); // ~60fps
    }
    
    window.addEventListener('scroll', throttleScroll);
    
    // Intersection Observer for header visibility
    const headerObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                header.classList.add('header-visible');
            } else {
                header.classList.remove('header-visible');
            }
        });
    }, {
        threshold: 0.1
    });
    
    // Observe header for scroll animations
    if (header) {
        headerObserver.observe(header);
    }
    
    // Touch/swipe gestures for mobile
    let touchStartX = 0;
    let touchEndX = 0;
    
    header.addEventListener('touchstart', function(e) {
        touchStartX = e.changedTouches[0].screenX;
    });
    
    header.addEventListener('touchend', function(e) {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
    });
    
    function handleSwipe() {
        const swipeDistance = touchEndX - touchStartX;
        if (Math.abs(swipeDistance) > 50) {
            // Handle swipe gestures if needed
            console.log('Swipe detected:', swipeDistance > 0 ? 'right' : 'left');
        }
    }
    
    // Add CSS animations dynamically
    const style = document.createElement('style');
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        @keyframes bounce {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        
        @keyframes fadeInDown {
            0% {
                opacity: 0;
                transform: translateY(-10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .header-visible {
            animation: slideInDown 0.5s ease;
        }
        
        @keyframes slideInDown {
            0% {
                transform: translateY(-100%);
            }
            100% {
                transform: translateY(0);
            }
        }
    `;
    document.head.appendChild(style);
    
    // Initialize tooltips if Bootstrap is available
    if (typeof bootstrap !== 'undefined' && bootstrap.Tooltip) {
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    }
    
    // Console log for debugging
    console.log('Modern Header JavaScript initialized successfully');
});

// Export functions for external use if needed
window.ModernHeader = {
    updateCartCount: function(count) {
        const cartCount = document.querySelector('.modern-cart-count');
        if (cartCount) {
            cartCount.textContent = count;
            cartCount.style.animation = 'cartPulse 0.6s ease';
            setTimeout(() => {
                cartCount.style.animation = '';
            }, 600);
        }
    },
    
    showSearchLoading: function() {
        const searchBtn = document.querySelector('.modern-search-btn');
        if (searchBtn) {
            const originalText = searchBtn.innerHTML;
            searchBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
            searchBtn.disabled = true;
            
            setTimeout(() => {
                searchBtn.innerHTML = originalText;
                searchBtn.disabled = false;
            }, 1500);
        }
    },
    
    showNotification: function() {
        const cartNotification = document.querySelector('.cart-notification');
        if (cartNotification) {
            cartNotification.classList.add('show');
            setTimeout(() => {
                cartNotification.classList.remove('show');
            }, 2000);
        }
    }
};
