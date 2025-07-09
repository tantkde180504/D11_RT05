// Favorites Manager - Quản lý sản phẩm yêu thích

class FavoritesManager {
    constructor() {
        // Sử dụng cách tính baseUrl giống như trong all-products-manager.js
        this.baseUrl = window.location.origin + (window.location.pathname.includes('/D11_RT05') ? '/D11_RT05' : '');
        console.log('FavoritesManager initialized with baseUrl:', this.baseUrl);
        this.init();
    }

    init() {
        console.log('Initializing FavoritesManager...');
        console.log('Document ready state:', document.readyState);
        console.log('Current URL:', window.location.href);
        
        // Check if we're on the favorites page
        if (!window.location.pathname.includes('favorites.jsp')) {
            console.log('Not on favorites page, skipping initialization');
            return;
        }
        
        // Test element existence
        const favoritesGrid = document.getElementById('favoritesGrid');
        const favoritesCount = document.getElementById('favoritesCount');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const emptyMessage = document.getElementById('emptyFavoritesMessage');
        
        console.log('DOM Elements check:');
        console.log('- favoritesGrid:', favoritesGrid ? 'Found' : 'NOT FOUND');
        console.log('- favoritesCount:', favoritesCount ? 'Found' : 'NOT FOUND');
        console.log('- loadingSpinner:', loadingSpinner ? 'Found' : 'NOT FOUND');
        console.log('- emptyMessage:', emptyMessage ? 'Found' : 'NOT FOUND');
        
        // Test rendering first - DISABLED to prevent interference
        // setTimeout(() => {
        //     this.testRendering();
        // }, 100);
        
        this.loadFavorites();
        this.setupEventListeners();
        
        // Setup mutation observer to detect content changes
        this.setupContentObserver();
    }

    setupEventListeners() {
        // Listen for favorite button clicks
        document.addEventListener('click', (e) => {
            if (e.target.closest('.favorite-btn')) {
                e.preventDefault();
                e.stopPropagation();
                const btn = e.target.closest('.favorite-btn');
                const productId = btn.dataset.productId;
                if (productId) {
                    this.toggleFavorite(productId, btn);
                }
            }
            
            // Listen for add to cart button clicks
            if (e.target.closest('.add-to-cart-btn')) {
                e.preventDefault();
                e.stopPropagation();
                const btn = e.target.closest('.add-to-cart-btn');
                const productId = btn.dataset.productId;
                if (productId) {
                    addToCart(productId, btn);
                }
            }
        });
    }

    setupContentObserver() {
        const favoritesGrid = document.getElementById('favoritesGrid');
        if (!favoritesGrid) return;
        
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.type === 'childList') {
                    console.log('Content changed in favoritesGrid:');
                    console.log('- Nodes added:', mutation.addedNodes.length);
                    console.log('- Nodes removed:', mutation.removedNodes.length);
                    console.log('- Current cards count:', favoritesGrid.querySelectorAll('.product-card').length);
                    
                    if (mutation.removedNodes.length > 0 && favoritesGrid.dataset.rendered === 'true') {
                        console.warn('WARNING: Content was removed from rendered grid!');
                        console.log('Removed nodes:', mutation.removedNodes);
                    }
                }
            });
        });
        
        observer.observe(favoritesGrid, {
            childList: true,
            subtree: true
        });
        
        console.log('Content observer setup complete');
    }

    async loadFavorites() {
        const loadingSpinner = document.getElementById('loadingSpinner');
        const favoritesGrid = document.getElementById('favoritesGrid');
        const emptyMessage = document.getElementById('emptyFavoritesMessage');
        const loginMessage = document.getElementById('loginRequiredMessage');
        const favoritesCount = document.getElementById('favoritesCount');

        try {
            console.log('Loading favorites...');
            const apiUrl = `/api/favorites/list`;
            console.log('API URL:', apiUrl);
            
            const response = await fetch(apiUrl, {
                method: 'GET',
                credentials: 'same-origin', // Đảm bảo gửi cookie session
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (response.status === 401) {
                // User not logged in
                console.log('User not logged in');
                loadingSpinner.style.display = 'none';
                loginMessage.style.display = 'block';
                return;
            }

            if (!response.ok) {
                console.error('Response not ok:', response.status, response.statusText);
                throw new Error('Failed to load favorites');
            }

            const responseText = await response.text();
            console.log('Raw response text:', responseText);
            console.log('Response text length:', responseText.length);
            
            const favorites = JSON.parse(responseText);
            console.log('Parsed favorites:', favorites);
            console.log('Favorites array length:', favorites.length);
            console.log('Is array?', Array.isArray(favorites));
            
            // Debug: Log first product to see structure
            if (favorites.length > 0) {
                console.log('First product structure:', favorites[0]);
                console.log('First product keys:', Object.keys(favorites[0]));
            }
            
            if (favorites.length === 0) {
                console.log('No favorites found - showing empty message');
                emptyMessage.style.display = 'block';
                if (favoritesCount) {
                    favoritesCount.textContent = '0 sản phẩm';
                }
            } else {
                console.log('Rendering favorites...');
                
                // Ẩn loading spinner trước khi render
                if (loadingSpinner) {
                    loadingSpinner.style.display = 'none';
                    console.log('Hidden loading spinner');
                }
                
                // Ẩn empty message
                if (emptyMessage) {
                    emptyMessage.style.display = 'none';
                    console.log('Hidden empty message');
                }
                
                // Đảm bảo elements tồn tại
                if (!favoritesGrid) {
                    console.error('favoritesGrid element not found!');
                    if (emptyMessage) emptyMessage.style.display = 'block';
                    return;
                }
                
                try {
                    this.renderFavorites(favorites);
                    
                    // Update count sau khi render thành công
                    if (favoritesCount) {
                        favoritesCount.textContent = `${favorites.length} sản phẩm`;
                    }
                    
                    console.log('Successfully rendered favorites');
                } catch (renderError) {
                    console.error('Error rendering favorites:', renderError);
                    console.error('Render error stack:', renderError.stack);
                    
                    // Fallback: try to render a simple version
                    try {
                        console.log('Attempting fallback rendering...');
                        this.renderFavoritesFallback(favorites);
                        
                        if (favoritesCount) {
                            favoritesCount.textContent = `${favorites.length} sản phẩm`;
                        }
                        
                        console.log('Fallback rendering successful');
                    } catch (fallbackError) {
                        console.error('Fallback rendering also failed:', fallbackError);
                        emptyMessage.style.display = 'block';
                        // Show a user-friendly error message
                        const errorDiv = document.createElement('div');
                        errorDiv.className = 'alert alert-warning';
                        errorDiv.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>Có lỗi khi hiển thị sản phẩm. Vui lòng thử lại.';
                        if (favoritesGrid) {
                            favoritesGrid.innerHTML = '';
                            favoritesGrid.appendChild(errorDiv);
                        }
                    }
                }
            }

        } catch (error) {
            console.error('Error loading favorites:', error);
            loadingSpinner.style.display = 'none';
            emptyMessage.style.display = 'block';
        }
    }

    renderFavorites(favorites) {
        console.log('renderFavorites called with:', favorites);
        const favoritesGrid = document.getElementById('favoritesGrid');
        
        if (!favoritesGrid) {
            console.error('favoritesGrid element not found');
            return;
        }
        
        console.log('Found favoritesGrid element');
        console.log('Current favoritesGrid innerHTML:', favoritesGrid.innerHTML);
        
        try {
            console.log('Starting to generate HTML for', favorites.length, 'products');
            
            const html = favorites.map((product, index) => {
                console.log(`Processing product ${index + 1}/${favorites.length}:`, product);
                console.log('Product imageUrl:', product.imageUrl);
                console.log('Product image_url:', product.image_url);
                console.log('Product category:', product.category);
                console.log('Product price:', product.price);
                console.log('Product name:', product.name);
                console.log('Product id:', product.id);
                
                // Safely get image URL - Backend trả về imageUrl (camelCase) giống cart.jsp
                const imageUrl = product.imageUrl || `${this.baseUrl}/img/logo.png`;
                console.log('Using image URL:', imageUrl);
                console.log('baseUrl:', this.baseUrl);
                
                // Kiểm tra xem imageUrl có tồn tại không
                if (!product.imageUrl) {
                    console.warn('No image URL found for product:', product.name);
                }
                
                // Safely get category - Backend trả về enum, cần convert
                let category = 'Gundam';
                if (product.category) {
                    switch (product.category) {
                        case 'GUNDAM_BANDAI':
                            category = 'Gundam Bandai';
                            break;
                        case 'PRE_ORDER':
                            category = 'Pre-order';
                            break;
                        case 'TOOLS_ACCESSORIES':
                            category = 'Tools & Accessories';
                            break;
                        default:
                            category = product.category;
                    }
                }
                console.log('Using category:', category);
                
                // Safely get price
                const price = this.formatPrice(product.price);
                console.log('Formatted price:', price);
                
                // Safely get name
                const name = product.name || 'Tên sản phẩm';
                console.log('Using name:', name);
                
                // Safely get id
                const id = product.id || 0;
                console.log('Using id:', id);
                
                // Prepare fallback image URL for onerror
                const fallbackImageUrl = `${this.baseUrl}/img/logo.png`;
                
                const cardHtml = `
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 border-0 shadow-sm">
                            <div class="position-relative">
                                <img src="${imageUrl}" 
                                     class="card-img-top product-img" 
                                     alt="${name}"
                                     style="height: 200px; object-fit: cover;"
                                     onerror="this.src='${fallbackImageUrl}';">
                                
                                <!-- Favorite Button -->
                                <button class="btn btn-sm btn-outline-danger favorite-btn position-absolute" 
                                        style="top: 10px; right: 10px; z-index: 10;"
                                        data-product-id="${id}"
                                        title="Xóa khỏi yêu thích">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                            
                            <div class="card-body p-3">
                                <h6 class="card-title mb-2" style="min-height: 2.5rem;">${name}</h6>
                                
                                <div class="mb-2">
                                    <span class="price fw-bold text-primary">${price}₫</span>
                                </div>
                                
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="fas fa-tags me-1"></i>${category}
                                    </small>
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <a href="${this.baseUrl}/product-detail.jsp?id=${id}" 
                                       class="btn btn-sm btn-outline-primary flex-grow-1">
                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                    </a>
                                    <button class="btn btn-sm btn-primary add-to-cart-btn" 
                                            data-product-id="${id}">
                                        <i class="fas fa-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                
                console.log(`Generated HTML for product ${index + 1}, length:`, cardHtml.length);
                return cardHtml;
            }).join('');
            
            console.log('Generated HTML total length:', html.length);
            console.log('Generated HTML preview (first 1000 chars):', html.substring(0, 1000));
            
            // Clear existing content first
            if (favoritesGrid.dataset.rendered === 'true') {
                console.warn('Grid already rendered, skipping clear to prevent data loss');
            } else {
                favoritesGrid.innerHTML = '';
                console.log('Cleared favoritesGrid innerHTML');
            }
            
            // Set new content
            favoritesGrid.innerHTML = html;
            console.log('Successfully set innerHTML');
            console.log('Final favoritesGrid innerHTML length:', favoritesGrid.innerHTML.length);
            
            // PREVENT CLEARING - Add a flag to prevent accidental clearing
            favoritesGrid.dataset.rendered = 'true';
            console.log('Set rendered flag to prevent clearing');
            
            // Verify the content was added
            const cards = favoritesGrid.querySelectorAll('.product-card');
            console.log('Number of product cards found after rendering:', cards.length);
            
            if (cards.length !== favorites.length) {
                console.error('Mismatch: Expected', favorites.length, 'cards but found', cards.length);
            }
            
            // Additional check after 2 seconds
            setTimeout(() => {
                const cardsAfter = favoritesGrid.querySelectorAll('.product-card');
                console.log('Cards still there after 2 seconds:', cardsAfter.length);
                console.log('innerHTML length after 2 seconds:', favoritesGrid.innerHTML.length);
                if (cardsAfter.length === 0) {
                    console.error('CARDS DISAPPEARED! Something cleared the content.');
                    console.error('Current innerHTML:', favoritesGrid.innerHTML);
                }
            }, 2000);
            
        } catch (error) {
            console.error('Error in renderFavorites:', error);
            console.error('Error stack:', error.stack);
            throw error;
        }
   }

    renderFavoritesFallback(favorites) {
        console.log('renderFavoritesFallback called with:', favorites);
        const favoritesGrid = document.getElementById('favoritesGrid');
        
        if (!favoritesGrid) {
            console.error('favoritesGrid element not found in fallback');
            return;
        }
        
        // Clear existing content
        favoritesGrid.innerHTML = '';
        
        // Create simple cards for each product
        favorites.forEach(product => {
            const card = document.createElement('div');
            card.className = 'col-6 col-md-4 col-lg-3';
            
            const productName = product.name || 'Tên sản phẩm';
            const productPrice = this.formatPrice(product.price);
            const productId = product.id;
            const imageUrl = product.imageUrl || `${this.baseUrl}/img/logo.png`;
            const fallbackImageUrl = `${this.baseUrl}/img/logo.png`;
            
            card.innerHTML = `
                <div class="card product-card h-100 border-0 shadow-sm">
                    <div class="position-relative">
                        <img src="${imageUrl}" 
                             class="card-img-top product-img" 
                             alt="${productName}"
                             style="height: 200px; object-fit: cover;"
                             onerror="this.src='${fallbackImageUrl}';">
                        
                        <button class="btn btn-sm btn-outline-danger favorite-btn position-absolute" 
                                style="top: 10px; right: 10px; z-index: 10;"
                                data-product-id="${productId}"
                                title="Xóa khỏi yêu thích">
                            <i class="fas fa-heart"></i>
                        </button>
                    </div>
                    
                    <div class="card-body p-3">
                        <h6 class="card-title mb-2" style="min-height: 2.5rem;">${productName}</h6>
                        
                        <div class="mb-2">
                            <span class="price fw-bold text-primary">${productPrice}₫</span>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <a href="${this.baseUrl}/product-detail.jsp?id=${productId}" 
                               class="btn btn-sm btn-outline-primary flex-grow-1">
                                <i class="fas fa-eye me-1"></i>Chi tiết
                            </a>
                            <button class="btn btn-sm btn-primary add-to-cart-btn" 
                                    data-product-id="${productId}">
                                <i class="fas fa-cart-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            `;
            
            favoritesGrid.appendChild(card);
        });
        
        console.log('Fallback rendering completed');
    }

    async toggleFavorite(productId, button) {
        const originalIcon = button.querySelector('i');
        const originalClass = originalIcon.className;
        
        // Show loading state
        originalIcon.className = 'fas fa-spinner fa-spin';
        button.disabled = true;

        try {
            const response = await fetch(`/api/favorites/toggle/${productId}`, {
                method: 'POST',
                credentials: 'same-origin', // Đảm bảo gửi cookie session
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.status === 401) {
                this.showMessage('Vui lòng đăng nhập để thêm sản phẩm yêu thích', 'warning');
                return;
            }

            if (!response.ok) {
                throw new Error('Failed to toggle favorite');
            }

            const result = await response.json();
            
            if (result.success) {
                if (result.isFavorite) {
                    // Added to favorites
                    originalIcon.className = 'fas fa-heart';
                    button.classList.remove('btn-outline-danger');
                    button.classList.add('btn-danger');
                    button.title = 'Xóa khỏi yêu thích';
                } else {
                    // Removed from favorites - if we're on favorites page, remove the card
                    if (window.location.pathname.includes('favorites.jsp')) {
                        const card = button.closest('.col-6, .col-md-4, .col-lg-3');
                        if (card) {
                            card.remove();
                            this.updateFavoritesCount();
                        }
                    } else {
                        originalIcon.className = 'far fa-heart';
                        button.classList.remove('btn-danger');
                        button.classList.add('btn-outline-danger');
                        button.title = 'Thêm vào yêu thích';
                    }
                }
                
                this.showMessage(result.message, 'success');
            } else {
                throw new Error(result.message || 'Failed to toggle favorite');
            }

        } catch (error) {
            console.error('Error toggling favorite:', error);
            this.showMessage('Có lỗi xảy ra khi thêm/xóa sản phẩm yêu thích', 'error');
            originalIcon.className = originalClass;
        } finally {
            button.disabled = false;
        }
    }

    async checkFavoriteStatus(productId) {
        try {
            const response = await fetch(`/api/favorites/check/${productId}`);
            
            if (response.status === 401) {
                return false;
            }

            if (!response.ok) {
                return false;
            }

            const result = await response.json();
            return result.isFavorite;
        } catch (error) {
            console.error('Error checking favorite status:', error);
            return false;
        }
    }

    updateFavoritesCount() {
        const favoritesGrid = document.getElementById('favoritesGrid');
        const favoritesCount = document.getElementById('favoritesCount');
        const emptyMessage = document.getElementById('emptyFavoritesMessage');
        
        const remainingProducts = favoritesGrid.querySelectorAll('.col-6, .col-md-4, .col-lg-3').length;
        
        if (remainingProducts === 0) {
            emptyMessage.style.display = 'block';
        }
        
        favoritesCount.textContent = `${remainingProducts} sản phẩm`;
    }

    formatPrice(price) {
        console.log('Formatting price:', price, 'Type:', typeof price);
        
        if (price === null || price === undefined) {
            console.log('Price is null/undefined, returning 0');
            return '0';
        }
        
        // Handle BigDecimal object from Java
        if (typeof price === 'object' && price !== null) {
            console.log('Price is object (BigDecimal), converting to string first');
            const priceStr = price.toString();
            console.log('Price string:', priceStr);
            const numPrice = parseFloat(priceStr);
            if (!isNaN(numPrice)) {
                return numPrice.toLocaleString('vi-VN');
            }
        }
        
        if (typeof price === 'number') {
            return price.toLocaleString('vi-VN');
        }
        
        if (typeof price === 'string') {
            const numPrice = parseFloat(price);
            if (!isNaN(numPrice)) {
                return numPrice.toLocaleString('vi-VN');
            }
        }
        
        console.log('Could not format price, returning as is:', price);
        return price || '0';
    }

    showMessage(message, type = 'info') {
        // Create toast notification
        const toastHtml = `
            <div class="toast align-items-center text-white bg-${type === 'success' ? 'success' : type === 'error' ? 'danger' : 'warning'} border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'} me-2"></i>
                        ${message}
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            </div>
        `;

        // Create toast container if it doesn't exist
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        // Add toast to container
        toastContainer.insertAdjacentHTML('beforeend', toastHtml);
        
        // Show toast
        const toastElement = toastContainer.lastElementChild;
        const toast = new bootstrap.Toast(toastElement);
        toast.show();

        // Remove toast element after it's hidden
        toastElement.addEventListener('hidden.bs.toast', () => {
            toastElement.remove();
        });
    }

    // Test method để debug
    testRendering() {
        console.log('Testing rendering...');
        const favoritesGrid = document.getElementById('favoritesGrid');
        
        if (!favoritesGrid) {
            console.error('favoritesGrid element not found');
            return;
        }
        
        console.log('favoritesGrid found, testing simple HTML...');
        
        // Test simple HTML first
        favoritesGrid.innerHTML = `
            <div class="col-12">
                <div class="alert alert-info">
                    <h4>Test rendering working!</h4>
                    <p>This is a test message to check if HTML rendering works.</p>
                </div>
            </div>
        `;
        
        console.log('Test HTML inserted, innerHTML length:', favoritesGrid.innerHTML.length);
        console.log('Test rendering complete');
        
        // Test with mock data after 2 seconds
        setTimeout(() => {
            console.log('Testing with mock data...');
            this.testWithMockData();
        }, 2000);
    }
    
    testWithMockData() {
        const mockData = [
            {
                id: 1,
                name: 'Test Product 1',
                price: 100000,
                imageUrl: 'img/logo.png',
                category: 'GUNDAM_BANDAI'
            },
            {
                id: 2,
                name: 'Test Product 2', 
                price: 200000,
                imageUrl: 'img/logo.png',
                category: 'PRE_ORDER'
            }
        ];
        
        console.log('Rendering mock data:', mockData);
        
        try {
            this.renderFavorites(mockData);
            console.log('Mock data rendered successfully');
        } catch (error) {
            console.error('Error rendering mock data:', error);
            try {
                this.renderFavoritesFallback(mockData);
                console.log('Fallback rendering successful');
            } catch (fallbackError) {
                console.error('Fallback also failed:', fallbackError);
            }
        }
    }
}

// Helper function to add favorite button to product cards
function addFavoriteButton(productId, container) {
    const button = document.createElement('button');
    button.className = 'btn btn-sm btn-outline-danger favorite-btn position-absolute';
    button.style.cssText = 'top: 10px; right: 10px; z-index: 10;';
    button.dataset.productId = productId;
    button.title = 'Thêm vào yêu thích';
    button.innerHTML = '<i class="far fa-heart"></i>';
    
    container.appendChild(button);
    
    // Check if already favorited
    if (window.favoritesManager) {
        window.favoritesManager.checkFavoriteStatus(productId).then(isFavorite => {
            if (isFavorite) {
                button.querySelector('i').className = 'fas fa-heart';
                button.classList.remove('btn-outline-danger');
                button.classList.add('btn-danger');
                button.title = 'Xóa khỏi yêu thích';
            }
        });
    }
}

// Helper function for add to cart
async function addToCart(productId, buttonElement) {
    console.log('Adding to cart:', productId);
    
    // Get the button element that was clicked
    const button = buttonElement || event.target;
    const originalContent = button.innerHTML;
    
    // Show loading state
    button.disabled = true;
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
    
    try {
        const response = await fetch('/api/cart/add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'same-origin',
            body: JSON.stringify({
                productId: Number(productId),
                quantity: 1
            })
        });
        
        const data = await response.json();
        
        if (response.status === 401) {
            // User not logged in
            if (window.favoritesManager) {
                window.favoritesManager.showMessage('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng', 'warning');
            } else {
                alert('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng');
            }
            return;
        }
        
        if (data.success) {
            // Success - show success state
            button.innerHTML = '<i class="fas fa-check"></i>';
            button.classList.add('btn-success');
            button.classList.remove('btn-primary');
            
            // Show success message
            if (window.favoritesManager) {
                window.favoritesManager.showMessage(data.message || 'Đã thêm vào giỏ hàng', 'success');
            }
            
            // Revert button after 2 seconds
            setTimeout(() => {
                button.innerHTML = '<i class="fas fa-cart-plus"></i>';
                button.classList.remove('btn-success');
                button.classList.add('btn-primary');
                button.disabled = false;
            }, 2000);
        } else {
            throw new Error(data.message || 'Không thể thêm vào giỏ hàng');
        }
    } catch (error) {
        console.error('Error adding to cart:', error);
        
        // Show error message
        if (window.favoritesManager) {
            window.favoritesManager.showMessage('Có lỗi xảy ra khi thêm vào giỏ hàng. Vui lòng thử lại!', 'error');
        } else {
            alert('Có lỗi xảy ra khi thêm vào giỏ hàng. Vui lòng thử lại!');
        }
        
        // Revert button
        button.innerHTML = originalContent;
        button.disabled = false;
    }
}

// Initialize FavoritesManager when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing FavoritesManager...');
    
    // Prevent double initialization
    if (window.favoritesManager) {
        console.log('FavoritesManager already exists, skipping initialization');
        return;
    }
    
    window.favoritesManager = new FavoritesManager();
});