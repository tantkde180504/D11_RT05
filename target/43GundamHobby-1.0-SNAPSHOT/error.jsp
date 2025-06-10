<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body text-center">
                        <h1 class="display-4 text-danger">Oops!</h1>
                        <h3>Đã xảy ra lỗi</h3>
                        <p class="lead">Xin lỗi, đã có lỗi xảy ra khi tải trang.</p>
                        <% if (exception != null) { %>
                            <div class="alert alert-danger" role="alert">
                                <strong>Chi tiết lỗi:</strong> <%= exception.getMessage() %>
                            </div>
                        <% } %>
                        <a href="<%=request.getContextPath()%>/" class="btn btn-primary">Về trang chủ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
