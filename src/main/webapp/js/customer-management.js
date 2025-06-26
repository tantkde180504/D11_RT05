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
});

function apiUrl(path) {
  const API_BASE = "http://localhost:8081";
  if (path.startsWith("/")) return API_BASE + path;
  return API_BASE + "/" + path;
}

function loadCustomerList() {
  fetch(apiUrl("/api/staffs/customers"))
    .then(res => {
      if (!res.ok) throw new Error("Lỗi HTTP");
      return res.json();
    })
    .then(data => {
      const tbody = document.getElementById("customerTableBody");
      tbody.innerHTML = "";
      data.forEach((cus, idx) => {
        const fullName = `${cus.firstName || ""} ${cus.lastName || ""}`.trim();
        const createdAt = cus.createdAt ? new Date(cus.createdAt).toLocaleDateString('vi-VN') : "";
        const row = `
          <tr>
            <td>${idx + 1}</td>
            <td>${fullName}</td>
            <td>${cus.email || ""}</td>
            <td>${cus.phone || ""}</td>
            <td>${createdAt}</td>
            <td><!-- Tổng đơn hàng --></td>
            <td>
              <button class="btn btn-sm btn-info btn-view-cus" data-id="${cus.id}" title="Xem chi tiết"><i class="fas fa-eye"></i></button>
              <button class="btn btn-sm btn-warning btn-edit-cus" data-id="${cus.id}" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>
            </td>
          </tr>
        `;
        tbody.insertAdjacentHTML("beforeend", row);
      });
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
    })
    .catch(err => {
      alert("Không thể tải danh sách khách hàng");
      console.error(err);
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
