-- Script SQL để cập nhật category_id trong bảng products cho phù hợp với categories mới

-- Cập nhật tất cả products Gundam về category_id = 1 (Mô hình Gundam Bandai)
UPDATE products SET category_id = 1 WHERE category = 'GUNDAM_BANDAI';

-- Cập nhật tất cả products tools/accessories về category_id = 2 (Dụng cụ và Phụ kiện)  
UPDATE products SET category_id = 2 WHERE category = 'TOOLS_ACCESSORIES';

-- Kiểm tra kết quả
SELECT 
    p.id,
    p.name,
    p.grade,
    p.category,
    p.category_id,
    c.name as category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
ORDER BY p.category, p.grade;
