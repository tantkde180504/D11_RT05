// js/shipper.js
// Quản lý đơn hàng cho shipper


let orders = [];

// Lấy danh sách shipping từ backend
function fetchShippingOrders(filter = 'ALL') {
  let url = '/api/shipping';
  if (filter && filter !== 'ALL') {
    url += `?status=${encodeURIComponent(filter)}`;
  }
  fetch(url)
    .then(res => res.json())
    .then(data => {
      console.log('Shipping API data:', data);
      orders = data.map(item => ({
        shippingId: item.id, // id của bản ghi shipping (dùng cho API detail)
        orderId: item.orderId || '(Không rõ)',
        customer: item.customerName || item.shippingName || '(Không rõ)',
        address: item.shippingAddress || '(Không rõ)',
        phone: item.shippingPhone || '(Không rõ)',
        status: item.status || '(Không rõ)',
        date: item.shippingDate ? formatVietnameseDate(item.shippingDate) : ''
      }));
      renderOrders(filter);
    })
    .catch(err => {
      console.error('Lỗi lấy shipping:', err);
      orders = [];
      renderOrders(filter);
    });
}


function renderOrders(filter = 'ALL') {
  const tbody = document.getElementById('orders-table-body');
  tbody.innerHTML = '';
  orders.filter(order => filter === 'ALL' || order.status === filter)
    .forEach(order => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td><strong>${order.orderId}</strong></td>
        <td>${order.customer}</td>
        <td>${order.address}</td>
        <td>${order.phone}</td>
        <td>${statusBadge(order.status)}</td>
        <td>${order.date}</td>
        <td>
          <button class="btn btn-sm btn-info me-1" onclick="showOrderDetail('${order.shippingId}')"><i class="fas fa-eye"></i></button>
          <button class="btn btn-sm btn-warning" onclick="showUpdateStatus('${order.shippingId}')"><i class="fas fa-edit"></i></button>
        </td>
      `;
      tbody.appendChild(tr);
    });
}

function statusBadge(status) {
  switch(status) {
    case 'PENDING': return '<span class="badge bg-secondary">Chờ giao</span>';
    case 'SHIPPING': return '<span class="badge bg-primary">Đang giao</span>';
    case 'DELIVERED': return '<span class="badge bg-success">Đã giao</span>';
    case 'FAILED':
    case 'CANCELLED': return '<span class="badge bg-danger">Hủy giao hàng</span>';
    default: return status;
  }
}

// Xem chi tiết đơn giao: lấy từ backend để đảm bảo đủ thông tin
function showOrderDetail(orderId) {
  fetch(`/api/shipping/detail?id=${encodeURIComponent(orderId)}`)
    .then(res => {
      if (!res.ok) throw new Error("Không thể lấy dữ liệu đơn giao");
      return res.json();
    })
    .then(data => {
      console.log('API chi tiết đơn giao:', data);
      if (Array.isArray(data)) data = data[0];
      // Thử lấy các trường snake_case nếu camelCase không có
      // Lấy thông tin từ bảng orders (giả sử backend đã join và trả về các trường này)
      const orderIdShow = data.order_id || data.id || '(Không rõ)';
      const status = data.status || '';
      const ngayGiao = data.assigned_at || '';
      const note = data.note || '';
      const customerName = data.customer_name || data.customerName || data.shipping_name || data.shippingName || '(Không rõ)';
      const phone = data.shipping_phone || data.shippingPhone || data.phone || '';
      const address = data.shipping_address || data.shippingAddress || '';
      const orderDate = data.order_date || data.orderDate || '';
      // Sản phẩm: mảng productNames hoặc product_names hoặc items
      let productListHtml = '';
      if (Array.isArray(data.product_names)) {
        productListHtml = data.product_names.map(p => `<li>${p}</li>`).join('');
      } else if (Array.isArray(data.productNames)) {
        productListHtml = data.productNames.map(p => `<li>${p}</li>`).join('');
      } else if (Array.isArray(data.items)) {
        productListHtml = data.items.map(i => `<li>${i.name || i.product_name || ''}</li>`).join('');
      }
      if (!data || typeof data !== 'object' || Object.keys(data).length === 0 || (orderIdShow === '(Không rõ)' && !status)) {
        document.getElementById('order-detail-body').innerHTML = '<p class="text-danger">Không tìm thấy đơn giao với ID này!</p>';
        new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
        return;
      }
      const html = `
        <div class="mb-2"><strong>Mã đơn hàng:</strong> #${orderIdShow}</div>
        <div class="mb-2"><strong>Khách hàng:</strong> ${customerName}</div>
        <div class="mb-2"><strong>Điện thoại:</strong> ${phone}</div>
        <div class="mb-2"><strong>Địa chỉ giao:</strong> ${address}</div>
        <div class="mb-2"><strong>Sản phẩm:</strong><ul class="mb-1">${productListHtml || '<li>—</li>'}</ul></div>
        <div class="mb-2"><strong>Ngày đặt hàng:</strong> ${orderDate ? formatVietnameseDate(orderDate) : ''}</div>
        <div class="mb-2"><strong>Trạng thái:</strong> ${statusBadge(status)}</div>
        <div class="mb-2"><strong>Ngày giao:</strong> ${ngayGiao ? formatVietnameseDate(ngayGiao) : ''}</div>
        <div class="mb-2"><strong>Ghi chú:</strong> ${note}</div>
      `;
      document.getElementById('order-detail-body').innerHTML = html;
      new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
    })
    .catch((err) => {
      document.getElementById('order-detail-body').innerHTML = '<p class="text-danger">Không lấy được chi tiết đơn giao!</p>';
      new bootstrap.Modal(document.getElementById('orderDetailModal')).show();
    });
}
// Định dạng ngày kiểu Việt Nam (dd/MM/yyyy, có giờ nếu có)
function formatVietnameseDate(dateInput) {
  if (!dateInput) return '';
  let dateObj;
  if (typeof dateInput === 'string') {
    dateObj = new Date(dateInput);
    if (isNaN(dateObj.getTime())) return dateInput;
  } else {
    dateObj = dateInput;
  }
  const day = String(dateObj.getDate()).padStart(2, '0');
  const month = String(dateObj.getMonth() + 1).padStart(2, '0');
  const year = dateObj.getFullYear();
  const hour = dateObj.getHours();
  const minute = dateObj.getMinutes();
  if (hour !== 0 || minute !== 0) {
    return `${day}/${month}/${year} ${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
  }
  return `${day}/${month}/${year}`;
}

function showUpdateStatus(orderId) {
  document.getElementById('update-order-id').value = orderId;
  new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
}


function updateOrderStatus() {
  const orderId = document.getElementById('update-order-id').value;
  const newStatus = document.getElementById('new-status').value;
  const note = document.getElementById('note').value;
  // Gửi cập nhật trạng thái shipping lên backend
  fetch('/api/shipping/update-status', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `shippingId=${encodeURIComponent(orderId)}&status=${encodeURIComponent(newStatus)}&note=${encodeURIComponent(note)}`
  })
    .then(res => res.text())
    .then(msg => {
      alert(msg);
      fetchShippingOrders(document.getElementById('order-status-filter').value);
      bootstrap.Modal.getInstance(document.getElementById('updateStatusModal')).hide();
    })
    .catch(err => {
      alert('Lỗi cập nhật trạng thái shipping!');
    });
}


document.addEventListener('DOMContentLoaded', function() {
  fetchShippingOrders();
  document.getElementById('order-status-filter').addEventListener('change', function() {
    fetchShippingOrders(this.value);
  });
});
