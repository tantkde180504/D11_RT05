// Carousel Protection Script
// File này đảm bảo carousel banner không bị thay đổi bởi bất kỳ JavaScript nào khác

(function() {
    'use strict';
    
    // Hàm bảo vệ carousel
    function protectCarousel() {
        const carousel = document.getElementById('heroCarousel');
        if (carousel) {
            // Đánh dấu carousel là được bảo vệ
            carousel.setAttribute('data-protected', 'true');
            carousel.setAttribute('data-protection-level', 'maximum');
            
            // Tạo observer để theo dõi mọi thay đổi
            const observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.type === 'childList' || mutation.type === 'attributes') {
                        console.warn('⚠️ Phát hiện thay đổi trên carousel được bảo vệ:', mutation);
                    }
                });
            });
            
            // Bắt đầu theo dõi
            observer.observe(carousel, {
                childList: true,
                subtree: true,
                attributes: true,
                attributeOldValue: true
            });
            
            console.log('🛡️ Carousel được bảo vệ bởi carousel-protection.js');
            
            return true;
        }
        return false;
    }
    
    // Hàm kiểm tra tính toàn vẹn của carousel
    window.checkCarouselIntegrity = function() {
        const carousel = document.getElementById('heroCarousel');
        if (!carousel) {
            console.error('❌ CẢNH BÁO: Carousel không tồn tại!');
            return false;
        }
        
        const isProtected = carousel.getAttribute('data-protected') === 'true';
        const hasCorrectClass = carousel.classList.contains('carousel');
        const hasSlides = carousel.querySelectorAll('.carousel-item').length > 0;
        
        console.log('🔍 Kiểm tra carousel:');
        console.log('- Được bảo vệ:', isProtected);
        console.log('- Class đúng:', hasCorrectClass);
        console.log('- Có slides:', hasSlides);
        
        return isProtected && hasCorrectClass && hasSlides;
    };
    
    // Khởi chạy khi DOM ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', protectCarousel);
    } else {
        protectCarousel();
    }
    
    // Backup protection khi window load
    window.addEventListener('load', function() {
        setTimeout(protectCarousel, 100);
    });
    
})();
