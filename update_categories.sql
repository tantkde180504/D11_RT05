-- Script SQL để cập nhật lại bảng categories cho đúng
-- Xóa dữ liệu cũ
DELETE FROM categories;

-- Thêm dữ liệu categories mới phù hợp với products
SET IDENTITY_INSERT categories ON;

-- Chỉ 2 danh mục chính theo dữ liệu thực tế
INSERT INTO categories (id, name, description, parent_id, is_active, created_at) VALUES
(1, 'GUNDAM_BANDAI', 'Các mô hình Gundam chính hãng từ Bandai', NULL, 1, GETDATE()),
(2, 'TOOLS_ACCESSORIES', 'Tools, sơn, base và các phụ kiện làm mô hình', NULL, 1, GETDATE());

SET IDENTITY_INSERT categories OFF;
