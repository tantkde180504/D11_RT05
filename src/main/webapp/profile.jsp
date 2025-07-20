<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin khách hàng - 43 Gundam Hobby</title>
    <%@ include file="/includes/unified-css.jsp" %>
</head>
<body class="profile-body">    <!-- Header -->
    <%@ include file="/includes/unified-header.jsp" %>
    
    <main class="container my-5">
        <div class="row">
            <div class="col-md-3">
                <div class="profile-sidebar">                    <div class="text-center mb-4">
                        <img id="profileUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-2 avatar-80">
                        <h5 id="profileUserName">Đang tải...</h5>
                        <small id="profileUserEmail" class="text-muted">Đang tải...</small>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#" id="profileInfoTab"><i class="fas fa-user me-2"></i>Thông tin tài khoản</a>
                        <a class="nav-link" href="#" id="profileAddressTab"><i class="fas fa-map-marker-alt me-2"></i>Sổ địa chỉ <span class="badge bg-primary ms-1">0</span></a>
                        <a class="nav-link" href="#" id="profileOrdersTab"><i class="fas fa-box me-2"></i>Đơn hàng của bạn</a>
                        <a class="nav-link" href="#" id="profilePasswordTab"><i class="fas fa-key me-2"></i>Đổi mật khẩu</a>
                        <a class="nav-link text-danger" href="#" id="profileLogoutBtn"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a>
                    </nav>
                </div>
            </div>
            <div class="col-md-9">                <div class="profile-content" id="profileContent">
                    <!-- Nội dung từng tab sẽ được hiển thị ở đây -->
                    <div id="profileInfoContent">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-user-circle me-2"></i>Thông tin tài khoản</h4>
                            <button type="button" class="btn btn-outline-primary" id="editProfileBtn">
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa
                            </button>
                        </div>
                        
                        <!-- View Mode -->
                        <div id="profileViewMode">
                            <div class="row mt-4">
                                <div class="col-md-8">
                                    <div class="info-section">
                                        <h6 class="text-muted mb-3">Thông tin cá nhân</h6>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Họ tên:</strong></div>
                                            <div class="col-sm-8" id="displayUserName">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Email:</strong></div>
                                            <div class="col-sm-8" id="displayUserEmail">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Số điện thoại:</strong></div>
                                            <div class="col-sm-8" id="displayUserPhone">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Địa chỉ:</strong></div>
                                            <div class="col-sm-8" id="displayUserAddress">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Ngày sinh:</strong></div>
                                            <div class="col-sm-8" id="displayUserDateOfBirth">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Giới tính:</strong></div>
                                            <div class="col-sm-8" id="displayUserGender">Chưa có thông tin</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Vai trò:</strong></div>
                                            <div class="col-sm-8" id="displayUserRole">Đang tải...</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Đăng nhập bằng:</strong></div>
                                            <div class="col-sm-8" id="displayLoginType">Đang tải...</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4 text-center">
                                    <div class="avatar-section">
                                        <img id="displayUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-3 avatar-120">
                                        <div class="mt-2">
                                            <small class="text-muted" id="avatarSource">Ảnh đại diện</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Edit Mode -->
                        <div id="profileEditMode" style="display: none;">
                            <form id="updateProfileForm">
                                <div class="row mt-4">
                                    <div class="col-md-8">
                                        <div class="info-section">
                                            <h6 class="text-muted mb-3">Cập nhật thông tin cá nhân</h6>
                                            
                                            <div class="mb-3">
                                                <label for="editFirstName" class="form-label">Họ *</label>
                                                <input type="text" class="form-control" id="editFirstName" name="firstName" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editLastName" class="form-label">Tên *</label>
                                                <input type="text" class="form-control" id="editLastName" name="lastName" required>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editEmail" class="form-label">Email</label>
                                                <input type="email" class="form-control" id="editEmail" name="email" readonly>
                                                <div class="form-text">Email không thể thay đổi</div>
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editPhone" class="form-label">Số điện thoại</label>
                                                <input type="tel" class="form-control" id="editPhone" name="phone" placeholder="Nhập số điện thoại">
                                            </div>
                                            
                                            <div class="mb-3">
                                                <label for="editAddress" class="form-label">Địa chỉ</label>
                                                <textarea class="form-control" id="editAddress" name="address" rows="3" placeholder="Nhập địa chỉ của bạn"></textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="editDateOfBirth" class="form-label">Ngày sinh</label>
                                                        <input type="date" class="form-control" id="editDateOfBirth" name="dateOfBirth">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="editGender" class="form-label">Giới tính</label>
                                                        <select class="form-control" id="editGender" name="gender">
                                                            <option value="">Chọn giới tính</option>
                                                            <option value="Nam">Nam</option>
                                                            <option value="Nữ">Nữ</option>
                                                            <option value="Khác">Khác</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="d-flex gap-2">
                                                <button type="submit" class="btn btn-success">
                                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                                </button>
                                                <button type="button" class="btn btn-secondary" id="cancelEditBtn">
                                                    <i class="fas fa-times me-2"></i>Hủy
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-center">
                                        <div class="avatar-section">
                                            <img id="editUserAvatar" src="/img/default-avatar.png" alt="Avatar" class="rounded-circle mb-3 avatar-120">
                                            <div class="mt-2">
                                                <small class="text-muted" id="editAvatarSource">Ảnh đại diện</small>
                                            </div>
                                            <div class="mt-2">
                                                <small class="text-info">
                                                    <i class="fas fa-info-circle me-1"></i>
                                                    Ảnh đại diện từ Google không thể thay đổi
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="/includes/unified-scripts.jsp" %>
    
    <!-- Profile-specific scripts -->
    <script src="<%=request.getContextPath()%>/js/address-book.js"></script>
    <script src="<%=request.getContextPath()%>/js/address-api-test.js"></script>
    <script src="<%=request.getContextPath()%>/js/address-e2e-test.js"></script>
    <script src="<%=request.getContextPath()%>/js/avatar-utils.js"></script>
    <script src="<%=request.getContextPath()%>/js/auth-sync.js"></script>
    
    <script>
        // Set context path globally for JavaScript access
        window.APP_CONTEXT_PATH = '<%=request.getContextPath()%>';
        console.log('App context path from JSP:', window.APP_CONTEXT_PATH);
    </script>
    
    <script>
        // Load profile data from API
        function loadProfileData() {
            let contextPath = '';
            if (window.APP_CONTEXT_PATH !== undefined) {
                contextPath = window.APP_CONTEXT_PATH;
            }
            
            fetch(contextPath + '/api/profile/info')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.userData) {
                    const userData = data.userData;
                    
                    // Update display elements
                    document.getElementById('displayUserName').textContent = userData.fullName || 'Chưa có thông tin';
                    document.getElementById('displayUserEmail').textContent = userData.email;
                    document.getElementById('displayUserPhone').textContent = userData.phone || 'Chưa có thông tin';
                    document.getElementById('displayUserAddress').textContent = userData.address || 'Chưa có thông tin';
                    document.getElementById('displayUserDateOfBirth').textContent = userData.dateOfBirth || 'Chưa có thông tin';
                    document.getElementById('displayUserGender').textContent = userData.gender || 'Chưa có thông tin';
                    
                    // Update role display
                    let roleText = userData.role;
                    if (userData.role === 'CUSTOMER') roleText = 'Khách hàng';
                    else if (userData.role === 'ADMIN') roleText = 'Quản trị viên';
                    else if (userData.role === 'STAFF') roleText = 'Nhân viên';
                    document.getElementById('displayUserRole').textContent = roleText;
                    
                    // Update login type display
                    let loginTypeText = userData.provider;
                    if (userData.provider === 'google') loginTypeText = 'Google OAuth';
                    else if (userData.provider === 'local') loginTypeText = 'Tài khoản nội bộ';
                    document.getElementById('displayLoginType').textContent = loginTypeText;
                    
                    // Populate edit form
                    document.getElementById('editFirstName').value = userData.firstName;
                    document.getElementById('editLastName').value = userData.lastName;
                    document.getElementById('editEmail').value = userData.email;
                    document.getElementById('editPhone').value = userData.phone;
                    document.getElementById('editAddress').value = userData.address;
                    document.getElementById('editDateOfBirth').value = userData.dateOfBirth;
                    document.getElementById('editGender').value = userData.gender;
                    
                    // Store in localStorage for persistence
                    localStorage.setItem('userName', userData.fullName);
                    localStorage.setItem('userPhone', userData.phone);
                    localStorage.setItem('userAddress', userData.address);
                    localStorage.setItem('userDateOfBirth', userData.dateOfBirth);
                    localStorage.setItem('userGender', userData.gender);
                }
            })
            .catch(error => {
                console.error('Error loading profile data:', error);
                // Fall back to session data if API fails
                loadFromSession();
            });
        }
        
        // Fallback function to load from session data
        function loadFromSession() {
        // Hiển thị thông tin người dùng từ session
            // Lấy thông tin từ session JSP
            const userName = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>';
            const userEmail = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>';
            const userPicture = '<%= session.getAttribute("userPicture") != null ? session.getAttribute("userPicture") : "" %>';
            const userRole = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "CUSTOMER" %>';
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            // Try to get additional info from localStorage (if available)
            const storedPhone = localStorage.getItem('userPhone') || '';
            const storedAddress = localStorage.getItem('userAddress') || '';
            const storedDateOfBirth = localStorage.getItem('userDateOfBirth') || '';
            const storedGender = localStorage.getItem('userGender') || '';
            
            // Split full name into first and last name
            let firstName = '';
            let lastName = '';
            if (userName && userName !== 'null' && userName !== '') {
                const nameParts = userName.split(' ');
                if (nameParts.length >= 2) {
                    firstName = nameParts.slice(0, -1).join(' ');
                    lastName = nameParts[nameParts.length - 1];
                } else {
                    firstName = userName;
                    lastName = '';
                }
            }
            
            // Update display elements
            document.getElementById('displayUserName').textContent = userName || 'Chưa có thông tin';
            document.getElementById('displayUserEmail').textContent = userEmail;
            document.getElementById('displayUserPhone').textContent = storedPhone || 'Chưa có thông tin';
            document.getElementById('displayUserAddress').textContent = storedAddress || 'Chưa có thông tin';
            document.getElementById('displayUserDateOfBirth').textContent = storedDateOfBirth || 'Chưa có thông tin';
            document.getElementById('displayUserGender').textContent = storedGender || 'Chưa có thông tin';
            
            // Populate edit form
            document.getElementById('editFirstName').value = firstName;
            document.getElementById('editLastName').value = lastName;
            document.getElementById('editEmail').value = userEmail;
            document.getElementById('editPhone').value = storedPhone;
            document.getElementById('editAddress').value = storedAddress;
            document.getElementById('editDateOfBirth').value = storedDateOfBirth;
            document.getElementById('editGender').value = storedGender;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            // Try to load from API first, fallback to session if needed
            if ('<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>') {
                loadProfileData();
            } else {
                loadFromSession();
            }
            
            // Load address count immediately for sidebar badge
            setTimeout(() => {
                if (typeof loadAddressCount === 'function') {
                    loadAddressCount();
                }
            }, 100);
            
            // Get session data for sidebar and other elements
            const userName = '<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>';
            const userEmail = '<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>';
            const userPicture = '<%= session.getAttribute("userPicture") != null ? session.getAttribute("userPicture") : "" %>';
            const userRole = '<%= session.getAttribute("userRole") != null ? session.getAttribute("userRole") : "CUSTOMER" %>';
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            // Cập nhật thông tin trong sidebar
            if (userName && userName !== 'null' && userName !== '') {
                document.getElementById('profileUserName').textContent = 'Xin chào, ' + userName;
            } else {
                document.getElementById('profileUserName').textContent = 'Chưa đăng nhập';
            }
            
            if (userEmail && userEmail !== 'null' && userEmail !== '') {
                document.getElementById('profileUserEmail').textContent = userEmail;
            } else {
                document.getElementById('profileUserEmail').textContent = 'Chưa có email';
            }
            
            // Cập nhật avatar
            if (userPicture && userPicture !== 'null' && userPicture !== '') {
                document.getElementById('profileUserAvatar').src = userPicture;
                document.getElementById('displayUserAvatar').src = userPicture;
                document.getElementById('editUserAvatar').src = userPicture;
                document.getElementById('avatarSource').textContent = 'Ảnh đại diện từ Google';
                document.getElementById('editAvatarSource').textContent = 'Ảnh đại diện từ Google';
            } else {
                // Generate Gravatar from email
                if (userEmail) {
                    const gravatarUrl = generateGravatarUrl(userEmail);
                    document.getElementById('profileUserAvatar').src = gravatarUrl;
                    document.getElementById('displayUserAvatar').src = gravatarUrl;
                    document.getElementById('editUserAvatar').src = gravatarUrl;
                    document.getElementById('avatarSource').textContent = 'Ảnh đại diện Gravatar';
                    document.getElementById('editAvatarSource').textContent = 'Ảnh đại diện Gravatar';
                }
            }
            
            // Setup edit mode handlers
            setupEditHandlers();
        });
        
        // Setup edit mode event handlers
        function setupEditHandlers() {
            // Edit button click
            document.getElementById('editProfileBtn').addEventListener('click', function() {
                document.getElementById('profileViewMode').style.display = 'none';
                document.getElementById('profileEditMode').style.display = 'block';
                this.style.display = 'none';
            });
            
            // Cancel edit button click
            document.getElementById('cancelEditBtn').addEventListener('click', function() {
                document.getElementById('profileEditMode').style.display = 'none';
                document.getElementById('profileViewMode').style.display = 'block';
                document.getElementById('editProfileBtn').style.display = 'block';
            });
            
            // Form submit
            document.getElementById('updateProfileForm').addEventListener('submit', function(e) {
                e.preventDefault();
                updateProfile();
            });
        }
        
        // Update profile function
        function updateProfile() {
            const formData = new FormData(document.getElementById('updateProfileForm'));
            const firstName = formData.get('firstName').trim();
            const lastName = formData.get('lastName').trim();
            const phone = formData.get('phone').trim();
            const address = formData.get('address').trim();
            const email = formData.get('email');
            const dateOfBirth = formData.get('dateOfBirth');
            const gender = formData.get('gender');
            
            // Validation
            if (!firstName || !lastName) {
                alert('Vui lòng nhập đầy đủ họ và tên!');
                return;
            }
            
            // Show loading
            const submitBtn = document.querySelector('#updateProfileForm button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang cập nhật...';
            submitBtn.disabled = true;
            
            // Prepare update data
            const updateData = {
                firstName: firstName,
                lastName: lastName,
                phone: phone,
                address: address,
                email: email,
                dateOfBirth: dateOfBirth,
                gender: gender
            };
            
            // Get context path
            let contextPath = '';
            if (window.APP_CONTEXT_PATH !== undefined) {
                contextPath = window.APP_CONTEXT_PATH;
            }
            
            // Send update request
            fetch(contextPath + '/api/profile/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updateData)
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('Update response:', data);
                
                if (data.success) {
                    // Update displayed information
                    const fullName = firstName + ' ' + lastName;
                    document.getElementById('displayUserName').textContent = fullName;
                    document.getElementById('profileUserName').textContent = 'Xin chào, ' + fullName;
                    document.getElementById('displayUserPhone').textContent = phone || 'Chưa có thông tin';
                    document.getElementById('displayUserAddress').textContent = address || 'Chưa có thông tin';
                    document.getElementById('displayUserDateOfBirth').textContent = dateOfBirth || 'Chưa có thông tin';
                    document.getElementById('displayUserGender').textContent = gender || 'Chưa có thông tin';
                    
                    // Store in localStorage for persistence
                    localStorage.setItem('userName', fullName);
                    localStorage.setItem('userPhone', phone);
                    localStorage.setItem('userAddress', address);
                    localStorage.setItem('userDateOfBirth', dateOfBirth);
                    localStorage.setItem('userGender', gender);
                    
                    // Switch back to view mode
                    document.getElementById('profileEditMode').style.display = 'none';
                    document.getElementById('profileViewMode').style.display = 'block';
                    document.getElementById('editProfileBtn').style.display = 'block';
                    
                    // Show success message
                    showNotification('Cập nhật thông tin thành công!', 'success');
                } else {
                    throw new Error(data.message || 'Cập nhật thất bại');
                }
            })
            .catch(error => {
                console.error('Update error:', error);
                showNotification('Lỗi cập nhật: ' + error.message, 'error');
            })
            .finally(() => {
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        }
        
        // Generate Gravatar URL
        function generateGravatarUrl(email) {
            if (!email) return '/img/default-avatar.png';
            
            // Simple hash function for demonstration
            let hash = 0;
            for (let i = 0; i < email.length; i++) {
                const char = email.charCodeAt(i);
                hash = ((hash << 5) - hash) + char;
                hash = hash & hash; // Convert to 32bit integer
            }
            const hashStr = Math.abs(hash).toString(16);
            return 'https://www.gravatar.com/avatar/' + hashStr + '?d=identicon&s=120';
        }
        
        // Show notification
        function showNotification(message, type = 'info') {
            // Create notification element
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
        
        // Xử lý tab switching
        document.getElementById('profileInfoTab').onclick = function(e) {
            e.preventDefault();
            // Remove active class from all tabs
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Show profile info content (đã có sẵn)
            const profileContent = document.getElementById('profileContent');
            profileContent.innerHTML = document.getElementById('profileInfoContent').outerHTML;
        };
        
        document.getElementById('profileAddressTab').onclick = async function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            // Load address book content
            const profileContent = document.getElementById('profileContent');
            profileContent.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải...</div>';
            
            try {
                console.log('=== LOADING ADDRESS BOOK TAB ===');
                
                // Đảm bảo script address-book.js đã load
                if (typeof createAddressBookHTML === 'function') {
                    console.log('Creating address book HTML...');
                    const addressBookHTML = await createAddressBookHTML();
                    console.log('Address book HTML created, setting innerHTML...');
                    profileContent.innerHTML = addressBookHTML;
                    console.log('Address book tab loaded successfully');
                    
                    // Force refresh sau khi load để đảm bảo data mới nhất
                    if (typeof forceRefreshAddresses === 'function') {
                        console.log('Force refreshing addresses after tab load...');
                        setTimeout(() => {
                            forceRefreshAddresses();
                        }, 100);
                    }
                } else {
                    throw new Error('Address book script not loaded');
                }
            } catch (error) {
                console.error('Error loading address book:', error);
                profileContent.innerHTML = 
                    '<div class="alert alert-danger">' +
                    '<i class="fas fa-exclamation-triangle me-2"></i>' +
                    'Có lỗi xảy ra khi tải sổ địa chỉ. Vui lòng thử lại.' +
                    '<br><button class="btn btn-sm btn-outline-primary mt-2" onclick="location.reload()">Tải lại trang</button>' +
                    '</div>';
            }
        };
        
        document.getElementById('profileOrdersTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            document.getElementById('profileContent').innerHTML = `
                <h4><i class="fas fa-box me-2"></i>Đơn hàng của bạn</h4>
                <div id="order-history-list" class="mt-4">
                    <div class="text-muted">Đang tải dữ liệu...</div>
                </div>
                
                <!-- Modal Gửi Khiếu Nại -->
                <div class="modal fade" id="complaintModal" tabindex="-1" aria-labelledby="complaintModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <form id="complaintForm" class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Gửi khiếu nại đơn hàng</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="complaintOrderId">
                                <div class="mb-3">
                                    <label for="complaintCategory" class="form-label">Danh mục (tùy chọn)</label>
                                    <select class="form-select" id="complaintCategory">
                                        <option value="">-- Chọn danh mục khiếu nại --</option>
                                        <option value="Giao hàng trễ">Giao hàng trễ</option>
                                        <option value="Hỏng sản phẩm">Hỏng sản phẩm</option>
                                        <option value="Thiếu hàng">Thiếu hàng</option>
                                        <option value="Sai hàng">Sai hàng</option>
                                        <option value="Không đúng mô tả">Không đúng mô tả</option>
                                        <option value="Không hoạt động">Không hoạt động</option>
                                        <option value="Chất lượng kém">Chất lượng kém</option>
                                        <option value="Lý do khác">Lý do khác</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="complaintContent" class="form-label">Nội dung khiếu nại *</label>
                                    <textarea class="form-control" id="complaintContent" rows="4" required></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Gửi khiếu nại</button>
                            </div>
                        </form>
                    </div>
                </div>
            `;
            
            // Load order history
            loadOrderHistory();
        };
        
        document.getElementById('profilePasswordTab').onclick = function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            this.classList.add('active');
            
            // Check if user is OAuth user
            const loginType = '<%= session.getAttribute("loginType") != null ? session.getAttribute("loginType") : "local" %>';
            
            if (loginType === 'google') {
                document.getElementById('profileContent').innerHTML = 
                    '<h4><i class="fas fa-key me-2"></i>Đổi mật khẩu</h4>' +
                    '<div class="alert alert-info mt-4">' +
                        '<i class="fas fa-info-circle me-2"></i>' +
                        'Tài khoản Google không thể đổi mật khẩu. Vui lòng đổi mật khẩu trực tiếp trong tài khoản Google của bạn.' +
                    '</div>';
            } else {
                document.getElementById('profileContent').innerHTML = `
                    <h4><i class="fas fa-key me-2"></i>Đổi mật khẩu</h4>
                    <div class="row mt-4">
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-body">
                                    <form id="changePasswordForm">
                                        <div class="mb-3">
                                            <label for="currentPassword" class="form-label">Mật khẩu hiện tại *</label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                                <button class="btn btn-outline-secondary" type="button" id="toggleCurrentPassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="newPassword" class="form-label">Mật khẩu mới *</label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                                <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                            <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới *</label>
                                            <div class="input-group">
                                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            <strong>Lưu ý:</strong> Sau khi đổi mật khẩu, bạn sẽ cần đăng nhập lại với mật khẩu mới.
                                        </div>
                                        
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-save me-2"></i>Đổi mật khẩu
                                            </button>
                                            <button type="reset" class="btn btn-secondary">
                                                <i class="fas fa-undo me-2"></i>Đặt lại
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h6 class="card-title"><i class="fas fa-shield-alt me-2"></i>Bảo mật mật khẩu</h6>
                                    <ul class="list-unstyled">
                                        <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Ít nhất 6 ký tự</li>
                                        <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Nên có chữ hoa và chữ thường</li>
                                        <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Nên có số và ký tự đặc biệt</li>
                                        <li class="mb-2"><i class="fas fa-check text-success me-2"></i>Không sử dụng thông tin cá nhân</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
                
                // Setup password change form handlers
                setupPasswordChangeHandlers();
            }
        };
        
        // Setup password change form handlers
        function setupPasswordChangeHandlers() {
            // Toggle password visibility
            document.getElementById('toggleCurrentPassword').addEventListener('click', function() {
                togglePasswordVisibility('currentPassword', this);
            });
            
            document.getElementById('toggleNewPassword').addEventListener('click', function() {
                togglePasswordVisibility('newPassword', this);
            });
            
            document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
                togglePasswordVisibility('confirmPassword', this);
            });
            
            // Form submission
            document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
                e.preventDefault();
                changePassword();
            });
        }
        
        // Toggle password visibility
        function togglePasswordVisibility(inputId, button) {
            const input = document.getElementById(inputId);
            const icon = button.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }
        
        // Change password function
        function changePassword() {
            const currentPassword = document.getElementById('currentPassword').value.trim();
            const newPassword = document.getElementById('newPassword').value.trim();
            const confirmPassword = document.getElementById('confirmPassword').value.trim();
            
            // Client-side validation
            if (!currentPassword) {
                showNotification('Vui lòng nhập mật khẩu hiện tại!', 'error');
                return;
            }
            
            if (!newPassword) {
                showNotification('Vui lòng nhập mật khẩu mới!', 'error');
                return;
            }
            
            if (!confirmPassword) {
                showNotification('Vui lòng xác nhận mật khẩu mới!', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showNotification('Mật khẩu mới và xác nhận mật khẩu không khớp!', 'error');
                return;
            }
            
            if (newPassword.length < 6) {
                showNotification('Mật khẩu mới phải có ít nhất 6 ký tự!', 'error');
                return;
            }
            
            if (currentPassword === newPassword) {
                showNotification('Mật khẩu mới phải khác mật khẩu hiện tại!', 'error');
                return;
            }
            
            // Show loading
            const submitBtn = document.querySelector('#changePasswordForm button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            // Prepare data
            const changeData = {
                currentPassword: currentPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword
            };
            
            // Get context path
            let contextPath = '';
            if (window.APP_CONTEXT_PATH !== undefined) {
                contextPath = window.APP_CONTEXT_PATH;
            }
            
            // Send request
            fetch(contextPath + '/api/profile/change-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(changeData)
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response headers:', response.headers);
                return response.json();
            })
            .then(data => {
                console.log('Change password response:', data);
                
                if (data.success) {
                    showNotification('Đổi mật khẩu thành công! Bạn sẽ được chuyển về trang đăng nhập.', 'success');
                    
                    // Clear form
                    document.getElementById('changePasswordForm').reset();
                    
                    // Redirect to login after 3 seconds
                    setTimeout(() => {
                        // Clear session and redirect to login
                        fetch('/logout', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            }
                        }).then(() => {
                            sessionStorage.clear();
                            localStorage.clear();
                            window.location.href = '/login.jsp';
                        }).catch(() => {
                            // Fallback
                            window.location.href = '/login.jsp';
                        });
                    }, 3000);
                } else {
                    console.error('Change password failed:', data.message);
                    showNotification(data.message || 'Đổi mật khẩu thất bại!', 'error');
                }
            })
            .catch(error => {
                console.error('Change password error:', error);
                showNotification('Lỗi kết nối máy chủ: ' + error.message, 'error');
            })
            .finally(() => {
                // Reset button
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        }
        
        // Xử lý đăng xuất
        document.getElementById('profileLogoutBtn').onclick = function(e) {
            e.preventDefault();
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                logoutUser();
            }
        };
        
        // Function đăng xuất
        function logoutUser() {
            // Gọi API logout của Spring Security OAuth2
            fetch('/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            }).then(() => {
                // Clear session storage
                sessionStorage.clear();
                localStorage.clear();
                
                // Redirect về trang chủ
                window.location.href = '/';
            }).catch(error => {
                console.error('Logout error:', error);
                // Fallback: redirect về trang chủ dù có lỗi
                window.location.href = '/';
            });
        }
        
        // Functions for order history
        async function loadOrderHistory() {
            const orderHistoryList = document.getElementById('order-history-list');
            try {
                const resp = await fetch('/api/orders/history', { headers: { 'Accept': 'application/json' } });
                if (!resp.ok) throw new Error('Lỗi xác thực hoặc máy chủ');
                const data = await resp.json();
                if (!Array.isArray(data)) {
                    orderHistoryList.innerHTML = '<div class="text-danger">' + (data.message || 'Không lấy được dữ liệu!') + '</div>';
                    return;
                }
                if (data.length === 0) {
                    orderHistoryList.innerHTML = '<div class="alert alert-info"><i class="fas fa-info-circle me-2"></i>Bạn chưa có đơn hàng nào. <a href="/" class="alert-link">Khám phá sản phẩm ngay!</a></div>';
                    return;
                }
                let html = '<div class="table-responsive"><table class="table table-bordered align-middle order-table"><thead class="table-light"><tr>' +
                    '<th>Hình ảnh</th><th>Mã đơn</th><th>Tên sản phẩm</th><th>Ngày đặt</th><th>Trạng thái</th><th>Tổng tiền</th><th>Hành động</th></tr></thead><tbody>';
                data.forEach(order => {
                    const product = order.firstProduct || {};
                    html += '<tr>' +
                        '<td style="width:70px">' + (product.image ? '<img src="' + product.image + '" alt="Ảnh" style="max-width:60px;max-height:60px;object-fit:cover;">' : '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td class="fw-bold">' + order.orderNumber + '</td>' +
                        '<td>' + (product.name || '<span class="text-muted">Không có</span>') + '</td>' +
                        '<td>' + (order.orderDate ? new Date(order.orderDate).toLocaleString('vi-VN') : '') + '</td>' +
                        '<td>' + renderStatus(order.status) + '</td>' +
                        '<td class="text-danger fw-bold">' + formatCurrency(order.totalAmount) + '₫</td>' +
                        '<td>' + renderCancelBtn(order) + '</td>' +
                        '</tr>';
                });
                html += '</tbody></table></div>';
                orderHistoryList.innerHTML = html;
            } catch (e) {
                orderHistoryList.innerHTML = '<div class="text-danger">Lỗi tải dữ liệu!</div>';
            }
        }

        function formatCurrency(num) {
            if (!num) return '0';
            return Number(num).toLocaleString('vi-VN');
        }

        function renderStatus(status) {
            return '<span class="order-status ' + status + '">' + status + '</span>';
        }

        function renderCancelBtn(order) {
            if (["PENDING", "CONFIRMED", "PROCESSING"].includes(order.status)) {
                return '<button class="btn btn-danger btn-sm" onclick="cancelOrder(' + order.id + ', this)"><i class="fas fa-trash-alt me-1"></i>Hủy đơn</button>';
            } else if (order.status === "DELIVERED") {
                return '<button class="btn btn-warning btn-sm" onclick="sendComplaint(' + order.id + ', this)"><i class="fas fa-exclamation-circle me-1"></i>Gửi khiếu nại</button>';
            }
            return '';
        }

        window.cancelOrder = async function (orderId, btn) {
            if (!confirm('Bạn chắc chắn muốn xóa/hủy đơn hàng này?')) return;
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xóa...';
            try {
                const resp = await fetch('/api/orders/' + orderId + '/cancel', { method: 'POST' });
                const data = await resp.json();
                if (data.success) {
                    btn.closest('tr').remove();
                    alert('Đã xóa/hủy đơn hàng thành công!');
                } else {
                    alert(data.message || 'Không thể xóa!');
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
                }
            } catch (e) {
                alert('Lỗi kết nối máy chủ!');
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-trash-alt me-1"></i>Hủy đơn';
            }
        }

        window.sendComplaint = function (orderId) {
            document.getElementById('complaintOrderId').value = orderId;
            document.getElementById('complaintForm').reset();
            const modal = new bootstrap.Modal(document.getElementById('complaintModal'));
            modal.show();
        };

        // Handle complaint form submission
        document.addEventListener('submit', async function(e) {
            if (e.target && e.target.id === 'complaintForm') {
                e.preventDefault();
                const orderId = document.getElementById('complaintOrderId').value;
                const category = document.getElementById('complaintCategory').value.trim();
                const content = document.getElementById('complaintContent').value.trim();

                if (!content) {
                    alert('Vui lòng nhập nội dung khiếu nại!');
                    return;
                }

                try {
                    const resp = await fetch('/api/complaints/create', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ orderId, category, content })
                    });
                    const data = await resp.json();
                    if (data.success) {
                        alert('Gửi khiếu nại thành công!');
                        bootstrap.Modal.getInstance(document.getElementById('complaintModal')).hide();
                    } else {
                        alert(data.message || 'Gửi khiếu nại thất bại!');
                    }
                } catch (err) {
                    alert('Lỗi kết nối máy chủ!');
                }
            }
        });
    </script>
    
    <!-- Force check auth state after page load -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Force check auth state multiple times to ensure sync
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 100);
            
            setTimeout(() => {
                if (window.authSyncManager) {
                    window.authSyncManager.forceRefresh();
                }
            }, 500);
        });
    </script>
</body>
</html>






