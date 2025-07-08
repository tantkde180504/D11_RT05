// Favorites Manager - Quản lý sản phẩm yêu thích

class FavoritesManager {
    constructor() {
        this.baseUrl = window.location.origin + window.location.pathname.substring(0, window.location.pathname.lastIndexOf('/'));
        this.init();
    }

    init() {
        this.loadFavorites();
        this.setupEventListeners();
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
        });
    }

    async loadFavorites() {
        const loadingSpinner = document.getElementById('loadingSpinner');
        const favoritesGrid = document.getElementById('favoritesGrid');
        const emptyMessage = document.getElementById('emptyFavoritesMessage');
        const loginMessage = document.getElementById('loginRequiredMessage');
        const favoritesCount = document.getElementById('favoritesCount');

        try {
            const response = await fetch(`${this.baseUrl}/api/favorites/list`);
            
            if (response.status === 401) {
                // User not logged in
                loadingSpinner.style.display = 'none';
                loginMessage.style.display = 'block';
                return;
            }

            if (!response.ok) {
                throw new Error('Failed to load favorites');
            }

            const favorites = await response.json();
            
            loadingSpinner.style.display = 'none';
            
            if (favorites.length === 0) {
                emptyMessage.style.display = 'block';
                favoritesCount.textContent = '0 sản phẩm';
            } else {
                this.renderFavorites(favorites);
                favoritesCount.textContent = `${favorites.length} sản phẩm`;
            }

        } catch (error) {
            console.error('Error loading favorites:', error);
            loadingSpinner.style.display = 'none';
            emptyMessage.style.display = 'block';
        }
    }

    renderFavorites(favorites) {
        const favoritesGrid = document.getElementById('favoritesGrid');
        
        favoritesGrid.innerHTML = favorites.map(product => `
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card product-card h-100 border-0 shadow-sm">
                    <div class="position-relative">
                        <img src="${product.imageUrl || 'img/placeholder.jpg'}" 
                             class="card-img-top product-img" 
                             alt="${product.name}"
                             style="height: 200px; object-fit: cover;">
                        
                        <!-- Favorite Button -->
                        <button class="btn btn-sm btn-outline-danger favorite-btn position-absolute" 
                                style="top: 10px; right: 10px; z-index: 10;"
                                data-product-id="${product.id}"
                                title="Xóa khỏi yêu thích">
                            <i class="fas fa-heart"></i>
                        </button>
                        
                        <!-- Discount Badge -->
                        ${product.discount ? `<span class="badge bg-danger position-absolute" style="top: 10px; left: 10px;">-${product.discount}%</span>` : ''}
                    </div>
                    
                    <div class="card-body p-3">
                        <h6 class="card-title mb-2" style="min-height: 2.5rem;">${product.name}</h6>
                        
                        <div class="mb-2">
                            <span class="price fw-bold text-primary">${this.formatPrice(product.price)}₫</span>
                            ${product.oldPrice ? `<span class="old-price text-muted text-decoration-line-through ms-2">${this.formatPrice(product.oldPrice)}₫</span>` : ''}
                        </div>
                        
                        <div class="mb-2">
                            <small class="text-muted">
                                <i class="fas fa-tags me-1"></i>${product.category || 'Gundam'}
                            </small>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <a href="${this.baseUrl}/product-detail.jsp?id=${product.id}" 
                               class="btn btn-sm btn-outline-primary flex-grow-1">
                                <i class="fas fa-eye me-1"></i>Chi tiết
                            </a>
                            <button class="btn btn-sm btn-primary" 
                                    onclick="addToCart(${product.id})">
                                <i class="fas fa-cart-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');
    }

    async toggleFavorite(productId, button) {
        const originalIcon = button.querySelector('i');
        const originalClass = originalIcon.className;
        
        // Show loading state
        originalIcon.className = 'fas fa-spinner fa-spin';
        button.disabled = true;

        try {
            const response = await fetch(`${this.baseUrl}/api/favorites/toggle/${productId}`, {
                method: 'POST',
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
            const response = await fetch(`${this.baseUrl}/api/favorites/check/${productId}`);
            
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
        if (typeof price === 'number') {
            return price.toLocaleString('vi-VN');
        }
        return price;
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
}

// Initialize favorites manager when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.favoritesManager = new FavoritesManager();
});

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

// Helper function for add to cart (placeholder)
function addToCart(productId) {
    console.log('Adding to cart:', productId);
    // Implement add to cart functionality
}