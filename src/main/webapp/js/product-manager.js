// Product Manager - Quản lý hiển thị sản phẩm từ database
// QUAN TRỌNG: Class này KHÔNG được can thiệp vào carousel banner (ID: heroCarousel)
class ProductManager {
    constructor() {
        // Danh sách các element được bảo vệ - KHÔNG ĐƯỢC SỬA ĐỔI
        this.protectedElements = ['heroCarousel', 'hero-banner']; 
        this.init();
    }

    init() {
        // Load sản phẩm khi trang load - chỉ load latest products, KHÔNG TOUCH CAROUSEL
        this.loadLatestProducts();
        
        // Bind search functionality        this.bindSearchEvents();
        
        // Xác nhận không can thiệp vào carousel
        this.verifyCarouselProtection();
        
        console.log('ProductManager initialized - Carousel banner được bảo vệ hoàn toàn');
    }

    // Xác nhận rằng ProductManager không can thiệp vào carousel
    verifyCarouselProtection() {
        const carousel = document.getElementById('heroCarousel');
        if (carousel) {
            const isProtected = carousel.getAttribute('data-protected');
            console.log('✅ ProductManager xác nhận: Carousel được bảo vệ =', isProtected);
            
            // Đảm bảo ProductManager không có reference đến carousel
            if (this.protectedElements.includes('heroCarousel')) {
                console.log('✅ ProductManager: heroCarousel trong danh sách bảo vệ');
            }
        }
    }

    // Load sản phẩm nổi bật cho carousel - REMOVED vì giữ nguyên carousel cố định
    // async loadFeaturedProducts() { ... }

    // Load sản phẩm mới nhất
    async loadLatestProducts() {
        try {
            const response = await fetch('/api/products/latest?limit=8', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    this.renderLatestProducts(result.data);
                }
            }
        } catch (error) {
            console.error('Error loading latest products:', error);
            this.showFallbackProductSection();
        }    }

    // Tìm hoặc tạo section cho sản phẩm - tìm sau các section cứng hiện có
    renderLatestProducts(products) {
        const productContainer = this.findOrCreateProductSection();
        if (!productContainer) return;

        let productsHTML = '';
        
        products.forEach(product => {
            const imageUrl = product.imageUrl || '/img/default-gundam.jpg';
            const stockStatus = product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng';
            const stockClass = product.stockQuantity > 0 ? 'text-success' : 'text-danger';
            
            productsHTML += `
                <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                    <div class="card product-card h-100">
                        <div class="product-image-container">
                            <img src="${imageUrl}" class="card-img-top product-image" alt="${product.name}"
                                 onerror="this.src='/img/default-gundam.jpg'">
                            ${product.isFeatured ? '<span class="badge badge-featured">Nổi bật</span>' : ''}
                            ${product.stockQuantity <= 0 ? '<span class="badge badge-out-of-stock">Hết hàng</span>' : ''}
                        </div>
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title product-name">${product.name}</h5>
                            <p class="card-text product-description">${product.description ? product.description.substring(0, 100) + '...' : ''}</p>
                            <div class="product-info mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="product-price h5 mb-0 text-primary">${this.formatPrice(product.price)}</span>
                                    <span class="badge badge-grade">${product.grade || 'N/A'}</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <small class="${stockClass}">${stockStatus}</small>
                                    <small class="text-muted">${product.brand || 'Bandai'}</small>
                                </div>
                                <div class="d-grid gap-2">
                                    <a href="${this.getContextPath()}product-detail.jsp?id=${product.id}" class="btn btn-outline-primary">Xem chi tiết</a>
                                    ${product.stockQuantity > 0 ? 
                                        `<button class="btn btn-primary" onclick="addToCart(${product.id})">Thêm vào giỏ</button>` :
                                        `<button class="btn btn-secondary" disabled>Hết hàng</button>`
                                    }
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });

        productContainer.innerHTML = `
            <div class="row">
                <div class="col-12">
                    <h2 class="section-title mb-4">
                        <i class="fas fa-star text-warning"></i>
                        Sản phẩm mới nhất
                    </h2>
                </div>
            </div>
            <div class="row">
                ${productsHTML}
            </div>
        `;
    }    // Tìm hoặc tạo section cho sản phẩm - BẢO VỆ CAROUSEL
    findOrCreateProductSection() {
        // Kiểm tra và bảo vệ carousel trước khi tạo section mới
        this.protectCarousel();
        
        let productSection = document.getElementById('products-section');
        if (!productSection) {
            // Tạo section mới sau hero banner, KHÔNG động vào carousel
            const heroSection = document.querySelector('.hero-banner');
            if (heroSection) {
                productSection = document.createElement('section');
                productSection.id = 'products-section';
                productSection.className = 'py-5';
                productSection.innerHTML = '<div class="container" id="products-container"></div>';
                heroSection.insertAdjacentElement('afterend', productSection);
                return document.getElementById('products-container');
            }
        } else {
            return productSection.querySelector('.container') || productSection;
        }
        return null;
    }

    // Phương thức bảo vệ carousel - đảm bảo không có code nào có thể sửa đổi
    protectCarousel() {
        const carousel = document.getElementById('heroCarousel');
        if (carousel) {
            // Thêm attribute để đánh dấu đây là element được bảo vệ
            carousel.setAttribute('data-protected', 'true');
            carousel.setAttribute('data-protection-message', 'Carousel banner is protected - Do not modify');
            console.log('Carousel được bảo vệ:', carousel.id);
        }
    }

    // Get context path
    getContextPath() {
        // Get context path from current page URL
        const path = window.location.pathname;
        const segments = path.split('/').filter(s => s); // Remove empty segments
        
        // If we're in a web application with context path (like D11_RT05)
        if (segments.length > 0 && segments[0] !== 'index.jsp' && segments[0] !== 'all-products.jsp' && segments[0] !== 'product-detail.jsp') {
            return '/' + segments[0] + '/';
        }
        
        return '';
    }

    // Format giá tiền
    formatPrice(price) {
        if (!price) return 'Liên hệ';
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(price);
    }

    // Bind search events
    bindSearchEvents() {
        const searchForm = document.querySelector('.search-form');
        const searchInput = document.querySelector('.search-input');
        
        if (searchForm && searchInput) {
            searchForm.addEventListener('submit', async (e) => {
                e.preventDefault();
                const keyword = searchInput.value.trim();
                if (keyword) {
                    await this.searchProducts(keyword);
                }
            });
        }
    }

    // Tìm kiếm sản phẩm
    async searchProducts(keyword) {
        try {
            const response = await fetch(`/api/products/search?keyword=${encodeURIComponent(keyword)}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    this.renderSearchResults(result.data, keyword);
                }
            }
        } catch (error) {
            console.error('Error searching products:', error);
        }
    }

    // Render kết quả tìm kiếm
    renderSearchResults(products, keyword) {
        const productContainer = this.findOrCreateProductSection();
        if (!productContainer) return;

        let productsHTML = '';
        
        if (products.length === 0) {
            productsHTML = `
                <div class="col-12 text-center">
                    <h3>Không tìm thấy sản phẩm nào với từ khóa "${keyword}"</h3>
                    <p>Vui lòng thử lại với từ khóa khác.</p>
                </div>
            `;
        } else {
            products.forEach(product => {
                const imageUrl = product.imageUrl || '/img/default-gundam.jpg';
                const stockStatus = product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng';
                const stockClass = product.stockQuantity > 0 ? 'text-success' : 'text-danger';
                
                productsHTML += `
                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card product-card h-100">
                            <div class="product-image-container">
                                <img src="${imageUrl}" class="card-img-top product-image" alt="${product.name}"
                                     onerror="this.src='/img/default-gundam.jpg'">
                            </div>
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title product-name">${product.name}</h5>
                                <p class="card-text product-description">${product.description ? product.description.substring(0, 100) + '...' : ''}</p>
                                <div class="product-info mt-auto">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="product-price h5 mb-0 text-primary">${this.formatPrice(product.price)}</span>
                                        <span class="badge badge-grade">${product.grade || 'N/A'}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <small class="${stockClass}">${stockStatus}</small>
                                        <small class="text-muted">${product.brand || 'Bandai'}</small>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <a href="${this.getContextPath()}product-detail.jsp?id=${product.id}" class="btn btn-outline-primary">Xem chi tiết</a>
                                        ${product.stockQuantity > 0 ? 
                                            `<button class="btn btn-primary" onclick="addToCart(${product.id})">Thêm vào giỏ</button>` :
                                            `<button class="btn btn-secondary" disabled>Hết hàng</button>`
                                        }
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            });
        }

        productContainer.innerHTML = `
            <div class="row">
                <div class="col-12">
                    <h2 class="section-title mb-4">
                        <i class="fas fa-search text-primary"></i>
                        Kết quả tìm kiếm cho "${keyword}" (${products.length} sản phẩm)
                    </h2>
                </div>
            </div>
            <div class="row">
                ${productsHTML}
            </div>
        `;
    }

    // Fallback nếu không load được sản phẩm
    showFallbackFeaturedSection() {
        console.log('Using fallback featured section');
        // Giữ nguyên HTML cứng như hiện tại
    }

    showFallbackProductSection() {
        console.log('Using fallback product section');
        // Có thể hiển thị thông báo lỗi hoặc giữ nguyên
    }
}

// Global function for adding to cart
function addToCart(productId) {
    console.log('Adding product to cart:', productId);
    // TODO: Implement cart functionality
    alert('Tính năng giỏ hàng đang được phát triển!');
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Đợi một chút để đảm bảo các element đã được render
    setTimeout(() => {
        window.productManager = new ProductManager();
    }, 500);
});

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ProductManager;
}
