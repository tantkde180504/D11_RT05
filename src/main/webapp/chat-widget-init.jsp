<!-- JavaScript để khởi tạo chat widget trên trang customer -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Kiểm tra xem user đã đăng nhập hay chưa
    const userId = sessionStorage.getItem('userId');
    const userType = sessionStorage.getItem('userType');
    
    // Chỉ khởi tạo chat widget cho customer đã đăng nhập
    if (userId && userType === 'CUSTOMER') {
        // Include chat widget
        fetch('/chat-widget.jsp')
            .then(response => response.text())
            .then(html => {
                document.body.insertAdjacentHTML('beforeend', html);
                
                // Khởi tạo chat widget
                if (typeof initChatWidget === 'function') {
                    initChatWidget(parseInt(userId), userType);
                }
            })
            .catch(error => {
                console.error('Error loading chat widget:', error);
            });
    }
});
</script>
