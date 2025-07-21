/**
 * UTF-8 Placeholder Fix
 * Fixes Vietnamese placeholder text encoding issues
 */
document.addEventListener('DOMContentLoaded', function() {
    // Define Vietnamese placeholder mappings
    const placeholderMappings = {
        'headerSearchInput': 'Tìm kiếm sản phẩm Gundam...',
        'email-newsletter': 'Nhập email của bạn...',
        'search-keyword': 'Nhập từ khóa...',
        'price-from': 'Từ',
        'price-to': 'Đến',
        'email-register': 'Nhập email đã đăng ký',
        'otp-input': 'Nhập 6 chữ số',
        'review-text': 'Chia sẻ trải nghiệm của bạn về sản phẩm này...',
        'customer-search': 'Tìm kiếm khách hàng...',
        'chat-message': 'Nhập tin nhắn...',
        'product-search': 'Tìm kiếm sản phẩm...',
        'quantity-input': 'Nhập số lượng mới',
        'reason-input': 'Nhập lý do...',
        'email-example': 'email@example.com',
        'title-input': 'Nhập tiêu đề...',
        'message-content': 'Nhập nội dung tin nhắn...',
        'response-input': 'Nhập phản hồi...',
        'note-input': 'Nhập ghi chú...',
        'process-note': 'Nhập ghi chú xử lý...',
        'update-note': 'Ghi chú cập nhật...',
        'fullname-input': 'Nhập họ tên...',
        'phone-input': '0123456789',
        'address-input': 'Nhập địa chỉ giao hàng...'
    };
    
    // Fix specific elements by ID
    Object.keys(placeholderMappings).forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.placeholder = placeholderMappings[id];
        }
    });
    
    // Fix elements by placeholder patterns (for elements without specific IDs)
    const placeholderPatterns = [
        { pattern: /^nhập email.*$/i, replacement: 'Nhập email của bạn...' },
        { pattern: /^từ$/i, replacement: 'Từ' },
        { pattern: /^đến$/i, replacement: 'Đến' },
        { pattern: /^nhập từ khóa.*$/i, replacement: 'Nhập từ khóa...' },
        { pattern: /^tìm kiếm.*$/i, replacement: function(original) {
            if (original.toLowerCase().includes('khách hàng')) return 'Tìm kiếm khách hàng...';
            if (original.toLowerCase().includes('sản phẩm')) return 'Tìm kiếm sản phẩm...';
            return 'Tìm kiếm...';
        }},
        { pattern: /^nhập.*$/i, replacement: function(original) {
            if (original.toLowerCase().includes('tin nhắn')) return 'Nhập tin nhắn...';
            if (original.toLowerCase().includes('số lượng')) return 'Nhập số lượng mới';
            if (original.toLowerCase().includes('lý do')) return 'Nhập lý do...';
            if (original.toLowerCase().includes('tiêu đề')) return 'Nhập tiêu đề...';
            if (original.toLowerCase().includes('nội dung')) return 'Nhập nội dung tin nhắn...';
            if (original.toLowerCase().includes('phản hồi')) return 'Nhập phản hồi...';
            if (original.toLowerCase().includes('ghi chú')) return 'Nhập ghi chú...';
            if (original.toLowerCase().includes('họ tên')) return 'Nhập họ tên...';
            if (original.toLowerCase().includes('địa chỉ')) return 'Nhập địa chỉ giao hàng...';
            return original;
        }}
    ];
    
    // Find all input and textarea elements with Vietnamese placeholders
    const inputs = document.querySelectorAll('input[placeholder], textarea[placeholder]');
    inputs.forEach(input => {
        const currentPlaceholder = input.placeholder;
        
        // Skip if placeholder is empty
        if (!currentPlaceholder) {
            return;
        }
        
        // Check if placeholder contains corrupted UTF-8 characters
        const hasCorruptedChars = currentPlaceholder.includes('Ã') || 
                                 currentPlaceholder.includes('º') || 
                                 currentPlaceholder.includes('¿') ||
                                 currentPlaceholder.includes('©') ||
                                 currentPlaceholder.includes('ª') ||
                                 currentPlaceholder.includes('¡');
        
        if (!hasCorruptedChars) {
            return; // Skip if placeholder looks fine
        }
        
        // Try to match and fix corrupted Vietnamese text
        let fixed = false;
        placeholderPatterns.forEach(pattern => {
            if (!fixed && pattern.pattern.test(currentPlaceholder.toLowerCase())) {
                if (typeof pattern.replacement === 'function') {
                    input.placeholder = pattern.replacement(currentPlaceholder);
                } else {
                    input.placeholder = pattern.replacement;
                }
                fixed = true;
                console.log('[UTF-8 Fix] Fixed placeholder:', currentPlaceholder, '->', input.placeholder);
            }
        });
        
        // Common Vietnamese corrupted text fixes
        if (!fixed) {
            let fixedText = currentPlaceholder;
            
            // Common UTF-8 corruption patterns for Vietnamese
            const corruptionFixes = {
                'TÃ¬m kiáº¿m': 'Tìm kiếm',
                'sáº£n pháº©m': 'sản phẩm',
                'Nháº­p': 'Nhập',
                'email cá»§a báº¡n': 'email của bạn',
                'tá»«': 'từ',
                'khÃ³a': 'khóa',
                'Äáº¿n': 'Đến',
                'Tá»«': 'Từ',
                'Äá»ã ': 'đã ',
                'Äáº­ng kÃ½': 'đăng ký',
                'chá»¯ sá»': 'chữ số',
                'tráº£i nghiá»m': 'trải nghiệm',
                'sáº£n pháº©m nÃ y': 'sản phẩm này',
                'khÃ¡ch hÃ ng': 'khách hàng',
                'tin nháº¯n': 'tin nhắn',
                'sá» lÆ°á»£ng má»i': 'số lượng mới',
                'lÃ½ do': 'lý do',
                'tiÃªu Äá»': 'tiêu đề',
                'ná»i dung': 'nội dung',
                'pháº£n há»i': 'phản hồi',
                'ghi chÃº': 'ghi chú',
                'há» tÃªn': 'họ tên',
                'Äá»a chá»': 'địa chỉ',
                'giao hÃ ng': 'giao hàng'
            };
            
            Object.keys(corruptionFixes).forEach(corrupted => {
                fixedText = fixedText.replace(new RegExp(corrupted, 'gi'), corruptionFixes[corrupted]);
            });
            
            if (fixedText !== currentPlaceholder) {
                input.placeholder = fixedText;
                console.log('[UTF-8 Fix] General fix applied:', currentPlaceholder, '->', fixedText);
            }
        }
    });
    
    // Log fixed placeholders for debugging
    if (window.console && console.log) {
        console.log('[UTF-8 Placeholder Fix] Processed placeholders');
    }
});
