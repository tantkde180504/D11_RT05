document.addEventListener("DOMContentLoaded", function () {
  let customerLoaded = false;
  // Chỉ load khi tab khách hàng được mở
  const customerTab = document.querySelector('a[href="#customers"]');
  if (customerTab) {
    customerTab.addEventListener("shown.bs.tab", function () {
      if (!customerLoaded) {
        loadCustomerList();
      }
    });
  }
  // Nếu tab khách hàng đang active sẵn
  const activeTab = document.querySelector('.tab-pane.active#customers');
  if (activeTab && !customerLoaded) {
    loadCustomerList();
  }
  // Badge filter gender elements
  const genderBadgeContainer = document.getElementById('customerGenderBadgeContainer');

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
          // Try to parse validation errors from backend
          let errorObj = null;
          try {
            errorObj = JSON.parse(msg);
          } catch (e) {}
          if (errorObj && errorObj.errors) {
            // Show field-specific errors
            let errorMsg = 'Cập nhật thất bại!\n';
            errorObj.errors.forEach(err => {
              errorMsg += `- ${err.field}: ${err.defaultMessage}\n`;
              // Optionally, highlight the field
              const field = editForm.querySelector(`[name='${err.field}']`);
              if (field) {
                field.classList.add('is-invalid');
                // Show error below field (if you have .invalid-feedback element)
                let feedback = field.parentElement.querySelector('.invalid-feedback');
                if (feedback) feedback.textContent = err.defaultMessage;
              }
            });
            throw new Error(errorMsg);
          } else {
            throw new Error('Lỗi cập nhật: ' + msg);
          }
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
        alert(err);
        console.error(err);
        if (submitBtn) submitBtn.disabled = false;
        // Remove previous invalid highlights after error
        ['editCusFirstName','editCusLastName','editCusEmail','editCusPhone','editCusDob','editCusGender','editCusAddress'].forEach(fid => {
          const field = document.getElementById(fid);
          if (field) field.classList.remove('is-invalid');
          let feedback = field && field.parentElement.querySelector('.invalid-feedback');
          if (feedback) feedback.textContent = '';
        });
      });
    });
  }

  // Thay vào đó, gán sự kiện cho ô tìm kiếm nâng cao
  const advSearchInput = document.getElementById('customerSearchInputAdvanced');
  if (advSearchInput) {
    advSearchInput.addEventListener('input', function () {
      const searchValue = this.value.toLowerCase();
      const rows = document.querySelectorAll('#customerTableBody tr');
      rows.forEach(row => {
        const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
        const email = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
        const phone = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
        if (
          name.includes(searchValue) ||
          email.includes(searchValue) ||
          phone.includes(searchValue)
        ) {
          row.style.display = '';
        } else {
          row.style.display = 'none';
        }
      });
    });
  }

  // --- FILTERS ---
  const genderFilter = document.getElementById('customerGenderFilter');
  const orderFilter = document.getElementById('customerOrderFilter');
  const dateFilter = document.getElementById('customerDateFilter');
  // Đã khai báo advSearchInput ở trên, không khai báo lại

  // Đặt filterCustomerRows ở ngoài hoàn toàn để mọi nơi đều gọi được
  function filterCustomerRows() {
    const genderFilter = document.getElementById('customerGenderFilter');
    const orderFilter = document.getElementById('customerOrderFilter');
    const dateFilter = document.getElementById('customerDateFilter');
    const advSearchInput = document.getElementById('customerSearchInputAdvanced');
    const gender = genderFilter ? genderFilter.value : '';
    const order = orderFilter ? orderFilter.value : '';
    const date = dateFilter ? dateFilter.value : '';
    const searchValue = advSearchInput ? advSearchInput.value.toLowerCase() : '';
    const rows = document.querySelectorAll('#customerTableBody tr');
    const now = new Date();
    let filteredCount = 0;
    rows.forEach(row => {
      // Lấy dữ liệu từng cột
      const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
      const email = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
      const phone = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
      const regDateText = row.querySelector('td:nth-child(5)').textContent.trim();
      const orderCount = parseInt(row.querySelector('td:nth-child(6)').textContent.trim() || '0', 10);
      const genderText = row.getAttribute('data-gender') || '';
      // --- Lọc theo search ---
      let visible = true;
      if (searchValue && !(name.includes(searchValue) || email.includes(searchValue) || phone.includes(searchValue))) {
        visible = false;
      }
      // --- Lọc theo giới tính ---
      if (visible && gender) {
        if (genderText !== gender) visible = false;
      }
      // --- Lọc theo số đơn hàng ---
      if (visible && order) {
        if (order === 'new' && orderCount !== 0) visible = false;
        else if (order === 'low' && (orderCount < 1 || orderCount > 5)) visible = false;
        else if (order === 'medium' && (orderCount < 6 || orderCount > 15)) visible = false;
        else if (order === 'high' && orderCount <= 15) visible = false;
      }
      // --- Lọc theo ngày đăng ký ---
      if (visible && date) {
        let regDate = null;
        if (regDateText) {
          // Định dạng dd/MM/yyyy hoặc dd/MM/yy
          const parts = regDateText.split('/');
          if (parts.length === 3) {
            let year = parseInt(parts[2], 10);
            if (year < 100) year += 2000;
            regDate = new Date(year, parseInt(parts[1], 10) - 1, parseInt(parts[0], 10));
          }
        }
        if (regDate) {
          const diffDays = Math.floor((now - regDate) / (1000 * 60 * 60 * 24));
          if (date === 'today' && diffDays !== 0) visible = false;
          else if (date === 'week' && diffDays > 6) visible = false;
          else if (date === 'month' && diffDays > 30) visible = false;
          else if (date === 'old' && diffDays <= 30) visible = false;
        } else {
          visible = false;
        }
      }
      row.style.display = visible ? '' : 'none';
      if (visible) filteredCount++;
    });
    // Cập nhật bộ đếm số lượng khách hàng đã lọc/tổng số
    document.getElementById('customerFilteredCount').textContent = filteredCount;
    document.getElementById('customerTotalCount').textContent = rows.length;
  }

  if (genderFilter) genderFilter.addEventListener('change', filterCustomerRows);
  if (orderFilter) orderFilter.addEventListener('change', filterCustomerRows);
  if (dateFilter) dateFilter.addEventListener('change', filterCustomerRows);
  if (advSearchInput) advSearchInput.addEventListener('input', filterCustomerRows);

  // Hiển thị badge filter giới tính
  if (genderFilter) {
    genderFilter.addEventListener('change', function() {
      showGenderBadge();
    });
    // Hiển thị badge khi load lại trang nếu filter đã chọn
    showGenderBadge();
  }

  function showGenderBadge() {
    if (!genderBadgeContainer) return;
    const gender = genderFilter ? genderFilter.value : '';
    genderBadgeContainer.innerHTML = '';
    if (gender) {
      let label = '';
      let badgeClass = 'status-badge';
      let customStyle = '';
      if (gender === 'MALE') {
        label = 'Giới tính: Nam';
        customStyle = 'background: linear-gradient(90deg, #e55a00 0%, #d94e13 100%); color: #fff;';
      } else if (gender === 'FEMALE') {
        label = 'Giới tính: Nữ';
        customStyle = 'background: linear-gradient(90deg, #e55a00 0%, #d94e13 100%); color: #fff;';
      } else if (gender === 'OTHER') {
        label = 'Giới tính: Khác';
        customStyle = 'background: linear-gradient(90deg, #e55a00 0%, #d94e13 100%); color: #fff;';
      }
      genderBadgeContainer.innerHTML = `<span class="${badgeClass} ms-2" style="${customStyle} font-size:1rem;">${label} <button type="button" class="btn btn-sm btn-close ms-1 p-0" aria-label="Xóa" id="clearGenderFilterBtn" style="filter: invert(1);"></button></span>`;
      const clearBtn = document.getElementById('clearGenderFilterBtn');
      if (clearBtn) {
        clearBtn.addEventListener('click', function(e) {
          genderFilter.value = '';
          showGenderBadge();
          filterCustomerRows();
        });
      }
    }
  }
});

function apiUrl(path) {
  const API_BASE = "http://localhost:8080";
  if (path.startsWith("/")) return API_BASE + path;
  return API_BASE + "/" + path;
}

function loadCustomerList() {
  fetch(apiUrl("/api/staffs/customers"), {
    headers: {
      'Accept': 'application/json'
    }
  })
    .then(res => {
      if (!res.ok) {
        // Đã xóa alert thông báo lỗi
        throw new Error("Lỗi HTTP: " + res.status);
      }
      return res.json();
    })
    .then(data => {
      const tbody = document.getElementById("customerTableBody");
      tbody.innerHTML = "";
      data.forEach((cus, idx) => {
        const fullName = `${cus.firstName || ""} ${cus.lastName || ""}`.trim();
        const createdAt = cus.createdAt ? new Date(cus.createdAt).toLocaleDateString('vi-VN') : "";
        const row = `
          <tr data-gender="${cus.gender || ''}">
            <td>${idx + 1}</td>
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
      window.customerLoaded = true;
      // Gán sự kiện cho nút xem
      tbody.querySelectorAll('.btn-view-cus').forEach(btn => {
        btn.addEventListener('click', function() {
          const id = this.getAttribute('data-id');
          const cus = data.find(c => c.id == id);
          if (cus) showCustomerDetail(cus);
        });
      });
      // Gán sự kiện cho nút sửa
      tbody.querySelectorAll('.btn-edit-cus').forEach(btn => {
        btn.addEventListener('click', function() {
          const id = this.getAttribute('data-id');
          const cus = data.find(c => c.id == id);
          if (cus) showEditCustomerModal(cus);
        });
      });
      // Thêm hiệu ứng hover cho dòng
      tbody.querySelectorAll('tr').forEach(tr => {
        tr.classList.add('table-row-hover');
      });
      filterCustomerRows(); // Lọc lại khi tải xong danh sách
      showGenderBadge(); // Hiển thị lại badge khi load danh sách
    })
    .catch(err => {
      // Đã xóa alert thông báo lỗi
      console.error("Lỗi khi tải danh sách khách hàng:", err);
    });
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
