// All Products Manager - Quản lý hiển thị và lọc sản phẩm cho trang all-products.jsp
class AllProductsManager {
    constructor() {
        this.currentPage = 1;
        this.itemsPerPage = 12;
        this.currentFilters = {
            category: [],
            grade: [],
            brand: [],
            minPrice: 0,
            maxPrice: 5000000,
            sortBy: 'latest'
        };
        this.allProducts = [];
        this.filteredProducts = [];
        
        this.init();
    }

    init() {
        console.log('AllProductsManager initialized');
        
        // Load tất cả sản phẩm
        this.loadAllProducts();
        
        // Bind filter events
        this.bindFilterEvents();
        
        // Bind sort events
        this.bindSortEvents();
          // Bind pagination events
        this.bindPaginationEvents();
        
        // Bind search functionality
        this.bindSearchEvents();
    }

    // Load tất cả sản phẩm từ API
    async loadAllProducts() {
        try {
            const response = await fetch('/api/products?limit=100', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success) {
                    this.allProducts = result.data;
                    this.filteredProducts = [...this.allProducts];
                    this.renderProducts();
                    this.updateProductCount();
                }
            } else {
                console.error('Failed to load products');
                this.showFallbackProducts();
            }
        } catch (error) {
            console.error('Error loading products:', error);
            this.showFallbackProducts();
        }
    }

    // Render sản phẩm lên grid
    renderProducts() {
        const productGrid = document.querySelector('.row.g-3');
        if (!productGrid) return;

        // Tính toán pagination
        const startIndex = (this.currentPage - 1) * this.itemsPerPage;
        const endIndex = startIndex + this.itemsPerPage;
        const productsToShow = this.filteredProducts.slice(startIndex, endIndex);

        let productsHTML = '';
        
        productsToShow.forEach(product => {
            const imageUrl = product.imageUrl || '/img/default-gundam.jpg';
            const stockStatus = product.stockQuantity > 0 ? 'Còn hàng' : 'Hết hàng';
            const stockClass = product.stockQuantity > 0 ? 'text-success' : 'text-danger';
            
            // Tính discount nếu có
            let discountHTML = '';
            if (product.originalPrice && product.originalPrice > product.price) {
                const discountPercent = Math.round(((product.originalPrice - product.price) / product.originalPrice) * 100);
                discountHTML = `
                    <span class="old-price ms-2">${this.formatPrice(product.originalPrice)}</span>
                    <span class="discount-badge ms-2">-${discountPercent}%</span>
                `;
            }
            
            productsHTML += `
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="card product-card h-100 border-0 shadow-sm">
                        <img src="${imageUrl}" class="card-img-top product-img" alt="${product.name}"
                             onerror="this.src='/img/default-gundam.jpg'">
                        <div class="card-body p-2">
                            <h6 class="card-title mb-1">${product.name}</h6>
                            <div class="mb-1">
                                <span class="price">${this.formatPrice(product.price)}</span>
                                ${discountHTML}
                            </div>
                            <div class="mb-2">
                                <small class="${stockClass}">${stockStatus}</small>
                                ${product.grade ? `<span class="badge bg-secondary ms-2">${product.grade}</span>` : ''}
                            </div>
                            <a href="${this.getContextPath()}product-detail.jsp?id=${product.id}" class="btn btn-sm btn-outline-primary w-100">Xem chi tiết</a>
                        </div>
                    </div>
                </div>
            `;
        });

        productGrid.innerHTML = productsHTML;
        
        // Update pagination
        this.renderPagination();
    }

    // Bind filter events
    bindFilterEvents() {
        // Grade filters
        const gradeFilters = ['filterHG', 'filterMG', 'filterRG', 'filterPG'];
        gradeFilters.forEach(filterId => {
            const filterElement = document.getElementById(filterId);
            if (filterElement) {
                filterElement.addEventListener('change', () => this.updateFilters());
            }
        });

        // Brand filters
        const brandFilters = ['filterBandai', 'filterKhac'];
        brandFilters.forEach(filterId => {
            const filterElement = document.getElementById(filterId);
            if (filterElement) {
                filterElement.addEventListener('change', () => this.updateFilters());
            }
        });

        // Price range filter
        const priceRange = document.querySelector('.form-range');
        if (priceRange) {
            priceRange.addEventListener('input', (e) => {
                this.currentFilters.maxPrice = parseInt(e.target.value);
                this.updateFilters();
            });
        }
    }

    // Bind sort events
    bindSortEvents() {
        const sortSelect = document.querySelector('.form-select');
        if (sortSelect) {
            sortSelect.addEventListener('change', (e) => {
                const sortValue = e.target.selectedIndex;
                switch(sortValue) {
                    case 0: this.currentFilters.sortBy = 'latest'; break;
                    case 1: this.currentFilters.sortBy = 'price_asc'; break;
                    case 2: this.currentFilters.sortBy = 'price_desc'; break;
                    case 3: this.currentFilters.sortBy = 'popular'; break;
                }
                this.applyFilters();
            });
        }
    }

    // Update filters based on checkboxes
    updateFilters() {
        // Reset filters
        this.currentFilters.grade = [];
        this.currentFilters.brand = [];

        // Grade filters
        if (document.getElementById('filterHG')?.checked) this.currentFilters.grade.push('HG');
        if (document.getElementById('filterMG')?.checked) this.currentFilters.grade.push('MG');
        if (document.getElementById('filterRG')?.checked) this.currentFilters.grade.push('RG');
        if (document.getElementById('filterPG')?.checked) this.currentFilters.grade.push('PG');

        // Brand filters
        if (document.getElementById('filterBandai')?.checked) this.currentFilters.brand.push('Bandai');
        if (document.getElementById('filterKhac')?.checked) this.currentFilters.brand.push('Khác');

        this.applyFilters();
    }    // Apply all filters
    applyFilters() {
        // Start with all products or current search results
        const searchInput = document.querySelector('.search-input');
        const searchQuery = searchInput ? searchInput.value.trim() : '';
        
        if (searchQuery) {
            // Filter by search first
            this.filteredProducts = this.allProducts.filter(product => {
                return product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                       (product.description && product.description.toLowerCase().includes(searchQuery.toLowerCase())) ||
                       (product.grade && product.grade.toLowerCase().includes(searchQuery.toLowerCase())) ||
                       (product.brand && product.brand.toLowerCase().includes(searchQuery.toLowerCase()));
            });
        } else {
            this.filteredProducts = [...this.allProducts];
        }

        // Apply other filters
        this.filteredProducts = this.filteredProducts.filter(product => {
            // Grade filter
            if (this.currentFilters.grade.length > 0) {
                if (!this.currentFilters.grade.includes(product.grade)) {
                    return false;
                }
            }

            // Brand filter
            if (this.currentFilters.brand.length > 0) {
                const productBrand = product.brand || 'Bandai';
                if (!this.currentFilters.brand.includes(productBrand)) {
                    return false;
                }
            }

            // Price filter
            if (product.price > this.currentFilters.maxPrice) {
                return false;
            }

            return true;
        });

        // Apply sorting
        this.applySorting();

        // Reset to first page
        this.currentPage = 1;
        
        // Re-render
        this.renderProducts();
        this.updateProductCount();
    }

    // Apply sorting
    applySorting() {
        switch(this.currentFilters.sortBy) {
            case 'price_asc':
                this.filteredProducts.sort((a, b) => a.price - b.price);
                break;
            case 'price_desc':
                this.filteredProducts.sort((a, b) => b.price - a.price);
                break;
            case 'popular':
                this.filteredProducts.sort((a, b) => (b.soldCount || 0) - (a.soldCount || 0));
                break;
            case 'latest':
            default:
                this.filteredProducts.sort((a, b) => new Date(b.createdDate || 0) - new Date(a.createdDate || 0));
                break;
        }
    }

    // Render pagination
    renderPagination() {
        const totalPages = Math.ceil(this.filteredProducts.length / this.itemsPerPage);
        const paginationContainer = document.querySelector('.pagination');
        
        if (!paginationContainer || totalPages <= 1) {
            if (paginationContainer) paginationContainer.parentElement.style.display = 'none';
            return;
        }

        paginationContainer.parentElement.style.display = 'block';

        let paginationHTML = '';
        
        // Previous button
        paginationHTML += `
            <li class="page-item ${this.currentPage === 1 ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="${this.currentPage - 1}">&laquo;</a>
            </li>
        `;

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= this.currentPage - 2 && i <= this.currentPage + 2)) {
                paginationHTML += `
                    <li class="page-item ${i === this.currentPage ? 'active' : ''}">
                        <a class="page-link" href="#" data-page="${i}">${i}</a>
                    </li>
                `;
            } else if (i === this.currentPage - 3 || i === this.currentPage + 3) {
                paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
        }

        // Next button
        paginationHTML += `
            <li class="page-item ${this.currentPage === totalPages ? 'disabled' : ''}">
                <a class="page-link" href="#" data-page="${this.currentPage + 1}">&raquo;</a>
            </li>
        `;

        paginationContainer.innerHTML = paginationHTML;
    }

    // Bind pagination events
    bindPaginationEvents() {
        document.addEventListener('click', (e) => {
            if (e.target.matches('.pagination .page-link')) {
                e.preventDefault();
                const page = parseInt(e.target.dataset.page);
                if (page && page !== this.currentPage) {
                    this.currentPage = page;
                    this.renderProducts();
                    
                    // Scroll to top of products
                    document.querySelector('.col-lg-9').scrollIntoView({ behavior: 'smooth' });
                }
            }
        });
    }

    // Update product count display
    updateProductCount() {
        const countElement = document.querySelector('.h4.fw-bold');
        if (countElement) {
            countElement.textContent = `Tất cả sản phẩm (${this.filteredProducts.length})`;
        }
    }

    // Format price
    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(price);
    }    // Show fallback products nếu API fail
    showFallbackProducts() {
        console.log('Loading fallback static products...');
        // Keep existing static products as fallback
        
        // Hide loading indicator
        const loadingElement = document.getElementById('products-loading');
        if (loadingElement) {
            loadingElement.style.display = 'none';
        }
    }

    // Bind search events
    bindSearchEvents() {
        const searchForm = document.querySelector('.search-form');
        const searchInput = document.querySelector('.search-input');
        
        if (searchForm && searchInput) {
            // Prevent form submission
            searchForm.addEventListener('submit', (e) => {
                e.preventDefault();
                this.performSearch(searchInput.value.trim());
            });
            
            // Real-time search
            let searchTimeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.performSearch(e.target.value.trim());
                }, 300);
            });
        }
    }

    // Perform search
    performSearch(query) {
        if (!query) {
            // Show all products if search is empty
            this.filteredProducts = [...this.allProducts];
        } else {
            // Filter products based on search query
            this.filteredProducts = this.allProducts.filter(product => {
                return product.name.toLowerCase().includes(query.toLowerCase()) ||
                       (product.description && product.description.toLowerCase().includes(query.toLowerCase())) ||
                       (product.grade && product.grade.toLowerCase().includes(query.toLowerCase())) ||
                       (product.brand && product.brand.toLowerCase().includes(query.toLowerCase()));
            });
        }
        
        // Apply other active filters
        this.applyCurrentFilters();
        
        // Reset to first page
        this.currentPage = 1;
        
        // Re-render
        this.renderProducts();
        this.updateProductCount();
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

    // Apply current filters to already filtered products
    applyCurrentFilters() {
        let products = [...this.filteredProducts];
        
        // Grade filter
        if (this.currentFilters.grade.length > 0) {
            products = products.filter(product => 
                this.currentFilters.grade.includes(product.grade)
            );
        }

        // Brand filter
        if (this.currentFilters.brand.length > 0) {
            products = products.filter(product => {
                const productBrand = product.brand || 'Bandai';
                return this.currentFilters.brand.includes(productBrand);
            });
        }

        // Price filter
        products = products.filter(product => 
            product.price <= this.currentFilters.maxPrice
        );

        this.filteredProducts = products;
        
        // Apply sorting
        this.applySorting();
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Chỉ khởi tạo nếu đang ở trang all-products
    if (window.location.pathname.includes('all-products.jsp')) {
        window.allProductsManager = new AllProductsManager();
    }
});
