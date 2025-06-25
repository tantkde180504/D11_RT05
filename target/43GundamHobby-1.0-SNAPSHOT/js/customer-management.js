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
      data.forEach(cus => {
        const fullName = `${cus.firstName || ""} ${cus.lastName || ""}`.trim();
        const createdAt = cus.createdAt ? new Date(cus.createdAt).toLocaleDateString('vi-VN') : "";
        const row = `
          <tr>
            <td>${cus.id || ""}</td>
            <td>${fullName}</td>
            <td>${cus.email || ""}</td>
            <td>${cus.phone || ""}</td>
            <td>${createdAt}</td>
            <td><!-- Tổng đơn hàng --></td>
            <td>
              <button class=\"btn btn-sm btn-info\"><i class=\"fas fa-eye\"></i></button>
              <button class=\"btn btn-sm btn-warning\"><i class=\"fas fa-edit\"></i></button>
            </td>
          </tr>
        `;
        tbody.insertAdjacentHTML("beforeend", row);
      });
    })
    .catch(err => {
      alert("Không thể tải danh sách khách hàng");
      console.error(err);
    });
}
