/****** Object:  Database [gundamhobby]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE DATABASE [gundamhobby]  (EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_S_Gen5_1', MAXSIZE = 32 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS, LEDGER = OFF;
GO
ALTER DATABASE [gundamhobby] SET COMPATIBILITY_LEVEL = 170
GO
ALTER DATABASE [gundamhobby] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [gundamhobby] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [gundamhobby] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [gundamhobby] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [gundamhobby] SET ARITHABORT OFF 
GO
ALTER DATABASE [gundamhobby] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [gundamhobby] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [gundamhobby] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [gundamhobby] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [gundamhobby] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [gundamhobby] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [gundamhobby] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [gundamhobby] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [gundamhobby] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [gundamhobby] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [gundamhobby] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [gundamhobby] SET  MULTI_USER 
GO
ALTER DATABASE [gundamhobby] SET ENCRYPTION ON
GO
ALTER DATABASE [gundamhobby] SET QUERY_STORE = ON
GO
ALTER DATABASE [gundamhobby] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_cart_count]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_get_cart_count](@user_id BIGINT)
RETURNS INT
AS
BEGIN
    DECLARE @count INT;
    
    SELECT @count = ISNULL(SUM(quantity), 0)
    FROM cart
    WHERE user_id = @user_id;
    
    RETURN @count;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_product_rating]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_get_product_rating](@product_id BIGINT)
RETURNS DECIMAL(3,2)
AS
BEGIN
    DECLARE @rating DECIMAL(3,2);
    
    SELECT @rating = AVG(CAST(rating AS DECIMAL(3,2)))
    FROM reviews
    WHERE product_id = @product_id;
    
    RETURN ISNULL(@rating, 0);
END;
GO
/****** Object:  Table [dbo].[reviews]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reviews](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[rating] [int] NOT NULL,
	[comment] [nvarchar](max) NULL,
	[is_verified] [bit] NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[products]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[products](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[price] [decimal](10, 2) NOT NULL,
	[stock_quantity] [int] NULL,
	[category] [nvarchar](50) NULL,
	[grade] [nvarchar](30) NULL,
	[brand] [nvarchar](100) NULL,
	[image_url] [nvarchar](500) NULL,
	[is_active] [bit] NULL,
	[is_featured] [bit] NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[category_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[order_number] [nvarchar](50) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[total_amount] [decimal](12, 2) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[shipping_address] [nvarchar](500) NOT NULL,
	[shipping_phone] [nvarchar](20) NULL,
	[shipping_name] [nvarchar](200) NULL,
	[payment_method] [nvarchar](20) NULL,
	[order_date] [datetime2](7) NULL,
	[shipped_date] [datetime2](7) NULL,
	[delivered_date] [datetime2](7) NULL,
	[notes] [nvarchar](max) NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[order_number] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[order_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[quantity] [int] NOT NULL,
	[unit_price] [decimal](10, 2) NOT NULL,
	[subtotal] [decimal](12, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_product_overview]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_product_overview] AS
SELECT 
    p.id,
    p.name,
    p.price,
    p.stock_quantity,
    p.category,
    p.grade,
    p.brand,
    p.is_active,
    p.is_featured,
    ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) as avg_rating,
    COUNT(r.id) as review_count,
    ISNULL(SUM(oi.quantity), 0) as total_sold
FROM products p
LEFT JOIN reviews r ON p.id = r.product_id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'DELIVERED'
GROUP BY p.id, p.name, p.price, p.stock_quantity, p.category, p.grade, p.brand, p.is_active, p.is_featured;
GO
/****** Object:  Table [dbo].[users]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[first_name] [nvarchar](100) NULL,
	[last_name] [nvarchar](100) NULL,
	[phone] [nvarchar](20) NULL,
	[date_of_birth] [date] NULL,
	[gender] [nvarchar](10) NULL,
	[address] [nvarchar](500) NULL,
	[role] [nvarchar](20) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[full_name] [varchar](100) NULL,
	[google_id] [nvarchar](255) NULL,
	[created_date] [datetime2](7) NULL,
	[provider] [nvarchar](50) NULL,
	[provider_id] [nvarchar](255) NULL,
	[picture] [nvarchar](500) NULL,
	[email_verified] [bit] NULL,
	[oauth_provider] [nvarchar](50) NULL,
	[oauth_provider_id] [nvarchar](255) NULL,
	[oauth_picture] [nvarchar](500) NULL,
	[is_oauth_linked] [bit] NULL,
	[oauth_created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_order_statistics]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Thống kê đơn hàng theo khách
CREATE   VIEW [dbo].[vw_order_statistics] AS
SELECT 
    u.id as user_id,
    u.first_name + ' ' + u.last_name as customer_name,
    u.email,
    COUNT(o.id) as total_orders,
    ISNULL(SUM(o.total_amount), 0) as total_spent,
    MAX(o.order_date) as last_order_date,
    AVG(o.total_amount) as avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE u.role = 'CUSTOMER'
GROUP BY u.id, u.first_name, u.last_name, u.email;
GO
/****** Object:  View [dbo].[vw_monthly_revenue]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Báo cáo doanh thu chi tiết theo năm-tháng
CREATE   VIEW [dbo].[vw_monthly_revenue] AS
SELECT 
    YEAR(order_date) AS [year],
    MONTH(order_date) AS [month],
    COUNT(id) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status IN ('DELIVERED', 'SHIPPING')
GROUP BY YEAR(order_date), MONTH(order_date);
GO
/****** Object:  View [dbo].[vw_top_selling_products]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Top sản phẩm bán chạy
CREATE   VIEW [dbo].[vw_top_selling_products] AS
SELECT TOP 20
    p.id,
    p.name,
    p.category,
    p.grade,
    p.brand,
    p.price,
    SUM(oi.quantity) as total_sold,
    SUM(oi.subtotal) as total_revenue,
    AVG(CAST(r.rating AS FLOAT)) as avg_rating
FROM products p
INNER JOIN order_items oi ON p.id = oi.product_id
INNER JOIN orders o ON oi.order_id = o.id
LEFT JOIN reviews r ON p.id = r.product_id
WHERE o.status IN ('DELIVERED', 'SHIPPING')
GROUP BY p.id, p.name, p.category, p.grade, p.brand, p.price
ORDER BY total_sold DESC;
GO
/****** Object:  View [dbo].[vw_revenue_by_day]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Thống kê đơn hàng
-- =====================================================
-- 8. THỐNG KÊ DOANH THU THEO NGÀY / THÁNG / QUÝ / NĂM
-- =====================================================

-- View: Doanh thu theo ngày
CREATE   VIEW [dbo].[vw_revenue_by_day] AS
SELECT 
    CAST(order_date AS DATE) AS [day],
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status IN ('DELIVERED', 'SHIPPING')
GROUP BY CAST(order_date AS DATE);
GO
/****** Object:  View [dbo].[vw_revenue_by_month]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Doanh thu theo tháng
CREATE   VIEW [dbo].[vw_revenue_by_month] AS
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS [month],
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status IN ('DELIVERED', 'SHIPPING')
GROUP BY FORMAT(order_date, 'yyyy-MM');
GO
/****** Object:  View [dbo].[vw_revenue_by_quarter]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Doanh thu theo quý
CREATE   VIEW [dbo].[vw_revenue_by_quarter] AS
SELECT 
    CAST(YEAR(order_date) AS VARCHAR) + '-Q' + CAST(DATEPART(QUARTER, order_date) AS VARCHAR) AS quarter,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status IN ('DELIVERED', 'SHIPPING')
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date);
GO
/****** Object:  View [dbo].[vw_revenue_by_year]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- View: Doanh thu theo năm
CREATE   VIEW [dbo].[vw_revenue_by_year] AS
SELECT 
    YEAR(order_date) AS [year],
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status IN ('DELIVERED', 'SHIPPING')
GROUP BY YEAR(order_date);
GO
/****** Object:  View [dbo].[vw_shipping_status_simple]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================
-- 5. TẠO VIEW: TAB VẬN CHUYỂN (KHÔNG DÙNG SHIPPER_ID)
-- ==============================================
CREATE   VIEW [dbo].[vw_shipping_status_simple] AS
SELECT 
    o.id AS order_id,
    o.order_number,
    o.shipping_name AS customer_name,
    o.total_amount,
    o.order_date,
    o.status AS order_status,
    CASE 
        WHEN o.status = 'CONFIRMED' THEN N'Chờ xác nhận'
        WHEN o.status = 'SHIPPING' THEN N'Xác nhận giao hàng'
        WHEN o.status = 'CANCELLED' THEN N'Hủy giao hàng'
        ELSE N'Không xác định'
    END AS shipping_status
FROM orders o
WHERE o.status IN ('CONFIRMED', 'SHIPPING', 'CANCELLED');
GO
/****** Object:  View [dbo].[vw_order_count_by_month]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================
-- Thống kê số lượng đơn hàng theo trạng thái/ tháng.
CREATE   VIEW [dbo].[vw_order_count_by_month] AS
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS [month],
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY FORMAT(order_date, 'yyyy-MM'), status;
GO
/****** Object:  View [dbo].[vw_order_count_by_quarter]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Thống kê số lượng đơn hàng theo trạng thái/ Quý.
CREATE   VIEW [dbo].[vw_order_count_by_quarter] AS
SELECT 
    CAST(YEAR(order_date) AS VARCHAR) + '-Q' + CAST(DATEPART(QUARTER, order_date) AS VARCHAR) AS quarter,
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_date), DATEPART(QUARTER, order_date), status;
GO
/****** Object:  Table [dbo].[returns]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[returns](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[return_code] [nvarchar](20) NOT NULL,
	[order_id] [bigint] NOT NULL,
	[user_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[complaint_code] [nvarchar](20) NULL,
	[reason] [nvarchar](max) NOT NULL,
	[request_type] [nvarchar](100) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[processed_by] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[return_code] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_returns_detail]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================
-- View: Danh sách yêu cầu đổi trả hàng (để staff theo dõi)
-- =====================================================
CREATE   VIEW [dbo].[vw_returns_detail] AS
SELECT 
    r.return_code,
    o.order_number,
    u.first_name + ' ' + u.last_name AS customer_name,
    p.name AS product_name,
    r.reason,
    r.request_type,
    r.status,
    r.created_at,
    r.updated_at
FROM returns r
JOIN orders o ON r.order_id = o.id
JOIN users u ON r.user_id = u.id
JOIN products p ON r.product_id = p.id;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_user_auth_methods]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_user_auth_methods](@email NVARCHAR(255))
RETURNS TABLE
AS
RETURN (
    SELECT 
        email,
        CASE WHEN password IS NOT NULL AND password != '' THEN 1 ELSE 0 END AS has_password,
        CASE WHEN is_oauth_linked = 1 THEN 1 ELSE 0 END AS has_oauth,
        oauth_provider,
        full_name,
        role
    FROM [dbo].[users]
    WHERE email = @email
);
GO
/****** Object:  Table [dbo].[shipping]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shipping](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[order_id] [bigint] NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[assigned_at] [datetime2](7) NULL,
	[confirmed_at] [datetime2](7) NULL,
	[note] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[order_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_shipping_tab]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================
-- 3. VIEW: TỔNG HỢP ĐƠN GIAO HÀNG CHO SHIPPER
-- ===========================
CREATE   VIEW [dbo].[vw_shipping_tab] AS
SELECT 
    s.id AS shipping_id,
    s.order_id,
    o.order_number,
    o.shipping_name AS customer_name,
    o.total_amount,
    o.order_date,
    s.status AS shipping_status,
    s.assigned_at,
    s.confirmed_at,
    s.note
FROM shipping s
JOIN orders o ON o.id = s.order_id;
GO
/****** Object:  Table [dbo].[brands]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[brands](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[description] [nvarchar](max) NULL,
	[logo_url] [nvarchar](500) NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cart]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[quantity] [int] NOT NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categories]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[categories](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[description] [nvarchar](max) NULL,
	[parent_id] [bigint] NULL,
	[is_active] [bit] NULL,
	[created_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[complaints]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[complaints](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[complaint_code] [nvarchar](20) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[order_id] [bigint] NOT NULL,
	[category] [nvarchar](100) NULL,
	[content] [nvarchar](max) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[solution] [nvarchar](100) NULL,
	[staff_response] [nvarchar](max) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[complaint_code] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[email_verification]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[email_verification](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[otp_code] [nvarchar](6) NOT NULL,
	[user_data] [nvarchar](max) NOT NULL,
	[created_at] [datetime2](7) NULL,
	[expires_at] [datetime2](7) NOT NULL,
	[verified] [bit] NULL,
	[attempts] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[favorites]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[favorites](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NOT NULL,
	[product_id] [bigint] NOT NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_favorites_user_product] UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inventory_logs]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inventory_logs](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[product_id] [bigint] NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[quantity] [int] NOT NULL,
	[previous_stock] [int] NOT NULL,
	[new_stock] [int] NOT NULL,
	[reason] [nvarchar](500) NULL,
	[created_by] [bigint] NULL,
	[created_at] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[oauth_users]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oauth_users](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[picture] [nvarchar](500) NULL,
	[provider] [nvarchar](50) NOT NULL,
	[provider_id] [nvarchar](255) NOT NULL,
	[first_name] [nvarchar](255) NULL,
	[last_name] [nvarchar](255) NULL,
	[role] [nvarchar](50) NULL,
	[created_at] [datetime2](7) NULL,
	[updated_at] [datetime2](7) NULL,
	[migrated_to_users] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[provider_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[password_reset_otp]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[password_reset_otp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [nvarchar](255) NOT NULL,
	[otp] [nvarchar](10) NOT NULL,
	[expiry_time] [datetime] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[is_used] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_cart_product_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_cart_product_id] ON [dbo].[cart]
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_cart_user_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_cart_user_id] ON [dbo].[cart]
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_email_otp]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [idx_email_otp] ON [dbo].[email_verification]
(
	[email] ASC,
	[otp_code] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [idx_expires_at]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [idx_expires_at] ON [dbo].[email_verification]
(
	[expires_at] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_favorites_created_at]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_favorites_created_at] ON [dbo].[favorites]
(
	[created_at] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_favorites_product_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_favorites_product_id] ON [dbo].[favorites]
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_favorites_user_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_favorites_user_id] ON [dbo].[favorites]
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_order_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items]
(
	[order_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_product_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_order_items_product_id] ON [dbo].[order_items]
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_orders_order_date]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_orders_order_date] ON [dbo].[orders]
(
	[order_date] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_orders_payment_method]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_orders_payment_method] ON [dbo].[orders]
(
	[payment_method] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_orders_status]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_orders_status] ON [dbo].[orders]
(
	[status] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_orders_user_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders]
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_password_reset_otp_email]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [idx_password_reset_otp_email] ON [dbo].[password_reset_otp]
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_products_brand]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_brand] ON [dbo].[products]
(
	[brand] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_products_category]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_category] ON [dbo].[products]
(
	[category] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_products_created_at]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_created_at] ON [dbo].[products]
(
	[created_at] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_products_grade]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_grade] ON [dbo].[products]
(
	[grade] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_products_is_active]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_is_active] ON [dbo].[products]
(
	[is_active] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_products_is_featured]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_is_featured] ON [dbo].[products]
(
	[is_featured] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_products_price]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_price] ON [dbo].[products]
(
	[price] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_products_stock_quantity]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_products_stock_quantity] ON [dbo].[products]
(
	[stock_quantity] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_returns_created_at]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_returns_created_at] ON [dbo].[returns]
(
	[created_at] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_returns_order_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_returns_order_id] ON [dbo].[returns]
(
	[order_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_returns_product_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_returns_product_id] ON [dbo].[returns]
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_returns_status]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_returns_status] ON [dbo].[returns]
(
	[status] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_returns_user_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_returns_user_id] ON [dbo].[returns]
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_reviews_product_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_reviews_product_id] ON [dbo].[reviews]
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_reviews_rating]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_reviews_rating] ON [dbo].[reviews]
(
	[rating] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_reviews_user_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_reviews_user_id] ON [dbo].[reviews]
(
	[user_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_shipping_status]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_shipping_status] ON [dbo].[shipping]
(
	[status] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_users_created_at]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_created_at] ON [dbo].[users]
(
	[created_at] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users_email]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_email] ON [dbo].[users]
(
	[email] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users_email_provider]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_email_provider] ON [dbo].[users]
(
	[email] ASC,
	[oauth_provider] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users_google_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_google_id] ON [dbo].[users]
(
	[google_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users_oauth_provider_id]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_oauth_provider_id] ON [dbo].[users]
(
	[oauth_provider_id] ASC
)
WHERE ([oauth_provider_id] IS NOT NULL)
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_users_role]    Script Date: 10/07/2025 5:47:24 CH ******/
CREATE NONCLUSTERED INDEX [IX_users_role] ON [dbo].[users]
(
	[role] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[brands] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[brands] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[categories] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[categories] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[complaints] ADD  DEFAULT ('PENDING') FOR [status]
GO
ALTER TABLE [dbo].[complaints] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[complaints] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[email_verification] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[email_verification] ADD  DEFAULT ((0)) FOR [verified]
GO
ALTER TABLE [dbo].[email_verification] ADD  DEFAULT ((0)) FOR [attempts]
GO
ALTER TABLE [dbo].[favorites] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[inventory_logs] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[oauth_users] ADD  DEFAULT ('USER') FOR [role]
GO
ALTER TABLE [dbo].[oauth_users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[oauth_users] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[oauth_users] ADD  DEFAULT ((0)) FOR [migrated_to_users]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT ('PENDING') FOR [status]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [dbo].[orders] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[password_reset_otp] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[password_reset_otp] ADD  DEFAULT ((0)) FOR [is_used]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT ((0)) FOR [stock_quantity]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT ('Bandai') FOR [brand]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT ((0)) FOR [is_featured]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[products] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[returns] ADD  DEFAULT ('PROCESSING') FOR [status]
GO
ALTER TABLE [dbo].[returns] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[returns] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[reviews] ADD  DEFAULT ((0)) FOR [is_verified]
GO
ALTER TABLE [dbo].[reviews] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[shipping] ADD  DEFAULT ('PENDING') FOR [status]
GO
ALTER TABLE [dbo].[shipping] ADD  DEFAULT (getdate()) FOR [assigned_at]
GO

ALTER TABLE [dbo].[users] ADD  DEFAULT ('CUSTOMER') FOR [role]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [updated_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((0)) FOR [email_verified]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((0)) FOR [is_oauth_linked]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[categories]  WITH CHECK ADD  CONSTRAINT [FK_categories_parent] FOREIGN KEY([parent_id])
REFERENCES [dbo].[categories] ([id])
GO
ALTER TABLE [dbo].[categories] CHECK CONSTRAINT [FK_categories_parent]
GO
ALTER TABLE [dbo].[complaints]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[complaints]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[favorites]  WITH CHECK ADD  CONSTRAINT [FK_favorites_product] FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[favorites] CHECK CONSTRAINT [FK_favorites_product]
GO
ALTER TABLE [dbo].[favorites]  WITH CHECK ADD  CONSTRAINT [FK_favorites_user] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[favorites] CHECK CONSTRAINT [FK_favorites_user]
GO
ALTER TABLE [dbo].[inventory_logs]  WITH CHECK ADD FOREIGN KEY([created_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[inventory_logs]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD FOREIGN KEY([complaint_code])
REFERENCES [dbo].[complaints] ([complaint_code])
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD FOREIGN KEY([processed_by])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
GO
ALTER TABLE [dbo].[reviews]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[products] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[reviews]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[shipping]  WITH CHECK ADD FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[cart]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[complaints]  WITH CHECK ADD CHECK  (([status]='REJECTED' OR [status]='COMPLETED' OR [status]='PROCESSING' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[inventory_logs]  WITH CHECK ADD CHECK  (([type]='ADJUSTMENT' OR [type]='OUT' OR [type]='IN'))
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD CHECK  (([quantity]>(0)))
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD CHECK  (([subtotal]>=(0)))
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD CHECK  (([unit_price]>=(0)))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([payment_method]='CREDIT_CARD' OR [payment_method]='VNPAY' OR [payment_method]='MOMO' OR [payment_method]='BANK_TRANSFER' OR [payment_method]='COD'))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([status]='CANCELLED' OR [status]='DELIVERED' OR [status]='SHIPPING' OR [status]='PROCESSING' OR [status]='CONFIRMED' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD CHECK  (([total_amount]>=(0)))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([category]='TOOLS_ACCESSORIES' OR [category]='PRE_ORDER' OR [category]='GUNDAM_BANDAI'))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([grade]='DECAL' OR [grade]='BASE_STAND' OR [grade]='PAINT' OR [grade]='TOOLS' OR [grade]='FULL_MECHANICS' OR [grade]='METAL_BUILD' OR [grade]='SD' OR [grade]='PG' OR [grade]='MG' OR [grade]='RG' OR [grade]='HG'))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([price]>=(0)))
GO
ALTER TABLE [dbo].[products]  WITH CHECK ADD CHECK  (([stock_quantity]>=(0)))
GO
ALTER TABLE [dbo].[returns]  WITH CHECK ADD CHECK  (([status]='REJECTED' OR [status]='COMPLETED' OR [status]='PROCESSING'))
GO
ALTER TABLE [dbo].[reviews]  WITH CHECK ADD CHECK  (([rating]>=(1) AND [rating]<=(5)))
GO
ALTER TABLE [dbo].[shipping]  WITH CHECK ADD  CONSTRAINT [CK_shipping_status] CHECK  (([status]='CANCELLED' OR [status]='DELIVERED' OR [status]='SHIPPING' OR [status]='PENDING'))
GO
ALTER TABLE [dbo].[shipping] CHECK CONSTRAINT [CK_shipping_status]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD CHECK  (([gender]='OTHER' OR [gender]='FEMALE' OR [gender]='MALE'))
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [CK__users__role__5FB337D6] CHECK  (([role]='ADMIN' OR [role]='STAFF' OR [role]='CUSTOMER' OR [role]='SHIPPER'))
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [CK__users__role__5FB337D6]
GO
/****** Object:  StoredProcedure [dbo].[CleanupExpiredOTP]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    CREATE PROCEDURE [dbo].[CleanupExpiredOTP]
    AS
    BEGIN
        DELETE FROM email_verification 
        WHERE expires_at < GETDATE() OR attempts >= 3;
    END
    
GO
/****** Object:  StoredProcedure [dbo].[sp_authenticate_user]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_authenticate_user]
    @email NVARCHAR(255),
    @password NVARCHAR(255) = NULL,
    @oauth_provider NVARCHAR(50) = NULL,
    @oauth_provider_id NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @user_id BIGINT;
    DECLARE @stored_password NVARCHAR(512);
    DECLARE @auth_success BIT;
    
    SET @auth_success = 0;
    
    -- Tìm user theo email
    SELECT 
        @user_id = id,
        @stored_password = password
    FROM [dbo].[users] 
    WHERE email = @email;
    
    IF @user_id IS NOT NULL
    BEGIN
        -- User tồn tại, kiểm tra phương thức xác thực
        IF @oauth_provider IS NOT NULL
        BEGIN
            -- OAuth authentication
            SET @auth_success = 1;
            
            -- Cập nhật thông tin OAuth nếu các trường tồn tại
            IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider')
            BEGIN
                UPDATE [dbo].[users] 
                SET 
                    provider = @oauth_provider,
                    provider_id = @oauth_provider_id,
                    updated_at = GETDATE()
                WHERE id = @user_id;
            END
        END
        ELSE IF @password IS NOT NULL
        BEGIN
            -- Password authentication - so sánh trực tiếp password đã hash
            IF @stored_password = @password
            BEGIN
                SET @auth_success = 1;
            END
        END
    END
    
    -- Trả về kết quả xác thực
    IF @auth_success = 1
    BEGIN
        SELECT 
            1 AS success,
            id AS user_id,
            email,
            ISNULL(first_name + ' ' + last_name, email) AS full_name,
            first_name,
            last_name,
            ISNULL(role, 'CUSTOMER') AS role,
            picture,
            provider AS oauth_provider,
            provider_id AS oauth_provider_id,
            CASE WHEN provider IS NOT NULL THEN 1 ELSE 0 END AS is_oauth_linked,
            'Authentication successful' AS message
        FROM [dbo].[users] 
        WHERE id = @user_id;
    END
    ELSE
    BEGIN
        SELECT 
            0 AS success,
            NULL AS user_id,
            @email AS email,
            NULL AS full_name,
            NULL AS first_name,
            NULL AS last_name,
            NULL AS role,
            NULL AS picture,
            NULL AS oauth_provider,
            NULL AS oauth_provider_id,
            0 AS is_oauth_linked,
            CASE 
                WHEN @user_id IS NULL THEN 'User not found'
                ELSE 'Invalid credentials'
            END AS message;
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_create_return_from_complaint]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored procedure tạo đổi trả từ khiếu nại
CREATE   PROCEDURE [dbo].[sp_create_return_from_complaint]
    @complaint_id BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @order_id BIGINT;
    DECLARE @user_name NVARCHAR(200);
    DECLARE @reason NVARCHAR(500);

    SELECT 
        @order_id = c.order_id,
        @user_name = u.first_name + ' ' + u.last_name,
        @reason = N'Từ khiếu nại: ' + ISNULL(c.content, N'Lý do không xác định')
    FROM complaints c
    JOIN users u ON c.user_id = u.id
    WHERE c.id = @complaint_id;

    IF @order_id IS NULL OR @user_name IS NULL OR @reason IS NULL
    BEGIN
        RAISERROR(N'❌ Không thể tạo yêu cầu đổi trả. Thiếu dữ liệu.', 16, 1);
        RETURN;
    END

    INSERT INTO returns (order_id, customer_name, reason, status, created_at, complaint_id)
    VALUES (@order_id, @user_name, @reason, 'PENDING', GETDATE(), @complaint_id);
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_merge_oauth_user]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_merge_oauth_user]
    @email NVARCHAR(255),
    @oauth_provider NVARCHAR(50),
    @oauth_provider_id NVARCHAR(255),
    @oauth_name NVARCHAR(255),
    @oauth_picture NVARCHAR(500),
    @oauth_first_name NVARCHAR(255),
    @oauth_last_name NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @existing_user_id BIGINT;
    DECLARE @result_user_id BIGINT;
    DECLARE @is_new_user BIT = 0;
    
    -- Check if user exists with this email
    SELECT @existing_user_id = id FROM [dbo].[users] WHERE email = @email;
    
    IF @existing_user_id IS NOT NULL
    BEGIN
        -- User exists, update OAuth info
        UPDATE [dbo].[users] 
        SET 
            oauth_provider = @oauth_provider,
            oauth_provider_id = @oauth_provider_id,
            oauth_picture = @oauth_picture,
            is_oauth_linked = 1,
            oauth_created_at = GETUTCDATE(),
            updated_at = GETUTCDATE(),
            -- Update name if not set
            first_name = CASE WHEN first_name IS NULL OR first_name = '' THEN @oauth_first_name ELSE first_name END,
            last_name = CASE WHEN last_name IS NULL OR last_name = '' THEN @oauth_last_name ELSE last_name END,
            full_name = CASE WHEN full_name IS NULL OR full_name = '' THEN @oauth_name ELSE full_name END,
            picture = CASE WHEN picture IS NULL OR picture = '' THEN @oauth_picture ELSE picture END
        WHERE id = @existing_user_id;
        
        SET @result_user_id = @existing_user_id;
        
        PRINT 'Updated existing user ID: ' + CAST(@existing_user_id AS VARCHAR);
    END
    ELSE
    BEGIN
        -- User doesn't exist, create new OAuth user
        INSERT INTO [dbo].[users] (
            email, 
            password, 
            first_name, 
            last_name, 
            full_name,
            role, 
            created_at, 
            updated_at,
            oauth_provider,
            oauth_provider_id,
            oauth_picture,
            is_oauth_linked,
            oauth_created_at,
            picture,
            provider,
            provider_id
        )
        VALUES (
            @email,
            '', -- Empty password for OAuth users
            @oauth_first_name,
            @oauth_last_name,
            @oauth_name,
            'CUSTOMER',
            GETUTCDATE(),
            GETUTCDATE(),
            @oauth_provider,
            @oauth_provider_id,
            @oauth_picture,
            1,
            GETUTCDATE(),
            @oauth_picture,
            @oauth_provider,
            @oauth_provider_id
        );
        
        SET @result_user_id = SCOPE_IDENTITY();
        SET @is_new_user = 1;
        
        PRINT 'Created new OAuth user ID: ' + CAST(@result_user_id AS VARCHAR);
    END
    
    -- Return result
    SELECT 
        @result_user_id AS user_id,
        @is_new_user AS is_new_user,
        email,
        full_name,
        first_name,
        last_name,
        role,
        picture,
        oauth_picture,
        is_oauth_linked,
        oauth_provider,
        oauth_provider_id
    FROM [dbo].[users] 
    WHERE id = @result_user_id;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_update_product_stock]    Script Date: 10/07/2025 5:47:24 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_update_product_stock]
    @product_id BIGINT,
    @quantity INT,
    @type NVARCHAR(10) -- 'IN' hoặc 'OUT'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @current_stock INT;
    DECLARE @new_stock INT;
    
    -- Lấy stock hiện tại
    SELECT @current_stock = stock_quantity FROM products WHERE id = @product_id;
    
    -- Tính stock mới
    IF @type = 'OUT'
        SET @new_stock = @current_stock - @quantity;
    ELSE
        SET @new_stock = @current_stock + @quantity;
    
    -- Kiểm tra stock không được âm
    IF @new_stock < 0
    BEGIN
        RAISERROR('Insufficient stock. Current stock: %d, Requested: %d', 16, 1, @current_stock, @quantity);
        RETURN;
    END
    
    -- Cập nhật stock
    UPDATE products 
    SET stock_quantity = @new_stock, updated_at = GETDATE()
    WHERE id = @product_id;
    
    -- Log inventory change
    INSERT INTO inventory_logs (product_id, type, quantity, previous_stock, new_stock, reason, created_at)
    VALUES (@product_id, @type, @quantity, @current_stock, @new_stock, 'Order processing', GETDATE());
END;
GO
ALTER DATABASE [gundamhobby] SET  READ_WRITE 
GO


