-- Fix Address Table Encoding Issues
-- Tạo lại table user_addresses với UTF-8 support

-- 1. Drop existing table if exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'user_addresses')
BEGIN
    DROP TABLE [dbo].[user_addresses];
    PRINT 'Dropped existing user_addresses table';
END

-- 2. Create new table with proper UTF-8 collation
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[user_addresses](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [is_default] [bit] NULL DEFAULT 0,
    [created_at] [datetime2](6) NULL DEFAULT GETDATE(),
    [updated_at] [datetime2](6) NULL DEFAULT GETDATE(),
    [phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [house_number] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [district] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [province] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [recipient_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [user_email] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [ward] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    
    CONSTRAINT [PK_user_addresses] PRIMARY KEY CLUSTERED ([id] ASC)
    WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- 3. Add indexes for better performance
CREATE NONCLUSTERED INDEX [IX_user_addresses_user_email] 
ON [dbo].[user_addresses] ([user_email])
GO

CREATE NONCLUSTERED INDEX [IX_user_addresses_is_default] 
ON [dbo].[user_addresses] ([user_email], [is_default])
GO

-- 4. Add foreign key constraint if users table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users')
BEGIN
    ALTER TABLE [dbo].[user_addresses]
    ADD CONSTRAINT [FK_user_addresses_users] 
    FOREIGN KEY ([user_email]) REFERENCES [dbo].[users]([email])
    ON DELETE CASCADE;
    PRINT 'Added foreign key constraint to users table';
END

-- 5. Insert sample data để test UTF-8
INSERT INTO [dbo].[user_addresses] 
([recipient_name], [phone], [house_number], [ward], [district], [province], [user_email], [is_default])
VALUES 
(N'Trần Kim Tân', '0385546145', N'59 Lê Đình Diễn', N'Hòa Xuân', N'Cẩm Lệ', N'Đà Nẵng', 'trankimtan.dev@gmail.com', 1),
(N'Nguyễn Văn Hùng', '0912345678', N'123 Trần Hưng Đạo', N'Bến Nghé', N'Quận 1', N'TP. Hồ Chí Minh', 'trankimtan.dev@gmail.com', 0);

PRINT 'Created user_addresses table with UTF-8 support and sample data';

-- 6. Verify data
SELECT 
    id,
    recipient_name,
    phone,
    house_number,
    ward,
    district,
    province,
    user_email,
    is_default,
    created_at
FROM [dbo].[user_addresses]
ORDER BY created_at DESC;
