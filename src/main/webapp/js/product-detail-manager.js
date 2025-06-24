// Product Detail Manager - Quản lý hiển thị chi tiết sản phẩm từ database
class ProductDetailManager {
    constructor() {
        this.productId = null;
        this.product = null;
        this.relatedProducts = [];
        
        this.init();
    }

    init() {
        console.log('ProductDetailManager initialized');
        
        // Lấy product ID từ URL
        this.productId = this.getProductIdFromURL();
        
        if (this.productId) {
            // Load chi tiết sản phẩm
            this.loadProductDetail();
            
            // Load sản phẩm liên quan
            this.loadRelatedProducts();
        } else {
            console.error('No product ID found in URL');
            this.showProductNotFound();
        }
        
        // Bind events
        this.bindEvents();
    }

    // Lấy product ID từ URL parameters
    getProductIdFromURL() {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get('id');
    }

    // Load chi tiết sản phẩm từ API
    async loadProductDetail() {
        try {
            const response = await fetch(`/api/products/${this.productId}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    this.product = result.data;
                    this.renderProductDetail();
                    this.updatePageTitle();
                } else {
                    console.error('Product not found');
                    this.showProductNotFound();
                }
            } else {
                console.error('Failed to load product details');
                this.showFallbackProduct();
            }
        } catch (error) {
            console.error('Error loading product details:', error);
            this.showFallbackProduct();
        }
    }

    // Load sản phẩm liên quan
    async loadRelatedProducts() {
        try {
            let url = '/api/products/latest?limit=6';
            
            // Nếu có sản phẩm hiện tại, load theo category hoặc grade
            if (this.product) {
                if (this.product.category) {
                    url = `/api/products/category/${this.product.category}?limit=6`;
                } else if (this.product.grade) {
                    url = `/api/products/grade/${this.product.grade}?limit=6`;
                }
            }

            const response = await fetch(url, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    // Loại bỏ sản phẩm hiện tại khỏi danh sách liên quan
                    this.relatedProducts = result.data.filter(p => p.id != this.productId);
                    this.renderRelatedProducts();
                }
            }
        } catch (error) {
            console.error('Error loading related products:', error);
        }
    }    // Render chi tiết sản phẩm
    renderProductDetail() {
        if (!this.product) return;

        // Update breadcrumb
        this.updateBreadcrumb();

        // Update product images
        this.updateProductImages();

        // Update product info
        this.updateProductInfo();

        // Update product description and specifications
        this.updateProductDescription();
        this.updateProductSpecifications();

        // Update meta tags
        this.updateMetaTags();

        // Hide loading state
        this.hideLoadingState();

        // Initialize image gallery
        if (window.initImageGallery) {
            setTimeout(() => window.initImageGallery(), 100);
        }
    }

    // Update breadcrumb
    updateBreadcrumb() {
        const breadcrumbNav = document.getElementById('breadcrumb-nav');
        const breadcrumbProductName = document.getElementById('breadcrumb-product-name');
        
        if (breadcrumbNav) {
            breadcrumbNav.style.display = 'block';
        }
        
        if (breadcrumbProductName && this.product) {
            breadcrumbProductName.textContent = this.product.name;
        }
    }

    // Update product images
    updateProductImages() {
        const mainImage = document.getElementById('main-product-image');
        const thumbnailContainer = document.getElementById('thumbnail-container');

        if (mainImage && this.product) {
            const imageUrl = this.product.imageUrl || '/img/default-gundam.jpg';
            mainImage.src = imageUrl;
            mainImage.alt = this.product.name;
            mainImage.onerror = function() { this.src = '/img/default-gundam.jpg'; };
        }

        // Update thumbnails
        if (thumbnailContainer && this.product) {
            const images = this.product.additionalImages || [this.product.imageUrl];
            const mainImageUrl = this.product.imageUrl || '/img/default-gundam.jpg';
            
            // Always include main image as first thumbnail
            const allImages = [mainImageUrl, ...images.filter(img => img !== mainImageUrl)];
            
            thumbnailContainer.innerHTML = allImages.map((imageUrl, index) => `
                <img src="${imageUrl || '/img/default-gundam.jpg'}" 
                     alt="${this.product.name} - Hình ${index + 1}"
                     class="thumbnail-image ${index === 0 ? 'active' : ''}"
                     onerror="this.src='/img/default-gundam.jpg'">
            `).join('');
        }
    }

    // Update product info
    updateProductInfo() {
        // Product title
        const titleElement = document.getElementById('product-title');
        if (titleElement && this.product) {
            titleElement.textContent = this.product.name;
        }

        // Product meta (badges)
        const metaContainer = document.getElementById('product-meta');
        if (metaContainer && this.product) {
            let metaHTML = '';
            
            // Grade badge
            if (this.product.grade) {
                metaHTML += `<span class="product-grade">${this.product.grade}</span>`;
            }
            
            // Brand badge
            if (this.product.brand) {
                metaHTML += `<span class="product-brand">${this.product.brand}</span>`;
            }
            
            // Stock status
            const stockStatus = this.getStockStatus();
            metaHTML += `<span class="stock-status ${stockStatus.class}">${stockStatus.text}</span>`;
            
            metaContainer.innerHTML = metaHTML;
        }

        // Product price
        const currentPriceElement = document.getElementById('current-price');
        if (currentPriceElement && this.product) {
            currentPriceElement.textContent = this.formatPrice(this.product.price);
        }

        // Old price and discount
        const oldPriceElement = document.getElementById('old-price');
        const discountBadge = document.getElementById('discount-badge');
        
        if (this.product.originalPrice && this.product.originalPrice > this.product.price) {
            const discountPercent = Math.round(((this.product.originalPrice - this.product.price) / this.product.originalPrice) * 100);
            
            if (oldPriceElement) {
                oldPriceElement.textContent = this.formatPrice(this.product.originalPrice);
                oldPriceElement.style.display = 'inline';
            }
            
            if (discountBadge) {
                discountBadge.textContent = `-${discountPercent}%`;
                discountBadge.style.display = 'inline';
            }
        } else {
            if (oldPriceElement) oldPriceElement.style.display = 'none';
            if (discountBadge) discountBadge.style.display = 'none';
        }

        // Product description
        const descriptionElement = document.getElementById('product-description');
        if (descriptionElement && this.product) {
            descriptionElement.textContent = this.product.description || 'Chưa có mô tả cho sản phẩm này.';
        }

        // Quantity selector
        const quantitySelector = document.getElementById('quantity-selector');
        const quantityInput = document.getElementById('quantity-input');
        if (quantitySelector && this.product.stockQuantity > 0) {
            quantitySelector.style.display = 'flex';
            if (quantityInput) {
                quantityInput.setAttribute('max', this.product.stockQuantity);
            }
        }

        // Add to cart button
        const addToCartBtn = document.getElementById('add-to-cart-btn');
        const wishlistBtn = document.getElementById('wishlist-btn');
        
        if (addToCartBtn) {
            if (this.product.stockQuantity > 0) {
                addToCartBtn.disabled = false;
                addToCartBtn.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng';
                addToCartBtn.classList.remove('btn-secondary');
                addToCartBtn.classList.add('btn-primary');
            } else {
                addToCartBtn.disabled = true;
                addToCartBtn.innerHTML = '<i class="fas fa-times me-2"></i>Hết hàng';
                addToCartBtn.classList.remove('btn-primary');
                addToCartBtn.classList.add('btn-secondary');
            }
        }

        if (wishlistBtn) {
            wishlistBtn.style.display = 'block';
        }

        // Specifications table in product info
        const specificationsContainer = document.getElementById('specifications-container');
        const specificationsTable = document.getElementById('specifications-table');
        
        if (specificationsContainer && specificationsTable && this.product) {
            specificationsContainer.style.display = 'block';
            this.renderSpecificationsTable(specificationsTable);
        }
    }

    // Get stock status object
    getStockStatus() {
        if (!this.product) return { class: 'out-of-stock', text: 'Không xác định' };
        
        if (this.product.stockQuantity <= 0) {
            return { class: 'out-of-stock', text: 'Hết hàng' };
        } else if (this.product.stockQuantity <= 5) {
            return { class: 'low-stock', text: `Chỉ còn ${this.product.stockQuantity} sản phẩm` };
        } else {
            return { class: 'in-stock', text: 'Còn hàng' };
        }
    }

    // Render specifications table
    renderSpecificationsTable(tableElement) {
        if (!tableElement || !this.product) return;
        
        const specifications = [
            { label: 'Thương hiệu', value: this.product.brand || 'Bandai' },
            { label: 'Phân loại', value: this.product.grade || 'Model Kit' },
            { label: 'Tỉ lệ', value: this.product.scale || 'N/A' },
            { label: 'Chất liệu', value: this.product.material || 'Nhựa cao cấp' },
            { label: 'Kích thước', value: this.product.dimensions || 'Xem mô tả chi tiết' },
            { label: 'Trọng lượng', value: this.product.weight || 'N/A' },
            { label: 'Mã sản phẩm', value: this.product.sku || this.product.id },
            { label: 'Tình trạng kho', value: this.getStockStatus().text }
        ];
        
        tableElement.innerHTML = specifications.map(spec => `
            <tr>
                <th>${spec.label}</th>
                <td>${spec.value}</td>
            </tr>
        `).join('');
    }    // Update product description and specifications
    updateProductDescription() {
        // Update description tab content
        const descriptionContent = document.getElementById('product-description-content');
        if (descriptionContent && this.product) {
            let descriptionHTML = '';
            
            if (this.product.description) {
                descriptionHTML = `<p class="lead">${this.product.description}</p>`;
            } else {
                descriptionHTML = `<p class="lead">Mô hình lắp ráp ${this.product.name} là sản phẩm cao cấp với thiết kế chi tiết, chất liệu nhựa bền đẹp, phù hợp cho cả người mới và người sưu tầm chuyên nghiệp.</p>`;
            }
            
            descriptionHTML += `
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h6><i class="fas fa-star text-warning me-2"></i>Điểm nổi bật</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-check text-success me-2"></i>Thiết kế chi tiết sắc nét</li>
                            <li><i class="fas fa-check text-success me-2"></i>Chất liệu nhựa cao cấp</li>
                            <li><i class="fas fa-check text-success me-2"></i>Dễ dàng lắp ráp</li>
                            <li><i class="fas fa-check text-success me-2"></i>Hướng dẫn tiếng Việt</li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <h6><i class="fas fa-tools text-primary me-2"></i>Yêu cầu lắp ráp</h6>
                        <ul class="list-unstyled">
                            <li><i class="fas fa-info-circle text-info me-2"></i>Cần có kìm cắt nhựa</li>
                            <li><i class="fas fa-info-circle text-info me-2"></i>Giấy nhám mịn (tuỳ chọn)</li>
                            <li><i class="fas fa-info-circle text-info me-2"></i>Thời gian lắp: 2-4 giờ</li>
                            <li><i class="fas fa-info-circle text-info me-2"></i>Độ khó: ${this.getDifficultyLevel()}</li>
                        </ul>
                    </div>
                </div>
                <div class="alert alert-warning mt-3">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>Lưu ý:</strong> Sản phẩm là mô hình lắp ráp, chưa bao gồm keo dán và màu sơn. Không phù hợp cho trẻ em dưới 8 tuổi.
                </div>
            `;
            
            descriptionContent.innerHTML = descriptionHTML;
        }
    }

    // Update specifications tab
    updateProductSpecifications() {
        const specsTable = document.getElementById('specs-detail-table');
        if (specsTable && this.product) {
            this.renderSpecificationsTable(specsTable.querySelector('tbody'));
        }
    }

    // Get difficulty level based on grade
    getDifficultyLevel() {
        const grade = (this.product.grade || '').toUpperCase();
        switch (grade) {
            case 'HG':
            case 'HIGH GRADE':
                return 'Dễ (★★☆☆☆)';
            case 'RG':
            case 'REAL GRADE':
                return 'Trung bình (★★★☆☆)';
            case 'MG':
            case 'MASTER GRADE':
                return 'Khó (★★★★☆)';
            case 'PG':
            case 'PERFECT GRADE':
                return 'Rất khó (★★★★★)';
            default:
                return 'Trung bình (★★★☆☆)';
        }
    }

    // Render related products
    renderRelatedProducts() {
        const relatedContainer = document.getElementById('related-products-container');
        if (!relatedContainer) return;

        if (this.relatedProducts.length === 0) {
            relatedContainer.innerHTML = `
                <div class="text-center py-4">
                    <i class="fas fa-box-open fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Không có sản phẩm liên quan</p>
                </div>
            `;
            return;
        }

        let relatedHTML = '';
        this.relatedProducts.slice(0, 5).forEach(product => {
            const imageUrl = product.imageUrl || '/img/default-gundam.jpg';
            const stockStatus = product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng';
            const stockClass = product.stockQuantity > 0 ? 'text-success' : 'text-danger';
            
            relatedHTML += `
                <a href="/product-detail.jsp?id=${product.id}" class="related-product-item">
                    <img src="${imageUrl}" alt="${product.name}" class="related-product-img"
                         onerror="this.src='/img/default-gundam.jpg'">
                    <div class="related-product-info">
                        <h6>${product.name}</h6>
                        <div class="related-product-price">${this.formatPrice(product.price)}</div>
                        <small class="${stockClass}">${stockStatus}</small>
                    </div>
                </a>
            `;
        });
        
        relatedContainer.innerHTML = relatedHTML;
    }

    // Update meta tags for SEO
    updateMetaTags() {
        if (!this.product) return;
        
        // Update page title
        document.title = `${this.product.name} - 43 Gundam Hobby`;
        
        // Update meta description
        let metaDescription = document.querySelector('meta[name="description"]');
        if (!metaDescription) {
            metaDescription = document.createElement('meta');
            metaDescription.name = 'description';
            document.head.appendChild(metaDescription);
        }
        metaDescription.content = `${this.product.name} - ${this.product.description || 'Mô hình Gundam chính hãng'} - Giá ${this.formatPrice(this.product.price)} - 43 Gundam Hobby`;
        
        // Update Open Graph tags
        this.updateOpenGraphTags();
    }

    // Update Open Graph tags for social sharing
    updateOpenGraphTags() {
        const ogTitle = document.querySelector('meta[property="og:title"]') || this.createMetaTag('property', 'og:title');
        const ogDescription = document.querySelector('meta[property="og:description"]') || this.createMetaTag('property', 'og:description');
        const ogImage = document.querySelector('meta[property="og:image"]') || this.createMetaTag('property', 'og:image');
        const ogUrl = document.querySelector('meta[property="og:url"]') || this.createMetaTag('property', 'og:url');
        
        ogTitle.content = `${this.product.name} - 43 Gundam Hobby`;
        ogDescription.content = this.product.description || `Mô hình ${this.product.name} - Giá ${this.formatPrice(this.product.price)}`;
        ogImage.content = this.product.imageUrl || '/img/default-gundam.jpg';
        ogUrl.content = window.location.href;
    }

    // Helper to create meta tags
    createMetaTag(attribute, value) {
        const meta = document.createElement('meta');
        meta.setAttribute(attribute, value);
        document.head.appendChild(meta);
        return meta;
    }

    // Bind events
    bindEvents() {
        // Add to cart button
        document.addEventListener('click', (e) => {
            if (e.target.matches('#add-to-cart-btn') || e.target.closest('#add-to-cart-btn')) {
                e.preventDefault();
                this.addToCart();
            }
            
            if (e.target.matches('#wishlist-btn') || e.target.closest('#wishlist-btn')) {
                e.preventDefault();
                this.toggleWishlist();
            }
        });

        // Quantity input validation
        const quantityInput = document.getElementById('quantity-input');
        if (quantityInput) {
            quantityInput.addEventListener('change', (e) => {
                const value = parseInt(e.target.value);
                const max = parseInt(e.target.getAttribute('max')) || 999;
                const min = 1;
                
                if (value < min) e.target.value = min;
                if (value > max) e.target.value = max;
            });
        }
    }

    // Add to cart functionality
    addToCart() {
        if (!this.product || this.product.stockQuantity <= 0) {
            alert('Sản phẩm hiện tại không có sẵn');
            return;
        }

        const quantityInput = document.getElementById('quantity-input');
        const quantity = quantityInput ? parseInt(quantityInput.value) : 1;

        // Implement add to cart logic here
        console.log('Adding to cart:', {
            productId: this.product.id,
            productName: this.product.name,
            price: this.product.price,
            quantity: quantity
        });
        
        // Show success animation
        const btn = document.getElementById('add-to-cart-btn');
        if (btn) {
            const originalHTML = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check me-2"></i>Đã thêm vào giỏ';
            btn.style.backgroundColor = '#28a745';
            btn.disabled = true;
            
            setTimeout(() => {
                btn.innerHTML = originalHTML;
                btn.style.backgroundColor = '';
                btn.disabled = false;
            }, 2000);
        }
        
        // Update cart count in navbar (implement as needed)
        this.updateCartCount();
    }

    // Toggle wishlist
    toggleWishlist() {
        const btn = document.getElementById('wishlist-btn');
        if (!btn) return;
        
        const icon = btn.querySelector('i');
        const isInWishlist = icon.classList.contains('fas');
        
        if (isInWishlist) {
            // Remove from wishlist
            icon.classList.remove('fas');
            icon.classList.add('far');
            btn.innerHTML = '<i class="far fa-heart me-2"></i>Yêu thích';
            console.log('Removed from wishlist:', this.product.id);
        } else {
            // Add to wishlist
            icon.classList.remove('far');
            icon.classList.add('fas');
            btn.innerHTML = '<i class="fas fa-heart me-2"></i>Đã yêu thích';
            console.log('Added to wishlist:', this.product.id);
        }
    }    // Update cart count in navbar
    updateCartCount() {
        // This would typically get the count from localStorage or a backend API
        const cartCount = document.querySelector('.cart-count');
        if (cartCount) {
            const currentCount = parseInt(cartCount.textContent) || 0;
            cartCount.textContent = currentCount + 1;
        }
    }

    // Format price
    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(price);
    }

    // Show product not found
    showProductNotFound() {
        const mainContent = document.querySelector('main.product-detail-container');
        if (mainContent) {
            mainContent.innerHTML = `
                <div class="container">
                    <div class="error-state">
                        <i class="fas fa-exclamation-triangle error-icon"></i>
                        <h3 class="error-message">Sản phẩm không tồn tại</h3>
                        <p class="error-description">Sản phẩm bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="/all-products.jsp" class="btn btn-primary">
                            <i class="fas fa-arrow-left me-2"></i>Xem tất cả sản phẩm
                        </a>
                    </div>
                </div>
            `;
        }
    }

    // Show fallback product
    showFallbackProduct() {
        console.log('Loading fallback static product...');
        // Keep existing static content as fallback
        this.hideLoadingState();
    }

    // Hide loading state
    hideLoadingState() {
        const loadingElement = document.getElementById('product-loading');
        const breadcrumbNav = document.getElementById('breadcrumb-nav');
        const productContent = document.getElementById('product-content');
        const productTabs = document.getElementById('product-tabs');
        
        if (loadingElement) loadingElement.style.display = 'none';
        if (breadcrumbNav) breadcrumbNav.style.display = 'block';
        if (productContent) productContent.style.display = 'block';
        if (productTabs) productTabs.style.display = 'block';
    }
}

// Global function for external access
window.loadProductDetail = function(productId) {
    if (window.productDetailManager) {
        window.productDetailManager.productId = productId;
        window.productDetailManager.loadProductDetail();
    }
};

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Chỉ khởi tạo nếu đang ở trang product-detail
    if (window.location.pathname.includes('product-detail.jsp')) {
        window.productDetailManager = new ProductDetailManager();
    }
});
