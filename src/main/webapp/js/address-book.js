// Address Book JavaScript with API Integration
console.log('Address Book Script Loading...');

// Hàm helper để fix UTF-8 encoding issues
function fixUTF8Encoding(text) {
    if (!text || typeof text !== 'string') return text;
    
    // Map các ký tự bị lỗi encoding thường gặp trong tiếng Việt
    const charMap = {
        // Đ/đ variants
        'Ðà': 'Đà',
        'Ðình': 'Đình', 
        'Ð': 'Đ',
        'ð': 'đ',
        
        // Tên thường gặp
        'Tr?n': 'Trần',
        'T?n': 'Tân',
        'C?m': 'Cẩm', 
        'L?': 'Lệ',
        'H?i': 'Hải',
        'N?ng': 'Nẵng',
        'Ph?m': 'Phạm',
        'Nguy?n': 'Nguyễn',
        'H?': 'Hà',
        'Qu?ng': 'Quảng',
        'Hu?': 'Huế',
        'Ðông': 'Đông',
        'Ð?c': 'Đức',
        
        // Tỉnh thành thường gặp
        'Hà N?i': 'Hà Nội',
        'TP. H? Chí Minh': 'TP. Hồ Chí Minh',
        'H? Chí Minh': 'Hồ Chí Minh',
        'C?n Th?': 'Cần Thơ',
        'Ðà L?t': 'Đà Lạt',
        'Nha Trang': 'Nha Trang',
        'Qu?ng Nam': 'Quảng Nam',
        'Qu?ng Ninh': 'Quảng Ninh',
        'Th?a Thiên Hu?': 'Thừa Thiên Huế'
    };
    
    let fixed = text;
    
    // Apply character mapping - SAFELY escape special regex characters
    for (const [wrong, correct] of Object.entries(charMap)) {
        // Escape special regex characters trong wrong string
        const escapedWrong = wrong.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        fixed = fixed.replace(new RegExp(escapedWrong, 'g'), correct);
    }
    
    // Safe fallback cho các ký tự ? còn lại (nếu có)
    // Sử dụng replace với string thay vì regex để tránh lỗi
    fixed = fixed.replace(/\?/g, 'ă');
    
    return fixed;
}

// Hàm để làm sạch và hiển thị text an toàn với xử lý UTF-8
function safeText(value, fallback = 'Chưa có thông tin') {
    // Simplified logging để tránh spam console
    // console.log('SafeText input:', { value, type: typeof value, fallback });
    
    if (value === null || value === undefined || value === 'null' || value === '') {
        return fallback;
    }
    
    // Xử lý encoding issue
    try {
        let processedValue = String(value).trim();
        
        // Sử dụng helper function để fix encoding
        processedValue = fixUTF8Encoding(processedValue);
        
        return processedValue;
    } catch (e) {
        console.warn('SafeText: Error processing value, returning as-is:', e);
        return String(value).trim();
    }
}

// Danh sách 63 tỉnh thành Việt Nam
const provinces = [
    "An Giang", "Bà Rịa - Vũng Tàu", "Bắc Giang", "Bắc Kạn", "Bạc Liêu", 
    "Bắc Ninh", "Bến Tre", "Bình Định", "Bình Dương", "Bình Phước", 
    "Bình Thuận", "Cà Mau", "Cao Bằng", "Đắk Lắk", "Đắk Nông", 
    "Điện Biên", "Đồng Nai", "Đồng Tháp", "Gia Lai", "Hà Giang", 
    "Hà Nam", "Hà Tĩnh", "Hải Dương", "Hậu Giang", "Hòa Bình", 
    "Hưng Yên", "Khánh Hòa", "Kiên Giang", "Kon Tum", "Lai Châu", 
    "Lâm Đồng", "Lạng Sơn", "Lào Cai", "Long An", "Nam Định", 
    "Nghệ An", "Ninh Bình", "Ninh Thuận", "Phú Thọ", "Quảng Bình", 
    "Quảng Nam", "Quảng Ngãi", "Quảng Ninh", "Quảng Trị", "Sóc Trăng", 
    "Sơn La", "Tây Ninh", "Thái Bình", "Thái Nguyên", "Thanh Hóa", 
    "Thừa Thiên Huế", "Tiền Giang", "Trà Vinh", "Tuyên Quang", "Vĩnh Long", 
    "Vĩnh Phúc", "Yên Bái", "Phú Yên", "Cần Thơ", "Đà Nẵng", 
    "Hải Phòng", "Hà Nội", "TP. Hồ Chí Minh"
];

// Regex for phone validation
const phoneRegex = /^[0-9]{10,11}$/;

// Danh sách địa chỉ (sẽ load từ API)
let addresses = [];

// Context path
const contextPath = window.APP_CONTEXT_PATH || '';
console.log('Address Book Context Path:', contextPath);

// Load địa chỉ từ API
async function loadAddresses() {
    try {
        console.log('=== LOADING ADDRESSES ===');
        console.log('API URL:', `${contextPath}/api/addresses`);
        
        const response = await fetch(`${contextPath}/api/addresses`, {
            headers: {
                'Accept': 'application/json; charset=UTF-8'
            }
        });
        console.log('Response status:', response.status);
        console.log('Response ok:', response.ok);
        
        const data = await response.json();
        console.log('=== RAW API RESPONSE ANALYSIS ===');
        console.log('Response data type:', typeof data);
        console.log('Response data:', data);
        console.log('Has success property:', 'success' in data);
        console.log('Success value:', data.success);
        console.log('Has addresses property:', 'addresses' in data);
        console.log('Addresses value:', data.addresses);
        console.log('Addresses type:', typeof data.addresses);
        
        // Check if it's a direct array
        if (Array.isArray(data)) {
            console.log('🔍 Response is direct array with length:', data.length);
            addresses = data;
            console.log('✅ Using direct array as addresses');
        }
        // Check if it has success and addresses structure
        else if (data.success && data.addresses) {
            console.log('🔍 Response has success/addresses structure');
            // Pre-process addresses để fix encoding issues
            data.addresses = data.addresses.map(addr => {
                const fixedAddr = { ...addr };
                
                // Fix encoding cho tất cả text fields
                if (fixedAddr.recipient_name) {
                    fixedAddr.recipient_name = fixUTF8Encoding(fixedAddr.recipient_name);
                }
                if (fixedAddr.recipientName) {
                    fixedAddr.recipientName = fixUTF8Encoding(fixedAddr.recipientName);
                }
                if (fixedAddr.phone) {
                    fixedAddr.phone = fixUTF8Encoding(fixedAddr.phone);
                }
                if (fixedAddr.house_number) {
                    fixedAddr.house_number = fixUTF8Encoding(fixedAddr.house_number);
                }
                if (fixedAddr.houseNumber) {
                    fixedAddr.houseNumber = fixUTF8Encoding(fixedAddr.houseNumber);
                }
                if (fixedAddr.ward) {
                    fixedAddr.ward = fixUTF8Encoding(fixedAddr.ward);
                }
                if (fixedAddr.district) {
                    fixedAddr.district = fixUTF8Encoding(fixedAddr.district);
                }
                if (fixedAddr.province) {
                    fixedAddr.province = fixUTF8Encoding(fixedAddr.province);
                }
                
                return fixedAddr;
            });
            
            addresses = data.addresses;
            console.log('✅ Using addresses from success structure');
        }
        // Check other possible structures
        else if (data.data && Array.isArray(data.data)) {
            console.log('🔍 Response has data property with array');
            addresses = data.data;
            console.log('✅ Using data array as addresses');
        }
        // Handle error cases
        else {
            console.warn('⚠️ Unexpected response structure');
            console.log('Available keys:', Object.keys(data));
            addresses = [];
        }
        
        console.log('📊 FINAL RESULT:');
        console.log('Loaded addresses count:', addresses.length);
        console.log('Addresses array:', addresses);
        
        // Debug từng địa chỉ để kiểm tra dữ liệu (chỉ khi có địa chỉ)
        if (addresses.length > 0) {
            console.log('🔍 ADDRESS DETAILS:');
            addresses.forEach((addr, index) => {
                console.log(`Address ${index + 1}:`, {
                    id: addr.id,
                    recipient_name: addr.recipient_name,
                    recipientName: addr.recipientName,
                    phone: addr.phone,
                    house_number: addr.house_number,
                    houseNumber: addr.houseNumber,
                    ward: addr.ward,
                    district: addr.district,
                    province: addr.province,
                    is_default: addr.is_default
                });
            });
        } else {
            console.log('❌ No addresses found in response');
        }
        
        updateAddressCount();
    } catch (error) {
        console.error('❌ Error loading addresses:', error);
        console.error('Error details:', {
            message: error.message,
            stack: error.stack
        });
        addresses = [];
    }
}

// Tạo HTML cho danh sách địa chỉ
async function createAddressBookHTML() {
    console.log('=== CREATING ADDRESS BOOK HTML ===');
    
    // Force reload addresses để đảm bảo data mới nhất
    console.log('Loading fresh addresses...');
    await loadAddresses();
    
    console.log('Creating HTML with', addresses.length, 'addresses');
    
    let html = `
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ</h4>
            <div>
                <button type="button" class="btn btn-outline-secondary btn-sm me-2" onclick="forceRefreshAddresses()" title="Làm mới danh sách">
                    <i class="fas fa-sync-alt"></i>
                </button>
                <button type="button" class="btn add-address-btn" onclick="showAddAddressForm()">
                    <i class="fas fa-plus me-2"></i>Thêm địa chỉ mới
                </button>
            </div>
        </div>
        
        <div class="address-book-container">
            <div id="addressList">
                ${addresses.length === 0 ? createEmptyStateHTML() : createAddressListHTML()}
            </div>
            
            <div id="addressForm" style="display: none;">
                ${createAddressFormHTML()}
            </div>
        </div>
    `;
    
    console.log('Address book HTML created');
    return html;
}

// Tạo HTML cho trạng thái trống
function createEmptyStateHTML() {
    return `
        <div class="empty-state">
            <i class="fas fa-map-marked-alt"></i>
            <h5>Chưa có địa chỉ nào</h5>
            <p>Thêm địa chỉ để thuận tiện khi đặt hàng</p>
        </div>
    `;
}

// Tạo HTML cho danh sách địa chỉ
function createAddressListHTML() {
    console.log('Creating address list HTML for', addresses.length, 'addresses');
    
    return addresses.map((address, index) => {
        const recipientName = safeText(address.recipient_name || address.recipientName);
        const phone = safeText(address.phone);
        const houseNumber = safeText(address.house_number || address.houseNumber);
        const ward = safeText(address.ward);
        const district = safeText(address.district);
        const province = safeText(address.province);
        
        return `
        <div class="address-card ${address.is_default ? 'default' : ''}">
            <div class="card-header">
                <div class="address-title">
                    Địa chỉ ${index + 1}
                    ${address.is_default ? '<span class="default-badge">Mặc định</span>' : ''}
                </div>
            </div>
            <div class="card-body">
                <div class="address-info">
                    <strong>${recipientName}</strong><br>
                    ${phone}<br>
                    ${houseNumber}<br>
                    ${ward}, ${district}<br>
                    ${province}
                </div>
                <div class="address-actions">
                    ${!address.is_default ? `<button class="btn btn-sm btn-outline-primary" onclick="setDefaultAddress(${address.id})">
                        <i class="fas fa-star me-1"></i>Đặt làm mặc định
                    </button>` : ''}
                    <button class="btn btn-sm btn-outline-secondary" onclick="editAddress(${address.id})">
                        <i class="fas fa-edit me-1"></i>Sửa
                    </button>
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteAddress(${address.id})">
                        <i class="fas fa-trash me-1"></i>Xóa
                    </button>
                </div>
            </div>
        </div>
        `;
    }).join('');
}

// Tạo HTML cho form thêm/sửa địa chỉ
function createAddressFormHTML() {
    return `
        <div class="address-form">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 id="formTitle">Thêm địa chỉ mới</h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="hideAddressForm()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <form id="addressFormElement">
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Họ tên người nhận *</label>
                            <input type="text" class="form-control" id="addressRecipientName" placeholder="Nhập họ tên" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Số điện thoại *</label>
                            <input type="tel" class="form-control" id="addressPhone" placeholder="Nhập số điện thoại" required pattern="[0-9]{10,11}" title="Số điện thoại phải có 10-11 chữ số">
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Số nhà, tên đường *</label>
                    <input type="text" class="form-control" id="addressHouseNumber" placeholder="Nhập số nhà, tên đường..." required>
                </div>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">Phường/Xã *</label>
                            <input type="text" class="form-control" id="addressWard" placeholder="Nhập phường/xã" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">Quận/Huyện *</label>
                            <input type="text" class="form-control" id="addressDistrict" placeholder="Nhập quận/huyện" required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="form-label">Tỉnh/Thành phố *</label>
                            <select class="form-select" id="addressProvince" required>
                                <option value="">Chọn tỉnh/thành phố</option>
                                ${provinces.map(province => `<option value="${province}">${province}</option>`).join('')}
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="checkbox-default">
                    <input type="checkbox" id="addressIsDefault">
                    <label for="addressIsDefault">Đặt làm địa chỉ mặc định</label>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn add-address-btn">
                        <i class="fas fa-save me-2"></i>Lưu địa chỉ
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="hideAddressForm()">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                </div>
            </form>
        </div>
    `;
}

// Hiển thị form thêm địa chỉ
function showAddAddressForm() {
    document.getElementById('addressForm').style.display = 'block';
    document.getElementById('formTitle').textContent = 'Thêm địa chỉ mới';
    document.getElementById('addressFormElement').reset();
    document.getElementById('addressFormElement').onsubmit = handleAddAddress;
}

// Ẩn form địa chỉ
function hideAddressForm() {
    document.getElementById('addressForm').style.display = 'none';
}

// Xử lý thêm địa chỉ
async function handleAddAddress(e) {
    e.preventDefault();
    
    const formData = {
        recipientName: document.getElementById('addressRecipientName').value,
        phone: document.getElementById('addressPhone').value,
        houseNumber: document.getElementById('addressHouseNumber').value,
        ward: document.getElementById('addressWard').value,
        district: document.getElementById('addressDistrict').value,
        province: document.getElementById('addressProvince').value,
        isDefault: document.getElementById('addressIsDefault').checked
    };
    
    // Validate
    if (!formData.recipientName || !formData.phone || !formData.houseNumber || !formData.ward || !formData.district || !formData.province) {
        alert('Vui lòng điền đầy đủ thông tin!');
        return;
    }
    
    // Show loading
    const submitBtn = e.target.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang lưu...';
    submitBtn.disabled = true;
    
    try {
        console.log('=== SENDING ADDRESS DATA ===');
        console.log('Form data:', formData);
        console.log('API URL:', `${contextPath}/api/addresses`);
        
        const response = await fetch(`${contextPath}/api/addresses`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify(formData)
        });
        
        console.log('Response status:', response.status);
        console.log('Response headers:', response.headers);
        console.log('Response ok:', response.ok);
        
        // Check if response is JSON
        const contentType = response.headers.get('content-type');
        console.log('Content-Type:', contentType);
        
        if (!contentType || !contentType.includes('application/json')) {
            // Try to get text response for debugging
            const textResponse = await response.text();
            console.error('Non-JSON response received:', textResponse);
            showNotification('Server trả về dữ liệu không đúng định dạng', 'error');
            return;
        }
        
        const result = await response.json();
        console.log('Response data:', result);
        
        if (result.success) {
            console.log('=== ADDRESS ADDED SUCCESSFULLY ===');
            console.log('Returned address:', result.address);
            
            // Hide form first
            hideAddressForm();
            
            // Show success notification
            showNotification('Đã thêm địa chỉ thành công!', 'success');
            
            // Wait a bit then refresh to ensure backend is ready
            setTimeout(async () => {
                console.log('⏳ Waiting 500ms then refreshing address list...');
                try {
                    await refreshAddressList();
                    updateAddressCount();
                    console.log('✅ Address list refreshed. New count:', addresses.length);
                } catch (error) {
                    console.error('❌ Error during refresh after save:', error);
                    // Fallback: reload page if refresh fails
                    console.log('🔄 Fallback: Reloading page...');
                    location.reload();
                }
            }, 500);
            
        } else {
            console.error('Server returned error:', result.message);
            showNotification(result.message || 'Có lỗi xảy ra khi thêm địa chỉ!', 'error');
        }
    } catch (error) {
        console.error('=== FETCH ERROR ===');
        console.error('Error type:', error.constructor.name);
        console.error('Error message:', error.message);
        console.error('Full error:', error);
        
        let errorMessage = 'Có lỗi xảy ra khi thêm địa chỉ!';
        if (error.message.includes('Failed to fetch')) {
            errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.';
        } else if (error.message.includes('JSON') || error.name === 'SyntaxError') {
            errorMessage = 'Lỗi xử lý dữ liệu từ server. Vui lòng kiểm tra console để biết chi tiết.';
        }
        
        showNotification(errorMessage, 'error');
    } finally {
        // Reset button
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
}

// Sửa địa chỉ
async function editAddress(addressId) {
    const address = addresses.find(addr => addr.id === addressId);
    if (!address) {
        alert('Không tìm thấy địa chỉ!');
        return;
    }
    
    // Hiển thị form
    document.getElementById('addressForm').style.display = 'block';
    document.getElementById('formTitle').textContent = 'Sửa địa chỉ';
    
    // Điền dữ liệu
    document.getElementById('addressRecipientName').value = address.recipient_name;
    document.getElementById('addressPhone').value = address.phone;
    document.getElementById('addressHouseNumber').value = address.house_number;
    document.getElementById('addressWard').value = address.ward;
    document.getElementById('addressDistrict').value = address.district;
    document.getElementById('addressProvince').value = address.province;
    document.getElementById('addressIsDefault').checked = address.is_default;
    
    // Xử lý submit
    document.getElementById('addressFormElement').onsubmit = async function(e) {
        e.preventDefault();
        
        const formData = {
            recipientName: document.getElementById('addressRecipientName').value,
            phone: document.getElementById('addressPhone').value,
            houseNumber: document.getElementById('addressHouseNumber').value,
            ward: document.getElementById('addressWard').value,
            district: document.getElementById('addressDistrict').value,
            province: document.getElementById('addressProvince').value,
            isDefault: document.getElementById('addressIsDefault').checked
        };        // Validate
        if (!formData.recipientName || !formData.phone || !formData.houseNumber || !formData.ward || !formData.district || !formData.province) {
            showNotification('Vui lòng điền đầy đủ thông tin!', 'error');
            return;
        }
        
        // Validate phone number
        if (!phoneRegex.test(formData.phone)) {
            showNotification('Số điện thoại phải có 10-11 chữ số!', 'error');
            return;
        }
    
    // Validate phone number
    if (!phoneRegex.test(formData.phone)) {
        showNotification('Số điện thoại phải có 10-11 chữ số!', 'error');
        return;
    }
        
        // Show loading
        const submitBtn = e.target.querySelector('button[type="submit"]');
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang cập nhật...';
        submitBtn.disabled = true;
        
        try {
            const response = await fetch(`${contextPath}/api/addresses/${addressId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Accept': 'application/json; charset=UTF-8'
                },
                body: JSON.stringify(formData)
            });
            
            const result = await response.json();
            
            if (result.success) {
                // Refresh danh sách
                await refreshAddressList();
                hideAddressForm();
                showNotification('Đã cập nhật địa chỉ thành công!', 'success');
            } else {
                showNotification(result.message || 'Có lỗi xảy ra khi cập nhật địa chỉ!', 'error');
            }
        } catch (error) {
            console.error('Error updating address:', error);
            showNotification('Có lỗi xảy ra khi cập nhật địa chỉ!', 'error');
        } finally {
            // Reset button
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
        }
    };
}

// Xóa địa chỉ
async function deleteAddress(addressId) {
    if (!confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')) {
        return;
    }
    
    try {
        const response = await fetch(`${contextPath}/api/addresses/${addressId}`, {
            method: 'DELETE',
            headers: {
                'Accept': 'application/json; charset=UTF-8'
            }
        });
        
        const result = await response.json();
        
        if (result.success) {
            await refreshAddressList();
            updateAddressCount();
            showNotification('Đã xóa địa chỉ thành công!', 'success');
        } else {
            showNotification(result.message || 'Có lỗi xảy ra khi xóa địa chỉ!', 'error');
        }
    } catch (error) {
        console.error('Error deleting address:', error);
        showNotification('Có lỗi xảy ra khi xóa địa chỉ!', 'error');
    }
}

// Đặt địa chỉ mặc định
async function setDefaultAddress(addressId) {
    try {
        const response = await fetch(`${contextPath}/api/addresses/${addressId}/default`, {
            method: 'PUT',
            headers: {
                'Accept': 'application/json; charset=UTF-8'
            }
        });
        
        const result = await response.json();
        
        if (result.success) {
            await refreshAddressList();
            showNotification('Đã đặt làm địa chỉ mặc định!', 'success');
        } else {
            showNotification(result.message || 'Có lỗi xảy ra!', 'error');
        }
    } catch (error) {
        console.error('Error setting default address:', error);
        showNotification('Có lỗi xảy ra khi đặt địa chỉ mặc định!', 'error');
    }
}

// Refresh danh sách địa chỉ
async function refreshAddressList() {
    console.log('=== REFRESHING ADDRESS LIST ===');
    console.log('Current addresses count before refresh:', addresses.length);
    
    try {
        await loadAddresses();
        console.log('Addresses count after loadAddresses:', addresses.length);
        
        const addressListElement = document.getElementById('addressList');
        if (addressListElement) {
            console.log('Found addressList element, updating HTML...');
            
            if (addresses.length === 0) {
                console.log('No addresses found, showing empty state');
                addressListElement.innerHTML = createEmptyStateHTML();
            } else {
                console.log('Creating address list HTML for', addresses.length, 'addresses');
                const newHTML = createAddressListHTML();
                console.log('Generated HTML length:', newHTML.length);
                addressListElement.innerHTML = newHTML;
            }
            
            console.log('Address list HTML updated successfully');
        } else {
            console.error('❌ addressList element not found! DOM structure:');
            console.log('Available elements with "address" in ID:', 
                Array.from(document.querySelectorAll('[id*="address"]')).map(el => el.id));
        }
    } catch (error) {
        console.error('❌ Error in refreshAddressList:', error);
    }
}

// Cập nhật số lượng địa chỉ trong badge
function updateAddressCount() {
    const badge = document.querySelector('#profileAddressTab .badge');
    if (badge) {
        badge.textContent = addresses.length;
    }
}

// Tải số lượng địa chỉ từ API
async function loadAddressCount() {
    try {
        const response = await fetch(`${contextPath}/api/addresses/count`, {
            headers: {
                'Accept': 'application/json; charset=UTF-8'
            }
        });
        const data = await response.json();
        
        if (data.success) {
            const badge = document.querySelector('#profileAddressTab .badge');
            if (badge) {
                badge.textContent = data.count;
            }
        }
    } catch (error) {
        console.error('Error loading address count:', error);
    }
}

// Show notification function
function showNotification(message, type = 'info') {
    // Check if notification function exists from profile page
    if (typeof window.showNotification === 'function') {
        window.showNotification(message, type);
        return;
    }
    
    // Fallback to creating our own notification
    const notification = document.createElement('div');
    const alertType = type === 'success' ? 'success' : 'danger';
    const iconType = type === 'success' ? 'check-circle' : 'exclamation-circle';
    
    notification.className = 'alert alert-' + alertType + ' alert-dismissible fade show position-fixed';
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 1060; min-width: 300px;';
    notification.innerHTML = 
        '<i class="fas fa-' + iconType + ' me-2"></i>' +
        message +
        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Debug function để force refresh UI (có thể gọi từ console)
window.debugAddressBook = async function() {
    console.log('=== DEBUG ADDRESS BOOK ===');
    console.log('Current addresses array:', addresses);
    console.log('Address count:', addresses.length);
    
    console.log('Loading fresh data from API...');
    await loadAddresses();
    
    console.log('After loading - addresses:', addresses);
    console.log('After loading - count:', addresses.length);
    
    console.log('Refreshing UI...');
    await refreshAddressList();
    
    console.log('Update complete');
    return addresses;
};

// Force refresh function
window.forceRefreshAddresses = async function() {
    console.log('Force refreshing addresses...');
    
    // Show loading indicator on refresh button
    const refreshBtn = document.querySelector('button[onclick="forceRefreshAddresses()"]');
    let originalHTML = '';
    
    if (refreshBtn) {
        originalHTML = refreshBtn.innerHTML;
        refreshBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
        refreshBtn.disabled = true;
    }
    
    try {
        // Show loading in address list
        const addressList = document.getElementById('addressList');
        if (addressList) {
            addressList.innerHTML = '<div class="text-center py-4"><i class="fas fa-spinner fa-spin me-2"></i>Đang tải...</div>';
        }
        
        await refreshAddressList();
        updateAddressCount();
        
        showNotification('Đã làm mới danh sách địa chỉ', 'success');
        console.log('Force refresh complete');
    } catch (error) {
        console.error('Error during force refresh:', error);
        showNotification('Có lỗi khi làm mới danh sách', 'error');
    } finally {
        // Restore refresh button
        if (refreshBtn) {
            refreshBtn.innerHTML = originalHTML;
            refreshBtn.disabled = false;
        }
    }
};

// Khởi tạo khi DOM ready
document.addEventListener('DOMContentLoaded', function() {
    loadAddresses();
    loadAddressCount();
});

// Force refresh function for profile tab integration
async function forceRefreshAddresses() {
    console.log('=== FORCE REFRESH ADDRESSES ===');
    try {
        await loadAddresses();
        await loadAddressCount();
        console.log('Force refresh completed successfully');
    } catch (error) {
        console.error('Error during force refresh:', error);
    }
}

console.log('Address Book Script Loaded');

// Test function để debug UTF-8 encoding
window.testUTF8Fix = function() {
    const testData = [
        'Tr?n Kim T?n',
        'Lê Ðình Diên', 
        'Hòa Xuân, C?m L?',
        'Ðà N?ng'
    ];
    
    console.log('=== UTF-8 ENCODING TEST ===');
    testData.forEach(text => {
        const fixed = fixUTF8Encoding(text);
        console.log(`"${text}" → "${fixed}"`);
    });
};

// Debug function để check trạng thái address book
window.debugAddressBook = function() {
    console.log('=== ADDRESS BOOK DEBUG ===');
    console.log('Addresses array:', addresses);
    console.log('Addresses count:', addresses.length);
    console.log('AddressList element:', document.getElementById('addressList'));
    console.log('AddressForm element:', document.getElementById('addressForm'));
    
    // Test refresh
    console.log('Testing refresh...');
    refreshAddressList();
};

// Debug function để test API trực tiếp
window.testAddressAPI = async function() {
    console.log('=== TESTING ADDRESS API DIRECTLY ===');
    
    const contextPath = window.APP_CONTEXT_PATH || '';
    const apiUrl = `${contextPath}/api/addresses`;
    
    console.log('Testing API URL:', apiUrl);
    
    try {
        const response = await fetch(apiUrl, {
            headers: {
                'Accept': 'application/json; charset=UTF-8'
            }
        });
        
        console.log('Response status:', response.status);
        console.log('Response headers:', [...response.headers.entries()]);
        
        const rawText = await response.text();
        console.log('Raw response text:', rawText);
        
        try {
            const jsonData = JSON.parse(rawText);
            console.log('Parsed JSON:', jsonData);
        } catch (parseError) {
            console.error('JSON parse error:', parseError);
        }
        
    } catch (error) {
        console.error('API test error:', error);
    }
};
