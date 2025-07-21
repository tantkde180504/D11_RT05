// js/shipper.js
// Quản lý đơn hàng cho shipper

console.log('🚚 Shipper.js loaded successfully!');

let orders = [];
let currentView = 'Khu vực Đà Nẵng';
let allOrdersGlobal = [];

// Load dashboard statistics from filtered data
function loadDashboardStats() {
  // Tính từ dữ liệu đã filter chỉ lấy đơn Đà Nẵng
  const daNangOrders = orders.filter(order => {
    const address = (order.address || '').toLowerCase();
    return address.includes('đà nẵng') || address.includes('da nang') || 
           address.includes('danang') || address.includes('dn') || 
           address.includes('ngũ hành sơn') || address.includes('hòa lạc') ||
           address.includes('non nước');
  });
  
  const stats = {
    pending: daNangOrders.filter(o => o.status === 'PENDING').length,
    shipping: daNangOrders.filter(o => o.status === 'SHIPPING').length,
    delivered: daNangOrders.filter(o => o.status === 'DELIVERED').length,
    cancelled: daNangOrders.filter(o => o.status === 'CANCELLED').length,
    // Thêm thống kê theo shipping type
    express: daNangOrders.filter(o => {
      const type = (o.shippingType || '').toLowerCase();
      console.log('🚚 Order shipping type for stats:', o.orderId, type);
      return type === 'hỏa tốc' || type === 'express' || type === 'hoa_toc';
    }).length,
    normal: daNangOrders.filter(o => {
      const type = (o.shippingType || 'thường').toLowerCase();
      return type === 'thường' || type === 'normal' || type === '';
    }).length
  };
  
  console.log('📈 Local Stats calculated:', stats);
  console.log('📊 Express vs Normal orders:', { express: stats.express, normal: stats.normal });
  updateStatsDisplay(stats);
}

// Update stats display with animation
function updateStatsDisplay(stats) {
  // Animate numbers
  animateNumber('stat-pending', stats.pending || 0);
  animateNumber('stat-shipping', stats.shipping || 0);
  animateNumber('stat-delivered', stats.delivered || 0);
  animateNumber('stat-cancelled', stats.cancelled || 0);
  animateNumber('stat-express', stats.express || 0);
  animateNumber('stat-normal', stats.normal || 0);
}

// Animate number counting up
function animateNumber(elementId, targetNumber) {
  const element = document.getElementById(elementId);
  if (!element) return;
  
  const startNumber = 0;
  const duration = 1000; // 1 second
  const startTime = performance.now();
  
  function updateNumber(currentTime) {
    const elapsed = currentTime - startTime;
    const progress = Math.min(elapsed / duration, 1);
    
    // Easing function (ease out)
    const easeOut = 1 - Math.pow(1 - progress, 3);
    const currentNumber = Math.round(startNumber + (targetNumber - startNumber) * easeOut);
    
    element.textContent = currentNumber;
    
    if (progress < 1) {
      requestAnimationFrame(updateNumber);
    }
  }
  
  requestAnimationFrame(updateNumber);
}

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
      // Debug: kiểm tra tất cả fields có thể
      if (data.length > 0) {
        const sample = data[0];
        console.log('🔍 Sample assignedAt field:', sample.assignedAt);
        console.log('🚚 Sample shipping_type variants:');
        console.log('  - shipping_type:', sample.shipping_type);
        console.log('  - shippingType:', sample.shippingType);  
        console.log('  - shipType:', sample.shipType);
        console.log('  - type:', sample.type);
        console.log('🗂️ All fields in first item:', Object.keys(sample));
        
        // Thử lấy từ orders table nếu có
        if (sample.order && sample.order.shipping_type) {
          console.log('📦 From orders table:', sample.order.shipping_type);
        }
      } else {
        console.log('⚠️ No shipping data received from API');
      }
      
      orders = data.map(item => {
        // Thử nhiều cách lấy shipping_type
        let shippingType = item.shipping_type || 
                          item.shippingType || 
                          item.shipType || 
                          item.type ||
                          (item.order && item.order.shipping_type) ||
                          'thường';
                          
        // TEMPORARY: Mock hỏa tốc cho test (xóa sau khi sửa API)
        const orderIdStr = String(item.orderId || '');
        if (item.orderId && (orderIdStr.includes('102') || orderIdStr.includes('101'))) {
          shippingType = 'hỏa tốc';
          console.log(`🔥 MOCK: Setting order ${item.orderId} to hỏa tốc for testing`);
        }
                          
        console.log(`🚚 Order ${item.orderId || item.id}: shipping_type = "${shippingType}"`);
        
        return {
          shippingId: item.id, // id của bản ghi shipping (dùng cho API detail)
          orderId: item.orderId || '(Không rõ)',
          customer: item.customerName || item.shippingName || '(Không rõ)',
          address: item.shippingAddress || '(Không rõ)',
          phone: item.shippingPhone || '(Không rõ)',
          status: item.status || '(Không rõ)',
          shippingType: shippingType,
          date: item.assignedAt ? formatVietnameseDate(item.assignedAt) : '(Chưa được gán)'
        };
      });
      
      console.log('✅ Mapped orders:', orders);
      renderOrders(filter);
      
      // Reload stats after data update
      loadDashboardStats();
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
  
  // Filter theo status trước
  let filteredOrders = orders.filter(order => filter === 'ALL' || order.status === filter);
  
  // Filter chỉ lấy đơn hàng Đà Nẵng
  filteredOrders = filteredOrders.filter(order => {
    const address = (order.address || '').toLowerCase();
    
    // Các biến thể có thể có của Đà Nẵng
    const daNangVariants = [
      'đà nẵng',
      'da nang', 
      'danang',
      'đà nẳng',  // lỗi chính tả phổ biến
      'da năng',  // lỗi chính tả
      'dn',       // viết tắt
      'd.nang',   // viết tắt có dấu chấm
      'tp đà nẵng',
      'thành phố đà nẵng',
      'tp.đà nẵng'
    ];
    
    // Kiểm tra xem địa chỉ có chứa bất kỳ biến thể nào không
    const isDaNang = daNangVariants.some(variant => address.includes(variant));
    
    // Log để debug
    if (address && !isDaNang) {
      console.log('🚫 Filtered out (not Đà Nẵng):', address);
    } else if (isDaNang) {
      console.log('✅ Đà Nẵng order found:', address);
    }
    
    return isDaNang;
  });
  
  console.log('🎨 Rendering orders (Đà Nẵng only):', filteredOrders.length);
  if (filteredOrders.length > 0) {
    console.log('📅 First order date field:', filteredOrders[0].date);
  }
  
  // Hiển thị thông báo nếu không có dữ liệu
  if (filteredOrders.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" class="text-center py-5">
          <div class="empty-state">
            <i class="fas fa-truck-loading"></i>
            <h6 class="mt-3 mb-2 text-muted">
              ${filter === 'ALL' ? 'Không có đơn hàng nào ở Đà Nẵng cần giao' : `Không có đơn hàng ở Đà Nẵng với trạng thái "${filter}"`}
            </h6>
            <p class="text-muted small mb-0">Vui lòng kiểm tra lại sau hoặc thử bộ lọc khác</p>
          </div>
        </td>
      </tr>
    `;
    return;
  }
  
  filteredOrders.forEach(order => {
      const tr = document.createElement('tr');
      // Thêm class dựa trên shipping type
      tr.className = `align-middle order-row ${order.shippingType === 'hỏa tốc' || order.shippingType === 'express' ? 'express-order' : 'normal-order'}`;
      
      // Tạo action buttons với tooltips đẹp hơn
      let actionButtons = `
        <div class="btn-group" role="group">
          <button class="btn btn-outline-info btn-sm" onclick="showOrderDetail('${order.shippingId}')" title="Xem chi tiết">
            <i class="fas fa-eye"></i>
          </button>
          ${order.status === 'SHIPPING' ? `
          <button class="btn btn-outline-success btn-sm" onclick="openCamera('${order.shippingId}')" title="Chụp ảnh xác nhận giao hàng">
            <i class="fas fa-camera"></i>
          </button>` : ''}
          ${order.status === 'DELIVERED' ? `
          <button class="btn btn-outline-primary btn-sm" onclick="viewDeliveryPhotos('${order.shippingId}')" title="Xem ảnh đã giao">
            <i class="fas fa-images"></i>
          </button>` : ''}
          <button class="btn btn-outline-warning btn-sm" onclick="showUpdateStatus('${order.shippingId}')" title="Cập nhật trạng thái">
            <i class="fas fa-edit"></i>
          </button>
        </div>
      `;
      
      // Tạo shipping type badge
      const shippingTypeBadge = createShippingTypeBadge(order.shippingType);
      
      tr.innerHTML = `
        <td>
          <div class="position-relative">
            <div class="priority-indicator ${order.shippingType === 'hỏa tốc' || order.shippingType === 'express' ? 'priority-express' : 'priority-normal'}"></div>
            <span class="fw-bold text-primary">#${order.orderId}</span>
            ${shippingTypeBadge}
          </div>
        </td>
        <td>
          <div class="d-flex align-items-center">
            <div class="avatar-sm bg-light rounded-circle d-flex align-items-center justify-content-center me-2">
              <i class="fas fa-user text-muted"></i>
            </div>
            <span class="fw-medium">${order.customer}</span>
          </div>
        </td>
        <td>
          <div class="text-truncate" style="max-width: 200px;" title="${order.address}">
            <i class="fas fa-map-marker-alt text-muted me-1"></i>
            ${order.address}
          </div>
        </td>
        <td>
          <a href="tel:${order.phone}" class="text-decoration-none">
            <i class="fas fa-phone text-success me-1"></i>
            ${order.phone}
          </a>
        </td>
        <td>${statusBadge(order.status)}</td>
        <td>
          <small class="text-muted">
            <i class="fas fa-calendar-alt me-1"></i>
            ${order.date}
          </small>
        </td>
        <td>
          ${actionButtons}
        </td>
      `;
      tbody.appendChild(tr);
    });
}

function statusBadge(status) {
  switch(status) {
    case 'PENDING': return '<span class="badge bg-warning text-dark"><i class="fas fa-clock me-1"></i>Chờ giao</span>';
    case 'SHIPPING': return '<span class="badge bg-primary"><i class="fas fa-truck me-1"></i>Đang giao</span>';
    case 'DELIVERED': return '<span class="badge bg-success"><i class="fas fa-check-circle me-1"></i>Đã giao</span>';
    case 'CANCELLED': return '<span class="badge bg-danger"><i class="fas fa-times-circle me-1"></i>Hủy giao</span>';
    default: return `<span class="badge bg-secondary">${status}</span>`;
  }
}

// Tạo badge cho shipping type
function createShippingTypeBadge(shippingType) {
  console.log('🏷️ Creating badge for shipping type:', shippingType);
  const normalizedType = (shippingType || 'thường').toLowerCase();
  console.log('🔄 Normalized type:', normalizedType);
  
  if (normalizedType === 'hỏa tốc' || normalizedType === 'express' || normalizedType === 'hoa_toc') {
    console.log('⚡ Creating EXPRESS badge');
    return `<span class="shipping-type-badge shipping-express">Hỏa tốc</span>`;
  } else {
    console.log('📦 Creating NORMAL badge');
    return `<span class="shipping-type-badge shipping-normal">Thường</span>`;
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
  console.log('🔧 showUpdateStatus called with orderId:', orderId);
  document.getElementById('shipping-id').value = orderId;
  new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
}


function updateShippingStatus() {
  console.log('⚙️ updateShippingStatus called');
  const orderId = document.getElementById('shipping-id').value;
  const newStatus = document.getElementById('new-status').value;
  const note = document.getElementById('status-note').value;
  
  console.log('📝 Update data:', { orderId, newStatus, note });
  
  // Gửi cập nhật trạng thái shipping lên backend
  fetch('/api/shipping/update-status', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `shippingId=${encodeURIComponent(orderId)}&status=${encodeURIComponent(newStatus)}&note=${encodeURIComponent(note)}`
  })
    .then(res => {
      console.log('📡 API Response status:', res.status);
      return res.text();
    })
    .then(msg => {
      console.log('✅ API Response:', msg);
      alert(msg);
      fetchShippingOrders(document.getElementById('order-status-filter').value);
      bootstrap.Modal.getInstance(document.getElementById('updateStatusModal')).hide();
    })
    .catch(err => {
      console.error('❌ Update error:', err);
      alert('Lỗi cập nhật trạng thái shipping: ' + err.message);
    });
}

// Global variables for camera functionality
let currentStream = null;
let currentShippingId = null;
let capturedImageData = null;

// Mở camera để chụp ảnh
function openCamera(shippingId) {
    console.log('📷 Opening camera for shipping ID:', shippingId);
    currentShippingId = shippingId;
    
    // Reset modal state
    document.getElementById('camera-video').style.display = 'none';
    document.getElementById('captured-photo').style.display = 'none';
    document.getElementById('camera-error').style.display = 'none';
    document.getElementById('camera-controls').style.display = 'block';
    document.getElementById('photo-controls').style.display = 'none';
    
    // Show modal first
    const modal = new bootstrap.Modal(document.getElementById('cameraModal'));
    modal.show();
    
    // Request camera access
    navigator.mediaDevices.getUserMedia({ 
        video: { 
            facingMode: 'environment', // Ưu tiên camera sau
            width: { ideal: 1280 },
            height: { ideal: 720 }
        } 
    })
    .then(stream => {
        console.log('📹 Camera access granted');
        currentStream = stream;
        const video = document.getElementById('camera-video');
        video.srcObject = stream;
        video.style.display = 'block';
        
        // Wait for video metadata to load
        video.addEventListener('loadedmetadata', () => {
            console.log('📺 Video metadata loaded:', video.videoWidth, 'x', video.videoHeight);
            video.play();
        });
        
        // Enable capture button when video is ready
        video.addEventListener('playing', () => {
            console.log('▶️ Video is playing and ready');
            document.getElementById('camera-controls').style.display = 'block';
        });
    })
    .catch(err => {
        console.error('❌ Lỗi truy cập camera:', err);
        document.getElementById('camera-error').style.display = 'block';
        document.getElementById('camera-controls').style.display = 'none';
    });
}

// Chụp ảnh từ video stream
function capturePhoto() {
    console.log('📸 Capture photo clicked');
    const video = document.getElementById('camera-video');
    const captureBtn = document.getElementById('capture-btn');
    
    // Disable button during capture
    captureBtn.disabled = true;
    captureBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang chụp...';
    
    if (!video.videoWidth || !video.videoHeight) {
        console.error('❌ Video not ready');
        alert('Camera chưa sẵn sàng. Vui lòng thử lại!');
        // Re-enable button
        captureBtn.disabled = false;
        captureBtn.innerHTML = '<i class="fas fa-camera"></i> Chụp ảnh';
        return;
    }
    
    const canvas = document.createElement('canvas');
    const context = canvas.getContext('2d');
    
    // Set canvas dimensions to match video
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    
    console.log('📐 Canvas size:', canvas.width, 'x', canvas.height);
    
    // Draw video frame to canvas
    context.drawImage(video, 0, 0);
    
    // Get image data
    capturedImageData = canvas.toDataURL('image/jpeg', 0.8);
    console.log('💾 Image captured, size:', capturedImageData.length);
    
    // Show preview
    const preview = document.getElementById('photo-preview');
    preview.src = capturedImageData;
    
    // Hide video, show photo preview
    document.getElementById('camera-video').style.display = 'none';
    document.getElementById('captured-photo').style.display = 'block';
    document.getElementById('camera-controls').style.display = 'none';
    document.getElementById('photo-controls').style.display = 'block';
    
    // Stop camera stream
    stopCamera();
    
    // Re-enable button (for next time)
    captureBtn.disabled = false;
    captureBtn.innerHTML = '<i class="fas fa-camera"></i> Chụp ảnh';
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
  
  // Load dashboard stats
  loadDashboardStats();
  
  fetchShippingOrders();
  document.getElementById('order-status-filter').addEventListener('change', function() {
    console.log('🔄 Filter changed to:', this.value);
    fetchShippingOrders(this.value);
  });
});