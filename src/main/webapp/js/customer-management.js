// Advanced Filters for Customers
let customerList = [];
let currentCustomerFilters = {
    search: '',
    gender: '',
    orderCount: '',
    date: '',
    sort: 'id_asc'
};

document.addEventListener("DOMContentLoaded", function () {
  // Chỉ load khi tab khách hàng được mở
  const customerTab = document.querySelector('a[href="#customers"]');
  if (customerTab) {
    customerTab.addEventListener("shown.bs.tab", function () {
      loadCustomerList();
    });
  }
  // Nếu tab khách hàng đang active sẵn
  const activeTab = document.querySelector('.tab-pane.active#customers');
  if (activeTab) {
    loadCustomerList();
  }

  // Gán sự kiện submit cho form sửa khách hàng (đặt trong DOMContentLoaded để luôn hoạt động)
  const editForm = document.getElementById('editCustomerForm');
  if (editForm) {
    editForm.addEventListener('submit', function(e) {
      e.preventDefault();
      // Log dữ liệu trước khi gửi request
      console.log("[DEBUG] Submit sửa customer:", {
        id: document.getElementById('editCusId').value,
        firstName: document.getElementById('editCusFirstName').value,
        lastName: document.getElementById('editCusLastName').value,
        email: document.getElementById('editCusEmail').value,
        phone: document.getElementById('editCusPhone').value,
        dateOfBirth: document.getElementById('editCusDob').value,
        gender: document.getElementById('editCusGender').value,
        address: document.getElementById('editCusAddress').value
      });
      // Disable nút submit để tránh double submit
      const submitBtn = editForm.querySelector('button[type="submit"]');
      if (submitBtn) submitBtn.disabled = true;
      const id = document.getElementById('editCusId').value;
      // Lấy giá trị gender, nếu rỗng thì mặc định là 'MALE'
      let genderValue = document.getElementById('editCusGender').value;
      if (!genderValue || !['MALE','FEMALE','OTHER'].includes(genderValue)) genderValue = 'MALE';
      const data = {
        firstName: document.getElementById('editCusFirstName').value,
        lastName: document.getElementById('editCusLastName').value,
        email: document.getElementById('editCusEmail').value,
        phone: document.getElementById('editCusPhone').value,
        dateOfBirth: document.getElementById('editCusDob').value,
        gender: genderValue,
        address: document.getElementById('editCusAddress').value
      };
      fetch(apiUrl(`/api/staffs/customers/${id}`), {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      })
      .then(async res => {
        if (!res.ok) {
          let msg = await res.text();
          throw new Error('Lỗi cập nhật: ' + msg);
        }
        // Nếu không có nội dung trả về (status 200, 204), không cần gọi res.json()
        if (res.status === 204 || res.headers.get('content-length') === '0') {
          return {};
        }
        const text = await res.text();
        if (!text) return {};
        try {
          return JSON.parse(text);
        } catch (e) {
          return {};
        }
      })
      .then(result => {
        bootstrap.Modal.getInstance(document.getElementById('editCustomerModal')).hide();
        setTimeout(() => {
          alert('Cập nhật thành công!');
          loadCustomerList();
          if (submitBtn) submitBtn.disabled = false;
        }, 300);
      })
      .catch(err => {
        alert('Cập nhật thất bại!\n' + err);
        console.error(err);
        if (submitBtn) submitBtn.disabled = false;
      });
    });
  }

  // Thêm ô tìm kiếm khách hàng
  const searchInput = document.createElement('input');
  searchInput.type = 'text';
  searchInput.placeholder = 'Tìm kiếm khách hàng...';
  searchInput.className = 'form-control mb-3';
  searchInput.id = 'customerSearchInput';
  searchInput.addEventListener('input', function () {
      const searchValue = this.value.toLowerCase();
      const rows = document.querySelectorAll('#customerTableBody tr');
      rows.forEach(row => {
          const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
          const email = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
          if (name.includes(searchValue) || email.includes(searchValue)) {
              row.style.display = '';
          } else {
              row.style.display = 'none';
          }
      });
  });

  // Thêm ô tìm kiếm vào DOM
  const customerTabContent = document.querySelector('#customers .admin-table');
  customerTabContent.insertBefore(searchInput, customerTabContent.firstChild);
  
  // Advanced Filters Event Listeners
  const customerSearchAdvanced = document.getElementById('customerSearchInputAdvanced');
  if (customerSearchAdvanced) {
      customerSearchAdvanced.addEventListener('input', (e) => {
          currentCustomerFilters.search = e.target.value;
          applyCustomerFilters();
      });
  }
  
  const customerGenderFilter = document.getElementById('customerGenderFilter');
  if (customerGenderFilter) {
      customerGenderFilter.addEventListener('change', (e) => {
          currentCustomerFilters.gender = e.target.value;
          applyCustomerFilters();
      });
  }
  
  const customerOrderFilter = document.getElementById('customerOrderFilter');
  if (customerOrderFilter) {
      customerOrderFilter.addEventListener('change', (e) => {
          currentCustomerFilters.orderCount = e.target.value;
          applyCustomerFilters();
      });
  }
  
  const customerDateFilter = document.getElementById('customerDateFilter');
  if (customerDateFilter) {
      customerDateFilter.addEventListener('change', (e) => {
          currentCustomerFilters.date = e.target.value;
          applyCustomerFilters();
      });
  }
  
  const customerSortFilter = document.getElementById('customerSortFilter');
  if (customerSortFilter) {
      customerSortFilter.addEventListener('change', (e) => {
          currentCustomerFilters.sort = e.target.value;
          applyCustomerFilters();
      });
  }
  
  const resetCustomerFiltersBtn = document.getElementById('resetCustomerFiltersBtn');
  if (resetCustomerFiltersBtn) {
      resetCustomerFiltersBtn.addEventListener('click', resetAllCustomerFilters);
  }
});

function apiUrl(path) {
  const API_BASE = "http://localhost:8081";
  if (path.startsWith("/")) return API_BASE + path;
  return API_BASE + "/" + path;
}

function loadCustomerList() {
  fetch(apiUrl("/api/staffs/customers"))
    .then(res => {
      if (!res.ok) {
        alert("Không thể tải danh sách khách hàng. Vui lòng thử lại sau.");
        throw new Error("Lỗi HTTP: " + res.status);
      }
      return res.json();
    })
    .then(data => {
      customerList = data; // Lưu danh sách khách hàng gốc
      applyCustomerFilters(); // Áp dụng bộ lọc hiện tại (nếu có)
    })
    .catch(err => {
      alert("Không thể tải danh sách khách hàng. Vui lòng thử lại sau.");
      console.error("Lỗi khi tải danh sách khách hàng:", err);
    });
}

function applyCustomerFilters() {
    let filteredCustomers = [...customerList];
    
    // Search filter
    if (currentCustomerFilters.search) {
        const searchTerm = currentCustomerFilters.search.toLowerCase();
        filteredCustomers = filteredCustomers.filter(customer => {
            const fullName = `${customer.firstName || ""} ${customer.lastName || ""}`.trim().toLowerCase();
            const email = (customer.email || '').toLowerCase();
            const phone = (customer.phone || '').toLowerCase();
            return fullName.includes(searchTerm) || email.includes(searchTerm) || phone.includes(searchTerm);
        });
    }
    
    // Gender filter
    if (currentCustomerFilters.gender) {
        filteredCustomers = filteredCustomers.filter(customer => 
            customer.gender === currentCustomerFilters.gender
        );
    }
    
    // Order count filter
    if (currentCustomerFilters.orderCount) {
        filteredCustomers = filteredCustomers.filter(customer => {
            const count = customer.totalOrders || 0;
            switch (currentCustomerFilters.orderCount) {
                case 'new': return count === 0;
                case 'low': return count >= 1 && count <= 5;
                case 'medium': return count >= 6 && count <= 15;
                case 'high': return count > 15;
                default: return true;
            }
        });
    }
    
    // Date filter
    if (currentCustomerFilters.date) {
        const now = new Date();
        filteredCustomers = filteredCustomers.filter(customer => {
            if (!customer.createdAt) return false;
            const createdDate = new Date(customer.createdAt);
            
            switch (currentCustomerFilters.date) {
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
    filteredCustomers.sort((a, b) => {
        switch (currentCustomerFilters.sort) {
            case 'id_asc': return (a.id || 0) - (b.id || 0);
            case 'id_desc': return (b.id || 0) - (a.id || 0);
            case 'name_asc': {
                const nameA = `${a.firstName || ""} ${a.lastName || ""}`.trim();
                const nameB = `${b.firstName || ""} ${b.lastName || ""}`.trim();
                return nameA.localeCompare(nameB);
            }
            case 'name_desc': {
                const nameA = `${a.firstName || ""} ${a.lastName || ""}`.trim();
                const nameB = `${b.firstName || ""} ${b.lastName || ""}`.trim();
                return nameB.localeCompare(nameA);
            }
            case 'date_asc': return new Date(a.createdAt || 0) - new Date(b.createdAt || 0);
            case 'date_desc': return new Date(b.createdAt || 0) - new Date(a.createdAt || 0);
            case 'orders_asc': return (a.totalOrders || 0) - (b.totalOrders || 0);
            case 'orders_desc': return (b.totalOrders || 0) - (a.totalOrders || 0);
            default: return 0;
        }
    });
    
    // Update UI
    renderCustomerTable(filteredCustomers);
    updateCustomerFilterSummary(filteredCustomers.length);
    updateCustomerActiveFilters();
}

function renderCustomerTable(customers) {
    const tbody = document.getElementById("customerTableBody");
    tbody.innerHTML = "";
    customers.forEach((cus, idx) => {
        const fullName = `${cus.firstName || ""} ${cus.lastName || ""}`.trim();
        const createdAt = cus.createdAt ? new Date(cus.createdAt).toLocaleDateString('vi-VN') : "";
        const row = `
          <tr>
            <td>${cus.id || idx + 1}</td>
            <td>${fullName}</td>
            <td>${cus.email || ""}</td>
            <td>${cus.phone || ""}</td>
            <td>${createdAt}</td>
            <td>${cus.totalOrders || 0}</td>
            <td>
              <button class="btn btn-sm btn-info btn-view-cus" data-id="${cus.id}" title="Xem chi tiết"><i class="fas fa-eye"></i></button>
              <button class="btn btn-sm btn-warning btn-edit-cus" data-id="${cus.id}" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>
            </td>
          </tr>
        `;
        tbody.insertAdjacentHTML("beforeend", row);
    });
    
    // Gán sự kiện cho nút xem và sửa
    tbody.querySelectorAll('.btn-view-cus').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            viewCustomer(id);
        });
    });
    
    tbody.querySelectorAll('.btn-edit-cus').forEach(btn => {
        btn.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            editCustomer(id);
        });
    });
}

function updateCustomerFilterSummary(filteredCount) {
    document.getElementById('customerFilteredCount').textContent = filteredCount;
    document.getElementById('customerTotalCount').textContent = customerList.length;
}

function updateCustomerActiveFilters() {
    const container = document.getElementById('customerActiveFilters');
    container.innerHTML = '';
    
    const filterLabels = {
        search: 'Tìm kiếm',
        gender: 'Giới tính',
        orderCount: 'Số đơn hàng',
        date: 'Ngày đăng ký'
    };
    
    Object.keys(currentCustomerFilters).forEach(key => {
        if (currentCustomerFilters[key] && key !== 'sort') {
            const badge = document.createElement('span');
            badge.className = 'badge bg-primary me-1';
            badge.innerHTML = `${filterLabels[key]}: ${getCustomerFilterDisplayValue(key, currentCustomerFilters[key])} <i class="fas fa-times ms-1" style="cursor: pointer;" onclick="removeCustomerFilter('${key}')"></i>`;
            container.appendChild(badge);
        }
    });
}

function getCustomerFilterDisplayValue(key, value) {
    const displayValues = {
        gender: { MALE: 'Nam', FEMALE: 'Nữ', OTHER: 'Khác' },
        orderCount: { new: 'Mới', low: 'Ít', medium: 'Trung bình', high: 'Nhiều' },
        date: { today: 'Hôm nay', week: 'Tuần này', month: 'Tháng này', old: 'Cũ hơn' }
    };
    
    if (key === 'search') return value;
    return displayValues[key] ? displayValues[key][value] : value;
}

function removeCustomerFilter(filterKey) {
    currentCustomerFilters[filterKey] = '';
    document.getElementById(getCustomerFilterElementId(filterKey)).value = '';
    applyCustomerFilters();
}

function getCustomerFilterElementId(filterKey) {
    const elementIds = {
        search: 'customerSearchInputAdvanced',
        gender: 'customerGenderFilter',
        orderCount: 'customerOrderFilter',
        date: 'customerDateFilter',
        sort: 'customerSortFilter'
    };
    return elementIds[filterKey];
}

function resetAllCustomerFilters() {
    currentCustomerFilters = {
        search: '',
        gender: '',
        orderCount: '',
        date: '',
        sort: 'id_asc'
    };
    
    // Reset form elements
    document.getElementById('customerSearchInputAdvanced').value = '';
    document.getElementById('customerGenderFilter').value = '';
    document.getElementById('customerOrderFilter').value = '';
    document.getElementById('customerDateFilter').value = '';
    document.getElementById('customerSortFilter').value = 'id_asc';
    
    applyCustomerFilters();
}

// Hiển thị modal chi tiết khách hàng (bổ sung trường mới)
function showCustomerDetail(cus) {
  document.getElementById('viewCusId').textContent = cus.id || '';
  document.getElementById('viewCusName').textContent = `${cus.firstName || ''} ${cus.lastName || ''}`.trim();
  document.getElementById('viewCusEmail').textContent = cus.email || '';
  document.getElementById('viewCusPhone').textContent = cus.phone || '';
  document.getElementById('viewCusDob').textContent = cus.dateOfBirth ? new Date(cus.dateOfBirth).toLocaleDateString('vi-VN') : '';
  document.getElementById('viewCusGender').textContent = cus.gender || '';
  document.getElementById('viewCusAddress').textContent = cus.address || '';
  document.getElementById('viewCusCreated').textContent = cus.createdAt ? new Date(cus.createdAt).toLocaleDateString('vi-VN') : '';
  const modal = new bootstrap.Modal(document.getElementById('viewCustomerModal'));
  modal.show();
}

// Hiển thị modal sửa khách hàng (bổ sung trường mới)
function showEditCustomerModal(cus) {
  document.getElementById('editCusId').value = cus.id || '';
  document.getElementById('editCusFirstName').value = cus.firstName || '';
  document.getElementById('editCusLastName').value = cus.lastName || '';
  document.getElementById('editCusEmail').value = cus.email || '';
  document.getElementById('editCusPhone').value = cus.phone || '';
  document.getElementById('editCusDob').value = cus.dateOfBirth ? cus.dateOfBirth.substring(0,10) : '';
  document.getElementById('editCusGender').value = cus.gender || '';
  document.getElementById('editCusAddress').value = cus.address || '';
  const modal = new bootstrap.Modal(document.getElementById('editCustomerModal'));
  modal.show();
}
