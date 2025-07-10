<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thêm nhân viên mới</title>
    <style>
        body {
            font-family: Arial;
            padding: 20px;
        }
        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }
        input, select {
            width: 300px;
            padding: 5px;
        }
        button {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
        }
        .success {
            color: green;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

<h2>Thêm nhân viên mới</h2>

<!-- Hiển thị thông báo nếu thêm thành công -->
<c:if test="${param.success != null}">
    <p class="success">✔ Nhân viên đã được thêm thành công!</p>
</c:if>

<!-- Form nhập thông tin nhân viên -->
<form:form method="POST" action="${pageContext.request.contextPath}/admin/staffs/create" modelAttribute="staff">
    <label>Họ tên:</label>
    <form:input path="fullName" required="true"/>

    <label>Ngày sinh:</label>
    <form:input path="birthDate" type="date" required="true"/>

    <label>Email:</label>
    <form:input path="email" type="email" required="true"/>

    <label>Chức vụ:</label>
    <form:input path="position" required="true"/>

    <label>Ngày vào làm:</label>
    <form:input path="startDate" type="date" required="true"/>

    <label>Trạng thái:</label>
    <form:select path="status">
        <form:option value="Hoạt động">Hoạt động</form:option>
        <form:option value="Ngưng hoạt động">Ngưng hoạt động</form:option>
    </form:select>

    <br/>
    <button type="submit">Tạo nhân viên</button>
</form:form>

</body>
</html>
