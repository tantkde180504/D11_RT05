<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Add SheetJS for Excel export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <!-- Add jsPDF for PDF export -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>
    <style>
        /* Admin Dashboard Specific Styles */
        :root {
            --admin-primary: #ff6600;
            --admin-secondary: #0066cc;
            --admin-dark: #333333;
            --admin-light: #f8f9fa;
            --admin-white: #ffffff;
            --admin-border: #e9ecef;
            --admin-success: #28a745;
            --admin-warning: #ffc107;
            --admin-danger: #dc3545;
            --admin-info: #17a2b8;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--admin-light);
        }

        /* Admin Header */
        .admin-header {
            background: linear-gradient(135deg, var(--admin-dark) 0%, #555555 100%);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-bottom: 3px solid var(--admin-primary);
        }

        .admin-brand {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--admin-white) !important;
            text-decoration: none;
        }

        .admin-brand i {
            color: var(--admin-primary);
            margin-right: 0.5rem;
        }

        .admin-nav-link {
            color: #cccccc !important;
            font-weight: 500;
            padding: 0.75rem 1rem !important;
            border-radius: 6px;
            transition: all 0.3s ease;
            margin: 0 0.25rem;
        }

        .admin-nav-link:hover {
            background-color: rgba(255, 102, 0, 0.2);
            color: var(--admin-white) !important;
        }

        /* Sidebar */
        .admin-sidebar {
            background-color: var(--admin-white);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
            border-right: 1px solid var(--admin-border);
            min-height: calc(100vh - 76px);
        }

        .sidebar-nav {
            padding: 1.5rem 0;
        }

        .sidebar-nav .nav-link {
            color: var(--admin-dark);
            padding: 1rem 1.5rem;
            border-radius: 0;
            border-left: 3px solid transparent;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-bottom: 0.25rem;
        }

        .sidebar-nav .nav-link:hover {
            background-color: rgba(255, 102, 0, 0.1);
            border-left-color: var(--admin-primary);
            color: var(--admin-primary);
        }

        .sidebar-nav .nav-link.active {
            background-color: rgba(255, 102, 0, 0.15);
            border-left-color: var(--admin-primary);
            color: var(--admin-primary);
            font-weight: 600;
        }

        .sidebar-nav .nav-link i {
            width: 20px;
            margin-right: 0.75rem;
        }

        /* Main Content */
        .admin-main {
            background-color: var(--admin-light);
            min-height: calc(100vh - 76px);
            padding: 2rem;
        }

        /* Page Headers */
        .page-header {
            background: linear-gradient(135deg, var(--admin-white) 0%, #f8f9fa 100%);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--admin-primary);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--admin-dark);
            margin: 0;
        }

        /* Statistics Cards */
        .stat-card {
            background: var(--admin-white);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: none;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .stat-card-body {
            padding: 2rem;
            position: relative;
        }

        .stat-card.primary { border-left: 4px solid var(--admin-primary); }
        .stat-card.success { border-left: 4px solid var(--admin-success); }
        .stat-card.info { border-left: 4px solid var(--admin-info); }
        .stat-card.warning { border-left: 4px solid var(--admin-warning); }

        .stat-label {
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--admin-dark);
            margin: 0;
        }

        .stat-icon {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            font-size: 2.5rem;
            opacity: 0.3;
        }

        /* Chart Cards */
        .chart-card {
            background: var(--admin-white);
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border: none;
            overflow: hidden;
        }

        .chart-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 1.5rem;
            border-bottom: 1px solid var(--admin-border);
        }

        .chart-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--admin-dark);
            margin: 0;
        }

        /* Tables */
        .admin-table {
            background: var(--admin-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .admin-table .table {
            margin: 0;
        }

        .admin-table .table thead th {
            background: linear-gradient(135deg, var(--admin-dark) 0%, #555555 100%);
            color: var(--admin-white);
            font-weight: 600;
            border: none;
            padding: 1rem;
        }

        .admin-table .table tbody td {
            padding: 1rem;
            vertical-align: middle;
            border-color: var(--admin-border);
        }

        .admin-table .table tbody tr:hover {
            background-color: rgba(255, 102, 0, 0.05);
        }

        /* Buttons */
        .btn-admin-primary {
            background: linear-gradient(135deg, var(--admin-primary) 0%, #e55a00 100%);
            border: none;
            color: var(--admin-white);
            font-weight: 600;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .btn-admin-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 102, 0, 0.3);
            color: var(--admin-white);
        }

        .btn-sm {
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 6px;
        }

        /* Badges */
        .badge {
            font-size: 0.75rem;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-weight: 600;
        }

        /* Modals */
        .modal-content {
            border-radius: 12px;
            border: none;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background: linear-gradient(135deg, var(--admin-primary) 0%, #e55a00 100%);
            color: var(--admin-white);
            border-radius: 12px 12px 0 0;
            border: none;
        }

        .modal-title {
            font-weight: 600;
        }

        .btn-close {
            filter: invert(1);
        }

        .modal-body {
            padding: 2rem;
        }

        .modal-footer {
            border: none;
            padding: 1rem 2rem 2rem;
        }

        /* Responsive */
        /* Reports specific styles */
.chart-container {
    position: relative;
    height: 400px;
    margin: 20px 0;
}

.table-hover tbody tr:hover {
    background-color: rgba(255, 102, 0, 0.075);
}

@media print {
    .no-print {
        display: none !important;
    }
    
    /* Print styles for reports */
    @page { 
        margin: 2cm; 
        size: A4;
    }
    
    body { 
        font-family: Arial, sans-serif; 
        color: #000;
        background: white;
    }
    
    .admin-header,
    .admin-sidebar,
    .btn-toolbar,
    .no-print {
        display: none !important;
    }
    
    .admin-main {
        width: 100% !important;
        margin: 0 !important;
        padding: 0 !important;
    }
    
    .reports-print-header {
        text-align: center;
        margin-bottom: 30px;
        border-bottom: 2px solid #333;
        padding-bottom: 20px;
    }
    
    .reports-print-header h1 {
        color: #ff6600;
        margin: 0;
        font-size: 24px;
        font-weight: bold;
    }
    
    .reports-print-header h2 {
        color: #333;
        margin: 10px 0;
        font-size: 18px;
    }
    
    .reports-print-header p {
        margin: 5px 0;
        color: #666;
        font-size: 14px;
    }
    
    table { 
        width: 100%; 
        border-collapse: collapse; 
        margin: 20px 0;
        font-size: 12px;
    }
    
    th, td { 
        border: 1px solid #333; 
        padding: 8px; 
        text-align: left; 
    }
    
    th { 
        background-color: #f5f5f5; 
        font-weight: bold; 
        color: #333;
    }
    
    .stat-card {
        border: 1px solid #333;
        margin: 10px 0;
        padding: 15px;
        page-break-inside: avoid;
    }
    
    .stat-value {
        font-size: 18px;
        font-weight: bold;
        color: #333;
    }
    
    .stat-label {
        font-size: 12px;
        color: #666;
        margin-bottom: 5px;
    }
    
    .chart-container {
        display: none; /* Hide charts in print */
    }
    
    .print-footer {
        position: fixed;
        bottom: 20px;
        width: 100%;
        text-align: center;
        font-size: 10px;
        color: #666;
        border-top: 1px solid #ccc;
        padding-top: 10px;
    }
    
    /* Page breaks */
    .page-break {
        page-break-before: always;
    }
    
    h1, h2, h3 {
        page-break-after: avoid;
    }
    
    /* Table page breaks */
    table {
        page-break-inside: auto;
    }
    
    tr {
        page-break-inside: avoid;
        page-break-after: auto;
    }
    
    thead {
        display: table-header-group;
    }
    
    /* Alert styles for print */
    .alert {
        border: 1px solid #333;
        padding: 10px;
        margin: 10px 0;
        background-color: #f9f9f9;
    }
    
    /* Enhanced print styles for reports */
    .badge {
        background-color: #f0f0f0 !important;
        color: #333 !important;
        border: 1px solid #333;
        padding: 2px 6px;
        border-radius: 3px;
    }
    
    .progress {
        border: 1px solid #333;
        background-color: #f9f9f9;
        height: 15px !important;
    }
    
    .progress-bar {
        background-color: #ccc !important;
        color: #333;
        text-align: center;
        line-height: 15px;
    }
    
    .text-success, .text-primary, .text-info, .text-warning, .text-danger {
        color: #333 !important;
    }
    
    .card {
        border: 1px solid #333;
        margin: 10px 0;
        page-break-inside: avoid;
    }
    
    .card-header {
        background-color: #f0f0f0 !important;
        border-bottom: 1px solid #333;
        font-weight: bold;
    }
    
    .card-body {
        padding: 15px;
    }
    
    .btn, .btn-group, .btn-toolbar {
        display: none !important;
    }
    
    .modal, .dropdown, .offcanvas {
        display: none !important;
    }
    
    /* Specific report print styles */
    .admin-table {
        border: 1px solid #333;
        overflow: visible;
    }
    
    .table-responsive {
        overflow: visible !important;
    }
    
    .chart-card {
        border: 1px solid #333;
        page-break-inside: avoid;
    }
    
    .report-section {
        page-break-before: auto;
        page-break-after: auto;
        page-break-inside: avoid;
    }
    
    /* Hide navigation and sidebar */
    .nav, .navbar, .sidebar, .admin-sidebar, .admin-header {
        display: none !important;
    }
    
    /* Make sure tables fit on page */
    table {
        font-size: 10px !important;
    }
    
    th, td {
        padding: 4px !important;
        word-wrap: break-word;
        max-width: 150px;
    }
    
    /* Print-specific headers and footers */
    .print-only {
        display: block !important;
    }
    
    .no-print, .no-print * {
        display: none !important;
        visibility: hidden !important;
    }
}
    </style>
</head>
<body class="dashboard-body"><!-- Admin Header -->
    <nav class="navbar navbar-expand-lg navbar-dark admin-header">
        <div class="container-fluid">
            <a class="admin-brand" href="#">
                <i class="fas fa-shield-alt"></i> Admin Panel - 43 Gundam Hobby
            </a>
            <div class="navbar-nav ms-auto d-flex align-items-center">
                <!-- User Info for OAuth -->
                <div id="nav-user-info" class="d-none"></div>
                
                <!-- Default navigation -->
                <div id="default-nav-items">
                    <a class="nav-link admin-nav-link" href="<%=request.getContextPath()%>/">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                    <a class="nav-link admin-nav-link" href="#" onclick="logout()">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </nav><div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block admin-sidebar">
                <div class="position-sticky sidebar-nav">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="#dashboard" data-bs-toggle="tab">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#products" data-bs-toggle="tab">
                                <i class="fas fa-box"></i> Quản lý sản phẩm
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#employees" data-bs-toggle="tab">
                                <i class="fas fa-users-cog"></i> Quản lý nhân viên
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#customers" data-bs-toggle="tab">
                                <i class="fas fa-users"></i> Quản lý khách hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#orders" data-bs-toggle="tab">
                                <i class="fas fa-shopping-cart"></i> Quản lý đơn hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#categories" data-bs-toggle="tab">
                                <i class="fas fa-tags"></i> Quản lý danh mục
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#reports" data-bs-toggle="tab">
                                <i class="fas fa-chart-bar"></i> Báo cáo
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 admin-main">
                <div class="tab-content" id="adminTabContent">
                      <!-- Dashboard Tab -->
                    <div class="tab-pane fade show active" id="dashboard">
                        <div class="page-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h1 class="page-title">
                                    <i class="fas fa-tachometer-alt me-3"></i>Dashboard Tổng Quan
                                </h1>
                                <div class="btn-toolbar">
                                    <button type="button" class="btn btn-admin-primary">
                                        <i class="fas fa-download me-2"></i>Xuất báo cáo
                                    </button>
                                </div>
                            </div>
                            <p class="text-muted mb-0">Tổng quan hoạt động kinh doanh của 43 Gundam Hobby</p>
                        </div>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card primary">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Doanh thu tháng này</div>
                                        <div class="stat-value" id="revenue"></div>
                                        <div class="stat-icon">
                                            <i class="fas fa-dollar-sign text-primary"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-success"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card success">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Đơn hàng tháng này</div>
                                        <div class="stat-value" id="orderCount"></div>
                                        <div class="stat-icon">
                                            <i class="fas fa-shopping-cart text-success"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-success"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card info">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Khách hàng mới</div>
                                        <div class="stat-value" id="newCustomers"></div>
                                        <div class="stat-icon">
                                            <i class="fas fa-user-plus text-info"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-info"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card warning">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Tổng sản phẩm</div>
                                        <div class="stat-value" id="totalProducts"></div>
                                        <div class="stat-icon">
                                            <i class="fas fa-box text-warning"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-warning" id="lowStockWarning"></small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Charts -->
                        <div class="row mb-4">
                            <div class="col-xl-8 col-lg-7 mb-4">
                                <div class="chart-card">
                                    <div class="chart-header">
                                        <h6 class="chart-title">
                                            <i class="fas fa-chart-line me-2"></i>Doanh Thu Theo Tháng
                                        </h6>
                                    </div>
                                    <div class="p-4">
                                        <canvas id="revenueChart" height="300"></canvas>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-4 col-lg-5 mb-4">
                                <div class="chart-card">
                                    <div class="chart-header">
                                        <h6 class="chart-title">
                                            <i class="fas fa-chart-pie me-2"></i>Sản Phẩm Bán Chạy
                                        </h6>
                                    </div>
                                    <div class="p-4">
                                        <canvas id="productChart" height="300"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Orders -->
                        <div class="row">
                            <div class="col-12">
                                <div class="admin-table">
                                    <div class="p-4 border-bottom">
                                        <h5 class="mb-0">
                                            <i class="fas fa-clock me-2"></i>Đơn Hàng Gần Đây
                                        </h5>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Mã đơn hàng</th>
                                                    <th>Khách hàng</th>
                                                    <th>Sản phẩm</th>
                                                    <th>Tổng tiền</th>
                                                    <th>Trạng thái</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <!-- Dữ liệu render bằng JavaScript hoặc backend, đã xóa mẫu -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>                    <!-- Products Management Tab -->
                    <div class="tab-pane fade" id="products">
                        <div class="page-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h1 class="page-title">
                                    <i class="fas fa-box me-3"></i>Quản Lý Sản Phẩm
                                </h1>
                                <button type="button" class="btn btn-admin-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                                </button>
                            </div>
                            <p class="text-muted mb-0">Quản lý toàn bộ sản phẩm Gundam trong cửa hàng</p>
                        </div>

                        <div class="admin-table">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Ảnh</th>
                                            <th>Tên sản phẩm</th>
                                            <th>Danh mục</th>
                                            <th>Giá</th>
                                            <th>Tồn kho</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Dữ liệu render bằng JavaScript hoặc backend, đã xóa mẫu -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <script>
  
                    
<!-- Employees Management Tab -->

</script>

<div class="tab-pane fade" id="employees">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h1 class="page-title">
                <i class="fas fa-users-cog me-2"></i>Quản lý nhân viên
            </h1>
            <button type="button" class="btn btn-admin-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                <i class="fas fa-plus me-2"></i>Thêm nhân viên mới
            </button>
        </div>
        <p class="text-muted mb-0">Danh sách tất cả nhân viên hệ thống</p>
    </div>
    
    <!-- Advanced Filters & Search for Staff -->
    <div class="card mb-4">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">
                    <i class="fas fa-filter me-2"></i>Bộ lọc nâng cao
                </h6>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="resetStaffFiltersBtn">
                    <i class="fas fa-undo me-1"></i>Đặt lại
                </button>
            </div>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <!-- Search Input -->
                <div class="col-md-4">
                    <label class="form-label small">Tìm kiếm</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="staffSearchInput" class="form-control" placeholder="Tên, email hoặc SĐT...">
                    </div>
                </div>
                
                <!-- Status Filter -->
                <div class="col-md-2">
                    <label class="form-label small">Trạng thái</label>
                    <select id="staffStatusFilter" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="active">Hoạt động</option>
                        <option value="inactive">Tạm ngưng</option>
                    </select>
                </div>
                
                <!-- Join Date Filter -->
                <div class="col-md-2">
                    <label class="form-label small">Ngày vào làm</label>
                    <select id="joinDateFilter" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="today">Hôm nay</option>
                        <option value="week">Tuần này</option>
                        <option value="month">Tháng này</option>
                        <option value="quarter">Quý này</option>
                        <option value="year">Năm này</option>
                        <option value="old">Cũ hơn</option>
                    </select>
                </div>
                
                <!-- Sort Options -->
                <div class="col-md-2">
                    <label class="form-label small">Sắp xếp</label>
                    <select id="staffSortFilter" class="form-select">
                        <option value="id_asc">ID ↑</option>
                        <option value="id_desc">ID ↓</option>
                        <option value="name_asc">Tên A-Z</option>
                        <option value="name_desc">Tên Z-A</option>
                        <option value="email_asc">Email A-Z</option>
                        <option value="email_desc">Email Z-A</option>
                        <option value="date_asc">Cũ nhất</option>
                        <option value="date_desc">Mới nhất</option>
                    </select>
                </div>
            </div>
            
            <!-- Filter Summary -->
            <div class="mt-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div id="staffFilterSummary" class="text-muted small">
                        <i class="fas fa-info-circle me-1"></i>
                        <span id="staffFilteredCount">0</span> / <span id="staffTotalCount">0</span> nhân viên
                    </div>
                    <div id="staffActiveFilters" class="d-flex gap-1 flex-wrap">
                        <!-- Active filter badges will be shown here -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="admin-table">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Chức vụ</th>
                        <th>Ngày vào làm</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody id="staffTableBody">
                    <!-- Dữ liệu render bằng JavaScript -->
                    
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Thêm Nhân Viên -->
<div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Thêm nhân viên mới</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <form id="addStaffForm">
        <div class="modal-body">
          <div class="row g-2">
            <div class="col-md-6">
              <label>Họ</label>
              <input type="text" name="firstName" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label>Tên</label>
              <input type="text" name="lastName" class="form-control" required>
            </div>
            <div class="col-12">
              <label>Email</label>
              <input type="email" name="email" class="form-control" required>
            </div>
            <div class="col-12">
              <label>Mật khẩu</label>
              <input type="password" name="password" class="form-control" required>
            </div>
            <div class="col-6">
              <label>Số điện thoại</label>
              <input type="text" name="phone" class="form-control">
            </div>
            <div class="col-6">
              <label>Ngày sinh</label>
              <input type="date" name="dateOfBirth" class="form-control">
            </div>
            <div class="col-6">
              <label>Giới tính</label>
              <select name="gender" class="form-control">
                <option value="MALE">Nam</option>
                <option value="FEMALE">Nữ</option>
                <option value="OTHER">Khác</option>
              </select>
            </div>
            <div class="col-6">
              <label>Địa chỉ</label>
              <input type="text" name="address" class="form-control">
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Lưu nhân viên</button>
        </div>
      </form>
    </div>
  </div>
</div>
<!-- Modal Chỉnh sửa Nhân Viên -->
<div class="modal fade" id="editStaffModal" tabindex="-1" aria-labelledby="editStaffModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
    
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title" id="editStaffModalLabel">Chỉnh sửa nhân viên</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      
      <div class="modal-body">
        <!-- ✅ ĐÃ THÊM DÒNG BẮT BUỘC -->
        <input type="hidden" id="editId">

        <div class="row g-3">
          <div class="col-md-6">
            <label for="editFirstName" class="form-label">Họ <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="editFirstName" required>
          </div>

          <div class="col-md-6">
            <label for="editLastName" class="form-label">Tên <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="editLastName" required>
          </div>

          <div class="col-md-6">
            <label for="editEmail" class="form-label">Email <span class="text-danger">*</span></label>
            <input type="email" class="form-control" id="editEmail" required>
          </div>

          <div class="col-md-6">
            <label for="editPhone" class="form-label">Số điện thoại <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="editPhone" required>
          </div>

          <div class="col-md-6">
            <label for="editDateOfBirth" class="form-label">Ngày sinh <span class="text-danger">*</span></label>
            <input type="date" class="form-control" id="editDateOfBirth" required>
          </div>

          <div class="col-md-6">
            <label for="editGender" class="form-label">Giới tính <span class="text-danger">*</span></label>
            <select class="form-control" id="editGender" required>
              <option value="">-- Chọn giới tính --</option>
              <option value="MALE">Nam</option>
              <option value="FEMALE">Nữ</option>
              <option value="OTHER">Khác</option>
            </select>
          </div>

          <div class="col-12">
            <label for="editAddress" class="form-label">Địa chỉ <span class="text-danger">*</span></label>
            <textarea class="form-control" id="editAddress" rows="3" required></textarea>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <button type="button" class="btn btn-success" onclick="saveStaffUpdate()">Lưu</button>
      </div>

    </div>
  </div>
</div>




                    <!-- Customers Management Tab -->
                    <div class="tab-pane fade" id="customers">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h1 class="page-title">
                <i class="fas fa-users me-2"></i>Quản lý khách hàng
            </h1>
        </div>
        <p class="text-muted mb-0">Danh sách tất cả khách hàng hệ thống</p>
    </div>
    
    <!-- Advanced Filters & Search for Customers -->
    <div class="card mb-4">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">
                    <i class="fas fa-filter me-2"></i>Bộ lọc nâng cao
                </h6>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="resetCustomerFiltersBtn">
                    <i class="fas fa-undo me-1"></i>Đặt lại
                </button>
            </div>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <!-- Search Input -->
                <div class="col-md-4">
                    <label class="form-label small">Tìm kiếm</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" id="customerSearchInputAdvanced" class="form-control" placeholder="Tên, email, số điện thoại...">
                    </div>
                </div>
                <!-- Gender Filter -->
                <div class="col-md-2">
                    <label class="form-label small">Giới tính</label>
                    <select id="customerGenderFilter" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="MALE">Nam</option>
                        <option value="FEMALE">Nữ</option>
                        <option value="OTHER">Khác</option>
                    </select>
                </div>
                <!-- Order Count Filter -->
                <div class="col-md-2">
                    <label class="form-label small">Số đơn hàng</label>
                    <select id="customerOrderFilter" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="new">Mới (0)</option>
                        <option value="low">Ít (1-5)</option>
                        <option value="medium">Trung bình (6-15)</option>
                        <option value="high">Nhiều (>15)</option>
                    </select>
                </div>
                <!-- Registration Date Filter -->
                <div class="col-md-2">
                    <label class="form-label small">Ngày đăng ký</label>
                    <select id="customerDateFilter" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="today">Hôm nay</option>
                        <option value="week">Tuần này</option>
                        <option value="month">Tháng này</option>
                        <option value="old">Cũ hơn</option>
                    </select>
                </div>
            </div>
            <!-- Filter Summary -->
            <div class="mt-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div id="customerFilterSummary" class="text-muted small">
                        <i class="fas fa-info-circle me-1"></i>
                        <span id="customerFilteredCount">0</span> / <span id="customerTotalCount">0</span> khách hàng
                    </div>
                    <div id="customerActiveFilters" class="d-flex gap-1 flex-wrap">
                        <!-- Active filter badges will be shown here -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="admin-table">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên khách hàng</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Ngày đăng ký</th>
                        <th>Tổng đơn hàng</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody id="customerTableBody">
                    <!-- Dữ liệu render bằng JavaScript -->
                </tbody>
            </table>
        </div>
    </div>
</div>
<!-- Modal: Xem chi tiết khách hàng -->
<div class="modal fade" id="viewCustomerModal" tabindex="-1" aria-labelledby="viewCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-info text-white">
        <h5 class="modal-title" id="viewCustomerModalLabel">Chi tiết khách hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <div class="modal-body">
        <ul class="list-group">
          <li class="list-group-item"><strong>ID:</strong> <span id="viewCusId"></span></li>
          <li class="list-group-item"><strong>Họ tên:</strong> <span id="viewCusName"></span></li>
          <li class="list-group-item"><strong>Email:</strong> <span id="viewCusEmail"></span></li>
          <li class="list-group-item"><strong>Số điện thoại:</strong> <span id="viewCusPhone"></span></li>
          <li class="list-group-item"><strong>Ngày sinh:</strong> <span id="viewCusDob"></span></li>
          <li class="list-group-item"><strong>Giới tính:</strong> <span id="viewCusGender"></span></li>
          <li class="list-group-item"><strong>Địa chỉ:</strong> <span id="viewCusAddress"></span></li>
          <li class="list-group-item"><strong>Ngày đăng ký:</strong> <span id="viewCusCreated"></span></li>
        </ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
      </div>
    </div>
  </div>
</div>
<!-- Modal: Sửa thông tin khách hàng -->
<div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title" id="editCustomerModalLabel">Chỉnh sửa khách hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <form id="editCustomerForm">
        <div class="modal-body">
          <input type="hidden" id="editCusId">
          <div class="mb-3">
            <label for="editCusFirstName" class="form-label">Họ</label>
            <input type="text" class="form-control" id="editCusFirstName" required>
          </div>
          <div class="mb-3">
            <label for="editCusLastName" class="form-label">Tên</label>
            <input type="text" class="form-control" id="editCusLastName" required>
          </div>
          <div class="mb-3">
            <label for="editCusEmail" class="form-label">Email</label>
            <input type="email" class="form-control" id="editCusEmail" required>
          </div>
          <div class="mb-3">
            <label for="editCusPhone" class="form-label">Số điện thoại</label>
            <input type="text" class="form-control" id="editCusPhone">
          </div>
          <div class="mb-3">
            <label for="editCusDob" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="editCusDob">
          </div>
          <div class="mb-3">
            <label for="editCusGender" class="form-label">Giới tính</label>
            <select class="form-control" id="editCusGender">
              <option value="MALE">Nam</option>
              <option value="FEMALE">Nữ</option>
              <option value="OTHER">Khác</option>
            </select>
          </div>
          <div class="mb-3">
            <label for="editCusAddress" class="form-label">Địa chỉ</label>
            <input type="text" class="form-control" id="editCusAddress">
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>

                    <!-- Categories Management Tab -->
                    <div class="tab-pane fade" id="categories">
                        <div class="page-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h1 class="page-title">
                                    <i class="fas fa-tags me-2"></i>Quản lý danh mục
                                </h1>
                                <button type="button" class="btn btn-admin-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                                    <i class="fas fa-plus me-2"></i>Thêm danh mục mới
                                </button>
                            </div>
                            <p class="text-muted mb-0">Danh sách tất cả danh mục sản phẩm</p>
                        </div>
                        
                        <!-- Advanced Filters & Search -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0">
                                        <i class="fas fa-filter me-2"></i>Bộ lọc nâng cao
                                    </h6>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" id="resetFiltersBtn">
                                        <i class="fas fa-undo me-1"></i>Đặt lại
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <!-- Search Input -->
                                    <div class="col-md-4">
                                        <label class="form-label small">Tìm kiếm</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                                            <input type="text" id="categorySearchInput" class="form-control" placeholder="Tên hoặc mô tả danh mục...">
                                        </div>
                                    </div>
                                    
                                    <!-- Status Filter -->
                                    <div class="col-md-2">
                                        <label class="form-label small">Trạng thái</label>
                                        <select id="statusFilter" class="form-select">
                                            <option value="">Tất cả</option>
                                            <option value="active">Hoạt động</option>
                                            <option value="inactive">Tạm ẩn</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Product Count Filter -->
                                    <div class="col-md-2">
                                        <label class="form-label small">Số sản phẩm</label>
                                        <select id="productCountFilter" class="form-select">
                                            <option value="">Tất cả</option>
                                            <option value="empty">Trống (0)</option>
                                            <option value="low">Ít (1-5)</option>
                                            <option value="medium">Trung bình (6-15)</option>
                                            <option value="high">Nhiều (>15)</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Date Filter -->
                                    <div class="col-md-2">
                                        <label class="form-label small">Ngày tạo</label>
                                        <select id="dateFilter" class="form-select">
                                            <option value="">Tất cả</option>
                                            <option value="today">Hôm nay</option>
                                            <option value="week">Tuần này</option>
                                            <option value="month">Tháng này</option>
                                            <option value="old">Cũ hơn</option>
                                        </select>
                                    </div>
                                    
                                    <!-- Sort Options -->
                                    <div class="col-md-2">
                                        <label class="form-label small">Sắp xếp</label>
                                        <select id="sortFilter" class="form-select">
                                            <option value="id_asc">ID ↑</option>
                                            <option value="id_desc">ID ↓</option>
                                            <option value="name_asc">Tên A-Z</option>
                                            <option value="name_desc">Tên Z-A</option>
                                            <option value="date_asc">Cũ nhất</option>
                                            <option value="date_desc">Mới nhất</option>
                                            <option value="products_asc">Ít SP nhất</option>
                                            <option value="products_desc">Nhiều SP nhất</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <!-- Filter Summary -->
                                <div class="mt-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div id="filterSummary" class="text-muted small">
                                            <i class="fas fa-info-circle me-1"></i>
                                            <span id="filteredCount">0</span> / <span id="totalCount">0</span> danh mục
                                        </div>
                                        <div id="activeFilters" class="d-flex gap-1 flex-wrap">
                                            <!-- Active filter badges will be shown here -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="admin-table">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên danh mục</th>
                                            <th>Mô tả</th>
                                            <th>Ngày tạo</th>
                                            <th>Sản phẩm bán được</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody id="categoryTableBody">
                                        <!-- Dữ liệu render bằng JavaScript -->
                                        <!-- Ví dụ mẫu, sẽ render động bằng JS thực tế -->
                                        <!--
                                        <tr>
                                            <td>1</td>
                                            <td>Real Grade</td>
                                            <td>Dòng sản phẩm chi tiết cao</td>
                                            <td>2024-06-26</td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1" onclick="editCategory(1)"><i class="fas fa-edit"></i></button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(1)"><i class="fas fa-trash"></i></button>
                                            </td>
                                        </tr>
                                        -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- Modal: Thêm danh mục -->
                    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title" id="addCategoryModalLabel">Thêm danh mục mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                          </div>
                          <form id="addCategoryForm">
                            <div class="modal-body">
                              <div class="mb-3">
                                <label for="categoryName" class="form-label">Tên danh mục</label>
                                <input type="text" class="form-control" id="categoryName" required>
                              </div>
                              <div class="mb-3">
                                <label for="categoryDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="categoryDescription" rows="2"></textarea>
                              </div>
                              <div class="mb-3">
                                <label for="categoryParent" class="form-label">Danh mục cha</label>
                                <select class="form-select" id="categoryParent">
                                  <option value="">Không có</option>
                                  <!-- Render động các option danh mục cha bằng JS nếu cần -->
                                </select>
                              </div>
                              <div class="mb-3">
                                <label for="categoryActive" class="form-label">Trạng thái</label>
                                <select class="form-select" id="categoryActive">
                                  <option value="true" selected>Kích hoạt</option>
                                  <option value="false">Ẩn</option>
                                </select>
                              </div>
                            </div>
                            <div class="modal-footer">
                              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                              <button type="submit" class="btn btn-primary">Lưu danh mục</button>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                    <!-- Modal: Sửa danh mục -->
                    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-warning text-dark">
        <h5 class="modal-title" id="editCategoryModalLabel">Chỉnh sửa danh mục</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
      </div>
      <form id="editCategoryForm">
        <div class="modal-body">
          <input type="hidden" id="editCategoryId">
          <div class="mb-3">
            <label for="editCategoryName" class="form-label">Tên danh mục</label>
            <input type="text" class="form-control" id="editCategoryName" required>
          </div>
          <div class="mb-3">
            <label for="editCategoryDescription" class="form-label">Mô tả</label>
            <textarea class="form-control" id="editCategoryDescription" rows="2"></textarea>
          </div>
          <div class="mb-3">
            <label for="editCategoryParent" class="form-label">Danh mục cha</label>
            <select class="form-select" id="editCategoryParent">
              <option value="">Không có</option>
              <!-- Render động các option danh mục cha bằng JS nếu cần -->
            </select>
          </div>
          <div class="mb-3">
            <label for="editCategoryActive" class="form-label">Trạng thái</label>
            <select class="form-select" id="editCategoryActive">
              <option value="true">Kích hoạt</option>
              <option value="false">Ẩn</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-warning">Lưu thay đổi</button>
        </div>
      </form>
    </div>
  </div>
</div>
                    <!-- Orders Management Tab -->
                    <div class="tab-pane fade" id="orders">
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Quản lý đơn hàng</h1>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Mã đơn hàng</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>#DH001</td>
                                        <td>Trần Thị B</td>
                                        <td>20/06/2024</td>
                                        <td>1,650,000đ</td>
                                        <td><span class="badge bg-warning">Đang xử lý</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-info">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Reports Tab -->
                    <div class="tab-pane fade" id="reports">
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <h1 class="page-title" id="reportTitle">
                <i class="fas fa-chart-bar me-3"></i>📊 Báo cáo
            </h1>
            <div class="btn-toolbar mb-2 mb-md-0 no-print">
                <div class="btn-group me-2">
                    <button type="button" class="btn btn-outline-secondary" id="exportExcel" disabled>
                        <i class="fas fa-file-excel me-1"></i>Excel
                    </button>
                    <!-- XÓA NÚT PDF: Đã loại bỏ nút xuất PDF -->
                    <button id="exportPrintBtn" class="btn btn-outline-secondary">
                        <i class="fas fa-print"></i> In
                    </button>
                </div>
            </div>
        </div>
        <p class="text-muted mb-0">Tổng quan và phân tích dữ liệu kinh doanh 43 Gundam Hobby</p>
    </div>

    <!-- Reports Filters -->
    <div class="card mb-4">
        <div class="card-header">
            <h6><i class="fas fa-filter me-2"></i>Bộ lọc báo cáo</h6>
        </div>
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3 mb-3">
                    <label class="form-label fw-bold">Loại báo cáo:</label>
                    <select id="reportType" class="form-select">
                        <option value="revenue">📈 Báo cáo doanh thu</option>
                        <option value="top-products">🏆 Sản phẩm bán chạy</option>
                        <option value="category">📂 Doanh thu theo danh mục</option>
                    </select>
                </div>
                <div class="col-md-2 mb-3" id="periodTypeContainer">
                    <label class="form-label fw-bold">Nhóm theo:</label>
                    <select id="periodType" class="form-select">
                        <option value="day">📅 Theo ngày</option>
                        <option value="month">📆 Theo tháng</option>
                        <option value="year">🗓️ Theo năm</option>
                    </select>
                </div>
                <div class="col-md-2 mb-3" id="startDateContainer">
                    <label class="form-label fw-bold">Từ ngày:</label>
                    <input type="date" id="startDate" class="form-control">
                </div>
                <div class="col-md-2 mb-3" id="endDateContainer">
                    <label class="form-label fw-bold">Đến ngày:</label>
                    <input type="date" id="endDate" class="form-control">
                </div>
                <div class="col-md-2 mb-3" id="monthPickerContainer" style="display:none;">
                    <label class="form-label fw-bold">Chọn tháng:</label>
                    <input type="month" id="monthPicker" class="form-control" />
                </div>
                <div class="col-md-2 mb-3" id="yearPickerContainer" style="display:none;">
                    <label class="form-label fw-bold">Chọn năm:</label>
                    <input type="number" id="yearPicker" class="form-control" min="2000" max="2100" placeholder="Năm" />
                </div>
                <div class="col-md-3 mb-3 d-flex align-items-end">
                    <button type="button" class="btn btn-admin-primary w-100" id="generateReport">
                        <i class="fas fa-chart-line me-2"></i>Tạo báo cáo
                    </button>
                </div>
        </div>
    </div>

    <!-- Quick Stats Row -->
    <div class="row mb-4" id="quickStatsRow" style="display: none;">
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="stat-card primary">
                <div class="stat-card-body">
                    <div class="stat-label">Tổng đơn hàng</div>
                    <div class="stat-value" id="totalOrders">0</div>
                    <div class="stat-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="stat-card success">
                <div class="stat-card-body">
                    <div class="stat-label">Tổng doanh thu</div>
                    <div class="stat-value" id="totalRevenue">0₫</div>
                    <div class="stat-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="stat-card info">
                <div class="stat-card-body">
                    <div class="stat-label">Đã giao hàng</div>
                    <div class="stat-value" id="deliveredOrders">0</div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="stat-card warning">
                <div class="stat-card-body">
                    <div class="stat-label">Giá trị TB/đơn</div>
                    <div class="stat-value" id="averageOrderValue">0₫</div>
                    <div class="stat-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Chart Container -->
    <div class="row mb-4" id="chartContainer" style="display: none;">
        <div class="col-12">
            <div class="chart-card">
                <div class="chart-header">
                    <h6 class="chart-title">
                        <i class="fas fa-chart-area me-2"></i>Biểu đồ phân tích
                    </h6>
                </div>
                <div class="p-4">
                    <div class="chart-container">
                        <canvas id="reportChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Report Content -->
    <div class="row">
        <div class="col-12">
            <div class="admin-table">
                <div class="p-4 border-bottom">
                    <h5 class="mb-0">
                        <i class="fas fa-table me-2"></i>Dữ liệu báo cáo
                    </h5>
                </div>
                <div id="reportContent">
                    <div class="text-center py-5 text-muted">
                        <i class="fas fa-chart-bar fa-3x mb-3 opacity-50"></i>
                        <p>Chọn loại báo cáo và nhấn "Tạo báo cáo" để bắt đầu</p>
                        <small class="text-muted">
                            Hệ thống hỗ trợ 3 loại báo cáo chính với biểu đồ trực quan
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
    </div>    <!-- Add Product Modal -->
    <div class="modal fade" id="addProductModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addProductForm">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="productName" class="form-label">Tên sản phẩm</label>
                                    <input type="text" class="form-control" id="productName" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="productCategory" class="form-label">Danh mục</label>
                                    <select class="form-select" id="productCategory" required>
                                        <option value="">Chọn danh mục</option>
                                        <option value="RG">Real Grade (RG)</option>
                                        <option value="MG">Master Grade (MG)</option>
                                        <option value="PG">Perfect Grade (PG)</option>
                                        <option value="HG">High Grade (HG)</option>
                                        <option value="SD">Super Deformed (SD)</option>
                                        <option value="MB">Metal Build (MB)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="productPrice" class="form-label">Giá (VNĐ)</label>
                                    <input type="number" class="form-control" id="productPrice" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="productStock" class="form-label">Số lượng tồn kho</label>
                                    <input type="number" class="form-control" id="productStock" required>
                                </div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Mô tả</label>
                            <textarea class="form-control" id="productDescription" rows="3" placeholder="Nhập mô tả chi tiết về sản phẩm..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="productImage" class="form-label">Hình ảnh</label>
                            <input type="file" class="form-control" id="productImage" accept="image/*">
                            <div class="form-text">Chỉ chấp nhận file ảnh (JPG, PNG, GIF)</div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <button type="button" class="btn btn-admin-primary" onclick="saveProduct()">
                        <i class="fas fa-save me-2"></i>Lưu sản phẩm
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Doanh thu (triệu VNĐ)',
                        data: [80, 95, 110, 125, 140, 125],
                        borderColor: '#ff6600',
                        backgroundColor: 'rgba(255, 102, 0, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Product Chart
            const productCtx = document.getElementById('productChart').getContext('2d');
            new Chart(productCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Real Grade', 'Master Grade', 'High Grade', 'Perfect Grade'],
                    datasets: [{
                        data: [35, 25, 30, 10],
                        backgroundColor: [
                            '#ff6600',
                            '#0066cc',
                            '#28a745',
                            '#ffc107'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        }
                    }
                }
            });
        });        // Admin functions
        function editProduct(id) {
            alert('Chức năng chỉnh sửa sản phẩm #' + id);
        }

        function deleteProduct(id) {
            if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
                alert('Đã xóa sản phẩm #' + id);
            }
        }

        function saveProduct() {
            const form = document.getElementById('addProductForm');
            if (form.checkValidity()) {
                alert('Đã thêm sản phẩm mới thành công!');
                bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
                form.reset();
            } else {
                form.reportValidity();
            }
        }

        // Tab management
        document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
            tab.addEventListener('click', function(e) {
                e.preventDefault();
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });
                this.classList.add('active');
            });        });
            // Common utility functions for reports
function formatCurrency(amount) {
    if (amount === null || amount === undefined) return '0₫';
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function formatDate(dateString) {
    if (!dateString) return '';
    return new Date(dateString).toLocaleDateString('vi-VN');
}

function showAlert(type, message) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.innerHTML = `
        <i class="fas fa-info-circle me-2"></i>
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    const container = document.querySelector('.container-fluid');
    container.insertBefore(alertDiv, container.firstChild);
    
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
}

// Status/Payment functions
function getStatusText(status) {
    const statusMap = {
        'PENDING': 'Chờ xử lý',
        'CONFIRMED': 'Đã xác nhận', 
        'SHIPPING': 'Đang giao',
        'DELIVERED': 'Đã giao',
        'CANCELLED': 'Đã hủy'
    };
    return statusMap[status] || status;
}

function getStatusBadgeClass(status) {
    const classMap = {
        'PENDING': 'warning',
        'CONFIRMED': 'info',
        'SHIPPING': 'primary', 
        'DELIVERED': 'success',
        'CANCELLED': 'danger'
    };
    return classMap[status] || 'secondary';
}

function getStatusIcon(status) {
    const iconMap = {
        'PENDING': '⏳',
        'CONFIRMED': '✅',
        'SHIPPING': '🚚',
        'DELIVERED': '📦',
        'CANCELLED': '❌'
    };
    return iconMap[status] || '📋';
}

function getPaymentText(method) {
    const methodMap = {
        'COD': 'Thanh toán khi nhận hàng',
        'BANK_TRANSFER': 'Chuyển khoản ngân hàng',
        'MOMO': 'Ví MoMo',
        'VNPAY': 'VNPay'
    };
    return methodMap[method] || method;
}

function getPaymentBadgeClass(method) {
    const classMap = {
        'COD': 'warning',
        'BANK_TRANSFER': 'primary',
        'MOMO': 'info',
        'VNPAY': 'success'
    };
    return classMap[method] || 'secondary';
}

function getPaymentIcon(method) {
    const iconMap = {
        'COD': '💵',
        'BANK_TRANSFER': '🏦',
        'MOMO': '📱',
        'VNPAY': '💳'
    };
    return iconMap[method] || '💰';
}
    </script>
    
    <!-- Auth script for logout functionality -->
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    
    <script>
        // Check admin access on page load
        document.addEventListener('DOMContentLoaded', function() {
            checkPageAccess('ADMIN');
        });
        
    </script>
    <!-- Loading Overlay -->
    <div id="loadingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; justify-content: center; align-items: center;">
        <div class="text-center text-white">
            <div class="spinner-border mb-3" role="status" style="width: 3rem; height: 3rem;">
                <span class="visually-hidden">Loading...</span>
            </div>
            <h5>Đang tạo báo cáo...</h5>
        </div>
    </div>

    <!-- Load reports script -->
<script src="<%=request.getContextPath()%>/js/reports-management.js"></script>
   <script src="<%=request.getContextPath()%>/js/staff-management.js"></script>
   <script src="<%=request.getContextPath()%>/js/customer-management.js"></script>
   <script src="<%=request.getContextPath()%>/js/category-management.js"></script>
   <script>
    fetch('/api/dashboard')
      .then(res => res.json())
      .then(data => {
        document.getElementById('revenue').textContent = data.revenueThisMonth;
        document.getElementById('orderCount').textContent = data.orderCountThisMonth;
        document.getElementById('newCustomers').textContent = data.newCustomersThisMonth;
        document.getElementById('totalProducts').textContent = data.totalProducts;
        if (data.lowStockProducts > 0) {
          document.getElementById('lowStockWarning').innerHTML =
            '<i class="fas fa-exclamation-triangle me-1"></i>' +
            data.lowStockProducts + ' sản phẩm sắp hết hàng';
        } else {
          document.getElementById('lowStockWarning').textContent = '';
        }
      })
      .catch(err => console.error('Dashboard API error:', err));
    </script>
</body>
</html>