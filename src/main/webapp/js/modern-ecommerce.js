// Modern E-commerce JavaScript Features
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎨 Initializing modern e-commerce features...');
    
    initializeModernFeatures();
    
    console.log('✨ Modern features initialized successfully!');
});

// Modern E-commerce Features
function initializeModernFeatures() {
    initializeNewsletter();
    initializeCountdown();
    initializeScrollAnimations();
    initializeParallaxEffect();
    initializeInteractiveElements();
}

// Newsletter Form Enhancement
function initializeNewsletter() {
    const newsletterForm = document.querySelector('.newsletter-form-modern');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const emailInput = document.getElementById('emailInput');
            const nameInput = document.getElementById('nameInput');
            const agreeTerms = document.getElementById('agreeTerms');
            const submitBtn = this.querySelector('.btn-newsletter');
            
            // Validation
            if (!emailInput.value) {
                showNotification('❌ Vui lòng nhập email của bạn!', 'error');
                emailInput.focus();
                return;
            }
            
            if (!agreeTerms.checked) {
                showNotification('❌ Vui lòng đồng ý với điều khoản!', 'error');
                return;
            }
            
            // Show loading
            const originalHTML = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            submitBtn.disabled = true;
            
            // Simulate API call
            setTimeout(() => {
                submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>Đăng ký thành công!';
                submitBtn.classList.remove('btn-newsletter');
                submitBtn.classList.add('btn-success');
                
                showNotification('🎉 Cảm ơn bạn đã đăng ký! Kiểm tra email để nhận mã giảm giá 10%!', 'success');
                
                // Reset form
                setTimeout(() => {
                    emailInput.value = '';
                    nameInput.value = '';
                    agreeTerms.checked = false;
                    submitBtn.innerHTML = originalHTML;
                    submitBtn.classList.add('btn-newsletter');
                    submitBtn.classList.remove('btn-success');
                    submitBtn.disabled = false;
                }, 3000);
            }, 2000);
        });
        
        // Input animations
        const inputs = newsletterForm.querySelectorAll('.form-control');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            input.addEventListener('blur', function() {
                if (!this.value) {
                    this.parentElement.classList.remove('focused');
                }
            });
        });
    }
}

// Countdown Timer for Pre-Order
function initializeCountdown() {
    const countdownElements = document.querySelectorAll('.countdown-display');
    
    countdownElements.forEach(element => {
        const timeUnits = element.querySelectorAll('.time-value');
        if (timeUnits.length >= 2) {
            let days = parseInt(timeUnits[0].textContent);
            let hours = parseInt(timeUnits[1].textContent);
            
            setInterval(() => {
                if (hours > 0) {
                    hours--;
                } else if (days > 0) {
                    days--;
                    hours = 23;
                }
                
                if (timeUnits[0]) timeUnits[0].textContent = days.toString().padStart(2, '0');
                if (timeUnits[1]) timeUnits[1].textContent = hours.toString().padStart(2, '0');
            }, 3600000);
        }
    });
}

// Scroll Animations
function initializeScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                
                if (entry.target.classList.contains('feature-card')) {
                    const icon = entry.target.querySelector('.feature-icon');
                    if (icon) {
                        setTimeout(() => {
                            icon.style.transform = 'scale(1.1) rotate(360deg)';
                            setTimeout(() => {
                                icon.style.transform = 'scale(1)';
                            }, 600);
                        }, 300);
                    }
                }
            }
        });
    }, observerOptions);
    
    document.querySelectorAll('.feature-card, .product-card, .newsletter-content').forEach(el => {
        observer.observe(el);
    });
}

// Parallax Effect
function initializeParallaxEffect() {
    let ticking = false;
    
    function updateParallax() {
        const scrolled = window.pageYOffset;
        const heroElements = document.querySelectorAll('.hero-carousel, .side-banners');
        
        heroElements.forEach(element => {
            const speed = 0.3;
            element.style.transform = 'translateY(' + (scrolled * speed) + 'px)';
        });
        
        ticking = false;
    }
    
    window.addEventListener('scroll', () => {
        if (!ticking) {
            requestAnimationFrame(updateParallax);
            ticking = true;
        }
    });
}

// Interactive Elements
function initializeInteractiveElements() {
    // Button ripple effects
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.cssText = 'position: absolute; width: ' + size + 'px; height: ' + size + 'px; left: ' + x + 'px; top: ' + y + 'px; background: rgba(255,255,255,0.3); border-radius: 50%; transform: scale(0); animation: ripple 0.6s ease-out; pointer-events: none;';
            
            this.style.position = 'relative';
            this.style.overflow = 'hidden';
            this.appendChild(ripple);
            
            setTimeout(() => ripple.remove(), 600);
        });
    });
    
    // Add animation styles
    if (!document.getElementById('modern-animations')) {
        const style = document.createElement('style');
        style.id = 'modern-animations';
        style.textContent = '@keyframes ripple { to { transform: scale(4); opacity: 0; } } .animate-in { animation: slideInUp 0.8s ease-out forwards; } @keyframes slideInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } } .input-group.focused .input-group-text { background: linear-gradient(135deg, #56ab2f, #a8e6cf) !important; transform: scale(1.05); } .input-group.focused .form-control { border-color: #56ab2f !important; box-shadow: 0 0 0 0.2rem rgba(86,171,47,0.25) !important; }';
        document.head.appendChild(style);
    }
}

// Simple notification function (if not available from other scripts)
function showNotification(message, type = 'info') {
    // Create or get notification container
    let container = document.getElementById('notification-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'notification-container';
        container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
        document.body.appendChild(container);
    }
    
    // Create notification
    const notification = document.createElement('div');
    const bgClass = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : 'bg-info';
    notification.className = 'alert ' + bgClass + ' text-white alert-dismissible fade show mb-2';
    notification.innerHTML = '<span>' + message + '</span><button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>';
    
    container.appendChild(notification);
    
    // Auto remove after 4 seconds
    setTimeout(() => {
        notification.remove();
    }, 4000);
}

// Enhanced product card interactions
function enhanceProductCards() {
    document.querySelectorAll('.product-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-15px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
}

// Initialize enhanced interactions when products are loaded
document.addEventListener('productsLoaded', enhanceProductCards);
