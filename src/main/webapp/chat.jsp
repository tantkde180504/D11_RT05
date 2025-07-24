<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat Support</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <style>
        .chat-container {
            max-width: 900px;
            margin: 20px auto;
            border: 1px solid #ddd;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .chat-header {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 123, 255, 0.3);
        }
        .chat-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }
        .chat-messages {
            height: 400px;
            overflow-y: auto;
            overflow-x: hidden;
            padding: 15px;
            background: #f9f9f9;
            scroll-behavior: smooth;
        }
        .message {
            margin-bottom: 15px;
            padding: 12px 16px;
            border-radius: 18px;
            max-width: 85%;
            word-wrap: break-word;
            word-break: break-word;
            white-space: pre-wrap;
            line-height: 1.4;
            display: inline-block;
            font-size: 14px;
        }
        .message.sent {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            margin-left: auto;
            text-align: left;
            border-radius: 18px 18px 4px 18px;
            box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
            float: right;
            clear: both;
        }
        .message.received {
            background: white;
            color: #333;
            border: 1px solid #e0e0e0;
            border-radius: 18px 18px 18px 4px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            float: left;
            clear: both;
        }
        .message-info {
            font-size: 11px;
            opacity: 0.7;
            margin-top: 6px;
            text-align: center;
            font-style: italic;
        }
        .chat-messages {
            height: 450px;
            overflow-y: auto;
            overflow-x: hidden;
            padding: 20px;
            background: linear-gradient(to bottom, #f8f9fa, #e9ecef);
            scroll-behavior: smooth;
            display: flex;
            flex-direction: column;
        }
        
        /* Custom scrollbar cho chat messages */
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }
        
        .chat-messages::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        
        .chat-messages::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 4px;
        }
        
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        .chat-messages::after {
            content: "";
            display: table;
            clear: both;
        }
        .chat-input {
            display: flex;
            padding: 20px;
            background: white;
            border-top: 1px solid #e0e0e0;
            gap: 12px;
            align-items: center;
        }
        .chat-input input {
            flex: 1;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 25px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        .chat-input input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
        }
        .chat-input button {
            padding: 12px 24px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            min-width: 80px;
        }
        .chat-input button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
        }
        .chat-input button:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .customer-list {
            width: 250px;
            border-right: 1px solid #ddd;
            background: white;
        }
        .customer-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
        }
        .customer-item:hover {
            background: #f5f5f5;
        }
        .customer-item.active {
            background: #007bff;
            color: white;
        }
        .chat-layout {
            display: flex;
            max-width: 1000px;
            margin: 20px auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
        }
        .unread-count {
            background: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 0.8em;
            margin-left: 5px;
        }
        
        /* Indicator tin nhắn mới */
        .new-message-indicator {
            position: absolute;
            bottom: 80px;
            right: 30px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 16px;
            cursor: pointer;
            font-size: 12px;
            box-shadow: 0 2px 10px rgba(0, 123, 255, 0.3);
            display: none;
            animation: fadeInUp 0.3s ease;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="chat-layout">
        <!-- Danh sách khách hàng (chỉ hiển thị cho staff) -->
        <div class="customer-list" id="customerList" style="display: none;">
            <div style="padding: 15px; background: #f8f9fa; font-weight: bold;">
                Danh sách khách hàng
            </div>
            <div id="customers">
                <!-- Danh sách khách hàng sẽ được load bằng JavaScript -->
            </div>
        </div>
        
        <!-- Khu vực chat -->
        <div class="chat-container" style="flex: 1; margin: 0; border: none; position: relative;">
            <div class="chat-header">
                <h3 id="chatTitle">Chat Support</h3>
            </div>
            <div class="chat-messages" id="chatMessages">
                <!-- Tin nhắn sẽ được hiển thị ở đây -->
            </div>
            <!-- Indicator tin nhắn mới -->
            <button class="new-message-indicator" id="newMessageIndicator" onclick="scrollToBottom()">
                ↓ Tin nhắn mới
            </button>
            <div class="chat-input">
                <input type="text" id="messageInput" placeholder="Nhập tin nhắn..." disabled>
                <button onclick="sendMessage()" id="sendButton" disabled>Gửi</button>
            </div>
        </div>
    </div>

    <script>
        let stompClient = null;
        let currentUserId = <c:choose><c:when test="${sessionScope.userId != null}">${sessionScope.userId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
        let currentUserType = '<c:choose><c:when test="${sessionScope.userType != null}">${sessionScope.userType}</c:when><c:otherwise>CUSTOMER</c:otherwise></c:choose>';
        let selectedReceiverId = null;
        let selectedReceiverType = null;

        // Kiểm tra session hợp lệ
        if (currentUserId === null) {
            alert('Vui lòng đăng nhập để sử dụng chat!');
            window.location.href = '/login';
        }

        // Kết nối WebSocket
        function connect() {
            const socket = new SockJS('/ws-chat');
            stompClient = Stomp.over(socket);
            
            stompClient.connect({}, function(frame) {
                console.log('Kết nối thành công: ' + frame);
                
                // Subscribe để nhận tin nhắn
                stompClient.subscribe('/user/' + currentUserId + '/queue/messages', function(message) {
                    const messageData = JSON.parse(message.body);
                    displayMessage(messageData);
                });
                
                // Subscribe cho customer để nhận tin nhắn broadcast
                if (currentUserType === 'CUSTOMER') {
                    stompClient.subscribe('/topic/customer/' + currentUserId, function(message) {
                        const messageData = JSON.parse(message.body);
                        displayMessage(messageData);
                    });
                }
                
                // Load giao diện theo loại user
                if (currentUserType === 'STAFF') {
                    loadStaffInterface();
                } else {
                    loadCustomerInterface();
                }
            });
        }

        // Load giao diện cho staff
        function loadStaffInterface() {
            document.getElementById('customerList').style.display = 'block';
            loadCustomerList();
        }

        // Load giao diện cho customer
        function loadCustomerInterface() {
            // Customer luôn có thể gửi tin nhắn đến staff (broadcast)
            // Đặt receiverId = 0 để báo hiệu broadcast đến tất cả staff
            selectedReceiverId = 0;
            selectedReceiverType = 'STAFF';
            
            // Enable input ngay lập tức
            document.getElementById('messageInput').disabled = false;
            document.getElementById('sendButton').disabled = false;
            document.getElementById('chatTitle').textContent = 'Chat với nhân viên hỗ trợ';
            
            // Load lịch sử chat của customer này
            loadCustomerChatHistory();
        }

        // Load lịch sử chat cho customer
        function loadCustomerChatHistory() {
            fetch(`/api/chat/customer-messages/${currentUserId}`)
                .then(response => response.json())
                .then(messages => {
                    const chatMessages = document.getElementById('chatMessages');
                    chatMessages.innerHTML = '';
                    
                    if (messages && messages.length > 0) {
                        messages.forEach(message => {
                            displayMessage(message);
                        });
                        // Scroll xuống tin nhắn mới nhất
                        scrollToBottom();
                    } else {
                        chatMessages.innerHTML = '<div style="text-align: center; color: #666; padding: 20px;">Bắt đầu cuộc trò chuyện...</div>';
                    }
                })
                .catch(error => {
                    console.log('Chưa có tin nhắn nào');
                    const chatMessages = document.getElementById('chatMessages');
                    chatMessages.innerHTML = '<div style="text-align: center; color: #666; padding: 20px;">Bắt đầu cuộc trò chuyện...</div>';
                });
        }

        // Tự động assign staff cho customer
        function autoAssignStaff() {
            // Logic để assign staff (có thể random hoặc theo quy tắc)
            // Ở đây đơn giản là assign staff có ID = 1
            selectReceiver(1, 'STAFF');
        }

        // Load danh sách khách hàng (cho staff)
        function loadCustomerList() {
            fetch('/api/chat/customers/' + currentUserId)
                .then(response => response.json())
                .then(customers => {
                    const customerDiv = document.getElementById('customers');
                    customerDiv.innerHTML = '';
                    
                    customers.forEach(customerId => {
                        fetch('/api/chat/unread-count?receiverId=' + currentUserId + '&senderId=' + customerId)
                            .then(response => response.json())
                            .then(unreadCount => {
                                const customerItem = document.createElement('div');
                                customerItem.className = 'customer-item';
                                customerItem.innerHTML = `
                                    Khách hàng #${customerId}
                                    ${unreadCount > 0 ? `<span class="unread-count">${unreadCount}</span>` : ''}
                                `;
                                customerItem.onclick = () => selectCustomer(customerId);
                                customerDiv.appendChild(customerItem);
                            });
                    });
                });
        }

        // Chọn khách hàng để chat (cho staff)
        function selectCustomer(customerId) {
            selectReceiver(customerId, 'CUSTOMER');
            
            // Đánh dấu active
            document.querySelectorAll('.customer-item').forEach(item => {
                item.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        // Chọn người nhận tin nhắn
        function selectReceiver(receiverId, receiverType) {
            selectedReceiverId = receiverId;
            selectedReceiverType = receiverType;
            
            // Enable input
            document.getElementById('messageInput').disabled = false;
            document.getElementById('sendButton').disabled = false;
            
            // Update title
            const title = receiverType === 'STAFF' ? 'Chat với nhân viên' : `Chat với khách hàng #${receiverId}`;
            document.getElementById('chatTitle').textContent = title;
            
            // Load lịch sử chat
            loadChatHistory();
            
            // Đánh dấu đã đọc
            if (currentUserType === 'STAFF') {
                markAsRead(receiverId);
            }
        }

        // Load lịch sử chat
        function loadChatHistory() {
            fetch(`/api/chat/messages?userId1=${currentUserId}&userId2=${selectedReceiverId}`)
                .then(response => response.json())
                .then(messages => {
                    const chatMessages = document.getElementById('chatMessages');
                    chatMessages.innerHTML = '';
                    
                    if (messages && messages.length > 0) {
                        messages.forEach(message => {
                            displayMessage(message);
                        });
                        // Scroll xuống tin nhắn mới nhất
                        scrollToBottom();
                    }
                })
                .catch(error => {
                    console.log('Lỗi load lịch sử chat:', error);
                });
        }

        // Hiển thị tin nhắn
        function displayMessage(message) {
            const chatMessages = document.getElementById('chatMessages');
            const messageWrapper = document.createElement('div');
            messageWrapper.style.width = '100%';
            messageWrapper.style.marginBottom = '10px';
            messageWrapper.style.display = 'block';
            
            const messageDiv = document.createElement('div');
            const isSent = message.senderId == currentUserId;
            messageDiv.className = `message ${isSent ? 'sent' : 'received'}`;
            
            // Xử lý tin nhắn để không bị đứt chữ sai chỗ
            const messageText = message.message.replace(/\n/g, '<br>');
            
            messageDiv.innerHTML = `
                <div style="word-break: break-word; overflow-wrap: break-word; hyphens: none;">${messageText}</div>
                <div class="message-info">
                    ${new Date(message.timestamp).toLocaleTimeString('vi-VN', {
                        hour: '2-digit',
                        minute: '2-digit'
                    })}
                    ${isSent && message.isRead ? ' ✓✓' : ''}
                </div>
            `;
            
            messageWrapper.appendChild(messageDiv);
            chatMessages.appendChild(messageWrapper);
            
            // Kiểm tra xem user có đang ở gần bottom không
            const isNearBottom = chatMessages.scrollTop + chatMessages.clientHeight >= chatMessages.scrollHeight - 100;
            
            if (isSent) {
                // Nếu là tin nhắn của mình thì luôn scroll xuống
                scrollToBottom();
            } else if (isNearBottom) {
                // Nếu là tin nhắn từ người khác và user đang ở gần bottom thì scroll xuống
                scrollToBottom();
            } else {
                // Nếu user đang scroll lên trên thì hiển thị indicator
                showNewMessageIndicator();
            }
        }
        
        // Hiển thị indicator tin nhắn mới
        function showNewMessageIndicator() {
            const indicator = document.getElementById('newMessageIndicator');
            indicator.style.display = 'block';
        }
        
        // Ẩn indicator tin nhắn mới
        function hideNewMessageIndicator() {
            const indicator = document.getElementById('newMessageIndicator');
            indicator.style.display = 'none';
        }
        
        // Hàm scroll xuống bottom một cách mượt mà
        function scrollToBottom() {
            const chatMessages = document.getElementById('chatMessages');
            setTimeout(() => {
                chatMessages.scrollTop = chatMessages.scrollHeight;
                hideNewMessageIndicator();
            }, 50);
        }

        // Gửi tin nhắn
        function sendMessage() {
            const messageInput = document.getElementById('messageInput');
            const message = messageInput.value.trim();
            
            if (message) {
                const messageData = {
                    senderId: currentUserId,
                    receiverId: selectedReceiverId || 0, // 0 nghĩa là broadcast đến staff
                    message: message,
                    senderType: currentUserType,
                    receiverType: selectedReceiverType || 'STAFF'
                };
                
                stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(messageData));
                messageInput.value = '';
                
                // Focus lại vào input để tiếp tục gõ
                messageInput.focus();
            }
        }

        // Đánh dấu đã đọc
        function markAsRead(senderId) {
            fetch('/api/chat/mark-read?receiverId=' + currentUserId + '&senderId=' + senderId, {
                method: 'POST'
            });
        }

        // Enter để gửi tin nhắn
        document.getElementById('messageInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });
        
        // Theo dõi scroll để ẩn/hiện indicator
        document.addEventListener('DOMContentLoaded', function() {
            const chatMessages = document.getElementById('chatMessages');
            if (chatMessages) {
                chatMessages.addEventListener('scroll', function() {
                    const isNearBottom = chatMessages.scrollTop + chatMessages.clientHeight >= chatMessages.scrollHeight - 50;
                    if (isNearBottom) {
                        hideNewMessageIndicator();
                    }
                });
            }
        });

        // Kết nối khi trang load
        window.onload = function() {
            connect();
        };
    </script>
</body>
</html>
