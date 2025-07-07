/**
 * Enhanced Search Autocomplete Handler
 * Provides search history, product previews, and suggestions functionality
 */

class SearchAutocompleteHandler {
    constructor(options = {}) {
        this.searchInputId = options.searchInputId || 'headerSearchInput';
        this.suggestionsContainerId = options.suggestionsContainerId || 'headerSearchSuggestions';
        this.formId = options.formId || 'headerSearchForm';
        this.apiEndpoint = options.apiEndpoint || '/search/suggestions';
        this.productSearchEndpoint = options.productSearchEndpoint || '/search/api';
        this.minQueryLength = options.minQueryLength || 1;
        this.debounceDelay = options.debounceDelay || 300;
        this.maxSuggestions = options.maxSuggestions || 6;
        this.maxProducts = options.maxProducts || 4;
        this.maxHistory = options.maxHistory || 5;
        
        this.searchInput = null;
        this.suggestionsContainer = null;
        this.searchForm = null;
        this.searchTimeout = null;
        this.searchHistory = this.loadSearchHistory();
        this.popularKeywords = [
            'Gundam', 'RG Strike', 'MG Freedom', 'HG Barbatos', 'PG Unicorn',
            'Wing Zero', 'Nu Gundam', 'Sazabi', 'Strike Freedom', 'Destiny'
        ];
        
        this.init();
    }

    init() {
        this.searchInput = document.getElementById(this.searchInputId);
        this.suggestionsContainer = document.getElementById(this.suggestionsContainerId);
        this.searchForm = document.getElementById(this.formId);

        if (!this.searchInput || !this.suggestionsContainer) {
            console.warn('Search autocomplete: Required elements not found');
            return;
        }

        this.bindEvents();
        console.log('Search autocomplete initialized');
    }

    bindEvents() {
        // Input event for typing
        this.searchInput.addEventListener('input', (e) => {
            this.handleInput(e.target.value);
        });

        // Blur event to hide suggestions
        this.searchInput.addEventListener('blur', () => {
            setTimeout(() => this.hideSuggestions(), 200);
        });

        // Focus event to show history and popular keywords
        this.searchInput.addEventListener('focus', () => {
            const query = this.searchInput.value.trim();
            if (query.length === 0) {
                this.showHistoryAndPopular();
            } else if (query.length >= this.minQueryLength) {
                this.fetchCombinedSuggestions(query);
            }
        });

        // Keydown event for navigation
        this.searchInput.addEventListener('keydown', (e) => {
            this.handleKeyNavigation(e);
        });

        // Form submission - save to history
        if (this.searchForm) {
            this.searchForm.addEventListener('submit', (e) => {
                const activeSuggestion = this.suggestionsContainer.querySelector('.suggestion-item.active');
                if (activeSuggestion) {
                    e.preventDefault();
                    const isProduct = activeSuggestion.dataset.type === 'product';
                    if (isProduct) {
                        // Navigate to product detail
                        const productId = activeSuggestion.dataset.productId;
                        window.location.href = this.getContextPath() + 'product-detail.jsp?id=' + productId;
                        return;
                    } else {
                        // Use suggestion text for search
                        const suggestionText = activeSuggestion.textContent.trim().replace(/^\w+\s+/, ''); // Remove icon text
                        this.searchInput.value = suggestionText;
                        this.saveToHistory(suggestionText);
                        this.hideSuggestions();
                        // Continue with form submission
                    }
                } else {
                    // Normal form submission - save search query
                    const query = this.searchInput.value.trim();
                    if (query) {
                        this.saveToHistory(query);
                    }
                }
                // Let the form submit normally for search results page
            });
        }
    }

    handleInput(value) {
        const query = value.trim();
        
        clearTimeout(this.searchTimeout);
        
        if (query.length === 0) {
            this.showHistoryAndPopular();
        } else if (query.length >= this.minQueryLength) {
            this.searchTimeout = setTimeout(() => {
                this.fetchCombinedSuggestions(query);
            }, this.debounceDelay);
        } else {
            this.hideSuggestions();
        }
    }

    handleKeyNavigation(e) {
        const suggestions = this.suggestionsContainer.querySelectorAll('.suggestion-item');
        const activeSuggestion = this.suggestionsContainer.querySelector('.suggestion-item.active');
        
        switch (e.key) {
            case 'ArrowDown':
                e.preventDefault();
                this.navigateDown(suggestions, activeSuggestion);
                break;
            case 'ArrowUp':
                e.preventDefault();
                this.navigateUp(suggestions, activeSuggestion);
                break;
            case 'Enter':
                if (activeSuggestion) {
                    e.preventDefault();
                    const isProduct = activeSuggestion.dataset.type === 'product';
                    if (isProduct) {
                        // Navigate to product detail
                        const productId = activeSuggestion.dataset.productId;
                        window.location.href = this.getContextPath() + 'product-detail.jsp?id=' + productId;
                    } else {
                        // Use data-text attribute if available, otherwise extract from textContent
                        let suggestionText = activeSuggestion.dataset.text || activeSuggestion.textContent.trim();
                        // Remove icon characters and extra spaces
                        suggestionText = suggestionText.replace(/^[\u{1F300}-\u{1F9FF}]|\s*[\u{2600}-\u{26FF}]|\s*[\u{2700}-\u{27BF}]/gu, '').trim();
                        if (!suggestionText && activeSuggestion.textContent) {
                            // Fallback: try to extract meaningful text
                            suggestionText = activeSuggestion.textContent.replace(/^\s*[\w\s]*?\s+/, '').trim();
                        }
                        if (suggestionText) {
                            this.selectSuggestion(suggestionText);
                        }
                    }
                }
                break;
            case 'Escape':
                this.hideSuggestions();
                this.searchInput.blur();
                break;
        }
    }

    navigateDown(suggestions, activeSuggestion) {
        if (!suggestions.length) return;

        if (!activeSuggestion) {
            suggestions[0].classList.add('active');
        } else {
            activeSuggestion.classList.remove('active');
            const nextIndex = Array.from(suggestions).indexOf(activeSuggestion) + 1;
            if (nextIndex < suggestions.length) {
                suggestions[nextIndex].classList.add('active');
            } else {
                suggestions[0].classList.add('active');
            }
        }
    }

    navigateUp(suggestions, activeSuggestion) {
        if (!suggestions.length) return;

        if (!activeSuggestion) {
            suggestions[suggestions.length - 1].classList.add('active');
        } else {
            activeSuggestion.classList.remove('active');
            const prevIndex = Array.from(suggestions).indexOf(activeSuggestion) - 1;
            if (prevIndex >= 0) {
                suggestions[prevIndex].classList.add('active');
            } else {
                suggestions[suggestions.length - 1].classList.add('active');
            }
        }
    }

    async fetchCombinedSuggestions(query) {
        try {
            const contextPath = this.getContextPath();
            console.log('Context path:', contextPath);
            console.log('Fetching suggestions for query:', query);
            
            // Fetch both suggestions and products in parallel
            const suggestionsUrl = `${contextPath}${this.apiEndpoint}?q=${encodeURIComponent(query)}`;
            const productsUrl = `${contextPath}${this.productSearchEndpoint}?q=${encodeURIComponent(query)}&size=${this.maxProducts}`;
            
            console.log('Suggestions URL:', suggestionsUrl);
            console.log('Products URL:', productsUrl);
            
            const [suggestionsResponse, productsResponse] = await Promise.all([
                fetch(suggestionsUrl),
                fetch(productsUrl)
            ]);
            
            let suggestions = [];
            let products = [];
            
            // Get keyword suggestions
            if (suggestionsResponse.ok) {
                const suggestionsData = await suggestionsResponse.json();
                console.log('Suggestions response:', suggestionsData);
                if (suggestionsData.success && suggestionsData.suggestions) {
                    suggestions = suggestionsData.suggestions.slice(0, this.maxSuggestions);
                }
            } else {
                console.warn('Suggestions API failed:', suggestionsResponse.status);
            }
            
            // Get product results
            if (productsResponse.ok) {
                const productsData = await productsResponse.json();
                console.log('Products API response:', productsData); // Debug log
                if (productsData.success && productsData.products) {
                    products = productsData.products.slice(0, this.maxProducts);
                    console.log('Found products for autocomplete:', products.length);
                }
            } else {
                console.warn('Products API failed:', productsResponse.status);
            }
            
            if (suggestions.length > 0 || products.length > 0) {
                console.log('Showing combined suggestions - keywords:', suggestions.length, 'products:', products.length);
                this.showCombinedSuggestions(suggestions, products, query);
            } else {
                console.log('No suggestions or products found');
                this.hideSuggestions();
            }
        } catch (error) {
            console.error('Error fetching suggestions:', error);
            this.hideSuggestions();
        }
    }

    showHistoryAndPopular() {
        const historyItems = this.searchHistory.slice(0, this.maxHistory);
        const popularItems = this.popularKeywords.slice(0, 6);
        
        let html = '';
        
        // Show search history
        if (historyItems.length > 0) {
            html += '<div class="suggestion-section">';
            html += '<div class="suggestion-header">Tìm kiếm gần đây</div>';
            historyItems.forEach(item => {
                html += `<div class="suggestion-item history-item" data-type="history" data-text="${this.escapeHtml(item)}">
                    <i class="fas fa-history me-2"></i>${this.escapeHtml(item)}
                    <span class="remove-history" onclick="event.stopPropagation(); searchAutocomplete.removeFromHistory('${this.escapeHtml(item)}')">
                        <i class="fas fa-times"></i>
                    </span>
                </div>`;
            });
            html += '</div>';
        }
        
        // Show popular keywords
        if (popularItems.length > 0) {
            html += '<div class="suggestion-section">';
            html += '<div class="suggestion-header">Từ khóa phổ biến</div>';
            popularItems.forEach(item => {
                html += `<div class="suggestion-item popular-item" data-type="popular" data-text="${this.escapeHtml(item)}">
                    <i class="fas fa-fire me-2"></i>${this.escapeHtml(item)}
                </div>`;
            });
            html += '</div>';
        }
        
        if (html) {
            this.suggestionsContainer.innerHTML = html;
            this.suggestionsContainer.style.display = 'block';
            this.bindSuggestionEvents();
        } else {
            this.hideSuggestions();
        }
    }

    showCombinedSuggestions(suggestions, products, query) {
        let html = '';
        
        // Show matching products first
        if (products.length > 0) {
            html += '<div class="suggestion-section">';
            html += '<div class="suggestion-header">Sản phẩm tìm thấy</div>';
            products.forEach(product => {
                const imageUrl = product.imageUrl || `${this.getContextPath()}/img/placeholder.jpg`;
                const categoryDisplay = product.category ? product.category.replace(/_/g, ' ') : '';
                const gradeDisplay = product.grade || '';
                const price = this.formatPrice(product.price);
                
                html += `<div class="suggestion-item product-item" data-type="product" data-product-id="${product.id}">
                    <div class="product-suggestion">
                        <img src="${imageUrl}" alt="${this.escapeHtml(product.name)}" class="product-thumb" 
                             onerror="this.src='${this.getContextPath()}/img/placeholder.jpg'">
                        <div class="product-info">
                            <div class="product-name">${this.highlightMatch(product.name, query)}</div>
                            <div class="product-meta">
                                <span class="product-category">${categoryDisplay}</span>
                                ${gradeDisplay ? `<span class="product-grade">${gradeDisplay}</span>` : ''}
                            </div>
                            <div class="product-price">${price}</div>
                        </div>
                    </div>
                </div>`;
            });
            html += '</div>';
        }
        
        // Show keyword suggestions
        if (suggestions.length > 0) {
            html += '<div class="suggestion-section">';
            html += '<div class="suggestion-header">Gợi ý tìm kiếm</div>';
            suggestions.forEach(suggestion => {
                html += `<div class="suggestion-item keyword-item" data-type="keyword" data-text="${this.escapeHtml(suggestion)}">
                    <i class="fas fa-search me-2"></i>${this.highlightMatch(suggestion, query)}
                </div>`;
            });
            html += '</div>';
        }
        
        if (html) {
            this.suggestionsContainer.innerHTML = html;
            this.suggestionsContainer.style.display = 'block';
            this.bindSuggestionEvents();
        } else {
            this.hideSuggestions();
        }
    }

    bindSuggestionEvents() {
        // Add click events for mouse interaction
        this.suggestionsContainer.querySelectorAll('.suggestion-item').forEach(item => {
            item.addEventListener('mouseenter', () => {
                this.suggestionsContainer.querySelectorAll('.suggestion-item').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
            
            item.addEventListener('click', () => {
                const type = item.dataset.type;
                if (type === 'product') {
                    const productId = item.dataset.productId;
                    window.location.href = this.getContextPath() + 'product-detail.jsp?id=' + productId;
                } else {
                    // Use data-text attribute if available, otherwise extract from textContent
                    let text = item.dataset.text || item.textContent.trim();
                    // Remove icon characters and extra spaces
                    text = text.replace(/^[\u{1F300}-\u{1F9FF}]|\s*[\u{2600}-\u{26FF}]|\s*[\u{2700}-\u{27BF}]/gu, '').trim();
                    if (!text && item.textContent) {
                        // Fallback: try to extract meaningful text
                        text = item.textContent.replace(/^\s*[\w\s]*?\s+/, '').trim();
                    }
                    if (text) {
                        this.selectSuggestion(text);
                    }
                }
            });
        });
    }

    hideSuggestions() {
        this.suggestionsContainer.style.display = 'none';
        this.suggestionsContainer.innerHTML = '';
    }

    selectSuggestion(suggestion) {
        this.searchInput.value = suggestion;
        this.hideSuggestions();
        this.saveToHistory(suggestion);
        if (this.searchForm) {
            this.searchForm.submit();
        }
    }

    // Search History Management
    loadSearchHistory() {
        try {
            const history = localStorage.getItem('gundam_search_history');
            return history ? JSON.parse(history) : [];
        } catch (error) {
            console.error('Error loading search history:', error);
            return [];
        }
    }

    saveToHistory(query) {
        if (!query || query.trim().length === 0) return;
        
        const trimmedQuery = query.trim();
        
        // Remove if already exists
        this.searchHistory = this.searchHistory.filter(item => 
            item.toLowerCase() !== trimmedQuery.toLowerCase()
        );
        
        // Add to beginning
        this.searchHistory.unshift(trimmedQuery);
        
        // Keep only maxHistory items
        this.searchHistory = this.searchHistory.slice(0, this.maxHistory);
        
        // Save to localStorage
        try {
            localStorage.setItem('gundam_search_history', JSON.stringify(this.searchHistory));
        } catch (error) {
            console.error('Error saving search history:', error);
        }
    }

    removeFromHistory(query) {
        this.searchHistory = this.searchHistory.filter(item => 
            item.toLowerCase() !== query.toLowerCase()
        );
        
        try {
            localStorage.setItem('gundam_search_history', JSON.stringify(this.searchHistory));
        } catch (error) {
            console.error('Error updating search history:', error);
        }
        
        // Refresh display
        if (this.searchInput.value.trim().length === 0) {
            this.showHistoryAndPopular();
        }
    }

    clearHistory() {
        this.searchHistory = [];
        try {
            localStorage.removeItem('gundam_search_history');
        } catch (error) {
            console.error('Error clearing search history:', error);
        }
        
        // Refresh display
        if (this.searchInput.value.trim().length === 0) {
            this.showHistoryAndPopular();
        }
    }

    highlightMatch(text, query = null) {
        const searchQuery = query || this.searchInput.value.trim().toLowerCase();
        if (!searchQuery) return this.escapeHtml(text);
        
        const regex = new RegExp(`(${this.escapeRegex(searchQuery)})`, 'gi');
        return this.escapeHtml(text).replace(regex, '<strong>$1</strong>');
    }

    formatPrice(price) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(price);
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    escapeRegex(text) {
        return text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

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

    // Public method to destroy instance
    destroy() {
        if (this.searchInput) {
            this.searchInput.removeEventListener('input', this.handleInput);
            this.searchInput.removeEventListener('blur', this.hideSuggestions);
            this.searchInput.removeEventListener('focus', this.handleFocus);
            this.searchInput.removeEventListener('keydown', this.handleKeyNavigation);
        }
        
        clearTimeout(this.searchTimeout);
        this.hideSuggestions();
    }
}

// Global instance for easy access
let searchAutocomplete = null;

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Only initialize if elements exist
    if (document.getElementById('headerSearchInput') && document.getElementById('headerSearchSuggestions')) {
        searchAutocomplete = new SearchAutocompleteHandler();
        
        // Make it globally accessible
        window.searchAutocomplete = searchAutocomplete;
    }
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SearchAutocompleteHandler;
}
