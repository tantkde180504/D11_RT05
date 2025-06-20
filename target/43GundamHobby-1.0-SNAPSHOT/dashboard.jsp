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
        @media (max-width: 991.98px) {
            .admin-main {
                padding: 1rem;
            }
            
            .page-header {
                padding: 1.5rem;
            }
            
            .stat-card-body {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Admin Header -->
    <nav class="navbar navbar-expand-lg navbar-dark admin-header">
        <div class="container-fluid">
            <a class="admin-brand" href="#">
                <i class="fas fa-shield-alt"></i> Admin Panel - 43 Gundam Hobby
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link admin-nav-link" href="<%=request.getContextPath()%>/">
                    <i class="fas fa-home me-2"></i>Về trang chủ
                </a>
                <a class="nav-link admin-nav-link" href="#" onclick="logout()">
                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                </a>
            </div>
        </div>
    </nav>    <div class="container-fluid">
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
                                        <div class="stat-value">125,450,000₫</div>
                                        <div class="stat-icon">
                                            <i class="fas fa-dollar-sign text-primary"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-success">
                                                <i class="fas fa-arrow-up me-1"></i>+12.5% so với tháng trước
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card success">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Đơn hàng tháng này</div>
                                        <div class="stat-value">245</div>
                                        <div class="stat-icon">
                                            <i class="fas fa-shopping-cart text-success"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-success">
                                                <i class="fas fa-arrow-up me-1"></i>+8.3% so với tháng trước
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card info">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Khách hàng mới</div>
                                        <div class="stat-value">67</div>
                                        <div class="stat-icon">
                                            <i class="fas fa-user-plus text-info"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-info">
                                                <i class="fas fa-arrow-up me-1"></i>+15.2% so với tháng trước
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xl-3 col-md-6 mb-4">
                                <div class="stat-card warning">
                                    <div class="stat-card-body">
                                        <div class="stat-label">Tổng sản phẩm</div>
                                        <div class="stat-value">127</div>
                                        <div class="stat-icon">
                                            <i class="fas fa-box text-warning"></i>
                                        </div>
                                        <div class="mt-2">
                                            <small class="text-warning">
                                                <i class="fas fa-exclamation-triangle me-1"></i>5 sản phẩm sắp hết hàng
                                            </small>
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
                                                <tr>
                                                    <td><strong>#DH001</strong></td>
                                                    <td>Trần Thị B</td>
                                                    <td>RG RX-78-2 Gundam</td>
                                                    <td><strong>650,000₫</strong></td>
                                                    <td><span class="badge bg-warning">Đang xử lý</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-success">
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>#DH002</strong></td>
                                                    <td>Nguyễn Văn C</td>
                                                    <td>MG Wing Gundam Zero</td>
                                                    <td><strong>1,200,000₫</strong></td>
                                                    <td><span class="badge bg-success">Hoàn thành</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-info">
                                                            <i class="fas fa-print"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><strong>#DH003</strong></td>
                                                    <td>Lê Thị D</td>
                                                    <td>HG Strike Freedom</td>
                                                    <td><strong>450,000₫</strong></td>
                                                    <td><span class="badge bg-info">Đang giao</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary me-1">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-warning">
                                                            <i class="fas fa-truck"></i>
                                                        </button>
                                                    </td>
                                                </tr>
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
                                        <tr>
                                            <td><strong>001</strong></td>
                                            <td><img src="https://via.placeholder.com/50x50/cccccc/666666?text=RG" class="img-thumbnail" alt="Product"></td>
                                            <td><strong>RG RX-78-2 Gundam</strong></td>
                                            <td><span class="badge bg-info">Real Grade</span></td>
                                            <td><strong>650,000₫</strong></td>
                                            <td>25</td>
                                            <td><span class="badge bg-success">Có sẵn</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1" onclick="editProduct(1)">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(1)">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>002</strong></td>
                                            <td><img src="https://via.placeholder.com/50x50/cccccc/666666?text=MG" class="img-thumbnail" alt="Product"></td>
                                            <td><strong>MG Wing Gundam Zero</strong></td>
                                            <td><span class="badge bg-primary">Master Grade</span></td>
                                            <td><strong>1,200,000₫</strong></td>
                                            <td>15</td>
                                            <td><span class="badge bg-success">Có sẵn</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>003</strong></td>
                                            <td><img src="https://via.placeholder.com/50x50/cccccc/666666?text=PG" class="img-thumbnail" alt="Product"></td>
                                            <td><strong>PG Unicorn Gundam</strong></td>
                                            <td><span class="badge bg-warning">Perfect Grade</span></td>
                                            <td><strong>3,500,000₫</strong></td>
                                            <td>3</td>
                                            <td><span class="badge bg-warning">Sắp hết</span></td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-warning me-1">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <script>
  document.querySelector("#addStaffForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const data = {
      firstName: document.querySelector('input[name="firstName"]').value,
      lastName: document.querySelector('input[name="lastName"]').value,
      email: document.querySelector('input[name="email"]').value,
      password: document.querySelector('input[name="password"]').value,
      phone: document.querySelector('input[name="phone"]').value,
      dateOfBirth: document.querySelector('input[name="dateOfBirth"]').value,
      gender: document.querySelector('select[name="gender"]').value,
      address: document.querySelector('input[name="address"]').value
    };

    fetch("/api/staffs/create", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
    .then(res => {
      if (!res.ok) throw res;
      return res.json();
    })
    .then(result => {
      alert("✅ Tạo nhân viên thành công!");
      location.reload();
    })
    .catch(err => {
      err.text().then(msg => alert("❌ Lỗi: " + msg));
    });
  });
</script>


                    
<!-- Employees Management Tab -->
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

    <div class="admin-table">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên</th>
                        <th>Email</th>
                        <th>Chức vụ</th>
                        <th>Ngày vào làm</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>Nguyễn Văn A</td>
                        <td>nguyenvana@74gundam.com</td>
                        <td>Quản lý</td>
                        <td>01/01/2023</td>
                        <td><span class="badge bg-success">Hoạt động</span></td>
                        <td>
                            <button class="btn btn-sm btn-warning">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
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

<script>
  document.querySelector("#addStaffForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const data = {
      firstName: document.querySelector('input[name="firstName"]').value,
      lastName: document.querySelector('input[name="lastName"]').value,
      email: document.querySelector('input[name="email"]').value,
      password: document.querySelector('input[name="password"]').value,
      phone: document.querySelector('input[name="phone"]').value,
      dateOfBirth: document.querySelector('input[name="dateOfBirth"]').value,
      gender: document.querySelector('select[name="gender"]').value,
      address: document.querySelector('input[name="address"]').value
    };

    fetch("/api/staffs/create", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
    .then(res => {
      if (!res.ok) throw res;
      return res.json();
    })
    .then(result => {
      alert("✅ Tạo nhân viên thành công!");
      location.reload();
    })
    .catch(err => {
      err.text().then(msg => alert("❌ Lỗi: " + msg));
    });
  });
</script>


                    <!-- Customers Management Tab -->
                    <div class="tab-pane fade" id="customers">
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Quản lý khách hàng</h1>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-dark">
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
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>Trần Thị B</td>
                                        <td>tranthib@email.com</td>
                                        <td>0901234567</td>
                                        <td>15/03/2024</td>
                                        <td>3</td>
                                        <td>
                                            <button class="btn btn-sm btn-info">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-warning">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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
                        <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                            <h1 class="h2">Báo cáo</h1>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5>Báo cáo doanh thu</h5>
                                    </div>
                                    <div class="card-body">
                                        <form>
                                            <div class="mb-3">
                                                <label for="reportType" class="form-label">Loại báo cáo</label>
                                                <select class="form-select" id="reportType">
                                                    <option value="daily">Theo ngày</option>
                                                    <option value="monthly">Theo tháng</option>
                                                    <option value="yearly">Theo năm</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="dateRange" class="form-label">Khoảng thời gian</label>
                                                <input type="date" class="form-control" id="dateFrom">
                                                <input type="date" class="form-control mt-2" id="dateTo">
                                            </div>
                                            <button type="button" class="btn btn-primary" onclick="generateReport()">
                                                <i class="fas fa-chart-line"></i> Tạo báo cáo
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5>Xuất báo cáo</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-grid gap-2">
                                            <button class="btn btn-success" onclick="exportExcel()">
                                                <i class="fas fa-file-excel"></i> Xuất Excel
                                            </button>
                                            <button class="btn btn-danger" onclick="exportPDF()">
                                                <i class="fas fa-file-pdf"></i> Xuất PDF
                                            </button>
                                            <button class="btn btn-info" onclick="printReport()">
                                                <i class="fas fa-print"></i> In báo cáo
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
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
    </script>
    
    <!-- Auth script for logout functionality -->
    <script src="<%=request.getContextPath()%>/js/auth.js"></script>
    
    <script>
        // Check admin access on page load
        document.addEventListener('DOMContentLoaded', function() {
            checkPageAccess('ADMIN');
        });
    </script>
</body>
</html>
