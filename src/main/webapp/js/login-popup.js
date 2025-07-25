// Login Success Popup Manager
class LoginPopupManager {
    constructor() {
        this.currentPopup = null;
        this.autoCloseTimer = null;
        this.countdownTimer = null;
        this.countdownSeconds = 3;
    }

    showSuccessPopup(userData) {
        // Remove any existing popup
        this.hidePopup();

        // Create popup HTML
        const popupHTML = `
            <div class="login-popup-overlay" id="loginPopupOverlay">
                <div class="login-popup">
                    <div class="login-popup-countdown" id="loginCountdown">
                        Tự động chuyển trang sau ${this.countdownSeconds}s
                    </div>
                    
                    <div class="login-popup-icon">
                        <i class="fas fa-check"></i>
                    </div>
                    
                    <div class="login-popup-title">
                        🎉 Đăng nhập thành công!
                    </div>
                    
                    <div class="login-popup-message">
                        Chào mừng bạn quay trở lại
                    </div>
                    
                    <div class="login-popup-user">
                        ${userData.fullName || userData.name || 'Người dùng'}
                    </div>
                    
                    <button class="login-popup-close" id="loginPopupClose">
                        <i class="fas fa-arrow-right me-2"></i>
                        Tiếp tục mua sắm
                    </button>
                </div>
            </div>
        `;

        // Add popup to body
        document.body.insertAdjacentHTML('beforeend', popupHTML);
        this.currentPopup = document.getElementById('loginPopupOverlay');

        // Add event listeners
        this.setupEventListeners();

        // Start countdown
        this.startCountdown();

        // Prevent body scroll
        document.body.style.overflow = 'hidden';

        console.log('✅ Login success popup displayed for:', userData.fullName || userData.name);
    }

    setupEventListeners() {
        const closeBtn = document.getElementById('loginPopupClose');
        const overlay = document.getElementById('loginPopupOverlay');

        // Close button click
        closeBtn?.addEventListener('click', () => {
            this.hidePopup();
            this.proceedToRedirect();
        });

        // Click outside popup to close
        overlay?.addEventListener('click', (e) => {
            if (e.target === overlay) {
                this.hidePopup();
                this.proceedToRedirect();
            }
        });

        // Escape key to close
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.currentPopup) {
                this.hidePopup();
                this.proceedToRedirect();
            }
        });
    }

    startCountdown() {
        const countdownElement = document.getElementById('loginCountdown');
        let seconds = this.countdownSeconds;

        this.countdownTimer = setInterval(() => {
            seconds--;
            if (countdownElement) {
                if (seconds > 0) {
                    countdownElement.textContent = `Tự động chuyển trang sau ${seconds}s`;
                } else {
                    countdownElement.textContent = 'Đang chuyển trang...';
                }
            }

            if (seconds <= 0) {
                clearInterval(this.countdownTimer);
                this.hidePopup();
                this.proceedToRedirect();
            }
        }, 1000);
    }

    hidePopup() {
        // Clear timers
        if (this.autoCloseTimer) {
            clearTimeout(this.autoCloseTimer);
            this.autoCloseTimer = null;
        }
        if (this.countdownTimer) {
            clearInterval(this.countdownTimer);
            this.countdownTimer = null;
        }

        // Remove popup with animation
        if (this.currentPopup) {
            this.currentPopup.style.animation = 'fadeOutOverlay 0.3s ease-out forwards';
            
            setTimeout(() => {
                if (this.currentPopup && this.currentPopup.parentNode) {
                    this.currentPopup.parentNode.removeChild(this.currentPopup);
                }
                this.currentPopup = null;

                // Restore body scroll
                document.body.style.overflow = '';
            }, 300);
        }
    }

    proceedToRedirect() {
        console.log('🔄 Proceeding to redirect after popup close...');
        
        // Get redirect URL from stored data or use default
        const storedUser = localStorage.getItem('currentUser');
        let redirectUrl = window.APP_CONTEXT_PATH || '';

        if (storedUser) {
            const userData = JSON.parse(storedUser);
            // Determine redirect based on role
            switch(userData.role) {
                case 'ADMIN':
                    redirectUrl += '/admin.jsp';
                    break;
                case 'STAFF':
                    redirectUrl += '/dashboard.jsp';
                    break;
                default:
                    redirectUrl += '/index.jsp';
            }
        } else {
            redirectUrl += '/index.jsp';
        }

        console.log('🚀 Redirecting to:', redirectUrl);
        window.location.href = redirectUrl;
    }
}

// Create global instance
window.loginPopupManager = new LoginPopupManager();

// Additional CSS animation for fade out
const additionalCSS = `
@keyframes fadeOutOverlay {
    from {
        opacity: 1;
    }
    to {
        opacity: 0;
    }
}
`;

// Add additional CSS to head
const style = document.createElement('style');
style.textContent = additionalCSS;
document.head.appendChild(style);

console.log('✅ Login Popup Manager initialized');
