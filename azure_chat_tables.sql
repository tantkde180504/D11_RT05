-- Script tạo bảng cho Azure SQL Database
-- Kết nối vào Azure SQL Database và chạy script này

-- Tạo bảng chat_messages
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chat_messages')
BEGIN
    CREATE TABLE chat_messages (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        sender_id BIGINT NOT NULL,
        receiver_id BIGINT NOT NULL,
        message NVARCHAR(MAX) NOT NULL,
        timestamp DATETIME2 NOT NULL DEFAULT GETDATE(),
        is_read BIT NOT NULL DEFAULT 0,
        sender_type NVARCHAR(10) NOT NULL CHECK (sender_type IN ('CUSTOMER', 'STAFF', 'ADMIN')),
        receiver_type NVARCHAR(10) NOT NULL CHECK (receiver_type IN ('CUSTOMER', 'STAFF', 'ADMIN'))
    );
    
    -- Tạo index
    CREATE INDEX IX_chat_messages_sender_receiver ON chat_messages (sender_id, receiver_id);
    CREATE INDEX IX_chat_messages_timestamp ON chat_messages (timestamp);
    CREATE INDEX IX_chat_messages_unread ON chat_messages (receiver_id, is_read);
    
    PRINT 'Table chat_messages created successfully';
END

-- Tạo bảng chat_assignments
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chat_assignments')
BEGIN
    CREATE TABLE chat_assignments (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        customer_id BIGINT NOT NULL,
        staff_id BIGINT NOT NULL,
        assigned_at DATETIME2 DEFAULT GETDATE(),
        is_active BIT DEFAULT 1,
        
        CONSTRAINT UQ_chat_assignments_customer UNIQUE (customer_id)
    );
    
    -- Tạo index
    CREATE INDEX IX_chat_assignments_customer ON chat_assignments (customer_id);
    CREATE INDEX IX_chat_assignments_staff ON chat_assignments (staff_id);
    
    PRINT 'Table chat_assignments created successfully';
END


