// category-management.js
let categories = [];

function fetchCategoriesAndRender() {
  fetch('/api/categories')
    .then(res => res.json())
    .then(data => {
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
    });
}

function renderCategoryTable() {
  const tbody = document.getElementById('categoryTableBody');
  tbody.innerHTML = '';
  categories.forEach((cat, idx) => {
    const createdAt = cat.createdAt ? cat.createdAt.split('T')[0] : '';
    const description = cat.description || '';
    const name = cat.name || '';
    const id = cat.id || '';
    tbody.innerHTML += `
      <tr>
        <td>${idx + 1}</td>
        <td>${name}</td>
        <td>${description}</td>
        <td>${createdAt}</td>
        <td>
          <button class="btn btn-sm btn-outline-warning me-1" onclick="editCategory(${id})"><i class="fas fa-edit"></i></button>
          <button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(${id})"><i class="fas fa-trash"></i></button>
        </td>
      </tr>
    `;
  });
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

document.addEventListener('DOMContentLoaded', fetchCategoriesAndRender);

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
