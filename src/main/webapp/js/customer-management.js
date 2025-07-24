  // Validate ngày sinh khi thêm khách hàng mới
  const addForm = document.getElementById('addCustomerForm');
  if (addForm) {
    addForm.addEventListener('submit', function(e) {
      // Validate ngày sinh: yyyy-MM-dd, ngày thực tế, tuổi 13-100
      const dobValue = addForm.querySelector('input[name="dateOfBirth"]').value;
      const submitBtn = addForm.querySelector('button[type="submit"]');
      if (!dobValue.match(/^\d{4}-\d{2}-\d{2}$/)) {
        showBootstrapAlert('Ngày sinh không hợp lệ. Định dạng phải là yyyy-MM-dd.', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        e.preventDefault();
        return;
      }
      const [yyyy, mm, dd] = dobValue.split('-').map(Number);
      const now = new Date();
      const nowYear = now.getFullYear();
      const minYear = nowYear - 100;
      const maxYear = nowYear - 13;
      if (yyyy < minYear || yyyy > maxYear || mm < 1 || mm > 12 || dd < 1 || dd > 31) {
        showBootstrapAlert(`Khách hàng phải từ 13 đến 100 tuổi (năm sinh từ ${minYear} đến ${maxYear})!`, 'warning');
        if (submitBtn) submitBtn.disabled = false;
        e.preventDefault();
        return;
      }
      const dob = new Date(dobValue);
      if (dob.getFullYear() !== yyyy || dob.getMonth() + 1 !== mm || dob.getDate() !== dd) {
        showBootstrapAlert('Ngày sinh không tồn tại thực tế.', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        e.preventDefault();
        return;
      }
      if (dob > now) {
        showBootstrapAlert('Ngày sinh không được lớn hơn ngày hiện tại!', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        e.preventDefault();
        return;
      }
    });
  }
let banCustomerId = null;

// === Hàm hiển thị thông báo Bootstrap alert/toast ===
function showBootstrapAlert(message, type = 'success', timeout = 3000) {
  // type: 'success', 'danger', 'warning', 'info'
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
// === Modal nhập lý do cấm (chèn trực tiếp vào DOM khi file JS được load) ===
(function() {
  if (!document.getElementById('banReasonModal')) {
    const modalHtml = `
    <div class="modal fade" id="banReasonModal" tabindex="-1" aria-labelledby="banReasonModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="banReasonModalLabel">Nhập lý do cấm tài khoản</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <textarea id="banReasonInput" class="form-control" rows="3" placeholder="Nhập lý do cấm..."></textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            <button type="button" class="btn btn-primary" id="confirmBanReasonBtn">Xác nhận</button>
          </div>
        </div>
      </div>
    </div>`;
    document.body.insertAdjacentHTML('beforeend', modalHtml);
  }
})();
document.addEventListener("DOMContentLoaded", function () {
  let customerLoaded = false;
  // Thêm sự kiện cho nút Đặt lại bộ lọc khách hàng
  const resetBtn = document.getElementById('resetCustomerFiltersBtn');
  if (resetBtn) {
    resetBtn.addEventListener('click', function() {
      // Xóa các bộ lọc
      const genderFilter = document.getElementById('customerGenderFilter');
      const orderFilter = document.getElementById('customerOrderFilter');
      const dateFilter = document.getElementById('customerDateFilter');
      const advSearchInput = document.getElementById('customerSearchInputAdvanced');
      if (genderFilter) genderFilter.value = '';
      if (orderFilter) orderFilter.value = '';
      if (dateFilter) dateFilter.value = '';
      if (advSearchInput) advSearchInput.value = '';
      // Cập nhật lại giao diện badge
      if (typeof showGenderBadge === 'function') showGenderBadge();
      if (typeof showOrderBadge === 'function') showOrderBadge();
      if (typeof showDateBadge === 'function') showDateBadge();
      // Gọi lại loadCustomerList để lấy lại dữ liệu gốc
      if (typeof loadCustomerList === 'function') loadCustomerList();
      // Sau khi load xong, filter lại bảng cho chắc chắn
      setTimeout(() => {
        if (typeof filterCustomerRows === 'function') filterCustomerRows();
      }, 200);
    });
  }
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
  const orderBadgeContainer = document.getElementById('customerOrderBadgeContainer');
  const dateBadgeContainer = document.getElementById('customerDateBadgeContainer');

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
      // Validate ngày sinh: yyyy-MM-dd, ngày thực tế, tuổi 13-100
      const dobValue = document.getElementById('editCusDob').value;
      if (!dobValue.match(/^\d{4}-\d{2}-\d{2}$/)) {
        showBootstrapAlert('Ngày sinh không hợp lệ. Định dạng phải là yyyy-MM-dd.', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        return;
      }
      const [yyyy, mm, dd] = dobValue.split('-').map(Number);
      const now = new Date();
      const nowYear = now.getFullYear();
      const minYear = nowYear - 100;
      const maxYear = nowYear - 13;
      if (yyyy < minYear || yyyy > maxYear || mm < 1 || mm > 12 || dd < 1 || dd > 31) {
        showBootstrapAlert(`Khách hàng phải từ 13 đến 100 tuổi (năm sinh từ ${minYear} đến ${maxYear})!`, 'warning');
        if (submitBtn) submitBtn.disabled = false;
        return;
      }
      const dob = new Date(dobValue);
      if (dob.getFullYear() !== yyyy || dob.getMonth() + 1 !== mm || dob.getDate() !== dd) {
        showBootstrapAlert('Ngày sinh không tồn tại thực tế.', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        return;
      }
      if (dob > now) {
        showBootstrapAlert('Ngày sinh không được lớn hơn ngày hiện tại!', 'warning');
        if (submitBtn) submitBtn.disabled = false;
        return;
      }
      // Lấy giá trị gender, nếu rỗng thì mặc định là 'MALE'
      let genderValue = document.getElementById('editCusGender').value;
      if (!genderValue || !['MALE','FEMALE','OTHER'].includes(genderValue)) genderValue = 'MALE';
      const data = {
        firstName: document.getElementById('editCusFirstName').value,
        lastName: document.getElementById('editCusLastName').value,
        email: document.getElementById('editCusEmail').value,
        phone: document.getElementById('editCusPhone').value,
        dateOfBirth: dobValue,
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
          showBootstrapAlert('Cập nhật thành công!', 'success');
          loadCustomerList();
          if (submitBtn) submitBtn.disabled = false;
        }, 300);
      })
      .catch(err => {
        showBootstrapAlert(err, 'danger');
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

  // Đặt filterCustomerRows ở global scope, ngoài mọi function
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
  window.filterCustomerRows = filterCustomerRows;

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
  window.showGenderBadge = showGenderBadge;

  // Hiển thị badge filter số đơn hàng
  if (orderFilter) {
    orderFilter.addEventListener('change', function() {
      showOrderBadge();
    });
    showOrderBadge();
  }
  function showOrderBadge() {
    if (!orderBadgeContainer) return;
    const order = orderFilter ? orderFilter.value : '';
    orderBadgeContainer.innerHTML = '';
    if (order) {
      let label = '';
      let badgeClass = 'status-badge';
      let customStyle = 'background: linear-gradient(90deg, #ff9800 0%, #ff6600 100%); color: #fff;';
      switch (order) {
        case 'new': label = 'Đơn hàng: Mới'; break;
        case 'low': label = 'Đơn hàng: Thấp'; break;
        case 'medium': label = 'Đơn hàng: Trung bình'; break;
        case 'high': label = 'Đơn hàng: Cao'; break;
        default: label = 'Đơn hàng: ' + order;
      }
      orderBadgeContainer.innerHTML = `<span class="${badgeClass} ms-2" style="${customStyle} font-size:1rem;">${label} <button type="button" class="btn btn-sm btn-close ms-1 p-0" aria-label="Xóa" id="clearOrderFilterBtn" style="filter: invert(1);"></button></span>`;
      const clearBtn = document.getElementById('clearOrderFilterBtn');
      if (clearBtn) {
        clearBtn.addEventListener('click', function(e) {
          orderFilter.value = '';
          showOrderBadge();
          filterCustomerRows();
        });
      }
    }
  }

  // Hiển thị badge filter ngày đăng ký
  if (dateFilter) {
    dateFilter.addEventListener('change', function() {
      showDateBadge();
    });
    showDateBadge();
  }
  function showDateBadge() {
    if (!dateBadgeContainer) return;
    const date = dateFilter ? dateFilter.value : '';
    dateBadgeContainer.innerHTML = '';
    if (date) {
      let label = '';
      let badgeClass = 'status-badge';
      let customStyle = 'background: linear-gradient(90deg, #00bcd4 0%, #2196f3 100%); color: #fff;';
      switch (date) {
        case 'today': label = 'Ngày đăng ký: Hôm nay'; break;
        case 'week': label = 'Ngày đăng ký: Tuần này'; break;
        case 'month': label = 'Ngày đăng ký: Tháng này'; break;
        case 'old': label = 'Ngày đăng ký: Cũ'; break;
        default: label = 'Ngày đăng ký: ' + date;
      }
      dateBadgeContainer.innerHTML = `<span class="${badgeClass} ms-2" style="${customStyle} font-size:1rem;">${label} <button type="button" class="btn btn-sm btn-close ms-1 p-0" aria-label="Xóa" id="clearDateFilterBtn" style="filter: invert(1);"></button></span>`;
      const clearBtn = document.getElementById('clearDateFilterBtn');
      if (clearBtn) {
        clearBtn.addEventListener('click', function(e) {
          dateFilter.value = '';
          showDateBadge();
          filterCustomerRows();
        });
      }
    }
  }

  // Gọi API cập nhật trạng thái khách hàng
  function banCustomer(id, status) {
    if (!id || !status) return;
    if (status === 'banned') {
      banCustomerId = id;
      const banReasonInput = document.getElementById('banReasonInput');
      if (!banReasonInput) {
        alert('Không tìm thấy ô nhập lý do. Vui lòng kiểm tra lại modal!');
        return;
      }
      banReasonInput.value = '';
      const modal = new bootstrap.Modal(document.getElementById('banReasonModal'));
      modal.show();
      document.getElementById('confirmBanReasonBtn').onclick = function() {
        let banReason = banReasonInput.value.trim();
        if (!banReason) banReason = 'Không có lý do cụ thể';
        modal.hide();
        sendBanCustomer(banCustomerId, status, banReason);
      };
    } else {
      sendBanCustomer(id, status, '');
    }
  }

  function sendBanCustomer(id, status, banReason) {
    fetch(apiUrl(`/api/customers/${id}/ban`), {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(status === 'banned' ? { status, banReason } : { status })
    })
      .then(res => {
        if (!res.ok) throw new Error('Lỗi cập nhật trạng thái!');
        return res.text();
      })
      .then(() => {
        showBootstrapAlert(status === 'banned' ? 'Đã cấm tài khoản!' : 'Đã bỏ cấm tài khoản!', 'success');
        loadCustomerList();
      })
      .catch(err => {
        alert(err);
      });
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
        // Trạng thái: active/banned
        let statusBadge = '';
        if (cus.status === 'banned') {
          statusBadge = '<span class="badge bg-danger">Banned</span>';
        } else {
          statusBadge = '<span class="badge bg-success">Active</span>';
        }
        // Nút thao tác: Cấm hoặc Bỏ cấm
        let actionBtn = '';
        if (cus.status === 'banned') {
          actionBtn = `<button class="btn btn-sm btn-success btn-unban-cus" data-id="${cus.id}">Bỏ cấm</button>`;
        } else {
          actionBtn = `<button class="btn btn-sm btn-warning btn-ban-cus" data-id="${cus.id}">Cấm</button>`;
        }
        const row = `
          <tr data-gender="${cus.gender || ''}">
            <td>${idx + 1}</td>
            <td>${fullName}</td>
            <td>${cus.email || ""}</td>
            <td>${cus.phone || ""}</td>
            <td>${createdAt}</td>
            <td>${cus.totalOrders || 0}</td>
            <td>${statusBadge}</td>
            <td>
              <button class="btn btn-sm btn-info btn-view-cus" data-id="${cus.id}" title="Xem chi tiết"><i class="fas fa-eye"></i></button>
              <button class="btn btn-sm btn-warning btn-edit-cus" data-id="${cus.id}" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>
              ${actionBtn}
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
      // Gán sự kiện cho nút cấm/bỏ cấm
      tbody.querySelectorAll('.btn-ban-cus').forEach(btn => {
        btn.addEventListener('click', function() {
          const id = this.getAttribute('data-id');
          banCustomer(id, 'banned');
        });
      });
      tbody.querySelectorAll('.btn-unban-cus').forEach(btn => {
        btn.addEventListener('click', function() {
          const id = this.getAttribute('data-id');
          banCustomer(id, 'active');
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

// Hiển thị badge filter số đơn hàng
if (orderFilter) {
  orderFilter.addEventListener('change', function() {
    showOrderBadge();
  });
  showOrderBadge();
}
function showOrderBadge() {
  if (!orderBadgeContainer) return;
  const order = orderFilter ? orderFilter.value : '';
  orderBadgeContainer.innerHTML = '';
  if (order) {
    let label = '';
    let badgeClass = 'status-badge';
    let customStyle = 'background: linear-gradient(90deg, #ff9800 0%, #ff6600 100%); color: #fff;';
    switch (order) {
      case 'new': label = 'Đơn hàng: Mới'; break;
      case 'low': label = 'Đơn hàng: Thấp'; break;
      case 'medium': label = 'Đơn hàng: Trung bình'; break;
      case 'high': label = 'Đơn hàng: Cao'; break;
      default: label = 'Đơn hàng: ' + order;
    }
    orderBadgeContainer.innerHTML = `<span class="${badgeClass} ms-2" style="${customStyle} font-size:1rem;">${label} <button type="button" class="btn btn-sm btn-close ms-1 p-0" aria-label="Xóa" id="clearOrderFilterBtn" style="filter: invert(1);"></button></span>`;
    const clearBtn = document.getElementById('clearOrderFilterBtn');
    if (clearBtn) {
      clearBtn.addEventListener('click', function(e) {
        orderFilter.value = '';
        showOrderBadge();
        filterCustomerRows();
      });
    }
  }
}

// Hiển thị badge filter ngày đăng ký
if (dateFilter) {
  dateFilter.addEventListener('change', function() {
    showDateBadge();
  });
  showDateBadge();
}
function showDateBadge() {
  if (!dateBadgeContainer) return;
  const date = dateFilter ? dateFilter.value : '';
  dateBadgeContainer.innerHTML = '';
  if (date) {
    let label = '';
    let badgeClass = 'status-badge';
    let customStyle = 'background: linear-gradient(90deg, #00bcd4 0%, #2196f3 100%); color: #fff;';
    switch (date) {
      case 'today': label = 'Ngày đăng ký: Hôm nay'; break;
      case 'week': label = 'Ngày đăng ký: Tuần này'; break;
      case 'month': label = 'Ngày đăng ký: Tháng này'; break;
      case 'old': label = 'Ngày đăng ký: Cũ'; break;
      default: label = 'Ngày đăng ký: ' + date;
    }
    dateBadgeContainer.innerHTML = `<span class="${badgeClass} ms-2" style="${customStyle} font-size:1rem;">${label} <button type="button" class="btn btn-sm btn-close ms-1 p-0" aria-label="Xóa" id="clearDateFilterBtn" style="filter: invert(1);"></button></span>`;
    const clearBtn = document.getElementById('clearDateFilterBtn');
    if (clearBtn) {
      clearBtn.addEventListener('click', function(e) {
        dateFilter.value = '';
        showDateBadge();
        filterCustomerRows();
      });
    }
  }
}

// Sửa lại hàm banCustomer để dùng modal
function banCustomer(id, status) {
  if (!id || !status) return;
  if (status === 'banned') {
    banCustomerId = id;
    const banReasonInput = document.getElementById('banReasonInput');
    if (!banReasonInput) {
      alert('Không tìm thấy ô nhập lý do. Vui lòng kiểm tra lại modal!');
      return;
    }
    banReasonInput.value = '';
    const modal = new bootstrap.Modal(document.getElementById('banReasonModal'));
    modal.show();
    document.getElementById('confirmBanReasonBtn').onclick = function() {
      let banReason = banReasonInput.value.trim();
      if (!banReason) banReason = 'Không có lý do cụ thể';
      modal.hide();
      sendBanCustomer(banCustomerId, status, banReason);
    };
  } else {
    sendBanCustomer(id, status, '');
  }
}

function sendBanCustomer(id, status, banReason) {
  fetch(apiUrl(`/api/customers/${id}/ban`), {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(status === 'banned' ? { status, banReason } : { status })
  })
    .then(res => {
      if (!res.ok) throw new Error('Lỗi cập nhật trạng thái!');
      return res.text();
    })
    .then(() => {
      alert(status === 'banned' ? 'Đã cấm tài khoản!' : 'Đã bỏ cấm tài khoản!');
      loadCustomerList();
    })
    .catch(err => {
      showBootstrapAlert(err, 'danger');
    });
}
