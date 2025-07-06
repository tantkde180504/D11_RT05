// category-management.js
let categories = [];

// Advanced Filters & Search Functions
let currentFilters = {
    search: '',
    status: '',
    productCount: '',
    date: '',
    sort: 'id_asc'
};

function fetchCategoriesAndRender() {
  fetch('/api/categories')
    .then(res => res.json())
    .then(data => {
      if (Array.isArray(data)) {
        categories = data;
        applyFilters();
      } else {
        categories = [];
        renderCategoryTable();
        console.error('API /api/categories không trả về mảng:', data);
      }
    })
    .catch(err => {
      categories = [];
      renderCategoryTable();
      console.error('Lỗi khi fetch /api/categories:', err);
    });
}

function applyFilters() {
    let filteredCategories = [...categories];
    
    // Search filter
    if (currentFilters.search) {
        const searchTerm = currentFilters.search.toLowerCase();
        filteredCategories = filteredCategories.filter(cat => 
            (cat.name || '').toLowerCase().includes(searchTerm) ||
            (cat.description || '').toLowerCase().includes(searchTerm)
        );
    }
    
    // Status filter
    if (currentFilters.status) {
        filteredCategories = filteredCategories.filter(cat => {
            if (currentFilters.status === 'active') return cat.isActive === true;
            if (currentFilters.status === 'inactive') return cat.isActive === false;
            return true;
        });
    }
    
    // Product count filter
    if (currentFilters.productCount) {
        filteredCategories = filteredCategories.filter(cat => {
            const count = cat.productCount || 0;
            switch (currentFilters.productCount) {
                case 'empty': return count === 0;
                case 'low': return count >= 1 && count <= 5;
                case 'medium': return count >= 6 && count <= 15;
                case 'high': return count > 15;
                default: return true;
            }
        });
    }
    
    // Date filter
    if (currentFilters.date) {
        const now = new Date();
        filteredCategories = filteredCategories.filter(cat => {
            if (!cat.createdAt) return false;
            const createdDate = new Date(cat.createdAt);
            
            switch (currentFilters.date) {
                case 'today':
                    return createdDate.toDateString() === now.toDateString();
                case 'week':
                    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                    return createdDate >= weekAgo;
                case 'month':
                    const monthAgo = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
                    return createdDate >= monthAgo;
                case 'old':
                    const threeMonthsAgo = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                    return createdDate < threeMonthsAgo;
                default:
                    return true;
            }
        });
    }
    
    // Sort
    filteredCategories.sort((a, b) => {
        switch (currentFilters.sort) {
            case 'id_asc': return (a.id || 0) - (b.id || 0);
            case 'id_desc': return (b.id || 0) - (a.id || 0);
            case 'name_asc': return (a.name || '').localeCompare(b.name || '');
            case 'name_desc': return (b.name || '').localeCompare(a.name || '');
            case 'date_asc': return new Date(a.createdAt || 0) - new Date(b.createdAt || 0);
            case 'date_desc': return new Date(b.createdAt || 0) - new Date(a.createdAt || 0);
            case 'products_asc': return (a.productCount || 0) - (b.productCount || 0);
            case 'products_desc': return (b.productCount || 0) - (a.productCount || 0);
            default: return 0;
        }
    });
    
    // Update UI
    renderCategoryTable(filteredCategories);
    updateFilterSummary(filteredCategories.length);
    updateActiveFilters();
}

function renderCategoryTable(categoriesToRender = null) {
    if (categoriesToRender === null) {
        applyFilters();
        return;
    }
    
    const tbody = document.getElementById('categoryTableBody');
    tbody.innerHTML = '';
    categoriesToRender.forEach((cat) => {
        const createdAt = cat.createdAt ? cat.createdAt.split('T')[0] : '';
        const description = cat.description || '';
        const name = cat.name || '';
        const id = cat.id || '';
        const productCount = cat.productCount || 0;
        
        // Status display logic
        const statusBadge = cat.isActive 
            ? `<span class="badge bg-success">Hoạt động</span>` 
            : `<span class="badge bg-secondary">Tạm ẩn</span>`;

        // Action buttons logic
        const toggleStatusBtn = cat.isActive
            ? `<button class="btn btn-sm btn-outline-secondary me-1" onclick="toggleCategoryStatus(${id})" title="Tạm ẩn danh mục"><i class="fas fa-eye-slash"></i></button>`
            : `<button class="btn btn-sm btn-outline-success me-1" onclick="toggleCategoryStatus(${id})" title="Kích hoạt danh mục"><i class="fas fa-eye"></i></button>`;
        
        const deleteBtnDisabled = productCount > 0 ? 'disabled' : '';
        const deleteBtnTitle = productCount > 0 ? 'Không thể xóa danh mục có sản phẩm' : 'Xóa danh mục';

        tbody.innerHTML += `
            <tr>
                <td>${id}</td>
                <td>${name}</td>
                <td>${description}</td>
                <td>${createdAt}</td>
                <td><span class="badge bg-info">${productCount}</span></td>
                <td>${statusBadge}</td>
                <td>
                    <button class="btn btn-sm btn-outline-warning me-1" onclick="editCategory(${id})"><i class="fas fa-edit"></i></button>
                    ${toggleStatusBtn}
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(${id})" ${deleteBtnDisabled} title="${deleteBtnTitle}"><i class="fas fa-trash"></i></button>
                </td>
            </tr>
        `;
    });
}

function updateFilterSummary(filteredCount) {
    document.getElementById('filteredCount').textContent = filteredCount;
    document.getElementById('totalCount').textContent = categories.length;
}

function updateActiveFilters() {
    const container = document.getElementById('activeFilters');
    container.innerHTML = '';
    
    const filterLabels = {
        search: 'Tìm kiếm',
        status: 'Trạng thái',
        productCount: 'Số sản phẩm',
        date: 'Ngày tạo',
        sort: 'Sắp xếp'
    };
    
    Object.keys(currentFilters).forEach(key => {
        if (currentFilters[key] && key !== 'sort') {
            const badge = document.createElement('span');
            badge.className = 'badge bg-primary me-1';
            badge.innerHTML = `${filterLabels[key]}: ${getFilterDisplayValue(key, currentFilters[key])} <i class="fas fa-times ms-1" style="cursor: pointer;" onclick="removeFilter('${key}')"></i>`;
            container.appendChild(badge);
        }
    });
}

function getFilterDisplayValue(key, value) {
    const displayValues = {
        status: { active: 'Hoạt động', inactive: 'Tạm ẩn' },
        productCount: { empty: 'Trống', low: 'Ít', medium: 'Trung bình', high: 'Nhiều' },
        date: { today: 'Hôm nay', week: 'Tuần này', month: 'Tháng này', old: 'Cũ hơn' }
    };
    
    if (key === 'search') return value;
    return displayValues[key] ? displayValues[key][value] : value;
}

function removeFilter(filterKey) {
    currentFilters[filterKey] = '';
    document.getElementById(getFilterElementId(filterKey)).value = '';
    applyFilters();
}

function getFilterElementId(filterKey) {
    const elementIds = {
        search: 'categorySearchInput',
        status: 'statusFilter',
        productCount: 'productCountFilter',
        date: 'dateFilter',
        sort: 'sortFilter'
    };
    return elementIds[filterKey];
}

function resetAllFilters() {
    currentFilters = {
        search: '',
        status: '',
        productCount: '',
        date: '',
        sort: 'id_asc'
    };
    
    // Reset form elements
    document.getElementById('categorySearchInput').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('productCountFilter').value = '';
    document.getElementById('dateFilter').value = '';
    document.getElementById('sortFilter').value = 'id_asc';
    
    applyFilters();
}

function editCategory(id) {
  const cat = categories.find(c => c.id === id);
  if (!cat) return;
  document.getElementById('editCategoryId').value = cat.id;
  document.getElementById('editCategoryName').value = cat.name;
  document.getElementById('editCategoryDescription').value = cat.description || '';
  // Render danh mục cha
  renderCategoryParentOptions('editCategoryParent', cat.parentId, cat.id);
  // Trạng thái
  document.getElementById('editCategoryActive').value = cat.isActive === false ? 'false' : 'true';
  // Hiển thị modal
  const modal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
  modal.show();
}

function renderCategoryParentOptions(selectId, selectedParentId, editingId) {
  const select = document.getElementById(selectId);
  select.innerHTML = '<option value="">Không có</option>';
  categories.forEach(cat => {
    // Không cho chọn chính nó làm cha
    if (editingId && cat.id === editingId) return;
    const option = document.createElement('option');
    option.value = cat.id;
    option.textContent = cat.name;
    if (selectedParentId && cat.id === selectedParentId) option.selected = true;
    select.appendChild(option);
  });
}

document.getElementById('editCategoryForm').addEventListener('submit', function(e) {
  e.preventDefault();
  const id = Number(document.getElementById('editCategoryId').value);
  const name = document.getElementById('editCategoryName').value.trim();
  const description = document.getElementById('editCategoryDescription').value.trim();
  const parentId = document.getElementById('editCategoryParent').value || null;
  const isActive = document.getElementById('editCategoryActive').value === 'true';

  fetch('/api/categories/update', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      id,
      name,
      description,
      parentId: parentId ? Number(parentId) : null,
      isActive
    })
  })
  .then(res => {
    if (!res.ok) throw res;
    return res.json();
  })
  .then(result => {
    alert('✅ Sửa danh mục thành công!');
    bootstrap.Modal.getInstance(document.getElementById('editCategoryModal')).hide();
    fetchCategoriesAndRender();
  })
  .catch(async err => {
    let msg = 'Lỗi không xác định!';
    if (err.text) msg = await err.text();
    alert('❌ ' + msg);
  });
});

function deleteCategory(id) {
  if (confirm('Bạn có chắc chắn muốn xóa danh mục #' + id + ' không?')) {
    fetch(`/api/categories/${id}`, {
      method: 'DELETE'
    })
    .then(res => {
      if (!res.ok) throw res;
      alert('✅ Đã xóa danh mục #' + id);
      fetchCategoriesAndRender();
    })
    .catch(async err => {
      let msg = 'Lỗi không xác định!';
      if (err.text) msg = await err.text();
      alert('❌ ' + msg);
    });
  }
}

function toggleCategoryStatus(id) {
    const cat = categories.find(c => c.id === id);
    if (!cat) {
        alert('Lỗi: Không tìm thấy danh mục!');
        return;
    }

    // Flip the status
    const updatedCategory = { ...cat, isActive: !cat.isActive };

    fetch('/api/categories/update', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedCategory)
    })
    .then(res => {
        if (!res.ok) throw new Error('Cập nhật trạng thái thất bại');
        return res.json();
    })
    .then(result => {
        alert(`✅ Đã ${updatedCategory.isActive ? 'kích hoạt' : 'ẩn'} danh mục!`);
        fetchCategoriesAndRender();
    })
    .catch(err => {
        alert('❌ ' + err.message);
    });
}

document.addEventListener('DOMContentLoaded', () => {
    fetchCategoriesAndRender();

    // Search input
    const searchInput = document.getElementById('categorySearchInput');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            currentFilters.search = e.target.value;
            applyFilters();
        });
    }
    
    // Status filter
    const statusFilter = document.getElementById('statusFilter');
    if (statusFilter) {
        statusFilter.addEventListener('change', (e) => {
            currentFilters.status = e.target.value;
            applyFilters();
        });
    }
    
    // Product count filter
    const productCountFilter = document.getElementById('productCountFilter');
    if (productCountFilter) {
        productCountFilter.addEventListener('change', (e) => {
            currentFilters.productCount = e.target.value;
            applyFilters();
        });
    }
    
    // Date filter
    const dateFilter = document.getElementById('dateFilter');
    if (dateFilter) {
        dateFilter.addEventListener('change', (e) => {
            currentFilters.date = e.target.value;
            applyFilters();
        });
    }
    
    // Sort filter
    const sortFilter = document.getElementById('sortFilter');
    if (sortFilter) {
        sortFilter.addEventListener('change', (e) => {
            currentFilters.sort = e.target.value;
            applyFilters();
        });
    }
    
    // Reset filters button
    const resetFiltersBtn = document.getElementById('resetFiltersBtn');
    if (resetFiltersBtn) {
        resetFiltersBtn.addEventListener('click', resetAllFilters);
    }

    document.getElementById('addCategoryForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const name = document.getElementById('categoryName').value.trim();
      const description = document.getElementById('categoryDescription').value.trim();
      const parentId = document.getElementById('categoryParent').value || null;
      const isActive = document.getElementById('categoryActive').value === 'true';

      fetch('/api/categories/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name,
          description,
          parentId: parentId ? Number(parentId) : null,
          isActive
        })
      })
      .then(res => {
        if (!res.ok) throw res;
        return res.json();
      })
      .then(result => {
        alert('✅ Thêm danh mục thành công!');
        bootstrap.Modal.getInstance(document.getElementById('addCategoryModal')).hide();
        fetchCategoriesAndRender();
        document.getElementById('addCategoryForm').reset();
      })
      .catch(async err => {
        let msg = 'Lỗi không xác định!';
        if (err.text) msg = await err.text();
        alert('❌ ' + msg);
      });
    });
});
