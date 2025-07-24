// Product Management JavaScript for Admin Dashboard

class ProductManager {
    constructor() {
        this.products = [];
        this.categories = [];
        this.grades = [];
        this.initializeEventListeners();
        this.loadProductData();
    }

    initializeEventListeners() {
        // Save product button
        document.addEventListener('click', (e) => {
            if (e.target.id === 'saveProductBtn') {
                this.handleSaveProduct();
            }
            if (e.target.id === 'updateProductBtn') {
                this.handleUpdateProduct();
            }
        });

        // Edit product buttons
        document.addEventListener('click', (e) => {
            if (e.target.closest('.edit-product-btn')) {
                const productId = e.target.closest('.edit-product-btn').dataset.productId;
                this.editProduct(productId);
            }
        });

        // Delete product buttons
        document.addEventListener('click', (e) => {
            if (e.target.closest('.delete-product-btn')) {
                const productId = e.target.closest('.delete-product-btn').dataset.productId;
                this.deleteProduct(productId);
            }
        });

        // Restore product buttons
        document.addEventListener('click', (e) => {
            if (e.target.closest('.restore-product-btn')) {
                const productId = e.target.closest('.restore-product-btn').dataset.productId;
                this.restoreProduct(productId);
            }
        });

        // Add product modal shown event
        const addProductModal = document.getElementById('addProductModal');
        if (addProductModal) {
            addProductModal.addEventListener('shown.bs.modal', () => {
                this.resetAddProductForm();
            });
        }
    }

    async loadProductData() {
        try {
            await this.loadCategories();
            await this.loadGrades();
            await this.loadProducts();
            this.populateDropdowns();
        } catch (error) {
            console.error('Error loading product data:', error);
            this.showAlert('danger', 'Lỗi khi tải dữ liệu sản phẩm');
        }
    }

    async loadProducts() {
        try {
            const response = await fetch('/api/admin/products', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            if (data.success) {
                this.products = data.data;
                this.renderProductTable();
            } else {
                throw new Error(data.message || 'Lỗi khi tải danh sách sản phẩm');
            }
        } catch (error) {
            console.error('Error loading products:', error);
            this.showAlert('danger', 'Lỗi khi tải danh sách sản phẩm: ' + error.message);
        }
    }

    async loadCategories() {
        try {
            const response = await fetch('/api/admin/products/categories');
            const data = await response.json();
            if (data.success) {
                this.categories = data.data;
            }
        } catch (error) {
            console.error('Error loading categories:', error);
        }
    }

    async loadGrades() {
        try {
            const response = await fetch('/api/admin/products/grades');
            const data = await response.json();
            if (data.success) {
                this.grades = data.data;
            }
        } catch (error) {
            console.error('Error loading grades:', error);
        }
    }

    populateDropdowns() {
        this.populateCategoryDropdown('productCategory');
        this.populateCategoryDropdown('editProductCategory');
        this.populateGradeDropdown('productGrade');
        this.populateGradeDropdown('editProductGrade');
    }

    populateCategoryDropdown(selectId) {
        const select = document.getElementById(selectId);
        if (select) {
            select.innerHTML = '<option value="">Chọn danh mục</option>';
            this.categories.forEach(category => {
                const option = document.createElement('option');
                option.value = category;
                option.textContent = this.getCategoryDisplayName(category);
                select.appendChild(option);
            });
        }
    }

    populateGradeDropdown(selectId) {
        const select = document.getElementById(selectId);
        if (select) {
            select.innerHTML = '<option value="">Chọn grade</option>';
            this.grades.forEach(grade => {
                const option = document.createElement('option');
                option.value = grade;
                option.textContent = this.getGradeDisplayName(grade);
                select.appendChild(option);
            });
        }
    }

    getCategoryDisplayName(category) {
        const categoryNames = {
            'GUNDAM_BANDAI': 'Gundam Bandai',
            'PRE_ORDER': 'Pre-order',
            'TOOLS_ACCESSORIES': 'Tools & Accessories'
        };
        return categoryNames[category] || category;
    }

    getGradeDisplayName(grade) {
        const gradeNames = {
            'HG': 'High Grade',
            'RG': 'Real Grade',
            'MG': 'Master Grade',
            'PG': 'Perfect Grade',
            'SD': 'Super Deformed',
            'METAL_BUILD': 'Metal Build',
            'FULL_MECHANICS': 'Full Mechanics',
            'TOOLS': 'Tools',
            'PAINT': 'Paint',
            'BASE_STAND': 'Base & Stand',
            'DECAL': 'Decal'
        };
        return gradeNames[grade] || grade;
    }

    renderProductTable() {
        const tbody = document.getElementById('productTableBody');
        if (!tbody) return;

        tbody.innerHTML = '';

        this.products.forEach(product => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td><strong>${product.id}</strong></td>
                <td>
                    <img src="${product.imageUrl || 'https://via.placeholder.com/50x50/cccccc/666666?text=IMG'}" 
                         class="img-thumbnail" alt="Product" style="width: 50px; height: 50px; object-fit: cover;">
                </td>
                <td><strong>${product.name}</strong></td>
                <td>
                    <span class="badge bg-info">${this.getCategoryDisplayName(product.category)}</span>
                </td>
                <td><strong>${this.formatCurrency(product.price)}</strong></td>
                <td>${product.stockQuantity || 0}</td>
                <td>
                    <span class="badge ${product.isActive ? 'bg-success' : 'bg-danger'}">
                        ${product.isActive ? 'Có sẵn' : 'Đã xóa'}
                    </span>
                </td>
                <td>
                    <div class="btn-group" role="group">
                        <button class="btn btn-sm btn-outline-warning edit-product-btn" 
                                data-product-id="${product.id}" title="Chỉnh sửa">
                            <i class="fas fa-edit"></i>
                        </button>
                        ${product.isActive ? `
                            <button class="btn btn-sm btn-outline-danger delete-product-btn" 
                                    data-product-id="${product.id}" title="Xóa">
                                <i class="fas fa-trash"></i>
                            </button>
                        ` : `
                            <button class="btn btn-sm btn-outline-success restore-product-btn" 
                                    data-product-id="${product.id}" title="Khôi phục">
                                <i class="fas fa-undo"></i>
                            </button>
                        `}
                    </div>
                </td>
            `;
            tbody.appendChild(row);
        });
    }

    resetAddProductForm() {
        const form = document.getElementById('addProductForm');
        if (form) {
            form.reset();
        }
    }

    async handleSaveProduct() {
        try {
            const formData = this.getProductFormData('addProductForm');
            
            if (!this.validateProductData(formData)) {
                return;
            }

            const response = await fetch('/api/admin/products', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            const data = await response.json();

            if (data.success) {
                this.showAlert('success', 'Thêm sản phẩm thành công!');
                const modal = bootstrap.Modal.getInstance(document.getElementById('addProductModal'));
                modal.hide();
                await this.loadProducts();
            } else {
                this.showAlert('danger', data.message || 'Lỗi khi thêm sản phẩm');
            }
        } catch (error) {
            console.error('Error saving product:', error);
            this.showAlert('danger', 'Lỗi khi thêm sản phẩm: ' + error.message);
        }
    }

    async editProduct(productId) {
        try {
            const response = await fetch(`/api/admin/products/${productId}`);
            const data = await response.json();

            if (data.success) {
                this.populateEditForm(data.data);
                const modal = new bootstrap.Modal(document.getElementById('editProductModal'));
                modal.show();
            } else {
                this.showAlert('danger', 'Không thể tải thông tin sản phẩm');
            }
        } catch (error) {
            console.error('Error loading product for edit:', error);
            this.showAlert('danger', 'Lỗi khi tải thông tin sản phẩm');
        }
    }

    populateEditForm(product) {
        document.getElementById('editProductId').value = product.id;
        document.getElementById('editProductName').value = product.name;
        document.getElementById('editProductDescription').value = product.description || '';
        document.getElementById('editProductPrice').value = product.price;
        document.getElementById('editProductStock').value = product.stockQuantity || 0;
        document.getElementById('editProductBrand').value = product.brand || '';
        document.getElementById('editProductImageUrl').value = product.imageUrl || '';
        document.getElementById('editProductCategory').value = product.category || '';
        document.getElementById('editProductGrade').value = product.grade || '';
        document.getElementById('editProductActive').checked = product.isActive;
        document.getElementById('editProductFeatured').checked = product.isFeatured;
    }

    async handleUpdateProduct() {
        try {
            const productId = document.getElementById('editProductId').value;
            const formData = this.getProductFormData('editProductForm');
            
            if (!this.validateProductData(formData)) {
                return;
            }

            const response = await fetch(`/api/admin/products/${productId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(formData)
            });

            const data = await response.json();

            if (data.success) {
                this.showAlert('success', 'Cập nhật sản phẩm thành công!');
                const modal = bootstrap.Modal.getInstance(document.getElementById('editProductModal'));
                modal.hide();
                await this.loadProducts();
            } else {
                this.showAlert('danger', data.message || 'Lỗi khi cập nhật sản phẩm');
            }
        } catch (error) {
            console.error('Error updating product:', error);
            this.showAlert('danger', 'Lỗi khi cập nhật sản phẩm: ' + error.message);
        }
    }

    async deleteProduct(productId) {
        if (!confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
            return;
        }

        try {
            const response = await fetch(`/api/admin/products/${productId}`, {
                method: 'DELETE',
                headers: {
                    'Accept': 'application/json'
                }
            });

            const data = await response.json();

            if (data.success) {
                this.showAlert('success', 'Xóa sản phẩm thành công!');
                await this.loadProducts();
            } else {
                this.showAlert('danger', data.message || 'Lỗi khi xóa sản phẩm');
            }
        } catch (error) {
            console.error('Error deleting product:', error);
            this.showAlert('danger', 'Lỗi khi xóa sản phẩm: ' + error.message);
        }
    }

    async restoreProduct(productId) {
        if (!confirm('Bạn có chắc chắn muốn khôi phục sản phẩm này?')) {
            return;
        }

        try {
            const response = await fetch(`/api/admin/products/${productId}/restore`, {
                method: 'PUT',
                headers: {
                    'Accept': 'application/json'
                }
            });

            const data = await response.json();

            if (data.success) {
                this.showAlert('success', 'Khôi phục sản phẩm thành công!');
                await this.loadProducts();
            } else {
                this.showAlert('danger', data.message || 'Lỗi khi khôi phục sản phẩm');
            }
        } catch (error) {
            console.error('Error restoring product:', error);
            this.showAlert('danger', 'Lỗi khi khôi phục sản phẩm: ' + error.message);
        }
    }

    getProductFormData(formId) {
        const form = document.getElementById(formId);
        const formData = new FormData(form);
        
        const data = {};
        for (let [key, value] of formData.entries()) {
            if (key === 'price' || key === 'stockQuantity') {
                data[key] = parseFloat(value) || 0;
            } else if (key === 'isActive' || key === 'isFeatured') {
                data[key] = form.querySelector(`[name="${key}"]`).checked;
            } else {
                data[key] = value;
            }
        }
        
        return data;
    }

    validateProductData(data) {
        if (!data.name || data.name.trim() === '') {
            this.showAlert('warning', 'Vui lòng nhập tên sản phẩm');
            return false;
        }
        
        if (!data.price || data.price <= 0) {
            this.showAlert('warning', 'Vui lòng nhập giá sản phẩm hợp lệ');
            return false;
        }
        
        if (data.stockQuantity < 0) {
            this.showAlert('warning', 'Số lượng tồn kho không thể âm');
            return false;
        }
        
        return true;
    }

    formatCurrency(amount) {
        if (amount === null || amount === undefined) return '0₫';
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    showAlert(type, message) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        alertDiv.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'danger' ? 'exclamation-circle' : 'info-circle'} me-2"></i>
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        document.body.appendChild(alertDiv);

        setTimeout(() => {
            if (alertDiv.parentNode) {
                alertDiv.remove();
            }
        }, 5000);
    }
}

// Initialize product manager when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    if (window.location.pathname.includes('dashboard') || 
        document.getElementById('productTableBody')) {
        window.productManager = new ProductManager();
    }
});
