/**
 * Recently Viewed Products Tracker
 * Automatically tracks products when users view them
 */

console.log('🔄 Loading recently viewed tracker...');

// Function to automatically add product to recently viewed when viewing product detail
function trackProductView(productId) {
    if (!productId) return;
    
    console.log(`👁️ Tracking product view: ${productId}`);
    
    // Add to recently viewed if the function exists
    if (window.addToRecentlyViewed) {
        window.addToRecentlyViewed(productId);
    } else {
        // Fallback: directly manage localStorage
        let recentlyViewed = JSON.parse(localStorage.getItem('recentlyViewed') || '[]');
        
        // Remove existing entry if present
        recentlyViewed = recentlyViewed.filter(item => item.id !== productId);
        
        // Add to beginning of array
        recentlyViewed.unshift({
            id: productId,
            viewedAt: new Date().toISOString()
        });
        
        // Keep only last 12 items
        recentlyViewed = recentlyViewed.slice(0, 12);
        
        localStorage.setItem('recentlyViewed', JSON.stringify(recentlyViewed));
        
        console.log(`✅ Product ${productId} added to recently viewed (fallback)`);
    }
}

// Function to extract product ID from URL
function getProductIdFromUrl() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('id');
}

// Auto-track when on product detail page
document.addEventListener('DOMContentLoaded', function() {
    const currentPage = window.location.pathname;
    
    // Check if we're on product detail page
    if (currentPage.includes('product-detail.jsp')) {
        const productId = getProductIdFromUrl();
        if (productId) {
            console.log(`📍 Product detail page detected, tracking product: ${productId}`);
            trackProductView(parseInt(productId));
        }
    }
});

// Function to track product views from product cards
function setupProductViewTracking() {
    // Track clicks on product images and titles
    document.addEventListener('click', function(e) {
        const productCard = e.target.closest('.product-card');
        if (!productCard) return;
        
        // Check if clicked element is a link to product detail
        const productLink = e.target.closest('a[href*="product-detail.jsp"]');
        if (productLink) {
            const href = productLink.getAttribute('href');
            const productId = extractProductIdFromHref(href);
            
            if (productId) {
                console.log(`🔗 Product link clicked, tracking: ${productId}`);
                trackProductView(parseInt(productId));
            }
        }
    });
}

// Function to extract product ID from href attribute
function extractProductIdFromHref(href) {
    const match = href.match(/[?&]id=(\d+)/);
    return match ? match[1] : null;
}

// Initialize tracking on page load
document.addEventListener('DOMContentLoaded', function() {
    setupProductViewTracking();
    console.log('✅ Product view tracking initialized');
});

// Make functions available globally
window.trackProductView = trackProductView;
window.getProductIdFromUrl = getProductIdFromUrl;
