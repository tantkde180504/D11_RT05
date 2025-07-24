<!-- Chat Widget HTML Only (No JavaScript) -->
<div id="chat-widget" class="chat-widget" style="display: none;">
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
                <button onclick="minimizeChatWidget()" class="chat-control-btn">
                    <i class="fas fa-minus"></i>
                </button>
                <button onclick="closeChatWidget()" class="chat-control-btn">
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
                <button id="chat-widget-send" onclick="sendWidgetMessage()" disabled>
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
            <div class="chat-status">
                <span id="connection-status">Đang kết nối...</span>
            </div>
        </div>
    </div>
</div>
