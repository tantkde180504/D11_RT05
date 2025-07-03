document.addEventListener("DOMContentLoaded", function () {
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
        alert("Vui lòng nhập đầy đủ các trường: " + missing.join(", "));
        return;
      }

      // Validate email phải chứa @
      const emailValue = form.querySelector('input[name="email"]').value;
      if (!emailValue.includes("@")) {
        alert("Email phải chứa ký tự @");
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
          alert("✅ Tạo nhân viên thành công!");
          const roleLabel = result.role === "STAFF" ? "Nhân viên" : result.role;
          const row = document.createElement("tr");
          row.innerHTML = `
            <td>${result.id}</td>
            <td>${result.firstName} ${result.lastName}</td>
            <td>${result.email}</td>
            <td>${result.phone || ''}</td>
            <td>${roleLabel}</td>
            <td>${result.createdAtFormatted || ""}</td>
            <td><span class="badge bg-success">Hoạt động</span></td>
            <td>
              <button class="btn btn-sm btn-warning" onclick="openEditModal(${result.id})"><i class="fas fa-edit"></i></button>
              <button class="btn btn-sm btn-danger" onclick="deleteStaff(${result.id})"><i class="fas fa-trash"></i></button>
            </td>
          `;
          document.querySelector("#staffTableBody").appendChild(row);
          form.reset();
          bootstrap.Modal.getInstance(document.getElementById("addStaffModal")).hide();
        })
        .catch(err => {
          if (err.text) {
            err.text().then(msg => alert("❌ Lỗi: " + msg));
          } else {
            alert("❌ Lỗi không xác định khi tạo nhân viên.");
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
});

// Đổi base URL API cho đúng port backend
const API_BASE = "http://localhost:8081";

function apiUrl(path) {
  if (path.startsWith("/")) return API_BASE + path;
  return API_BASE + "/" + path;
}

function loadStaffList() {
  console.log("✅ Hàm loadStaffList đã được gọi");
  fetch(apiUrl("/api/staffs/list"))
    .then(res => {
      if (!res.ok) throw new Error("Lỗi HTTP");
      return res.json();
    })
    .then(data => {
      console.log("📦 Dữ liệu trả về:", data);
      const tbody = document.getElementById("staffTableBody");
      tbody.innerHTML = "";
      data.forEach(staff => {
        const fullName = `${staff.firstName} ${staff.lastName}`;
        const joinDate = staff.createdAtFormatted || "";
        // Log id khi render nút xóa
        console.log("[DEBUG] Render staff row, id:", staff.id, staff);
        let deleteBtn = '';
        if (staff.id !== undefined && staff.id !== null && staff.id !== "" && !isNaN(staff.id)) {
          deleteBtn = `<button class=\"btn btn-sm btn-danger\" onclick=\"deleteStaff(${staff.id})\"><i class=\"fas fa-trash\"></i></button>`;
        } else {
          console.warn("[WARN] Không render nút xóa vì staff không có id hợp lệ:", staff);
        }
        const row = `
          <tr>
            <td>${staff.id || ''}</td>
            <td>${fullName}</td>
            <td>${staff.email}</td>
            <td>${staff.phone || ''}</td>
            <td>Nhân viên</td>
            <td>${joinDate}</td>
            <td><span class=\"badge bg-success\">Hoạt động</span></td>
            <td>
              <button class=\"btn btn-sm btn-warning\" onclick=\"openEditModal(${staff.id})\"><i class=\"fas fa-edit\"></i></button>
              ${deleteBtn}
            </td>
          </tr>
        `;
        tbody.insertAdjacentHTML("beforeend", row);
      });
    })
    .catch(err => {
      console.error("❌ Lỗi khi tải danh sách nhân viên:", err);
      alert("Không thể tải danh sách nhân viên. Kiểm tra API /api/staffs/list hoặc xem log backend.");
    });
}

// ✅ Gắn các hàm vào phạm vi global
window.openEditModal = function (id) {
  fetch(apiUrl(`/api/staffs/${id}`))
    .then(async res => {
      if (!res.ok) {
        let msg = "Không tìm thấy nhân viên với ID: " + id;
        try {
          const errJson = await res.json();
          if (errJson && errJson.message) msg = errJson.message;
        } catch {}
        // Reload lại danh sách nếu không tìm thấy nhân viên
        alert(msg + "\nDanh sách sẽ được làm mới.");
        loadStaffList();
        return Promise.reject(new Error(msg));
      }
      return res.json();
    })
    .then(data => {
      if (!data || !data.id) {
        alert("API không trả về dữ liệu hợp lệ.\n" + JSON.stringify(data));
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
      alert("Không thể tải dữ liệu nhân viên.\n" + err.message);
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
    alert("Vui lòng nhập đầy đủ các trường: " + missing.join(", "));
    return;
  }
  
  // Đảm bảo format ngày đúng yyyy-MM-dd
  let dateOfBirth = document.getElementById("editDateOfBirth").value;
  console.log("Original dateOfBirth:", dateOfBirth);
  
  // Nếu đã là format yyyy-MM-dd thì ok, nếu không thì convert
  if (!dateOfBirth.match(/^\d{4}-\d{2}-\d{2}$/)) {
    console.warn("Invalid date format, trying to convert:", dateOfBirth);
    try {
      const date = new Date(dateOfBirth);
      if (!isNaN(date)) {
        dateOfBirth = date.toISOString().split('T')[0];
        console.log("Converted dateOfBirth:", dateOfBirth);
      } else {
        alert("Format ngày sinh không hợp lệ. Vui lòng nhập lại.");
        return;
      }
    } catch (e) {
      alert("Format ngày sinh không hợp lệ. Vui lòng nhập lại.");
      return;
    }
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
    alert("Email phải chứa ký tự @");
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
      alert("Cập nhật thành công");
      bootstrap.Modal.getInstance(document.getElementById("editStaffModal")).hide();
      loadStaffList(); // Reload danh sách thay vì reload toàn trang
    } else {
      // Xử lý lỗi chi tiết
      let errorMessage = "Lỗi khi cập nhật nhân viên";
      try {
        const errorData = await res.json();
        if (errorData.message) {
          errorMessage = errorData.message;
        }
      } catch (e) {
        // Nếu không parse được JSON, lấy text
        try {
          const errorText = await res.text();
          if (errorText) {
            errorMessage = errorText;
          }
        } catch (e2) {
          errorMessage = `Lỗi HTTP ${res.status}: ${res.statusText}`;
        }
      }
      alert(errorMessage);
      console.error("Chi tiết lỗi:", res);
    }
  })
  .catch(err => {
    console.error("❌ Lỗi khi cập nhật nhân viên:", err);
    alert("Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.");
  });
};

window.deleteStaff = function (id) {
  console.log("[DEBUG] Gọi deleteStaff với id:", id, typeof id);
  if (!id || isNaN(id)) {
    alert("ID nhân viên không hợp lệ! Không thể xóa.");
    console.warn("[WARN] deleteStaff được gọi với id không hợp lệ:", id);
    return;
  }
  if (confirm("Bạn có chắc chắn muốn xoá nhân viên này?")) {
    fetch(apiUrl(`/api/staffs/${id}`), {
      method: "DELETE"
    }).then(res => {
      if (res.ok) {
        alert("Xoá thành công!");
        loadStaffList();
      } else {
        alert("Xoá thất bại!");
      }
    });
  }
};
