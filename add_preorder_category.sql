-- Script SQL để thêm danh mục PREORDER vào bảng categories

-- Thêm danh mục PREORDER theo đúng cấu trúc bảng
INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES
('PREORDER', 'Sản phẩm đặt trước - chưa có sẵn trong kho', NULL, 1, GETDATE());

-- Kiểm tra kết quả
SELECT id, name, description, parent_id, is_active, created_at FROM categories ORDER BY id;
