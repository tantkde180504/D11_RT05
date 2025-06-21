document.addEventListener("DOMContentLoaded", function () {
  const form = document.querySelector("#addStaffForm");
  if (form) {
    form.addEventListener("submit", function(e) {
      e.preventDefault();

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

      fetch("/api/staffs/create", {
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
          <td>${roleLabel}</td>
          <td>${result.createdAtFormatted || ""}</td>
          <td><span class="badge bg-success">Hoạt động</span></td>
          <td>
            <button class="btn btn-sm btn-warning"><i class="fas fa-edit"></i></button>
            <button class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
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

  // 🔁 Chạy loadStaffList khi tab Nhân viên được mở
  const staffTab = document.querySelector('a[href="#employees"]');
  if (staffTab) {
    staffTab.addEventListener("shown.bs.tab", function () {
      console.log("🟢 Tab Nhân viên đã được mở, gọi loadStaffList()");
      loadStaffList();
    });
  }

  // 👀 Nếu tab đã active ngay từ đầu thì gọi luôn
  const activeTab = document.querySelector('.tab-pane.active#employees');
  if (activeTab) {
    console.log("🟢 Tab Nhân viên đang active sẵn, gọi loadStaffList()");
    loadStaffList();
  }
});

function loadStaffList() {
  console.log("✅ Hàm loadStaffList đã được gọi");
  fetch("/api/staffs/list")
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
        const row = `
          <tr>
            <td>${staff.id}</td>
            <td>${fullName}</td>
            <td>${staff.email}</td>
            <td>Nhân viên</td>
            <td>${joinDate}</td>
            <td><span class="badge bg-success">Hoạt động</span></td>
            <td>
              <button class="btn btn-sm btn-warning"><i class="fas fa-edit"></i></button>
              <button class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
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
