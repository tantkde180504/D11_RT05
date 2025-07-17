<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách bảo mật và xử lý khiếu nại - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/styles.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/layout-sizing.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/category-popup.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-darkmode.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-bg-orange.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-menu-white.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/hamburger-menu.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/navbar-fix.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/account-menu-fix.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/user-avatar.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        .privacy-policy-content {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .policy-section {
            margin-bottom: 40px;
        }
        .policy-section h2 {
            color: #2c3e50;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 3px solid #e74c3c;
            font-size: 1.8rem;
            font-weight: 600;
        }
        .policy-section h3 {
            color: #34495e;
            margin-bottom: 20px;
            font-size: 1.4rem;
            font-weight: 500;
        }
        .policy-section h4 {
            color: #34495e;
            margin-bottom: 15px;
            font-size: 1.2rem;
            font-weight: 500;
        }
        .policy-content {
            line-height: 1.8;
            text-align: justify;
            color: #333;
        }
        .policy-content p {
            margin-bottom: 15px;
        }
        .policy-content ul, .policy-content ol {
            margin-bottom: 20px;
            padding-left: 25px;
        }
        .policy-content li {
            margin-bottom: 8px;
        }
        .contact-info {
            background: #f8f9fa;
            border-left: 4px solid #e74c3c;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
        }
        .contact-info .contact-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .contact-info .contact-item i {
            color: #e74c3c;
            width: 20px;
            margin-right: 10px;
        }
        .highlight-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
        .page-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 60px 0;
            text-align: center;
        }
        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }
        .page-header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        .breadcrumb-custom {
            background: none;
            padding: 20px 0;
        }
        .breadcrumb-custom .breadcrumb {
            background: none;
            margin: 0;
        }
        .process-step {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #e74c3c;
        }
        .process-step h5 {
            color: #e74c3c;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .process-step .step-number {
            background: #e74c3c;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="bg-white shadow-sm sticky-top">
        <div class="container">
            <div class="row align-items-center py-3">
                <!-- Logo Section with Hamburger Menu -->
                <div class="col-lg-3 col-md-4 col-6">
                    <div class="header-logo-section">
                        <!-- Hamburger Menu (Mobile) -->
                        <button class="hamburger-menu" id="hamburgerBtn" aria-label="Menu">
                            <span class="line"></span>
                            <span class="line"></span>
                            <span class="line"></span>
                        </button>
                        
                        <div class="logo">
                            <a href="<%=request.getContextPath()%>/">
                                <img src="<%=request.getContextPath()%>/img/logo.png" alt="43 Gundam Logo" class="logo-img">
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Search Section -->
                <div class="col-lg-6 col-md-4 col-12 order-lg-2 order-md-2 order-3">
                    <div class="header-center-section">
                        <div class="search-container w-100">
                            <form class="search-form" action="<%=request.getContextPath()%>/search.jsp" method="get">
                                <div class="input-group">
                                    <input type="text" name="q" class="form-control search-input" 
                                           placeholder="Tìm kiếm sản phẩm..." autocomplete="off">
                                    <button class="btn btn-search" type="submit">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Actions Section -->
                <div class="col-lg-3 col-md-4 col-6 order-lg-3 order-md-3 order-2">
                    <div class="header-actions-section">
                        <div class="account-menu me-3">
                            <!-- User Info (visible when logged in) -->
                            <div id="nav-user-info" class="d-none">
                                <div class="dropdown">
                                    <a href="#" class="btn btn-outline-success dropdown-toggle d-flex align-items-center" 
                                       id="userAccountDropdown" role="button" data-bs-toggle="dropdown">
                                        <div class="user-avatar-container me-2">
                                            <img id="userAvatarImage" 
                                                 src="<%=request.getContextPath()%>/img/placeholder.jpg" 
                                                 alt="User Avatar" 
                                                 class="user-avatar rounded-circle"
                                                 style="width: 32px; height: 32px; object-fit: cover;">
                                        </div>
                                        <span class="d-none d-md-inline">
                                            <span class="greeting-text">Xin chào</span>
                                            <span id="userDisplayName" class="fw-bold">User</span>
                                        </span>
                                        <span class="d-md-none">
                                            <span id="userDisplayNameMobile" class="fw-bold">User</span>
                                        </span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><h6 class="dropdown-header d-flex align-items-center">
                                            <img id="userAvatarDropdown" 
                                                 src="<%=request.getContextPath()%>/img/placeholder.jpg" 
                                                 alt="User Avatar" 
                                                 class="user-avatar-small rounded-circle me-2"
                                                 style="width: 24px; height: 24px; object-fit: cover;">
                                            <span id="userFullName">User Name</span>
                                        </h6></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/profile.jsp">
                                            <i class="fas fa-user-edit me-2"></i>Thông tin tài khoản
                                        </a></li>
                                        <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-shopping-bag me-2"></i>Đơn hàng của tôi
                                        </a></li>
                                        <li><a class="dropdown-item" href="#">
                                            <i class="fas fa-heart me-2"></i>Sản phẩm yêu thích
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="#" onclick="userLogout()">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <!-- Login Button (visible when not logged in) -->
                            <div id="nav-login-btn">
                                <div class="dropdown">
                                    <a href="#" class="btn btn-outline-primary dropdown-toggle" 
                                       id="accountDropdown" role="button" data-bs-toggle="dropdown">
                                        <i class="fas fa-user me-1"></i>
                                        <span class="d-none d-md-inline">Tài khoản</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/login.jsp">
                                            <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                        </a></li>
                                        <li><a class="dropdown-item" href="<%=request.getContextPath()%>/register.jsp">
                                            <i class="fas fa-user-plus me-2"></i>Đăng ký
                                        </a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="cart-btn">
                            <a href="#" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-1"></i>
                                <span class="cart-count">0</span>
                                <span class="d-none d-lg-inline ms-1">Giỏ hàng</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Mobile Sidebar Navigation -->
    <jsp:include page="includes/mobile-sidebar.jsp" />

    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <h1><i class="fas fa-shield-alt me-3"></i>Chính sách bảo mật và xử lý khiếu nại</h1>
            <p>43gundamhobby.com cam kết bảo vệ thông tin khách hàng và xử lý khiếu nại một cách công bằng</p>
        </div>
    </div>

    <!-- Breadcrumb -->
    <div class="breadcrumb-custom">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="<%=request.getContextPath()%>/"><i class="fas fa-home"></i> Trang chủ</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Chính sách bảo mật</li>
                </ol>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <div class="privacy-policy-content">
        <div class="container">
            <!-- Introduction -->
            <div class="policy-section">
                <h2><i class="fas fa-info-circle me-2"></i>Giới thiệu</h2>
                <div class="policy-content">
                    <p><strong>43gundamhobby.com</strong> luôn hiểu được tầm quan trọng của việc bảo mật thông tin khách hàng, đó là một phần thể hiện sự quan tâm khách hàng và uy tín của 43gundamhobby.com. Vì thông tin khách hàng giúp 43gundamhobby.com nâng cao dịch vụ chăm sóc khách hàng tốt hơn, chuyên nghiệp hơn, mang lại nhiều niềm vui mua sắm tại 43gundamhobby.com hơn nữa, đồng thời tiện lợi hơn, tiết kiệm thời gian hơn cho khách hàng.</p>
                </div>
            </div>

            <!-- 1. Mục đích thu thập thông tin -->
            <div class="policy-section">
                <h2>1. MỤC ĐÍCH THU THẬP THÔNG TIN</h2>
                <div class="policy-content">
                    <p>Chúng tôi thu thập Thông tin của Khách hàng chủ yếu phục vụ cho mục đích hỗ trợ, duy trì mối liên hệ với Khách hàng như:</p>
                    <ul>
                        <li>Thông báo đến Khách hàng các Thông tin khuyến mại, quảng cáo hoặc cho các mục đích tiếp thị trực tiếp, xúc tiến thương mại khác.</li>
                        <li>Duy trì liên lạc với Khách hàng, giải đáp các thắc mắc của Khách hàng liên quan đến Dịch vụ của Chúng tôi;</li>
                        <li>Hỗ trợ khi Khách hàng mua sản phẩm và/hoặc sử dụng Dịch vụ của Chúng tôi.</li>
                        <li>Kiểm soát người truy cập, sử dụng Dịch vụ của Chúng tôi;</li>
                        <li>Phân tích và tối ưu hóa các Dịch vụ của Chúng tôi;</li>
                        <li>Nâng cao chất lượng Dịch vụ của Chúng tôi và Chúng tôi cũng có thể thu thập Thông tin để phục vụ các mục đích khác không trái với quy định pháp luật.</li>
                    </ul>
                </div>
            </div>

            <!-- 2. Phạm vi thu thập thông tin -->
            <div class="policy-section">
                <h2>2. PHẠM VI THU THẬP THÔNG TIN</h2>
                <div class="policy-content">
                    <h4>2.1</h4>
                    <p>Thông tin của Khách hàng mà Chúng tôi sẽ thu thập cho từng dịch vụ, mục đích thu thập cụ thể khác, tùy từng thời điểm Chúng tôi có thể yêu cầu Khách hàng cung cấp thêm một số Thông tin nhằm đảm bảo việc sử dụng Dịch vụ của chính Khách hàng hoặc đảm bảo sự liên hệ, giao dịch giữa Chúng tôi và Khách hàng được thông suốt, thuận tiện ví dụ như: chiều cao, cân nặng, số đo và/hoặc các Thông tin cần thiết khác.</p>
                    
                    <h4>2.2</h4>
                    <p>Đối với phạm vi thu thập Thông tin đề cập tại Chính sách này, Chúng tôi sẽ luôn tạo điều kiện bằng cách thiết lập những tính năng trên giao diện Website để Khách hàng tùy chọn để quyết định việc cung cấp hoặc từ chối cung cấp Thông tin cho Chúng tôi.</p>
                    
                    <div class="highlight-box">
                        <h5><i class="fas fa-list me-2"></i>Thông tin cần thiết:</h5>
                        <ul>
                            <li>Họ tên;</li>
                            <li>Số điện thoại;</li>
                            <li>Email;</li>
                            <li>Địa chỉ</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 3. Phương thức thu thập thông tin -->
            <div class="policy-section">
                <h2>3. PHƯƠNG THỨC THU THẬP THÔNG TIN</h2>
                <div class="policy-content">
                    <p>Nhằm đảm bảo Thông tin được thu thập là đầy đủ, chính xác, tùy trường hợp Chúng tôi có thể lựa chọn sử dụng đơn lẻ hoặc tổng hợp các phương thức thu thập Thông tin của Khách hàng như sau:</p>
                    
                    <h4>3.1 Đề nghị Khách hàng cung cấp Thông tin</h4>
                    <ul>
                        <li>Một số Dịch vụ của Chúng tôi cho phép/đề nghị Khách hàng tạo tài khoản hoặc hồ sơ cá nhân và để sử dụng một cách tốt nhất các Dịch vụ này, Chúng tôi có thể yêu cầu Khách hàng cung cấp các Thông tin đề cập tại Mục 2 nêu trên để đáp ứng nhu cầu sử dụng Dịch vụ của Khách hàng.</li>
                        <li>Trường hợp Khách hàng yêu cầu Chúng tôi giải đáp các thắc mắc liên quan đến Dịch vụ/Sản phẩm của Chúng tôi hoặc Khách hàng yêu cầu Chúng tôi cung cấp Dịch vụ ví dụ: đặt hàng mua trực tuyến, yêu cầu hỗ trợ thông tin giao hàng... thì Chúng tôi có thể yêu cầu Khách hàng cung cấp Thông tin để xử lý các yêu cầu của Khách hàng một cách nhanh chóng, chính xác;</li>
                        <li>Các trường hợp yêu cầu thu thập Thông tin khác tùy theo nhu cầu thu thập của Chúng tôi.</li>
                    </ul>

                    <h4>3.2 Chúng tôi tự thu thập Thông tin</h4>
                    <ul>
                        <li>Thu thập Thông tin từ các nguồn của bên thứ ba: Chúng tôi có thể nhận Thông tin về Khách hàng đã công bố công khai trên các website thương mại điện tử của bất kỳ bên thứ ba nào hoặc nhận Thông tin của Khách hàng từ bên thứ ba khi Chúng tôi tham gia vào các giao dịch có sự chuyển giao Thông tin đó.</li>
                        <li>Thu thập trong quá trình thực hiện Dịch vụ: Trong quá trình thực hiện Dịch vụ, Chúng tôi cũng có thể thu thập các Thông tin của Khách hàng bằng các cách thức phù hợp khác với sự đồng ý của Khách hàng với cách thức thu thập đó.</li>
                        <li>Thu thập trong quá trình Khách hàng sử dụng Dịch vụ: Một số Dịch vụ của Chúng tôi cho phép Khách hàng liên lạc với bên thứ ba, những lần liên lạc đó sẽ được truyền qua và những Thông tin phát sinh trong quá trình liên lạc đó có thể được lưu trữ trên hệ thống của Chúng tôi.</li>
                    </ul>

                    <h4>3.3 Hợp nhất Thông tin</h4>
                    <p>Chúng tôi có thể hợp nhất Thông tin Khách hàng mà Chúng tôi có được từ việc thu thập bằng nhiều phương thức khác nhau đề cập tại Mục này như một thao tác hoàn thiện Thông tin để phục vụ cho các mục đích được đề cập tại Chính sách này mà không cần sự đồng ý trước của Khách hàng. Tuy nhiên Khách hàng luôn có quyền lựa chọn điều chỉnh Thông tin của mình theo quy định tại Mục 9.1 Chính sách này.</p>
                    
                    <p><strong>Lưu ý quan trọng:</strong> Chúng tôi sẽ luôn đưa ra tùy chọn về việc quyết định cung cấp hay không cung cấp Thông tin đối với Khách hàng. Trường hợp Khách hàng lựa chọn không cung cấp Thông tin có thể sẽ có một số Dịch vụ, giao dịch không thể thực hiện được hoặc một số giao dịch Khách hàng sẽ được truy cập, thực hiện dưới chế độ ẩn danh (Guest).</p>
                </div>
            </div>

            <!-- 4. Phạm vi sử dụng thông tin -->
            <div class="policy-section">
                <h2>4. PHẠM VI SỬ DỤNG THÔNG TIN</h2>
                <div class="policy-content">
                    <p>Chúng tôi sử dụng các Thông tin của Khách hàng thu thập được để:</p>
                    <ul>
                        <li>Thực hiện các biện pháp để hoàn thiện Dịch vụ của Chúng tôi;</li>
                        <li>Thiết lập các chương trình hỗ trợ khách hàng thân thiết hoặc các chương trình xúc tiến thương mại khác;</li>
                        <li>Xử lý các vấn đề liên quan đến việc sử dụng Dịch vụ của Khách hàng hoặc giao dịch giữa Chúng tôi và Khách hàng;</li>
                        <li>Gửi thư ngỏ, đơn đặt hàng, thư cảm ơn;</li>
                        <li>Gửi các Thông tin khuyến mãi hoặc các Thông tin khác cho Khách hàng khi có sự đồng ý trước của Khách hàng;</li>
                        <li>Thông báo về các thông tin tuyển dụng của Chúng tôi nếu Khách hàng đăng kí nhận email thông báo;</li>
                        <li>Đánh giá và phân tích thị trường, khách hàng, Dịch vụ của Chúng tôi;</li>
                        <li>Các nội dung khác mà Chúng tôi được phép sử dụng Thông tin không trái với quy định của pháp luật.</li>
                    </ul>
                </div>
            </div>

            <!-- 5. Đối tượng tiếp cận thông tin -->
            <div class="policy-section">
                <h2>5. ĐỐI TƯỢNG TIẾP CẬN THÔNG TIN</h2>
                <div class="policy-content">
                    <h4>5.1</h4>
                    <p>Để thực hiện mục đích thu thập Thông tin đề cập tại Chính sách này Chúng tôi có thể cần sự hỗ trợ từ bên thứ ba để phân tích dữ liệu, tiếp thị và hỗ trợ dịch vụ khách hàng và/hoặc cung cấp Dịch vụ tốt hơn cho Khách hàng. Trong quá trình hỗ trợ, Thông tin của Khách hàng có thể được Chúng tôi tiết lộ cho các đối tượng được đề cập dưới đây:</p>
                    <ul>
                        <li>Đơn vị trực thuộc của Chúng tôi khi sự tham gia của Đơn vị trực thuộc là cần thiết để thực hiện/hoàn thiện giao dịch đã thiết lập giữa Chúng tôi với Khách hàng.</li>
                        <li>Đối tác kinh doanh mà Chúng tôi tin tưởng, việc tiết lộ và trách nhiệm bảo mật Thông tin của Khách hàng sẽ được thực hiện theo thỏa thuận giữa Chúng tôi và đối tác kinh doanh của Chúng tôi.</li>
                    </ul>

                    <h4>5.2</h4>
                    <p>Chúng tôi sẽ phải tiết lộ Thông tin của Khách hàng cho Bên thứ ba hoặc cho cơ quan có thẩm quyền khi được cơ quan có thẩm quyền yêu cầu hoặc các trường hợp khác theo quy định của pháp luật hoặc Chúng tôi có cơ sở để tin rằng việc tiết lộ Thông tin có thể bảo vệ quyền, tài sản hoặc an toàn của chính Khách hàng hoặc của Chúng tôi</p>

                    <h4>5.3</h4>
                    <p>Các bên khác khi có sự đồng ý hoặc theo hướng dẫn của Khách hàng.</p>
                </div>
            </div>

            <!-- 6. Thời gian lưu trữ thông tin -->
            <div class="policy-section">
                <h2>6. THỜI GIAN LƯU TRỮ THÔNG TIN</h2>
                <div class="policy-content">
                    <p>Chúng tôi chỉ lưu giữ Thông tin về Khách hàng trong thời gian cần thiết cho mục đích mà Thông tin được thu thập hoặc theo yêu cầu của Hợp đồng hoặc theo quy định của pháp luật hiện hành.</p>
                </div>
            </div>

            <!-- 7. Các liên kết và sản phẩm của bên thứ ba -->
            <div class="policy-section">
                <h2>7. CÁC LIÊN KẾT VÀ SẢN PHẨM CỦA BÊN THỨ BA TRÊN WEBSITE</h2>
                <div class="policy-content">
                    <p>Một số nội dung, quảng cáo và tính năng trên trang web của Chúng tôi có thể được cung cấp bởi các bên thứ ba có hoặc không liên kết với Chúng tôi. Các bên thứ ba này có thể thu thập hoặc nhận Thông tin nhất định về việc Khách hàng sử dụng Dịch vụ, kể cả thông qua việc sử dụng Cookie..., và các công nghệ tương tự và Thông tin này có thể được thu thập theo thời gian, đồng thời được kết hợp với Thông tin được thu thập trên các Website và dịch vụ trực tuyến khác nhau.</p>
                    
                    <p>Nếu Khách hàng kết nối với dịch vụ mạng xã hội, Chúng tôi có thể nhận và lưu trữ Thông tin xác thực từ dịch vụ đó để cho phép Khách hàng đăng nhập, cũng như Thông tin khác mà Khách hàng cho phép Chúng tôi nhận khi Khách hàng kết nối với các dịch vụ đó.</p>
                    
                    <p>Bằng cách truy cập và/hoặc sử dụng Dịch vụ của Chúng tôi, Khách hàng đồng ý lưu trữ Cookie..., các công nghệ lưu trữ cục bộ khác. Khách hàng cũng đồng ý quyền truy cập Cookie..., công nghệ lưu trữ cục bộ của Chúng tôi và các bên thứ ba được đề cập ở trên.</p>
                    
                    <div class="highlight-box">
                        <p><strong>Lưu ý quan trọng:</strong> Như đã nêu trên, Dịch vụ của Chúng tôi có thể có các liên kết đến các website của Bên thứ ba khác không thuộc quyền kiểm soát của Chúng tôi, do đó Chúng tôi sẽ không chịu trách nhiệm về sự an toàn hoặc bảo mật của bất kỳ Thông tin nào được thu thập bởi các Bên thứ ba đó, không được thực hiện trên giao diện website hoặc Chúng tôi có quyền quản lý và/hoặc kiểm soát. Chúng tôi khuyên Khách hàng nên thận trọng và xem xét các quyết định về bảo mật Thông tin áp dụng cho các Website và dịch vụ của Bên thứ ba mà Khách hàng sử dụng.</p>
                    </div>
                </div>
            </div>

            <!-- 8. Cam kết bảo mật thông tin -->
            <div class="policy-section">
                <h2>8. CAM KẾT BẢO MẬT THÔNG TIN</h2>
                <div class="policy-content">
                    <p>Chúng tôi cam kết bảo mật Thông tin của Khách hàng theo đúng các nội dung được quy định tại Chính sách này và quy định của pháp luật.</p>
                    
                    <p>Chúng tôi sẽ áp dụng phương án và giải pháp thích hợp về kỹ thuật và an ninh để bảo vệ hiệu quả nhất Thông tin của Khách hàng. Tuy nhiên, lưu ý rằng mặc dù Chúng tôi thực hiện các phương thức hợp lý để bảo vệ Thông tin của Khách hàng, nhưng không có trang web, đường truyền Internet, hệ thống máy vi tính hay kết nối không dây nào là an toàn tuyệt đối. Do vậy, Chúng tôi không thể đưa ra một cam kết chắc chắn rằng thông tin Khách hàng cung cấp cho Chúng tôi sẽ được bảo mật một cách tuyệt đối an toàn, và Chúng tôi không thể chịu trách nhiệm trong trường hợp có sự truy cập trái phép, rò rỉ Thông tin của Khách hàng mà không do lỗi của Chúng tôi. Nếu Khách hàng không đồng ý với các điều khoản như đã mô tả ở trên, Chúng tôi khuyến nghị Khách hàng không nên gửi Thông tin đến cho Chúng tôi</p>
                </div>
            </div>

            <!-- 9. Quyền lợi và trách nhiệm của khách hàng -->
            <div class="policy-section">
                <h2>9. QUYỀN LỢI VÀ TRÁCH NHIỆM CỦA KHÁCH HÀNG</h2>
                <div class="policy-content">
                    <h4>Quyền lợi của Khách hàng:</h4>
                    <ul>
                        <li>Khách hàng được bảo đảm các quyền lợi và bảo mật về Thông tin mà Chúng tôi đã cam kết theo Chính sách này;</li>
                        <li>Nếu Khách hàng không muốn nhận bất cứ thông tin quảng cáo, chương trình khuyến mại....của Chúng tôi thì có quyền từ chối bất cứ lúc nào bằng cách gửi yêu cầu ngưng nhận thông tin đến website của Chúng tôi theo các tính năng & thông tin liên hệ được hướng dẫn ở cuối trang.</li>
                    </ul>

                    <h4>Trách nhiệm của Khách hàng:</h4>
                    <ul>
                        <li>Tìm hiểu kỹ Chính sách này trước khi sử dụng, truy cập Dịch vụ của Chúng tôi., Việc Khách hàng sử dụng, truy cập Dịch vụ của Chúng tôi cũng chính là sự xác nhận việc đã tìm hiểu kỹ và đồng ý với toàn bộ nội dung Chính sách này.</li>
                        <li>Cung cấp Thông tin chính xác, hợp pháp cho Chúng tôi khi được đề nghị và đồng ý cung cấp. Khách hàng sẽ hoàn toàn chịu trách nhiệm (trong mọi trường hợp, không có sự liên đới nào đến Chúng tôi dù cho một phần hay toàn bộ) nếu Thông tin Khách hàng cung cấp cho Chúng tôi là không chính xác, không hợp pháp và/hoặc việc thực hiện Dịch vụ của Khách hàng bị gián đoạn, không thể thực hiện; hoặc giao dịch giữa Chúng tôi và Khách hàng, giữa Chúng tôi và Bên thứ ba, giữa Khách hàng và Bên thứ ba bị gián đoạn hoặc không thể thực hiện được vì yếu tố kỹ thuật, đường truyền, lỗi hệ thống, v.v. hoặc phát sinh bất kể thiệt hại vật chất, phi vật chất nào từ việc sử dụng những Thông tin không chính xác/vi phạm pháp luật này.</li>
                        <li>Không sử dụng bất kỳ chương trình, công cụ hay hình thức nào khác để can thiệp vào hệ thống hay làm thay đổi cấu trúc dữ liệu của Dịch vụ, giao diện của website, các tính năng hiện hữu của website Chúng tôi.</li>
                        <li>Không phát tán, truyền bá hay cổ vũ cho bất kỳ hoạt động nào nhằm can thiệp, phá hoại hay xâm nhập vào dữ liệu của hệ thống website thuộc quyền quản lý của Chúng tôi.</li>
                        <li>Không truyền bá, phát tán nội dung vi phạm pháp luật và/hoặc trái đạo đức xã hội tại website của Chúng tôi.</li>
                    </ul>
                    <p><strong>Mọi vi phạm sẽ bị xử lý theo quy định của pháp luật.</strong></p>
                </div>
            </div>

            <!-- 10. Quy trình xử lý khiếu nại -->
            <div class="policy-section">
                <h2>10. QUY TRÌNH TIẾP NHẬN VÀ GIẢI QUYẾT KHIẾU NẠI</h2>
                <div class="policy-content">
                    <p><strong>43gundamhobby.com</strong> công bố Quy trình tiếp nhận và giải quyết phản ánh, yêu cầu, khiếu nại (sau đây gọi chung là "Khiếu nại") của người tiêu dùng như sau:</p>

                    <h3>1. Đối tượng áp dụng:</h3>
                    <p>Người tiêu dùng là người mua, sử dụng sản phẩm, hàng hóa, dịch vụ của 43gundamhobby.com cho mục đích tiêu dùng, sinh hoạt của cá nhân, gia đình, cơ quan, tổ chức và không vì mục đích thương mại.</p>

                    <div class="contact-info">
                        <h5><i class="fas fa-phone me-2"></i>Thông tin liên hệ để gửi khiếu nại:</h5>
                        <div class="contact-item">
                            <i class="fas fa-phone"></i>
                            <span><strong>Đường dây nóng:</strong> 0385546145</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-envelope"></i>
                            <span><strong>Email:</strong> 43gundamhobby@gmail.com</span>
                        </div>
                        <div class="contact-item">
                            <i class="fas fa-globe"></i>
                            <span><strong>Website:</strong> 43gundamhobby.com</span>
                        </div>
                    </div>

                    <h3>2. Các bước tiếp nhận và giải quyết khiếu nại:</h3>

                    <div class="process-step">
                        <h5><span class="step-number">1</span>Tiếp nhận Khiếu nại</h5>
                        <p><strong>(1)</strong> Người tiêu dùng của 43gundamhobby.com có thể gửi phản ánh, yêu cầu, khiếu nại tới 43gundamhobby.com thông qua các phương thức liên hệ đã nêu trên.</p>
                        
                        <p><strong>(2)</strong> Các thông tin Người tiêu dùng cần cung cấp cho 43gundamhobby.com gồm: thông tin cá nhân của người tiêu dùng, thông tin về quá trình mua, sử dụng sản phẩm, hàng hóa, dịch vụ của người tiêu dùng, hóa đơn chứng từ mua hàng và thông tin khác liên quan đến giao dịch giữa người tiêu dùng và tổ chức, cá nhân kinh doanh.</p>
                        
                        <p><strong>(3)</strong> Trong thời hạn <strong>03 ngày</strong> kể từ ngày nhận được Khiếu nại, Bộ phận giải quyết khiếu nại của 43gundamhobby.com thông báo cho Người tiêu dùng về việc tiếp nhận Khiếu nại của Người tiêu dùng.</p>
                    </div>

                    <div class="process-step">
                        <h5><span class="step-number">2</span>Thụ lý giải quyết khiếu nại</h5>
                        <p>Trong thời hạn <strong>03 ngày làm việc</strong> kể từ ngày thông báo tiếp nhận Khiếu nại, Bộ phận giải quyết khiếu nại của 43gundamhobby.com thông báo cho Người khiếu nại về việc thụ lý giải quyết Khiếu nại, trường hợp không thụ lý giải quyết thì nêu rõ lý do trong văn bản thông báo cho Người khiếu nại.</p>
                    </div>

                    <div class="process-step">
                        <h5><span class="step-number">3</span>Xác minh nội dung Khiếu nại</h5>
                        <p><strong>(1) Làm việc trực tiếp với Người khiếu nại:</strong></p>
                        <ul>
                            <li>Bộ phận giải quyết khiếu nại của 43gundamhobby.com liên hệ với Người khiếu nại để yêu cầu cung cấp thông tin, tài liệu, bằng chứng làm rõ những nội dung liên quan đến khiếu nại.</li>
                            <li>Việc cung cấp thông tin, tài liệu, bằng chứng được thực hiện trong thời hạn <strong>07 ngày làm việc</strong>, kể từ ngày nhận được yêu cầu.</li>
                            <li>Trường hợp Người khiếu nại ủy quyền cho tổ chức, cá nhân khác làm việc với 43gundamhobby.com thì tổ chức, cá nhân được ủy quyền phải cung cấp các giấy tờ, văn bản ủy quyền chứng minh việc ủy quyền là hợp pháp.</li>
                        </ul>

                        <p><strong>(2) Thu thập thông tin, tài liệu, bằng chứng liên quan đến nội dung Khiếu nại:</strong></p>
                        <ul>
                            <li>Bộ phận giải quyết khiếu nại của 43gundamhobby.com liên hệ và yêu cầu nhà sản xuất, các tổ chức, đơn vị, cá nhân liên quan để thu thập thông tin, tài liệu, bằng chứng liên quan đến nội dung khiếu nại.</li>
                            <li>Việc thu thập thông tin, tài liệu, bằng chứng được thực hiện trong thời hạn <strong>10 ngày làm việc</strong> (đối với hàng hóa sản xuất trong nước) hoặc <strong>15 ngày làm việc</strong> (đối với hàng hóa sản xuất ở nước ngoài), kể từ ngày thụ lý Khiếu nại.</li>
                        </ul>
                    </div>

                    <div class="process-step">
                        <h5><span class="step-number">4</span>Thông báo kết quả giải quyết Khiếu nại</h5>
                        <p>43gundamhobby.com có trách nhiệm thông báo kết quả giải quyết tới Người khiếu nại trong thời hạn:</p>
                        <ul>
                            <li><strong>30 ngày làm việc</strong> (đối với hàng hóa sản xuất trong nước)</li>
                            <li><strong>45 ngày làm việc</strong> (đối với hàng hóa sản xuất ở nước ngoài)</li>
                        </ul>
                        <p>Kể từ ngày thụ lý Khiếu nại.</p>
                    </div>

                    <div class="highlight-box">
                        <h5><i class="fas fa-shield-alt me-2"></i>Cam kết của chúng tôi</h5>
                        <p><strong>43gundamhobby.com</strong> tôn trọng và nghiêm túc thực hiện các quy định của pháp luật về bảo vệ quyền lợi người tiêu dùng.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white">
        <div class="footer-top py-5">
            <div class="container">
                <div class="row">
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="footer-section">
                            <h5 class="footer-title">43 Gundam Hobby</h5>
                            <p class="footer-desc">Chuyên cung cấp mô hình Gundam chính hãng với giá tốt nhất. Uy tín - Chất lượng - Dịch vụ tận tâm.</p>
                            <div class="store-info">
                                <div class="info-item mb-2">
                                    <i class="fas fa-map-marker-alt me-2"></i>
                                    <span>59 Lê Đình Diên, Cẩm Lệ, Đà Nẵng</span>
                                </div>
                                <div class="info-item mb-2">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:0385546145" class="text-white">0385546145 (8h-20h)</a>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-envelope me-2"></i>
                                    <a href="mailto:43gundamhobby@gmail.com" class="text-white">43gundamhobby@gmail.com</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Sản phẩm</h6>
                            <ul class="footer-links">
                                <li><a href="#">Gundam Bandai</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=HG">High Grade (HG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=MG">Master Grade (MG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=RG">Real Grade (RG)</a></li>
                                <li><a href="<%=request.getContextPath()%>/grade.jsp?grade=PG">Perfect Grade (PG)</a></li>
                                <li><a href="#">Metal Build</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Dịch vụ</h6>
                            <ul class="footer-links">
                                <li><a href="#">Hàng Pre-Order</a></li>
                                <li><a href="<%=request.getContextPath()%>/tools-accessories.jsp">Dụng cụ & Phụ kiện</a></li>
                                <li><a href="#">Hướng dẫn lắp ráp</a></li>
                                <li><a href="#">Sơn & Trang trí</a></li>
                                <li><a href="#">Bảo hành sản phẩm</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Chính sách</h6>
                            <ul class="footer-links">
                                <li><a href="<%=request.getContextPath()%>/privacy-policy.jsp">Chính sách bảo mật</a></li>
                                <li><a href="#">Chính sách thanh toán</a></li>
                                <li><a href="<%=request.getContextPath()%>/shipping-policy.jsp">Chính sách vận chuyển</a></li>
                                <li><a href="<%=request.getContextPath()%>/shipping-policy.jsp">Chính sách đổi trả</a></li>
                                <li><a href="#">Quy định sử dụng</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6 mb-4">
                        <div class="footer-section">
                            <h6 class="footer-title">Hỗ trợ</h6>
                            <ul class="footer-links">
                                <li><a href="#">Liên hệ</a></li>
                                <li><a href="#">FAQ</a></li>
                                <li><a href="#">Hướng dẫn đặt hàng</a></li>
                                <li><a href="#">Tra cứu đơn hàng</a></li>
                                <li><a href="#">Hỗ trợ kỹ thuật</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-social py-4 bg-darker">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h6 class="social-title mb-3">Theo dõi chúng tôi</h6>
                        <div class="social-links">
                            <a href="https://www.facebook.com/BANDAIHobbysite.EN" target="_blank" rel="noopener noreferrer" class="social-link facebook">
                                <i class="fab fa-facebook-f"></i>
                                <span>Facebook</span>
                            </a>
                            <a href="https://www.youtube.com/@GundamInfo" target="_blank" rel="noopener noreferrer" class="social-link youtube">
                                <i class="fab fa-youtube"></i>
                                <span>Youtube</span>
                            </a>
                            <a href="https://www.tiktok.com/@bandainamcoasiahobby_?is_from_webapp=1&sender_device=pc" target="_blank" rel="noopener noreferrer" class="social-link tiktok">
                                <i class="fab fa-tiktok"></i>
                                <span>TikTok</span>
                            </a>
                            <a href="https://www.instagram.com/bandaihobbyhk/" target="_blank" rel="noopener noreferrer" class="social-link instagram">
                                <i class="fab fa-instagram"></i>
                                <span>Instagram</span>
                            </a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="newsletter">
                            <h6 class="newsletter-title mb-3">Đăng ký nhận tin</h6>
                            <form class="newsletter-form">
                                <div class="input-group">
                                    <input type="email" class="form-control" placeholder="Nhập email của bạn...">
                                    <button class="btn btn-primary" type="submit">
                                        <i class="fas fa-paper-plane"></i>
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer-bottom py-3 bg-darker border-top border-secondary">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <p class="copyright mb-0">&copy; 2025 43 Gundam Hobby. All rights reserved.</p>
                    </div>
                    <div class="col-md-6 text-md-end">
                        <div class="payment-methods">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=VISA" alt="Visa" class="payment-icon">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=MC" alt="Mastercard" class="payment-icon">
                            <img src="https://via.placeholder.com/40x25/cccccc/666666?text=COD" alt="COD" class="payment-icon">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <!-- Chat Widget Include -->
    <jsp:include page="chat-widget.jsp" />

    <!-- Bootstrap JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Include external JavaScript files -->
    <script src="<%=request.getContextPath()%>/js/cart.js"></script>
    <script src="<%=request.getContextPath()%>/js/favorites.js"></script>
    <script src="<%=request.getContextPath()%>/js/navbar-auth.js"></script>
    <script src="<%=request.getContextPath()%>/js/category-popup.js"></script>
    <script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>
    <script src="<%=request.getContextPath()%>/js/oauth-success.js"></script>
    <script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>

    <script>
        // Initialize page functionality
        $(document).ready(function() {
            // Smooth scrolling for anchor links
            $('a[href^="#"]').on('click', function(event) {
                var target = $(this.getAttribute('href'));
                if(target.length) {
                    event.preventDefault();
                    $('html, body').stop().animate({
                        scrollTop: target.offset().top - 100
                    }, 1000);
                }
            });
            
            // Unified navbar manager initialization
            if (window.unifiedNavbarManager) {
                setTimeout(() => {
                    window.unifiedNavbarManager.checkAuthState();
                }, 100);
            }
        });

        // Function to open chat widget - called from dropdown menu
        function openChatWidget() {
            console.log('🔗 openChatWidget called from dropdown menu');
            
            // Gọi toggleChatWidget từ chat-widget.jsp
            if (typeof toggleChatWidget === 'function') {
                toggleChatWidget();
            } else {
                console.log('❌ toggleChatWidget function not found');
            }
        }
    </script>
</body>
</html>
