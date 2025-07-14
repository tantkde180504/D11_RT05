/**
 * Chat Widget JavaScript Functions
 * Separated from JSP to avoid JavaScript execution issues
 */

// Global variables for chat widget
let chatWidgetStompClient = null;
let widgetCurrentUserId = null;
let widgetCurrentUserType = null;
let widgetStaffId = null;
let isChatWidgetOpen = false;
let unreadCount = 0;

// Khởi tạo chat widget
function initChatWidget(userId, userType) {
    console.log('🚀 Initializing chat widget for user:', userId, userType);
    widgetCurrentUserId = userId;
    widgetCurrentUserType = userType;
    
    // Chỉ hiển thị cho customer
    if (userType === 'CUSTOMER') {
        const chatWidget = document.getElementById('chat-widget');
        if (chatWidget) {
            chatWidget.style.display = 'block';
            console.log('✅ Chat widget shown');
            connectChatWidget();
        } else {
            console.error('❌ Chat widget element not found');
        }
    }
}

// Kết nối WebSocket cho widget
function connectChatWidget() {
    console.log('🔌 Connecting chat widget WebSocket...');
    
    const statusElement = document.getElementById('connection-status');
    if (statusElement) {
        statusElement.textContent = 'Đang kết nối...';
        statusElement.className = 'connecting';
    }
    
    const socket = new SockJS('/ws-chat');
    chatWidgetStompClient = Stomp.over(socket);
    
    chatWidgetStompClient.connect({}, function(frame) {
        console.log('✅ Chat widget connected: ' + frame);
        
        // Subscribe để nhận tin nhắn
        chatWidgetStompClient.subscribe('/user/' + widgetCurrentUserId + '/queue/messages', function(message) {
            const messageData = JSON.parse(message.body);
            displayWidgetMessage(messageData);
            
            if (!isChatWidgetOpen) {
                updateUnreadCount();
            }
        });
        
        // Cập nhật trạng thái kết nối
        if (statusElement) {
            statusElement.textContent = 'Đã kết nối';
            statusElement.className = 'connected';
        }
        
        // Enable input
        const input = document.getElementById('chat-widget-input');
        const sendBtn = document.getElementById('chat-widget-send');
        if (input) input.disabled = false;
        if (sendBtn) sendBtn.disabled = false;
        
        // Tự động assign staff nếu chưa có
        getAssignedStaff();
        
    }, function(error) {
        console.error('❌ Chat widget connection error:', error);
        if (statusElement) {
            statusElement.textContent = 'Mất kết nối';
            statusElement.className = 'disconnected';
        }
    });
}

// Lấy staff được assign
function getAssignedStaff() {
    console.log('👥 Getting assigned staff for user:', widgetCurrentUserId);
    
    fetch('/api/chat/assigned-staff/' + widgetCurrentUserId)
        .then(response => response.json())
        .then(staffId => {
            if (staffId) {
                widgetStaffId = staffId;
                console.log('✅ Staff assigned:', staffId);
                loadChatHistory();
            } else {
                // Auto assign staff đầu tiên có sẵn
                autoAssignStaff();
            }
        })
        .catch(error => {
            console.error('❌ Error getting assigned staff:', error);
            autoAssignStaff();
        });
}

// Tự động assign staff
function autoAssignStaff() {
    console.log('🤖 Auto-assigning staff...');
    // Assign staff có ID = 2 (Staff User)
    widgetStaffId = 2;
    console.log('✅ Staff auto-assigned:', widgetStaffId);
    // Không cần tạo assignment ngay, sẽ tạo khi gửi tin nhắn đầu tiên
}

// Load lịch sử chat
function loadChatHistory() {
    console.log('📜 Loading chat history...');
    
    if (widgetStaffId) {
        fetch('/api/chat/messages?userId1=' + widgetCurrentUserId + '&userId2=' + widgetStaffId)
            .then(response => response.json())
            .then(messages => {
                console.log('✅ Chat history loaded:', messages.length, 'messages');
                const messagesContainer = document.getElementById('chat-widget-messages');
                
                messages.forEach(message => {
                    displayWidgetMessage(message, false);
                });
                
                scrollToBottom();
            })
            .catch(error => {
                console.error('❌ Error loading chat history:', error);
            });
    }
}

// Hiển thị tin nhắn trong widget
function displayWidgetMessage(message, isNew = true) {
    const messagesContainer = document.getElementById('chat-widget-messages');
    if (!messagesContainer) {
        console.error('❌ Messages container not found');
        return;
    }
    
    const messageDiv = document.createElement('div');
    const isSent = message.senderId == widgetCurrentUserId;
    messageDiv.className = 'widget-message ' + (isSent ? 'sent' : 'received');
    
    const avatar = isSent ? '' : `
        <div class="staff-avatar">
            <i class="fas fa-user-tie"></i>
        </div>
    `;
    
    messageDiv.innerHTML = 
        avatar +
        '<div>' +
            '<div class="message-bubble">' +
                message.message +
            '</div>' +
            '<div class="message-time">' +
                new Date(message.timestamp).toLocaleTimeString() +
            '</div>' +
        '</div>';
    
    messagesContainer.appendChild(messageDiv);
    
    if (isNew) {
        scrollToBottom();
    }
}

// Gửi tin nhắn từ widget
function sendWidgetMessage() {
    console.log('📤 Sending widget message...');
    
    const input = document.getElementById('chat-widget-input');
    if (!input) {
        console.error('❌ Chat input not found');
        return;
    }
    
    const message = input.value.trim();
    
    if (message && chatWidgetStompClient && widgetStaffId) {
        const messageData = {
            senderId: widgetCurrentUserId,
            receiverId: widgetStaffId,
            message: message,
            senderType: 'CUSTOMER',
            receiverType: 'STAFF'
        };
        
        console.log('📤 Sending message:', messageData);
        chatWidgetStompClient.send("/app/chat.sendMessage", {}, JSON.stringify(messageData));
        input.value = '';
    } else {
        console.warn('⚠️ Cannot send message - missing data:', {
            message: !!message,
            stompClient: !!chatWidgetStompClient,
            staffId: !!widgetStaffId
        });
    }
}

// Toggle chat widget
function toggleChatWidget() {
    console.log('🔄 Toggling chat widget...');
    
    const window = document.getElementById('chat-widget-window');
    if (!window) {
        console.error('❌ Chat widget window not found');
        return;
    }
    
    if (window.style.display === 'none' || window.style.display === '') {
        window.style.display = 'block';
        isChatWidgetOpen = true;
        resetUnreadCount();
        scrollToBottom();
        console.log('✅ Chat widget opened');
    } else {
        window.style.display = 'none';
        isChatWidgetOpen = false;
        console.log('✅ Chat widget closed');
    }
}

// Minimize chat widget
function minimizeChatWidget() {
    console.log('➖ Minimizing chat widget...');
    const window = document.getElementById('chat-widget-window');
    if (window) {
        window.style.display = 'none';
        isChatWidgetOpen = false;
    }
}

// Close chat widget
function closeChatWidget() {
    console.log('❌ Closing chat widget...');
    const window = document.getElementById('chat-widget-window');
    if (window) {
        window.style.display = 'none';
        isChatWidgetOpen = false;
    }
}

// Cập nhật số tin nhắn chưa đọc
function updateUnreadCount() {
    unreadCount++;
    const badge = document.getElementById('unread-badge');
    if (badge) {
        badge.textContent = unreadCount;
        badge.style.display = 'block';
    }
}

// Reset số tin nhắn chưa đọc
function resetUnreadCount() {
    unreadCount = 0;
    const badge = document.getElementById('unread-badge');
    if (badge) {
        badge.style.display = 'none';
    }
}

// Scroll to bottom
function scrollToBottom() {
    const messagesContainer = document.getElementById('chat-widget-messages');
    if (messagesContainer) {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }
}

// Initialize event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎯 Chat widget DOM loaded, setting up event listeners...');
    
    // Enter để gửi tin nhắn
    const input = document.getElementById('chat-widget-input');
    if (input) {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendWidgetMessage();
            }
        });
        console.log('✅ Chat input event listener added');
    }
});

console.log('📦 Chat widget JavaScript loaded');
