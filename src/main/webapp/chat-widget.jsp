<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Chat Widget cho Customer (hiển thị ở góc dưới phải) -->
<div id="chat-widget" class="chat-widget" style="display: block;">
    <!-- Chat Widget Button -->
    <div id="chat-widget-button" class="chat-widget-button" onclick="toggleChatWidget()">
        <i class="fas fa-comments"></i>
        <span id="unread-badge" class="unread-badge" style="display: none;">0</span>
    </div>
    
    <!-- Chat Widget Window -->
    <div id="chat-widget-window" class="chat-widget-window" style="display: none;">
        <!-- Header -->
        <div class="chat-widget-header">
            <div class="chat-widget-title">
                <i class="fas fa-headset"></i>
                <span>Hỗ trợ khách hàng</span>
            </div>
            <div class="chat-widget-controls">
                <button onclick="minimizeChatWidget()" class="chat-control-btn" title="Thu nhỏ">
                    <i class="fas fa-minus"></i>
                </button>
                <button onclick="closeChatWidget()" class="chat-control-btn" title="Đóng">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
        
        <!-- Messages -->
        <div id="chat-widget-messages" class="chat-widget-messages">
            <div class="welcome-message">
                <div class="staff-avatar">
                    <i class="fas fa-user-tie"></i>
                </div>
                <div class="welcome-text">
                    <h6>Chào mừng bạn!</h6>
                    <p>Chúng tôi có thể giúp gì cho bạn?</p>
                </div>
            </div>
        </div>
        
        <!-- Input -->
        <div class="chat-widget-input">
            <div class="input-container">
                <input type="text" id="chat-widget-input" placeholder="Nhập tin nhắn..." disabled>
                <button id="chat-widget-send" onclick="sendWidgetMessage()" disabled title="Gửi tin nhắn">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
            <div class="chat-status">
                <span id="connection-status">Đang kết nối...</span>
            </div>
        </div>
    </div>
</div>

<style>
/* Đảm bảo font render đúng cho tiếng Việt */
* {
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

.chat-widget {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 9999;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
    font-feature-settings: normal;
    font-variant-ligatures: normal;
}

.chat-widget-button {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #007bff, #0056b3);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
    transition: all 0.3s ease;
    position: relative;
}

.chat-widget-button:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
}

.chat-widget-button i {
    color: white;
    font-size: 24px;
}

.unread-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #dc3545;
    color: white;
    border-radius: 50%;
    width: 20px;
    height: 20px;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
}

.chat-widget-window {
    width: 350px;
    height: 500px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
    display: flex;
    flex-direction: column;
    margin-bottom: 10px;
    overflow: hidden;
    animation: slideUp 0.3s ease;
    font-family: inherit;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.chat-widget-header {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-family: inherit;
}

.chat-widget-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 600;
    font-family: inherit;
    font-size: 14px;
}

.chat-widget-controls {
    display: flex;
    gap: 5px;
}

.chat-control-btn {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

.chat-control-btn:hover {
    background: rgba(255, 255, 255, 0.3);
}

.chat-widget-messages {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
    overflow-x: hidden;
    background: #f8f9fa;
    max-height: 350px;
    min-height: 200px;
    scroll-behavior: smooth;
}

/* Custom scrollbar cho chat widget */
.chat-widget-messages::-webkit-scrollbar {
    width: 6px;
}

.chat-widget-messages::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 3px;
}

.chat-widget-messages::-webkit-scrollbar-thumb {
    background: #c1c1c1;
    border-radius: 3px;
}

.chat-widget-messages::-webkit-scrollbar-thumb:hover {
    background: #a8a8a8;
}

.welcome-message {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 15px;
}

.staff-avatar {
    width: 40px;
    height: 40px;
    background: #007bff;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    flex-shrink: 0;
}

.welcome-text h6 {
    margin: 0 0 5px 0;
    color: #333;
    font-size: 14px;
    font-weight: 600;
    font-family: inherit;
    text-rendering: optimizeLegibility;
}

.welcome-text p {
    margin: 0;
    color: #666;
    font-size: 13px;
    font-family: inherit;
    text-rendering: optimizeLegibility;
    line-height: 1.4;
}

.widget-message {
    margin-bottom: 15px;
    display: flex;
    gap: 10px;
    font-family: inherit;
}

.widget-message.sent {
    flex-direction: row-reverse;
}

.widget-message.sent .message-bubble {
    background: #007bff;
    color: white;
    border-radius: 18px 18px 4px 18px;
}

.widget-message.received .message-bubble {
    background: white;
    color: #333;
    border: 1px solid #e0e0e0;
    border-radius: 18px 18px 18px 4px;
}

.message-bubble {
    max-width: 80%;
    padding: 10px 15px;
    word-wrap: break-word;
    word-break: break-word;
    overflow-wrap: break-word;
    font-size: 14px;
    line-height: 1.4;
    font-family: inherit;
    text-rendering: optimizeLegibility;
    white-space: pre-wrap;
}

.message-time {
    font-size: 11px;
    color: #999;
    margin-top: 5px;
    text-align: center;
    font-family: inherit;
}

.chat-widget-input {
    padding: 15px;
    border-top: 1px solid #e0e0e0;
    background: white;
}

.input-container {
    display: flex;
    gap: 10px;
    align-items: center;
}

#chat-widget-input {
    flex: 1;
    border: 1px solid #ddd;
    border-radius: 20px;
    padding: 10px 15px;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s ease;
    font-family: inherit;
    background: white;
    color: #333;
}

#chat-widget-input:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.1);
}

#chat-widget-input::placeholder {
    color: #999;
    font-family: inherit;
}

#chat-widget-send {
    width: 40px;
    height: 40px;
    background: #007bff;
    border: none;
    border-radius: 50%;
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
}

#chat-widget-send:hover {
    background: #0056b3;
    transform: scale(1.05);
}

#chat-widget-send:disabled {
    background: #ccc;
    cursor: not-allowed;
    transform: none;
}

.chat-status {
    text-align: center;
    margin-top: 8px;
}

#connection-status {
    font-size: 12px;
    color: #666;
    font-family: inherit;
    font-weight: 500;
}

#connection-status.connected {
    color: #28a745;
}

#connection-status.connecting {
    color: #ffc107;
}

#connection-status.disconnected {
    color: #dc3545;
}

/* Mobile responsive */
@media (max-width: 768px) {
    .chat-widget {
        bottom: 10px;
        right: 10px;
    }
    
    .chat-widget-window {
        width: 300px;
        height: 450px;
    }
}
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>
let chatWidgetStompClient = null;
let widgetCurrentUserId = null;
let widgetCurrentUserType = null;
let widgetStaffId = null;
let isChatWidgetOpen = false;
let unreadCount = 0;

// Khởi tạo chat widget
function initChatWidget(userId, userType) {
    console.log('🚀 Initializing chat widget:', { userId, userType });
    widgetCurrentUserId = userId;
    widgetCurrentUserType = userType;
    
    // Hiển thị cho tất cả user (không chỉ customer)
    document.getElementById('chat-widget').style.display = 'block';
    
    // Kết nối WebSocket
    connectChatWidget();
}

// Kết nối WebSocket cho widget
function connectChatWidget() {
    console.log('🔌 Connecting chat widget WebSocket for user:', widgetCurrentUserId);
    document.getElementById('connection-status').textContent = 'Đang kết nối...';
    document.getElementById('connection-status').className = 'connecting';
    
    const socket = new SockJS('/ws-chat');
    chatWidgetStompClient = Stomp.over(socket);
    
    chatWidgetStompClient.connect({}, function(frame) {
        console.log('✅ Chat widget connected:', frame);
        
        // Subscribe để nhận tin nhắn
        const subscriptionUrl = '/user/' + widgetCurrentUserId + '/queue/messages';
        console.log('📡 Widget subscribing to:', subscriptionUrl);
        
        chatWidgetStompClient.subscribe(subscriptionUrl, function(message) {
            console.log('📩 Widget received message:', message.body);
            const messageData = JSON.parse(message.body);
            displayWidgetMessage(messageData);
            
            if (!isChatWidgetOpen) {
                updateUnreadCount();
            }
        });
        
        // Cập nhật trạng thái kết nối
        document.getElementById('connection-status').textContent = 'Đã kết nối';
        document.getElementById('connection-status').className = 'connected';
        
        // Enable input
        document.getElementById('chat-widget-input').disabled = false;
        document.getElementById('chat-widget-send').disabled = false;
        
        // Tự động assign staff nếu chưa có
        // Không cần assignment nữa - bất kỳ staff nào cũng có thể phản hồi
        loadAllChatHistory();
        
    }, function(error) {
        console.error('Chat widget connection error:', error);
        document.getElementById('connection-status').textContent = 'Mất kết nối';
        document.getElementById('connection-status').className = 'disconnected';
    });
}

// Lấy staff được assign
function getAssignedStaff() {
    console.log('🔍 Finding assigned staff for customer:', widgetCurrentUserId);
    fetch('/api/chat/assigned-staff/' + widgetCurrentUserId)
        .then(response => response.json())
        .then(staffId => {
            console.log('👥 Assigned staff response:', staffId);
            if (staffId) {
                widgetStaffId = staffId;
                console.log('✅ Staff assigned:', staffId);
                loadChatHistory();
            } else {
                console.log('❌ No staff assigned, auto-assigning...');
                // Auto assign staff đầu tiên có sẵn
                autoAssignStaff();
            }
        })
        .catch(error => {
            console.error('❌ Error finding assigned staff:', error);
            autoAssignStaff();
        });
}

// Tự động assign staff
function autoAssignStaff() {
    console.log('🎯 Auto-assigning staff for customer:', widgetCurrentUserId);
    // Assign staff có ID = 8 (Staff Member từ database assignments)
    widgetStaffId = 8;
    console.log('✅ Auto-assigned to Staff Member (ID: 8)');
    loadChatHistory();
    // Không cần tạo assignment ngay, sẽ tạo khi gửi tin nhắn đầu tiên
}

// Load tất cả lịch sử chat của customer với bất kỳ staff nào
function loadAllChatHistory() {
    console.log('📚 Loading all chat history for customer:', widgetCurrentUserId);
    fetch('/api/chat/customer-messages/' + widgetCurrentUserId)
        .then(response => response.json())
        .then(messages => {
            console.log('📝 Chat history loaded:', messages.length, 'messages');
            const messagesContainer = document.getElementById('chat-widget-messages');
            
            // Clear existing messages (except welcome message)
            const welcomeMessage = messagesContainer.querySelector('.welcome-message');
            messagesContainer.innerHTML = '';
            if (welcomeMessage) {
                messagesContainer.appendChild(welcomeMessage);
            }

            if (messages && messages.length > 0) {
                messages.forEach(message => {
                    displayWidgetMessage(message, false);
                });
            } else {
                // Nếu không có tin nhắn, thêm một số tin nhắn mẫu để test scroll
                addSampleMessages();
            }
            
            scrollToBottom();
        })
        .catch(error => {
            console.error('❌ Error loading chat history:', error);
            // Thêm tin nhắn mẫu nếu load lỗi
            addSampleMessages();
        });
}

// Thêm tin nhắn mẫu để test scroll (temporary function)
function addSampleMessages() {
    const currentTime = new Date();
    const sampleMessages = [
        { 
            senderId: 8, 
            message: "Xin chào! Chúng tôi có thể hỗ trợ gì cho bạn hôm nay?", 
            timestamp: new Date(currentTime.getTime() - 300000) 
        },
        { 
            senderId: widgetCurrentUserId, 
            message: "Tôi muốn tìm hiểu về các dòng sản phẩm Gundam", 
            timestamp: new Date(currentTime.getTime() - 280000) 
        },
        { 
            senderId: 8, 
            message: "Tuyệt vời! Chúng tôi có nhiều dòng sản phẩm: High Grade (HG), Master Grade (MG), Real Grade (RG) và Perfect Grade (PG). Bạn quan tâm đến dòng nào?", 
            timestamp: new Date(currentTime.getTime() - 260000) 
        },
        { 
            senderId: widgetCurrentUserId, 
            message: "Tôi mới bắt đầu, bạn có thể tư vấn dòng phù hợp không?", 
            timestamp: new Date(currentTime.getTime() - 240000) 
        },
        { 
            senderId: 8, 
            message: "Với người mới bắt đầu, tôi khuyên bạn nên chọn dòng HG (High Grade) vì dễ lắp ráp, giá cả phù hợp và chất lượng tốt.", 
            timestamp: new Date(currentTime.getTime() - 220000) 
        },
        { 
            senderId: widgetCurrentUserId, 
            message: "Nghe hay đấy! Có mẫu nào bạn gợi ý không?", 
            timestamp: new Date(currentTime.getTime() - 200000) 
        },
        { 
            senderId: 8, 
            message: "HG RX-78-2 Gundam là lựa chọn tuyệt vời cho người mới. Đây là mẫu kinh điển và rất dễ lắp ráp!", 
            timestamp: new Date(currentTime.getTime() - 180000) 
        },
        { 
            senderId: widgetCurrentUserId, 
            message: "Giá thành như thế nào ạ?", 
            timestamp: new Date(currentTime.getTime() - 160000) 
        },
        { 
            senderId: 8, 
            message: "Hiện tại giá khoảng 350.000 VNĐ. Bạn có muốn xem thông tin chi tiết không?", 
            timestamp: new Date(currentTime.getTime() - 140000) 
        },
        { 
            senderId: widgetCurrentUserId, 
            message: "Có! Bạn có thể gửi link sản phẩm cho tôi được không?", 
            timestamp: new Date(currentTime.getTime() - 120000) 
        }
    ];

    sampleMessages.forEach(msg => {
        displayWidgetMessage(msg, false);
    });
}

// Hiển thị tin nhắn trong widget
function displayWidgetMessage(message, isNew = true) {
    const messagesContainer = document.getElementById('chat-widget-messages');
    const messageDiv = document.createElement('div');
    
    const isSent = message.senderId == widgetCurrentUserId;
    messageDiv.className = 'widget-message ' + (isSent ? 'sent' : 'received');
    
    const avatar = isSent ? '' : `
        <div class="staff-avatar">
            <i class="fas fa-user-tie"></i>
        </div>
    `;
    
    // Escape HTML và xử lý text properly
    const messageText = escapeHtml(message.message);
    const formattedTime = new Date(message.timestamp).toLocaleTimeString('vi-VN', {
        hour: '2-digit',
        minute: '2-digit'
    });
    
    messageDiv.innerHTML = 
        avatar +
        '<div>' +
            '<div class="message-bubble">' +
                messageText +
            '</div>' +
            '<div class="message-time">' +
                formattedTime +
            '</div>' +
        '</div>';
    
    messagesContainer.appendChild(messageDiv);
    
    if (isNew) {
        scrollToBottom();
    }
}

// Helper function để escape HTML
function escapeHtml(unsafe) {
    if (!unsafe) return '';
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

// Gửi tin nhắn từ widget
function sendWidgetMessage() {
    const input = document.getElementById('chat-widget-input');
    const message = input.value.trim();
    
    console.log('📤 Sending widget message:', {
        message,
        fromUserId: widgetCurrentUserId,
        hasStompClient: !!chatWidgetStompClient
    });
    
    if (message && chatWidgetStompClient) {
        // Gửi tin nhắn broadcast cho tất cả staff
        const messageData = {
            senderId: widgetCurrentUserId,
            receiverId: null, // Không cần receiverId cụ thể
            message: message,
            senderType: 'CUSTOMER',
            receiverType: 'STAFF'
        };

        console.log('📤 Broadcasting message to all staff:', messageData);
        chatWidgetStompClient.send("/app/chat.sendMessage", {}, JSON.stringify(messageData));
        input.value = '';

        // Hiển thị tin nhắn vừa gửi lên UI ngay lập tức
        displayWidgetMessage({
            senderId: widgetCurrentUserId,
            message: message,
            timestamp: new Date()
        }, true);
    } else {
        console.log('❌ Cannot send message - missing:', {
            message: !!message,
            stompClient: !!chatWidgetStompClient
        });
    }
}

// Toggle chat widget
function toggleChatWidget() {
    const window = document.getElementById('chat-widget-window');
    if (window.style.display === 'none' || window.style.display === '') {
        window.style.display = 'block';
        isChatWidgetOpen = true;
        resetUnreadCount();
        scrollToBottom();
    } else {
        window.style.display = 'none';
        isChatWidgetOpen = false;
    }
}

// Minimize chat widget
function minimizeChatWidget() {
    document.getElementById('chat-widget-window').style.display = 'none';
    isChatWidgetOpen = false;
}

// Close chat widget
function closeChatWidget() {
    document.getElementById('chat-widget-window').style.display = 'none';
    isChatWidgetOpen = false;
}

// Cập nhật số tin nhắn chưa đọc
function updateUnreadCount() {
    unreadCount++;
    const badge = document.getElementById('unread-badge');
    badge.textContent = unreadCount;
    badge.style.display = 'block';
}

// Reset số tin nhắn chưa đọc
function resetUnreadCount() {
    unreadCount = 0;
    document.getElementById('unread-badge').style.display = 'none';
}

// Load lịch sử chat cho widget
function loadWidgetChatHistory() {
    if (!widgetCurrentUserId) {
        console.log('⚠️ No user ID for chat history');
        return;
    }

    console.log('📚 Loading chat history for widget...');
    
    fetch('/api/chat/customer-messages/' + widgetCurrentUserId)
        .then(response => response.json())
        .then(messages => {
            const messagesContainer = document.getElementById('chat-widget-messages');
            
            // Giữ welcome message
            const welcomeMessage = messagesContainer.querySelector('.welcome-message');
            messagesContainer.innerHTML = '';
            if (welcomeMessage) {
                messagesContainer.appendChild(welcomeMessage);
            }
            
            console.log('📨 Loaded messages:', messages.length);
            
            if (messages && messages.length > 0) {
                messages.forEach(message => {
                    displayWidgetMessage(message, false);
                });
                
                // Scroll xuống tin nhắn mới nhất
                setTimeout(() => scrollToBottom(), 100);
            }
        })
        .catch(error => {
            console.log('⚠️ Error loading chat history:', error);
        });
}

// Scroll to bottom with smooth animation
function scrollToBottom() {
    const messagesContainer = document.getElementById('chat-widget-messages');
    setTimeout(() => {
        messagesContainer.scrollTo({
            top: messagesContainer.scrollHeight,
            behavior: 'smooth'
        });
    }, 50);
}

// Enter để gửi tin nhắn
document.addEventListener('DOMContentLoaded', function() {
    const input = document.getElementById('chat-widget-input');
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendWidgetMessage();
            }
        });
    }
    
    // Lấy thông tin user thật từ API thay vì hardcode
    console.log('🔍 Getting user info from API for chat initialization...');
    
    setTimeout(() => {
        fetch('/api/user-info')
            .then(response => response.json())
            .then(data => {
                console.log('👤 User info received:', data);
                
                if (data.isLoggedIn && data.userId) {
                    console.log('✅ User authenticated, initializing chat with ID:', data.userId);
                    initChatWidget(data.userId, 'CUSTOMER');
                } else {
                    console.log('❌ User not logged in, chat widget disabled');
                }
            })
            .catch(err => {
                console.error('❌ Error getting user info:', err);
                console.log('🔄 Fallback: Using unified navbar manager data...');
                
                // Fallback: check sessionStorage from unified navbar
                const storedUserId = sessionStorage.getItem('userId');
                if (storedUserId && storedUserId !== 'null') {
                    console.log('✅ Using sessionStorage userId:', storedUserId);
                    // Try to parse as number, fallback to email-based lookup
                    const numericUserId = parseInt(storedUserId);
                    if (!isNaN(numericUserId)) {
                        initChatWidget(numericUserId, 'CUSTOMER');
                    } else {
                        // If it's an email, we'd need backend lookup, for now log error
                        console.log('❌ Cannot use email as userId for chat, need numeric ID');
                    }
                } else {
                    console.log('❌ No user info available, chat disabled');
                }
            });
    }, 500);
});
</script>
