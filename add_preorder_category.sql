-- Script SQL để thêm danh mục PREORDER vào bảng categories

-- Thêm danh mục PREORDER theo đúng cấu trúc bảng
INSERT INTO categories (name, description, parent_id, is_active, created_at) VALUES
('PREORDER', 'Sản phẩm đặt trước - chưa có sẵn trong kho', NULL, 1, GETDATE());

-- Kiểm tra kết quả
SELECT id, name, description, parent_id, is_active, created_at FROM categories ORDER BY id;

-- Thêm trường shipping_type vào bảng orders nếu chưa có
IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=OBJECT_ID('orders') AND name='shipping_type')
    ALTER TABLE orders ADD shipping_type NVARCHAR(20) NULL;

-- Nếu tạo mới bảng orders, thêm shipping_type vào CREATE TABLE
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='orders' AND xtype='U')
    CREATE TABLE orders (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_number NVARCHAR(50) NOT NULL UNIQUE,
        user_id BIGINT NOT NULL,
        total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
        status NVARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPING', 'DELIVERED', 'CANCELLED')),
        shipping_address NVARCHAR(500) NOT NULL,
        shipping_phone NVARCHAR(20),
        shipping_name NVARCHAR(200),
        payment_method NVARCHAR(20) CHECK (payment_method IN ('COD', 'BANK_TRANSFER', 'MOMO', 'VNPAY', 'CREDIT_CARD')),
        shipping_type NVARCHAR(20),
        order_date DATETIME2 DEFAULT GETDATE(),
        shipped_date DATETIME2,
        delivered_date DATETIME2,
        notes NVARCHAR(MAX),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
