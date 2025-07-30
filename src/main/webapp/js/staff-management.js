document.addEventListener("DOMContentLoaded", function () {
  // === Hàm hiển thị thông báo Bootstrap alert/toast ===
  window.showBootstrapAlert = function(message, type = 'success', timeout = 3000) {
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
  const form = document.querySelector("#addStaffForm");
  if (form) {

    form.addEventListener("submit", function (e) {
      e.preventDefault();

      // Validate all required fields
      const requiredFields = [
        { name: "firstName", label: "Họ" },
        { name: "lastName", label: "Tên" },
        { name: "email", label: "Email" },
        { name: "password", label: "Mật khẩu" },
        { name: "phone", label: "Số điện thoại" },
        { name: "dateOfBirth", label: "Ngày sinh" },
        { name: "gender", label: "Giới tính" },
        { name: "address", label: "Địa chỉ" }
      ];
      let missing = [];
      requiredFields.forEach(f => {
        const value = form.querySelector(`[name="${f.name}"]`).value;
        if (!value || value.trim() === "") missing.push(f.label);
      });
      if (missing.length > 0) {
        showBootstrapAlert("Vui lòng nhập đầy đủ các trường: " + missing.join(", "), 'warning');
        return;
      }

      // Validate mật khẩu theo rule backend
      const password = form.querySelector('input[name="password"]').value;
      if (password.length < 8 || password.length > 20) {
        showBootstrapAlert("Mật khẩu phải từ 8 đến 20 ký tự", 'warning');
        return;
      }
      if (!/[A-Z]/.test(password)) {
        showBootstrapAlert("Mật khẩu phải chứa ít nhất 1 chữ hoa (A-Z)", 'warning');
        return;
      }
      if (!/[a-z]/.test(password)) {
        showBootstrapAlert("Mật khẩu phải chứa ít nhất 1 chữ thường (a-z)", 'warning');
        return;
      }
      if (!/[0-9]/.test(password)) {
        showBootstrapAlert("Mật khẩu phải chứa ít nhất 1 chữ số (0-9)", 'warning');
        return;
      }
      if (!/[!@#$%^&*()_\-+=]/.test(password)) {
        showBootstrapAlert("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt (!@#$%^&*()_+-=)", 'warning');
        return;
      }

      // Validate ngày sinh: phải đúng định dạng yyyy-MM-dd, là ngày hợp lệ, năm >= 1900, không ở tương lai, đủ 18 tuổi
      const dobValue = form.querySelector('input[name="dateOfBirth"]').value;
      if (!dobValue.match(/^\d{4}-\d{2}-\d{2}$/)) {
        showBootstrapAlert("Ngày sinh không hợp lệ. Định dạng phải là yyyy-MM-dd.", 'warning');
        return;
      }
      // Kiểm tra ngày thực tế và năm >= 1900
      const [yyyy, mm, dd] = dobValue.split('-').map(Number);
      const nowYear = new Date().getFullYear();
      const minYear = 1900;
      const maxYear = nowYear - 18;
      if (yyyy < minYear || yyyy > maxYear || mm < 1 || mm > 12 || dd < 1 || dd > 31) {
        showBootstrapAlert(`Năm sinh phải từ ${minYear} đến ${maxYear} (và đủ 18 tuổi)!`, 'warning');
        return;
      }
      // Kiểm tra ngày tồn tại thực tế (ví dụ: 2023-02-30 là không hợp lệ)
      const dob = new Date(dobValue);
      if (dob.getFullYear() !== yyyy || dob.getMonth() + 1 !== mm || dob.getDate() !== dd) {
        showBootstrapAlert("Ngày sinh không tồn tại thực tế.", 'warning');
        return;
      }
      const now = new Date();
      if (dob > now) {
        showBootstrapAlert("Ngày sinh không được lớn hơn ngày hiện tại!", 'warning');
        return;
      }
      // Kiểm tra đủ 18 tuổi
      const age = now.getFullYear() - dob.getFullYear() - (now.getMonth() < dob.getMonth() || (now.getMonth() === dob.getMonth() && now.getDate() < dob.getDate()) ? 1 : 0);
      if (age < 18) {
        showBootstrapAlert("Nhân viên phải đủ 18 tuổi trở lên!", 'warning');
        return;
      }

      // Validate firstName & lastName: chỉ cho phép chữ và khoảng trắng, tối đa 50 ký tự
      const namePattern = /^[A-Za-zÀ-ỹ ]{1,50}$/;
      const firstName = form.querySelector('input[name="firstName"]').value.trim();
      const lastName = form.querySelector('input[name="lastName"]').value.trim();
      if (!namePattern.test(firstName)) {
          showBootstrapAlert("Họ chỉ được chứa chữ, khoảng trắng và tối đa 50 ký tự!", 'warning');
          return;
      }
      if (!namePattern.test(lastName)) {
          showBootstrapAlert("Tên chỉ được chứa chữ, khoảng trắng và tối đa 50 ký tự!", 'warning');
          return;
      }

      // Validate email phải chứa @
      const emailValue = form.querySelector('input[name="email"]').value;
      if (!emailValue.includes("@")) {
        showBootstrapAlert("Email phải chứa ký tự @", 'warning');
        return;
      }

      const data = {
        firstName: form.querySelector('input[name="firstName"]').value,
        lastName: form.querySelector('input[name="lastName"]').value,
        email: form.querySelector('input[name="email"]').value,
        password: form.querySelector('input[name="password"]').value,
        phone: form.querySelector('input[name="phone"]').value,
        dateOfBirth: form.querySelector('input[name="dateOfBirth"]').value,
        gender: form.querySelector('select[name="gender"]').value,
        address: form.querySelector('input[name="address"]').value
      };

      fetch(apiUrl("/api/staffs/create"), {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
      })
        .then(res => {
          if (!res.ok) throw res;
          return res.json();
        })
        .then(result => {
          showBootstrapAlert("✅ Tạo nhân viên thành công!", 'success');
          // Sau khi thêm mới, reload lại toàn bộ danh sách nhân viên để đảm bảo mọi chức năng hoạt động đầy đủ
          loadStaffList();
          form.reset();
          bootstrap.Modal.getInstance(document.getElementById("addStaffModal")).hide();
        })
        .catch(err => {
          if (err.text) {
            err.text().then(msg => showBootstrapAlert("❌ Lỗi: " + msg, 'danger'));
          } else {
            showBootstrapAlert("❌ Lỗi không xác định khi tạo nhân viên.", 'danger');
            console.error(err);
          }
        });
    });
  }

  const staffTab = document.querySelector('a[href="#employees"]');
  if (staffTab) {
    staffTab.addEventListener("shown.bs.tab", function () {
      console.log("🟢 Tab Nhân viên đã được mở, gọi loadStaffList()");
      loadStaffList();
    });
  }

  const activeTab = document.querySelector('.tab-pane.active#employees');
  if (activeTab) {
    console.log("🟢 Tab Nhân viên đang active sẵn, gọi loadStaffList()");
    loadStaffList();
  }

  // Staff filter event listeners
  const staffSearchInput = document.getElementById('staffSearchInput');
  if (staffSearchInput) {
    staffSearchInput.addEventListener('input', (e) => {
      currentStaffFilters.search = e.target.value;
      applyStaffFilters();
    });
  }

  const roleFilter = document.getElementById('roleFilter');
  if (roleFilter) {
    roleFilter.addEventListener('change', (e) => {
      currentStaffFilters.role = e.target.value;
      applyStaffFilters();
    });
  }

  const staffStatusFilter = document.getElementById('staffStatusFilter');
  if (staffStatusFilter) {
    staffStatusFilter.addEventListener('change', (e) => {
      currentStaffFilters.status = e.target.value;
      applyStaffFilters();
    });
  }

  const joinDateFilter = document.getElementById('joinDateFilter');
  if (joinDateFilter) {
    joinDateFilter.addEventListener('change', (e) => {
      currentStaffFilters.joinDate = e.target.value;
      applyStaffFilters();
    });
  }

  const staffSortFilter = document.getElementById('staffSortFilter');
  if (staffSortFilter) {
    staffSortFilter.addEventListener('change', (e) => {
      currentStaffFilters.sort = e.target.value;
      applyStaffFilters();
    });
  }

  const resetStaffFiltersBtn = document.getElementById('resetStaffFiltersBtn');
  if (resetStaffFiltersBtn) {
    resetStaffFiltersBtn.addEventListener('click', resetAllStaffFilters);
  }
});

// Đổi base URL API cho đúng port backend
const API_BASE = "http://localhost:8080";

function apiUrl(path) {
  if (path.startsWith("/")) return API_BASE + path;
  return API_BASE + "/" + path;
}

function loadStaffList() {
  console.log("✅ Hàm loadStaffList đã được gọi");
  fetch(apiUrl("/api/staffs/list"), {
    headers: {
      'Accept': 'application/json'
    }
  })
    .then(res => {
      if (!res.ok) throw new Error("Lỗi HTTP");
      return res.json();
    })
    .then(data => {
      console.log("📦 Dữ liệu trả về:", data);
      // Store data in global variable for filtering
      staffList = data;
      // Reset filter UI và biến filter về mặc định
      currentStaffFilters = {
        search: '',
        role: '',
        status: '',
        joinDate: '',
        sort: 'id_asc'
      };
      var staffSearchInput = document.getElementById('staffSearchInput');
      if (staffSearchInput) staffSearchInput.value = '';
      var roleFilter = document.getElementById('roleFilter');
      if (roleFilter) roleFilter.value = '';
      var staffStatusFilter = document.getElementById('staffStatusFilter');
      if (staffStatusFilter) staffStatusFilter.value = '';
      var joinDateFilter = document.getElementById('joinDateFilter');
      if (joinDateFilter) joinDateFilter.value = '';
      var staffSortFilter = document.getElementById('staffSortFilter');
      if (staffSortFilter) staffSortFilter.value = 'id_asc';
      if (typeof updateStaffActiveFilters === 'function') updateStaffActiveFilters();
      // Apply lại filter mặc định
      applyStaffFilters();
    })
    .catch(err => {
      console.error("❌ Lỗi khi tải danh sách nhân viên:", err);
      alert("Không thể tải danh sách nhân viên. Kiểm tra API /api/staffs/list hoặc xem log backend.");
      // Reset data and UI
      staffList = [];
      applyStaffFilters();
    });
}

// ✅ Gắn các hàm vào phạm vi global
window.openEditModal = function (id) {
  fetch(apiUrl(`/api/staffs/${id}`), {
    headers: {
      'Accept': 'application/json'
    }
  })
    .then(async res => {
      if (!res.ok) {
        let msg = "Không tìm thấy nhân viên với ID: " + id;
        try {
          const errJson = await res.json();
          if (errJson && errJson.message) msg = errJson.message;
        } catch {}
        // Reload lại danh sách nếu không tìm thấy nhân viên
        showBootstrapAlert(msg + "<br>Danh sách sẽ được làm mới.", 'danger');
        loadStaffList();
        return Promise.reject(new Error(msg));
      }
      return res.json();
    })
    .then(data => {
      if (!data || !data.id) {
        showBootstrapAlert("API không trả về dữ liệu hợp lệ.<br>" + JSON.stringify(data), 'danger');
        loadStaffList();
        return;
      }
      document.getElementById("editId").value = data.id;
      document.getElementById("editFirstName").value = data.firstName || "";
      document.getElementById("editLastName").value = data.lastName || "";
      document.getElementById("editEmail").value = data.email || "";
      document.getElementById("editPhone").value = data.phone || "";
      
      // Xử lý ngày sinh - convert từ LocalDate sang format yyyy-MM-dd nếu cần
      let dateOfBirth = "";
      if (data.dateOfBirth) {
        // Nếu đã là format yyyy-MM-dd thì dùng luôn
        if (data.dateOfBirth.match(/^\d{4}-\d{2}-\d{2}$/)) {
          dateOfBirth = data.dateOfBirth;
        } else {
          // Nếu là format khác, thử parse và convert
          try {
            const date = new Date(data.dateOfBirth);
            if (!isNaN(date)) {
              dateOfBirth = date.toISOString().split('T')[0];
            }
          } catch (e) {
            console.warn("Không thể parse ngày sinh:", data.dateOfBirth);
          }
        }
      }
      document.getElementById("editDateOfBirth").value = dateOfBirth;
      
      document.getElementById("editGender").value = data.gender || "";
      document.getElementById("editAddress").value = data.address || "";
      const modal = new bootstrap.Modal(document.getElementById("editStaffModal"));
      modal.show();
    })
    .catch(err => {
      if (err && err.message && err.message.startsWith("Không tìm thấy nhân viên")) return;
      console.error("❌ Lỗi khi lấy dữ liệu nhân viên:", err);
      showBootstrapAlert("Không thể tải dữ liệu nhân viên.<br>" + err.message, 'danger');
    });
};

window.saveStaffUpdate = function () {
  const id = document.getElementById("editId").value;
  
  // Validate required fields
  const requiredFields = [
    { id: "editFirstName", label: "Họ" },
    { id: "editLastName", label: "Tên" },
    { id: "editEmail", label: "Email" },
    { id: "editPhone", label: "Số điện thoại" },
    { id: "editDateOfBirth", label: "Ngày sinh" },
    { id: "editGender", label: "Giới tính" },
    { id: "editAddress", label: "Địa chỉ" }
  ];
  
  let missing = [];
  requiredFields.forEach(field => {
    const value = document.getElementById(field.id).value;
    if (!value || value.trim() === "") {
      missing.push(field.label);
    }
  });
  
  if (missing.length > 0) {
    showBootstrapAlert("Vui lòng nhập đầy đủ các trường: " + missing.join(", "), 'warning');
    return;
  }
  
  // Đảm bảo format ngày đúng yyyy-MM-dd, kiểm tra ngày thực tế, năm >= 1900, đủ 18 tuổi
  let dateOfBirth = document.getElementById("editDateOfBirth").value;
  if (!dateOfBirth.match(/^\d{4}-\d{2}-\d{2}$/)) {
    showBootstrapAlert("Ngày sinh không hợp lệ. Định dạng phải là yyyy-MM-dd.", 'warning');
    return;
  }
  const [yyyy, mm, dd] = dateOfBirth.split('-').map(Number);
  const nowYear = new Date().getFullYear();
  const minYear = 1900;
  const maxYear = nowYear - 18;
  if (yyyy < minYear || yyyy > maxYear || mm < 1 || mm > 12 || dd < 1 || dd > 31) {
    showBootstrapAlert(`Năm sinh phải từ ${minYear} đến ${maxYear} (và đủ 18 tuổi)!`, 'warning');
    return;
  }
  const dob = new Date(dateOfBirth);
  if (dob.getFullYear() !== yyyy || dob.getMonth() + 1 !== mm || dob.getDate() !== dd) {
    showBootstrapAlert("Ngày sinh không tồn tại thực tế.", 'warning');
    return;
  }
  const now = new Date();
  if (dob > now) {
    showBootstrapAlert("Ngày sinh không được lớn hơn ngày hiện tại!", 'warning');
    return;
  }
  // Kiểm tra đủ 18 tuổi
  const age = now.getFullYear() - dob.getFullYear() - (now.getMonth() < dob.getMonth() || (now.getMonth() === dob.getMonth() && now.getDate() < dob.getDate()) ? 1 : 0);
  if (age < 18) {
    showBootstrapAlert("Nhân viên phải đủ 18 tuổi trở lên!", 'warning');
    return;
  }
  
  const data = {
    firstName: document.getElementById("editFirstName").value.trim(),
    lastName: document.getElementById("editLastName").value.trim(),
    email: document.getElementById("editEmail").value.trim(),
    phone: document.getElementById("editPhone").value.trim(),
    dateOfBirth: dateOfBirth,
    gender: document.getElementById("editGender").value,
    address: document.getElementById("editAddress").value.trim()
  };

  // Validate email phải chứa @
  if (!data.email.includes("@")) {
    showBootstrapAlert("Email phải chứa ký tự @", 'warning');
    return;
  }

  console.log("Dữ liệu gửi lên server:", data);

  fetch(apiUrl(`/api/staffs/${id}`), {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data)
  })
  .then(async res => {
    console.log("Response status:", res.status);
    if (res.ok) {
      showBootstrapAlert("Cập nhật thành công", 'success');
      bootstrap.Modal.getInstance(document.getElementById("editStaffModal")).hide();
      loadStaffList();
    } else {
      // Xử lý lỗi chi tiết từ backend (validation)
      let errorMessage = "Lỗi khi cập nhật nhân viên";
      try {
        const errorData = await res.json();
        if (errorData && typeof errorData === 'object') {
          if (Array.isArray(errorData.errors) && errorData.errors.length > 0) {
            // Gộp các thông báo lỗi lại, chỉ lấy defaultMessage
            errorMessage = errorData.errors.map(e => e.defaultMessage).join('<br>');
          } else if (errorData.message) {
            errorMessage = errorData.message;
          } else {
            errorMessage = JSON.stringify(errorData);
          }
        } else if (typeof errorData === 'string') {
          errorMessage = errorData;
        }
      } catch (e) {
        try {
          const errorText = await res.text();
          if (errorText) errorMessage = errorText;
        } catch (e2) {
          errorMessage = `Lỗi HTTP ${res.status}: ${res.statusText}`;
        }
      }
      showBootstrapAlert(errorMessage, 'danger');
      console.error("Chi tiết lỗi:", errorMessage);
    }
  })
  .catch(err => {
    console.error("❌ Lỗi khi cập nhật nhân viên:", err);
    showBootstrapAlert("Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.", 'danger');
  });
};


window.deleteStaff = function (id) {
  console.log("[DEBUG] Gọi deleteStaff với id:", id, typeof id);
  if (!id || isNaN(id)) {
    showBootstrapAlert("ID nhân viên không hợp lệ! Không thể xóa.", 'warning');
    console.warn("[WARN] deleteStaff được gọi với id không hợp lệ:", id);
    return;
  }
  showConfirmDeleteStaff(id);
};

// Modal xác nhận xóa nhân viên
function showConfirmDeleteStaff(id) {
  let modal = document.getElementById('confirmDeleteStaffModal');
  if (!modal) {
    modal = document.createElement('div');
    modal.className = 'modal fade';
    modal.id = 'confirmDeleteStaffModal';
    modal.tabIndex = -1;
    modal.innerHTML = `
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Xác nhận xoá nhân viên</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Bạn có chắc chắn muốn xoá nhân viên này?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
            <button type="button" class="btn btn-danger" id="confirmDeleteStaffBtn">Xoá</button>
          </div>
        </div>
      </div>`;
    document.body.appendChild(modal);
  }
  // Gán lại sự kiện cho nút xác nhận
  setTimeout(() => {
    const btn = document.getElementById('confirmDeleteStaffBtn');
    if (btn) {
      btn.onclick = function() {
        const bsModal = bootstrap.Modal.getInstance(modal);
        if (bsModal) bsModal.hide();
        doDeleteStaff(id);
      };
    }
  }, 100);
  const bsModal = new bootstrap.Modal(modal);
  bsModal.show();
}

function doDeleteStaff(id) {
  fetch(apiUrl(`/api/staffs/${id}`), {
    method: "DELETE"
  }).then(res => {
    if (res.ok) {
      showBootstrapAlert("Xoá thành công!", 'success');
      loadStaffList();
    } else {
      showBootstrapAlert("Xoá thất bại!", 'danger');
    }
  });
}

// Advanced Filters & Search for Staff Management
let staffList = [];
let currentStaffFilters = {
    search: '',
    role: '',
    status: '',
    joinDate: '',
    sort: 'id_asc'
};

function applyStaffFilters() {
    let filteredStaff = [...staffList];
    
    // Search filter
    if (currentStaffFilters.search) {
        const searchTerm = currentStaffFilters.search.toLowerCase();
        filteredStaff = filteredStaff.filter(staff => {
            const fullName = `${staff.firstName} ${staff.lastName}`.toLowerCase();
            const email = (staff.email || '').toLowerCase();
            const phone = (staff.phone || '').toLowerCase();
            
            return fullName.includes(searchTerm) || 
                   email.includes(searchTerm) || 
                   phone.includes(searchTerm);
        });
    }
    
    // Role filter
    if (currentStaffFilters.role) {
        filteredStaff = filteredStaff.filter(staff => {
            const staffRole = staff.role || 'STAFF';
            return staffRole === currentStaffFilters.role;
        });
    }
    
    // Status filter (assuming all current staff are active, can be extended)
    if (currentStaffFilters.status) {
        filteredStaff = filteredStaff.filter(staff => {
            // For now, assume all staff are active unless there's an isActive field
            if (currentStaffFilters.status === 'active') return staff.isActive !== false;
            if (currentStaffFilters.status === 'inactive') return staff.isActive === false;
            return true;
        });
    }
    
    // Join date filter
    if (currentStaffFilters.joinDate) {
        const now = new Date();
        filteredStaff = filteredStaff.filter(staff => {
            if (!staff.createdAt && !staff.createdAtFormatted) return false;
            
            let joinDate;
            if (staff.createdAt) {
                joinDate = new Date(staff.createdAt);
            } else if (staff.createdAtFormatted) {
                joinDate = new Date(staff.createdAtFormatted);
            }
            
            if (!joinDate || isNaN(joinDate)) return false;
            
            switch (currentStaffFilters.joinDate) {
                case 'today':
                    return joinDate.toDateString() === now.toDateString();
                case 'week':
                    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                    return joinDate >= weekAgo;
                case 'month':
                    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
                    return joinDate >= startOfMonth;
                case 'quarter':
                    const quarterAgo = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                    return joinDate >= quarterAgo;
                case 'year':
                    const yearAgo = new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
                    return joinDate >= yearAgo;
                case 'old':
                    const sixMonthsAgo = new Date(now.getFullYear(), now.getMonth() - 6, now.getDate());
                    return joinDate < sixMonthsAgo;
                default:
                    return true;
            }
        });
    }
    
    // Sort
    filteredStaff.sort((a, b) => {
        switch (currentStaffFilters.sort) {
            case 'id_asc': return (a.id || 0) - (b.id || 0);
            case 'id_desc': return (b.id || 0) - (a.id || 0);
            case 'name_asc': 
                const nameA = `${a.firstName} ${a.lastName}`.toLowerCase();
                const nameB = `${b.firstName} ${b.lastName}`.toLowerCase();
                return nameA.localeCompare(nameB);
            case 'name_desc':
                const nameA2 = `${a.firstName} ${a.lastName}`.toLowerCase();
                const nameB2 = `${b.firstName} ${b.lastName}`.toLowerCase();
                return nameB2.localeCompare(nameA2);
            case 'email_asc': return (a.email || '').localeCompare(b.email || '');
            case 'email_desc': return (b.email || '').localeCompare(a.email || '');
            case 'date_asc': 
                const dateA = new Date(a.createdAt || a.createdAtFormatted || 0);
                const dateB = new Date(b.createdAt || b.createdAtFormatted || 0);
                return dateA - dateB;
            case 'date_desc':
                const dateA2 = new Date(a.createdAt || a.createdAtFormatted || 0);
                const dateB2 = new Date(b.createdAt || b.createdAtFormatted || 0);
                return dateB2 - dateA2;
            default: return 0;
        }
    });
    
    // Update UI
    renderStaffTable(filteredStaff);
    updateStaffFilterSummary(filteredStaff.length);
    updateStaffActiveFilters();
}

function renderStaffTable(staffToRender) {
    const tbody = document.getElementById("staffTableBody");
    tbody.innerHTML = "";
    
    staffToRender.forEach(staff => {
        const fullName = `${staff.firstName} ${staff.lastName}`;
        const joinDate = staff.createdAtFormatted || "";
        const roleLabel = staff.role === "STAFF" ? "Nhân viên" : (staff.role || "Nhân viên");

        let deleteBtn = '';
        if (staff.id !== undefined && staff.id !== null && staff.id !== "" && !isNaN(staff.id)) {
            deleteBtn = `<button class="btn btn-sm btn-danger" onclick="deleteStaff(${staff.id})"><i class="fas fa-trash"></i></button>`;
        }

        // Nút chuyển trạng thái
        const toggleBtn = `<button class="btn btn-sm ${staff.isActive === false ? 'btn-success' : 'btn-secondary'}" title="${staff.isActive === false ? 'Kích hoạt' : 'Tạm ngưng'}" onclick="toggleStaffActive(${staff.id})">
            <i class="fas ${staff.isActive === false ? 'fa-power-off' : 'fa-ban'}"></i>
        </button>`;

        const statusBadge = staff.isActive === false ? 
            '<span class="badge bg-secondary">Tạm ngưng</span>' : 
            '<span class="badge bg-success">Hoạt động</span>';

        const row = `
            <tr>
                <td>${staff.id || ''}</td>
                <td>${fullName}</td>
                <td>${staff.email}</td>
                <td>${staff.phone || ''}</td>
                <td>${roleLabel}</td>
                <td>${joinDate}</td>
                <td>${statusBadge}</td>
                <td>
                    ${toggleBtn}
                    <button class="btn btn-sm btn-warning" onclick="openEditModal(${staff.id})"><i class="fas fa-edit"></i></button>
                    ${deleteBtn}
                </td>
            </tr>
        `;
        tbody.insertAdjacentHTML("beforeend", row);
    });
}

// Modal xác nhận chuyển trạng thái nhân viên
function showConfirmToggleStaff(id) {
    // Nếu modal chưa có trong DOM thì tạo
    let modal = document.getElementById('confirmToggleStaffModal');
    if (!modal) {
        modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.id = 'confirmToggleStaffModal';
        modal.tabIndex = -1;
        modal.innerHTML = `
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Xác nhận chuyển trạng thái</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              <p>Bạn có chắc muốn chuyển trạng thái nhân viên này?</p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Huỷ</button>
              <button type="button" class="btn btn-primary" id="confirmToggleStaffBtn">Xác nhận</button>
            </div>
          </div>
        </div>`;
        document.body.appendChild(modal);
    }
    // Gán lại sự kiện cho nút xác nhận
    setTimeout(() => {
      const btn = document.getElementById('confirmToggleStaffBtn');
      if (btn) {
        btn.onclick = function() {
          const bsModal = bootstrap.Modal.getInstance(modal);
          if (bsModal) bsModal.hide();
          doToggleStaffActive(id);
        };
      }
    }, 100);
    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();
}

// Hàm thực hiện gọi API chuyển trạng thái
function doToggleStaffActive(id) {
    if (!id) return;
    fetch(apiUrl(`/api/staffs/${id}/toggle-active`), {
        method: "PUT",
        headers: { 'Content-Type': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        if (data && data.message) showBootstrapAlert(data.message, 'info');
        loadStaffList();
    })
    .catch(err => {
        showBootstrapAlert("Lỗi khi chuyển trạng thái nhân viên!", 'danger');
        console.error(err);
    });
}

// Thay thế nút chuyển trạng thái gọi hàm mới
function toggleStaffActive(id) {
    showConfirmToggleStaff(id);
}

function updateStaffFilterSummary(filteredCount) {
    document.getElementById('staffFilteredCount').textContent = filteredCount;
    document.getElementById('staffTotalCount').textContent = staffList.length;
}

function updateStaffActiveFilters() {
    const container = document.getElementById('staffActiveFilters');
    container.innerHTML = '';
    
    const filterLabels = {
        search: 'Tìm kiếm',
        role: 'Chức vụ',
        status: 'Trạng thái',
        joinDate: 'Ngày vào làm'
    };
    
    Object.keys(currentStaffFilters).forEach(key => {
        if (currentStaffFilters[key] && key !== 'sort') {
            const badge = document.createElement('span');
            badge.className = 'badge bg-primary me-1';
            badge.innerHTML = `${filterLabels[key]}: ${getStaffFilterDisplayValue(key, currentStaffFilters[key])} <i class="fas fa-times ms-1" style="cursor: pointer;" onclick="removeStaffFilter('${key}')"></i>`;
            container.appendChild(badge);
        }
    });
}

function getStaffFilterDisplayValue(key, value) {
    const displayValues = {
        role: { ADMIN: 'Quản trị viên', STAFF: 'Nhân viên', MANAGER: 'Quản lý' },
        status: { active: 'Hoạt động', inactive: 'Tạm ngưng' },
        joinDate: { 
            today: 'Hôm nay', 
            week: 'Tuần này', 
            month: 'Tháng này', 
            quarter: 'Quý này',
            year: 'Năm này',
            old: 'Cũ hơn' 
        }
    };
    
    if (key === 'search') return value;
    return displayValues[key] ? displayValues[key][value] : value;
}

function removeStaffFilter(filterKey) {
    currentStaffFilters[filterKey] = '';
    document.getElementById(getStaffFilterElementId(filterKey)).value = '';
    applyStaffFilters();
}

function getStaffFilterElementId(filterKey) {
    const elementIds = {
        search: 'staffSearchInput',
        role: 'roleFilter',
        status: 'staffStatusFilter',
        joinDate: 'joinDateFilter',
        sort: 'staffSortFilter'
    };
    return elementIds[filterKey];
}

function resetAllStaffFilters() {
    currentStaffFilters = {
        search: '',
        role: '',
        status: '',
        joinDate: '',
        sort: 'id_asc'
    };
    // Reset form elements an toàn
    var staffSearchInput = document.getElementById('staffSearchInput');
    if (staffSearchInput) staffSearchInput.value = '';
    var roleFilter = document.getElementById('roleFilter');
    if (roleFilter) roleFilter.value = '';
    var staffStatusFilter = document.getElementById('staffStatusFilter');
    if (staffStatusFilter) staffStatusFilter.value = '';
    var joinDateFilter = document.getElementById('joinDateFilter');
    if (joinDateFilter) joinDateFilter.value = '';
    var staffSortFilter = document.getElementById('staffSortFilter');
    if (staffSortFilter) staffSortFilter.value = 'id_asc';
    // Xóa badge filter nếu có
    if (typeof updateStaffActiveFilters === 'function') updateStaffActiveFilters();
    // Gọi lại loadStaffList để đảm bảo dữ liệu gốc được hiển thị
    if (typeof loadStaffList === 'function') loadStaffList();
    // Sau khi load xong, filter lại bảng cho chắc chắn
    setTimeout(() => {
        if (typeof applyStaffFilters === 'function') applyStaffFilters();
        if (typeof updateStaffActiveFilters === 'function') updateStaffActiveFilters();
    }, 200);
}
