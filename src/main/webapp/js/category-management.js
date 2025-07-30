// === Hàm hiển thị thông báo Bootstrap alert/toast ===
function showBootstrapAlert(message, type = 'success', timeout = 3000) {
  let alertContainer = document.getElementById('customAlertContainer');
  if (!alertContainer) {
    alertContainer = document.createElement('div');
    alertContainer.id = 'customAlertContainer';
    alertContainer.style.position = 'fixed';
    alertContainer.style.top = '20px';
    alertContainer.style.right = '20px';
    alertContainer.style.zIndex = '9999';
    document.body.appendChild(alertContainer);
  }
  const alertDiv = document.createElement('div');
  alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
  alertDiv.role = 'alert';
  alertDiv.innerHTML = `
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  `;
  alertContainer.appendChild(alertDiv);
  setTimeout(() => {
    if (alertDiv) alertDiv.classList.remove('show');
    setTimeout(() => alertDiv.remove(), 500);
  }, timeout);
}
// category-management.js
let categories = [];

function fetchCategoriesAndRender() {
  fetch('/api/categories', {
    headers: {
      'Accept': 'application/json'
    }
  })
    .then(async res => {
      const contentType = res.headers.get('content-type') || '';
      if (!contentType.includes('application/json')) {
        const text = await res.text();
        console.error('API /api/categories không trả về JSON. Content-Type:', contentType, '\nResponse:', text.slice(0, 200));
        categories = [];
        renderCategoryTable();
        showBootstrapAlert('❌ Lỗi: API /api/categories không trả về dữ liệu JSON hợp lệ!', 'danger');
        return;
      }
      return res.json();
    })
    .then(data => {
      if (!data) return;
      if (Array.isArray(data)) {
        categories = data;
        renderCategoryTable();
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
      showBootstrapAlert('❌ Lỗi khi lấy danh sách danh mục!', 'danger');
    });
}

function renderCategoryTable(categoriesToRender = categories) {
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
  updateCategoryCount(categoriesToRender.length, categories.length);
}

// Hàm cập nhật số lượng danh mục hiển thị
function updateCategoryCount(current, total) {
  const filteredCount = document.getElementById('filteredCount');
  const totalCount = document.getElementById('totalCount');
  if (filteredCount) filteredCount.textContent = current;
  if (totalCount) totalCount.textContent = total;
}

function editCategory(id) {
  const cat = categories.find(c => c.id === id);
  if (!cat) {
    showBootstrapAlert('Không tìm thấy danh mục!', 'danger');
    return;
  }
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
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({
      id,
      name,
      description,
      parentId: parentId ? Number(parentId) : null,
      isActive
    })
  })
  .then(async res => {
    const contentType = res.headers.get('content-type') || '';
    if (!res.ok) {
      let msg = 'Lỗi không xác định!';
      if (contentType.includes('application/json')) {
        const data = await res.json();
        msg = data.message || JSON.stringify(data);
      } else {
        const text = await res.text();
        msg = text.slice(0, 200);
      }
      throw new Error(msg);
    }
    if (!contentType.includes('application/json')) {
      const text = await res.text();
      console.error('API /api/categories/update không trả về JSON. Content-Type:', contentType, '\nResponse:', text.slice(0, 200));
      showBootstrapAlert('❌ Lỗi: API /api/categories/update không trả về dữ liệu JSON hợp lệ!', 'danger');
      return;
    }
    return res.json();
  })
  .then(result => {
    if (!result) return;
    showBootstrapAlert('✅ Sửa danh mục thành công!', 'success');
    bootstrap.Modal.getInstance(document.getElementById('editCategoryModal')).hide();
    fetchCategoriesAndRender();
  })
  .catch(err => {
    showBootstrapAlert('❌ ' + err.message, 'danger');
  });
});

function deleteCategory(id) {
  if (confirm('Bạn có chắc chắn muốn xóa danh mục #' + id + ' không?')) {
    fetch(`/api/categories/${id}`, {
      method: 'DELETE',
      headers: { 'Accept': 'application/json' }
    })
    .then(async res => {
      const contentType = res.headers.get('content-type') || '';
      if (!res.ok) {
        let msg = 'Lỗi không xác định!';
        if (contentType.includes('application/json')) {
          const data = await res.json();
          msg = data.message || JSON.stringify(data);
        } else {
          const text = await res.text();
          msg = text.slice(0, 200);
        }
        throw new Error(msg);
      }
      // Nếu xóa thành công mà không trả về JSON (204 No Content hoặc text/plain), vẫn coi là thành công
      if (!contentType.includes('application/json')) {
        showBootstrapAlert('✅ Đã xóa danh mục #' + id, 'success');
        fetchCategoriesAndRender();
        return;
      }
      // Nếu có JSON thì xử lý như cũ
      const result = await res.json();
      showBootstrapAlert('✅ Đã xóa danh mục #' + id, 'success');
      fetchCategoriesAndRender();
    })
    .catch(err => {
      showBootstrapAlert('❌ ' + err.message, 'danger');
    });
  }
}

function toggleCategoryStatus(id) {
    const cat = categories.find(c => c.id === id);
    if (!cat) {
        showBootstrapAlert('Lỗi: Không tìm thấy danh mục!', 'danger');
        return;
    }

    // Flip the status
    const updatedCategory = { ...cat, isActive: !cat.isActive };

    fetch('/api/categories/update', {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify(updatedCategory)
    })
    .then(async res => {
        const contentType = res.headers.get('content-type') || '';
        if (!res.ok) {
          let msg = 'Lỗi không xác định!';
          if (contentType.includes('application/json')) {
            const data = await res.json();
            msg = data.message || JSON.stringify(data);
          } else {
            const text = await res.text();
            msg = text.slice(0, 200);
          }
          throw new Error(msg);
        }
        if (!contentType.includes('application/json')) {
          const text = await res.text();
          console.error('API /api/categories/update không trả về JSON. Content-Type:', contentType, '\nResponse:', text.slice(0, 200));
          showBootstrapAlert('❌ Lỗi: API /api/categories/update không trả về dữ liệu JSON hợp lệ!', 'danger');
          return;
        }
        return res.json();
    })
    .then(result => {
        if (!result) return;
        showBootstrapAlert(`✅ Đã ${updatedCategory.isActive ? 'kích hoạt' : 'ẩn'} danh mục!`, 'success');
        fetchCategoriesAndRender();
    })
    .catch(err => {
        showBootstrapAlert('❌ ' + err.message, 'danger');
    });
}

document.addEventListener('DOMContentLoaded', () => {
    fetchCategoriesAndRender();

    const searchInput = document.getElementById('categorySearchInput');
    const statusFilter = document.getElementById('statusFilter');
    const productCountFilter = document.getElementById('productCountFilter');
    const dateFilter = document.getElementById('dateFilter');
    const sortFilter = document.getElementById('sortFilter');

    // Thêm xử lý cho nút Đặt lại filter
    const resetBtn = document.getElementById('resetFiltersBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', function() {
            if (searchInput) searchInput.value = '';
            if (statusFilter) statusFilter.value = '';
            if (productCountFilter) productCountFilter.value = '';
            if (dateFilter) dateFilter.value = '';
            if (sortFilter) sortFilter.value = '';
            applyAllFilters();
        });
    }

    function applyAllFilters() {
        let filtered = [...categories];
        // Tên/mô tả
        const searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
        if (searchTerm) {
            filtered = filtered.filter(cat =>
                cat.name.toLowerCase().includes(searchTerm) ||
                (cat.description && cat.description.toLowerCase().includes(searchTerm))
            );
        }
        // Trạng thái
        const status = statusFilter ? statusFilter.value : '';
        if (status) {
            filtered = filtered.filter(cat =>
                (status === 'active' && cat.isActive) ||
                (status === 'inactive' && !cat.isActive)
            );
        }
        // Số sản phẩm
        const productCount = productCountFilter ? productCountFilter.value : '';
        if (productCount) {
            filtered = filtered.filter(cat => {
                const count = cat.productCount || 0;
                if (productCount === 'empty') return count === 0;
                if (productCount === 'low') return count >= 1 && count <= 5;
                if (productCount === 'medium') return count >= 6 && count <= 15;
                if (productCount === 'high') return count > 15;
                return true;
            });
        }
        // Ngày tạo
        const dateType = dateFilter ? dateFilter.value : '';
        if (dateType) {
            const today = new Date();
            filtered = filtered.filter(cat => {
                if (!cat.createdAt) return false;
                const created = new Date(cat.createdAt.split('T')[0]);
                const diffDays = Math.floor((today - created) / (1000 * 60 * 60 * 24));
                if (dateType === 'today') return diffDays === 0;
                if (dateType === 'week') return diffDays <= 6;
                if (dateType === 'month') return diffDays <= 30;
                if (dateType === 'old') return diffDays > 30;
                return true;
            });
        }
        // Sắp xếp
        const sort = sortFilter ? sortFilter.value : '';
        if (sort) {
            if (sort === 'id_asc') filtered.sort((a, b) => a.id - b.id);
            if (sort === 'id_desc') filtered.sort((a, b) => b.id - a.id);
            if (sort === 'name_asc') filtered.sort((a, b) => a.name.localeCompare(b.name));
            if (sort === 'name_desc') filtered.sort((a, b) => b.name.localeCompare(a.name));
            if (sort === 'date_asc') filtered.sort((a, b) => new Date(a.createdAt) - new Date(b.createdAt));
            if (sort === 'date_desc') filtered.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
            if (sort === 'products_asc') filtered.sort((a, b) => (a.productCount || 0) - (b.productCount || 0));
            if (sort === 'products_desc') filtered.sort((a, b) => (b.productCount || 0) - (a.productCount || 0));
        }
        renderCategoryTable(filtered);
        // updateCategoryCount(filtered.length, categories.length); // đã gọi trong renderCategoryTable
    }

    if (searchInput) searchInput.addEventListener('input', applyAllFilters);
    if (statusFilter) statusFilter.addEventListener('change', applyAllFilters);
    if (productCountFilter) productCountFilter.addEventListener('change', applyAllFilters);
    if (dateFilter) dateFilter.addEventListener('change', applyAllFilters);
    if (sortFilter) sortFilter.addEventListener('change', applyAllFilters);

    document.getElementById('addCategoryForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const name = document.getElementById('categoryName').value.trim();
      const description = document.getElementById('categoryDescription').value.trim();
      const parentId = document.getElementById('categoryParent').value || null;
      const isActive = document.getElementById('categoryActive').value === 'true';

      fetch('/api/categories/add', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify({
          name,
          description,
          parentId: parentId ? Number(parentId) : null,
          isActive
        })
      })
      .then(async res => {
        const contentType = res.headers.get('content-type') || '';
        if (!res.ok) {
          let msg = 'Lỗi không xác định!';
          if (contentType.includes('application/json')) {
            const data = await res.json();
            msg = data.message || JSON.stringify(data);
          } else {
            const text = await res.text();
            msg = text.slice(0, 200);
          }
          throw new Error(msg);
        }
        if (!contentType.includes('application/json')) {
          const text = await res.text();
          console.error('API /api/categories/add không trả về JSON. Content-Type:', contentType, '\nResponse:', text.slice(0, 200));
          showBootstrapAlert('❌ Lỗi: API /api/categories/add không trả về dữ liệu JSON hợp lệ!', 'danger');
          return;
        }
        return res.json();
      })
      .then(result => {
        if (!result) return;
        showBootstrapAlert('✅ Thêm danh mục thành công!', 'success');
        bootstrap.Modal.getInstance(document.getElementById('addCategoryModal')).hide();
        fetchCategoriesAndRender();
        document.getElementById('addCategoryForm').reset();
      })
      .catch(err => {
        showBootstrapAlert('❌ ' + err.message, 'danger');
      });
    });
});
