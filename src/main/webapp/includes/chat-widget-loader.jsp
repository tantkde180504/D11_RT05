<%-- Chat Widget Integration Script --%>
<script>
// Chỉ thêm chat widget nếu trang không có script này rồi
if (!window.chatWidgetLoaded) {
    window.chatWidgetLoaded = true;
    
    document.addEventListener('DOMContentLoaded', function() {
        const userId = sessionStorage.getItem('userId');
        const userType = sessionStorage.getItem('userType');
        
        // Chỉ khởi tạo cho customer đã đăng nhập
        if (userId && userType === 'CUSTOMER') {
            // Load chat widget HTML nếu chưa có
            if (!document.getElementById('chat-widget')) {
                fetch('<%=request.getContextPath()%>/chat-widget.jsp')
                    .then(response => response.text())
                    .then(html => {
                        // Tạo container tạm để parse HTML
                        const temp = document.createElement('div');
                        temp.innerHTML = html;
                        
                        // Lấy chat widget content (bỏ qua các script và style tags)
                        const widgetContent = temp.querySelector('#chat-widget').parentElement.innerHTML;
                        
                        // Thêm vào body
                        document.body.insertAdjacentHTML('beforeend', widgetContent);
                        
                        // Khởi tạo chat widget
                        if (typeof initChatWidget === 'function') {
                            initChatWidget(parseInt(userId), userType);
                        }
                    })
                    .catch(error => {
                        console.error('Error loading chat widget:', error);
                    });
            } else {
                // Nếu widget đã có, chỉ cần khởi tạo
                if (typeof initChatWidget === 'function') {
                    initChatWidget(parseInt(userId), userType);
                }
            }
        }
    });
}
</script>
