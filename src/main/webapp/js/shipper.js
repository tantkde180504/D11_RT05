// js/shipper.js
// Quản lý đơn hàng cho shipper

console.log('🚚 Shipper.js loaded successfully!');

let orders = [];

// Lấy danh sách shipping từ backend
function fetchShippingOrders(filter = 'ALL') {
  let url = '/api/shipping';
  if (filter && filter !== 'ALL') {
    url += `?status=${encodeURIComponent(filter)}`;
  }
  
  console.log('🔄 Fetching shipping data from:', url);
  
  fetch(url)
    .then(res => {
      console.log('📡 API Response status:', res.status, res.statusText);
      if (!res.ok) {
        throw new Error(`HTTP error! status: ${res.status}`);
      }
      return res.json();
    })
    .then(data => {
      console.log('📦 Shipping API data:', data);
      // Debug: kiểm tra assignedAt field
      if (data.length > 0) {
        console.log('🔍 Sample assignedAt field:', data[0].assignedAt);
        console.log('🗂️ All fields in first item:', Object.keys(data[0]));
      } else {
        console.log('⚠️ No shipping data received from API');
      }
      
      orders = data.map(item => ({
        shippingId: item.id, // id của bản ghi shipping (dùng cho API detail)
        orderId: item.orderId || '(Không rõ)',
        customer: item.customerName || item.shippingName || '(Không rõ)',
        address: item.shippingAddress || '(Không rõ)',
        phone: item.shippingPhone || '(Không rõ)',
        status: item.status || '(Không rõ)',
        date: item.assignedAt ? formatVietnameseDate(item.assignedAt) : '(Chưa được gán)'
      }));
      
      console.log('✅ Mapped orders:', orders);
      renderOrders(filter);
    })
    .catch(err => {
      console.error('❌ Lỗi lấy shipping:', err);
      
      // Hiển thị thông báo lỗi cho user
      const tbody = document.getElementById('orders-table-body');
      tbody.innerHTML = `
        <tr>
          <td colspan="7" class="text-center text-danger">
            <i class="fas fa-exclamation-triangle me-2"></i>
            Lỗi tải dữ liệu: ${err.message}
          </td>
        </tr>
      `;
      
      orders = [];
    });
}


function renderOrders(filter = 'ALL') {
  const tbody = document.getElementById('orders-table-body');
  tbody.innerHTML = '';
  const filteredOrders = orders.filter(order => filter === 'ALL' || order.status === filter);
  
  console.log('🎨 Rendering orders:', filteredOrders.length);
  if (filteredOrders.length > 0) {
    console.log('📅 First order date field:', filteredOrders[0].date);
  }
  
  // Hiển thị thông báo nếu không có dữ liệu
  if (filteredOrders.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" class="text-center text-muted py-4">
          <i class="fas fa-inbox me-2"></i>
          ${filter === 'ALL' ? 'Chưa có đơn hàng nào cần giao' : `Không có đơn hàng với trạng thái "${filter}"`}
        </td>
      </tr>
    `;
    return;
  }
  
  filteredOrders.forEach(order => {
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
          ${order.status === 'SHIPPING' ? `<button class="btn btn-sm btn-success me-1" onclick="openCamera('${order.shippingId}')" title="Chụp ảnh xác nhận"><i class="fas fa-camera"></i></button>` : ''}
          ${order.status === 'DELIVERED' ? `<button class="btn btn-sm btn-primary me-1" onclick="viewDeliveryPhotos('${order.shippingId}')" title="Xem ảnh giao hàng"><i class="fas fa-images"></i></button>` : ''}
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
      console.log('🔍 assignedAt value:', data.assignedAt);
      console.log('🔍 assigned_at value:', data.assigned_at);
      if (Array.isArray(data)) data = data[0];
      // Thử lấy các trường snake_case nếu camelCase không có
      // Lấy thông tin từ bảng orders (giả sử backend đã join và trả về các trường này)
      const orderIdShow = data.order_id || data.orderId || data.id || '(Không rõ)';
      const status = data.status || '';
      const ngayGiao = data.assigned_at || data.assignedAt || '';
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
        <div class="mb-2"><strong>Ngày giao:</strong> ${ngayGiao ? formatVietnameseDate(ngayGiao) : '(Chưa có)'}</div>
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
  
  try {
    if (typeof dateInput === 'string') {
      dateObj = new Date(dateInput);
    } else if (dateInput instanceof Date) {
      dateObj = dateInput;
    } else if (Array.isArray(dateInput) && dateInput.length >= 3) {
      // Java LocalDateTime array format: [year, month, day, hour, minute, second]
      dateObj = new Date(dateInput[0], dateInput[1] - 1, dateInput[2], 
                        dateInput[3] || 0, dateInput[4] || 0, dateInput[5] || 0);
    } else {
      // Fallback: try to convert to string first
      dateObj = new Date(String(dateInput));
    }
    
    // Kiểm tra xem dateObj có hợp lệ không
    if (isNaN(dateObj.getTime())) {
      console.warn('Invalid date input:', dateInput);
      return String(dateInput); // Trả về string gốc nếu không parse được
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
    
  } catch (error) {
    console.error('Error formatting date:', error, 'Input:', dateInput);
    return String(dateInput); // Fallback to string representation
  }
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

// Global variables for camera functionality
let currentStream = null;
let currentShippingId = null;
let capturedImageData = null;

// Mở camera để chụp ảnh
function openCamera(shippingId) {
    currentShippingId = shippingId;
    const modal = new bootstrap.Modal(document.getElementById('cameraModal'));
    
    // Reset modal state
    document.getElementById('camera-container').style.display = 'none';
    document.getElementById('photo-preview').style.display = 'none';
    document.getElementById('camera-error').style.display = 'none';
    
    // Request camera access
    navigator.mediaDevices.getUserMedia({ 
        video: { 
            facingMode: 'environment', // Ưu tiên camera sau
            width: { ideal: 1280 },
            height: { ideal: 720 }
        } 
    })
    .then(stream => {
        currentStream = stream;
        const video = document.getElementById('camera-video');
        video.srcObject = stream;
        document.getElementById('camera-container').style.display = 'block';
        modal.show();
    })
    .catch(err => {
        console.error('Lỗi truy cập camera:', err);
        document.getElementById('camera-error').style.display = 'block';
        modal.show();
    });
}

// Chụp ảnh từ video stream
function capturePhoto() {
    const video = document.getElementById('camera-video');
const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');
    
    // Set canvas dimensions to match video
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    
    // Draw video frame to canvas
    context.drawImage(video, 0, 0);
    
    // Get image data
    capturedImageData = canvas.toDataURL('image/jpeg', 0.8);
    
    // Show preview
    document.getElementById('captured-image').src = capturedImageData;
    document.getElementById('camera-container').style.display = 'none';
    document.getElementById('photo-preview').style.display = 'block';
    
    // Stop camera stream
    stopCamera();
}

// Lưu ảnh lên server
function savePhoto() {
    if (!capturedImageData || !currentShippingId) {
        alert('Không có ảnh để lưu!');
        return;
    }
    
    // Convert base64 to blob
    const byteCharacters = atob(capturedImageData.split(',')[1]);
    const byteNumbers = new Array(byteCharacters.length);
    for (let i = 0; i < byteCharacters.length; i++) {
        byteNumbers[i] = byteCharacters.charCodeAt(i);
    }
    const byteArray = new Uint8Array(byteNumbers);
    const blob = new Blob([byteArray], { type: 'image/jpeg' });
    
    // Create form data
    const formData = new FormData();
    formData.append('photo', blob, `delivery_${currentShippingId}_${Date.now()}.jpg`);
    formData.append('shippingId', currentShippingId);
    
    // Upload to server
    fetch('/api/shipping/upload-delivery-photo', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Upload failed');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert('✅ Ảnh đã được lưu thành công!');
            bootstrap.Modal.getInstance(document.getElementById('cameraModal')).hide();
            // Refresh orders to show updated status
            fetchShippingOrders();
        } else {
            alert('❌ Lỗi lưu ảnh: ' + (data.message || 'Unknown error'));
        }
    })
    .catch(err => {
        console.error('Lỗi upload ảnh:', err);
        alert('❌ Lỗi upload ảnh: ' + err.message);
    });
}

// Chụp lại ảnh
function retakePhoto() {
    openCamera(currentShippingId);
}

// Hủy chụp ảnh
function cancelPhoto() {
    bootstrap.Modal.getInstance(document.getElementById('cameraModal')).hide();
}

// Dừng camera stream
function stopCamera() {
    if (currentStream) {
        currentStream.getTracks().forEach(track => track.stop());
        currentStream = null;
    }
}

// Xem ảnh giao hàng đã chụp
function viewDeliveryPhotos(shippingId) {
    fetch(`/api/shipping/delivery-photos?shippingId=${encodeURIComponent(shippingId)}`)
    .then(response => {
        if (!response.ok) {
            throw new Error('Failed to fetch photos');
        }
        return response.json();
    })
    .then(data => {
const container = document.getElementById('delivery-photos-container');
        
        if (data && data.length > 0) {
            let photosHtml = '<div class="row">';
            data.forEach((photo, index) => {
                photosHtml += `
                    <div class="col-md-6 mb-3">
                        <div class="card">
                            <img src="${photo.photoUrl}" class="card-img-top" alt="Ảnh giao hàng ${index + 1}" 
                                 style="height: 300px; object-fit: cover; cursor: pointer;" 
                                 onclick="showFullPhoto('${photo.photoUrl}')">
                            <div class="card-body p-2">
                                <small class="text-muted">
                                    <i class="fas fa-clock"></i> ${photo.uploadedAt}
                                </small>
                            </div>
                        </div>
                    </div>
                `;
            });
            photosHtml += '</div>';
            container.innerHTML = photosHtml;
        } else {
            container.innerHTML = `
                <div class="text-center text-muted">
                    <i class="fas fa-camera fa-3x mb-3"></i>
                    <p>Chưa có ảnh giao hàng nào cho đơn hàng này.</p>
                </div>
            `;
        }
        
        new bootstrap.Modal(document.getElementById('viewPhotoModal')).show();
    })
    .catch(err => {
        console.error('Lỗi lấy ảnh:', err);
        alert('❌ Lỗi lấy ảnh giao hàng: ' + err.message);
    });
}

// Hiển thị ảnh full size
function showFullPhoto(imageUrl) {
    const fullImageModal = document.createElement('div');
    fullImageModal.className = 'modal fade';
    fullImageModal.innerHTML = `
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Ảnh giao hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center p-0">
                    <img src="${imageUrl}" style="max-width: 100%; max-height: 80vh;" alt="Ảnh giao hàng">
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(fullImageModal);
    const modal = new bootstrap.Modal(fullImageModal);
    modal.show();
    
    // Remove modal from DOM when hidden
    fullImageModal.addEventListener('hidden.bs.modal', () => {
        document.body.removeChild(fullImageModal);
    });
}

// Cleanup camera when modal is closed
document.getElementById('cameraModal').addEventListener('hidden.bs.modal', function() {
    stopCamera();
    currentShippingId = null;
    capturedImageData = null;
});

document.addEventListener('DOMContentLoaded', function() {
  console.log('🎯 DOM loaded, initializing shipper dashboard...');
fetchShippingOrders();
  document.getElementById('order-status-filter').addEventListener('change', function() {
    console.log('🔄 Filter changed to:', this.value);
    fetchShippingOrders(this.value);
  });
});