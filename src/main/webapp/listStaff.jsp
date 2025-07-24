<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Danh sách nhân viên</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container py-4">

    <h2>Danh sách nhân viên</h2>

    <!-- Nút mở modal -->
    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addStaffModal">
        + Thêm nhân viên mới
    </button>

    <!-- Bảng nhân viên -->
    <table class="table table-bordered">
        <thead class="table-light">
            <tr>
                <th>ID</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>Chức vụ</th>
                <th>Ngày sinh</th>
                <th>Ngày vào làm</th>
                <th>Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="staff" items="${staffList}">
                <tr>
                    <td>${staff.id}</td>
                    <td>${staff.fullName}</td>
                    <td>${staff.email}</td>
                    <td>${staff.position}</td>
                    <td>${staff.birthDate}</td>
                    <td>${staff.startDate}</td>
                    <td>
                        <span class="badge ${staff.status == 'Hoạt động' ? 'bg-success' : 'bg-warning'}">
                            ${staff.status}
                        </span>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Modal thêm nhân viên -->
    <div class="modal fade" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/admin/staffs/create" method="post">
                    <div class="modal-header bg-warning">
                        <h5 class="modal-title" id="addStaffModalLabel">+ Thêm nhân viên mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>

                    <div class="modal-body">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label>Họ tên:</label>
                                <input name="fullName" type="text" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label>Email:</label>
                                <input name="email" type="email" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label>Chức vụ:</label>
                                <input name="position" type="text" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label>Ngày sinh:</label>
                                <input name="birthDate" type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label>Ngày vào làm:</label>
                                <input name="startDate" type="date" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label>Trạng thái:</label>
                                <select name="status" class="form-select">
                                    <option value="Hoạt động">Hoạt động</option>
                                    <option value="Ngưng hoạt động">Ngưng hoạt động</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-warning">Lưu nhân viên</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
