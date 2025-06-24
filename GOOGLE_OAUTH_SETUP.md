# Google OAuth Integration Setup - 43 Gundam Hobby

## Tổng quan
Hệ thống đã được tích hợp đăng nhập Google OAuth2 sử dụng Spring Security OAuth2 Client.

## Cấu hình

### 1. Google OAuth Credentials
```
Redirect URI: http://localhost:8080/login/oauth2/code/google
```

### 2. Spring Configuration
File `application.properties` đã được cập nhật với:
- Spring Security OAuth2 client registration
- Google OAuth2 provider configuration
- Database connection cho lưu trữ user data

### 3. Database Schema
Bảng `oauth_users` sẽ được tự động tạo với các trường:
- id (BIGINT, PRIMARY KEY)
- email (NVARCHAR(255), UNIQUE)
- name (NVARCHAR(255))
- picture (NVARCHAR(500))
- provider (NVARCHAR(50)) - "google"
- provider_id (NVARCHAR(255)) - Google user ID
- role (NVARCHAR(50)) - Default: "USER"
- created_at, updated_at (DATETIME2)

## Cấu trúc Code

### 1. Security Configuration
- `SecurityConfig.java`: Cấu hình Spring Security và OAuth2
- Xử lý authentication success/failure
- Session management

### 2. Controllers
- `GoogleOAuthController.java`: API endpoints cho OAuth operations
  - `/oauth2/user-info` - Lấy thông tin user
  - `/oauth2/logout` - Đăng xuất
  - `/oauth2/login-status` - Kiểm tra trạng thái đăng nhập

### 3. Services
- `OAuthUserService.java`: Xử lý database operations cho OAuth users
- Tự động tạo/cập nhật user data từ Google

### 4. Models
- `OAuthUser.java`: Entity model cho OAuth users

### 5. Frontend
- `google-oauth-handler.js`: JavaScript handler cho OAuth operations
- CSS styling cho OAuth components
- Updated `login.jsp` với Google login button

## Cách sử dụng

### 1. Khởi động ứng dụng
```bash
mvn spring-boot:run
```

### 2. Truy cập trang login
```
http://localhost:8080/login.jsp
```

### 3. Kiểm tra Google OAuth
```
http://localhost:8080/google-oauth-test.jsp
```

## Flow đăng nhập

### 1. User clicks "Đăng nhập bằng Google"
- JavaScript chuyển hướng đến `/oauth2/authorization/google`
- Spring Security redirect đến Google OAuth

### 2. Google Authorization
- User authorize ở Google
- Google redirect về `/login/oauth2/code/google`

### 3. Spring Security Processing
- Nhận authorization code từ Google
- Exchange code để lấy access token
- Gọi Google API để lấy user info

### 4. Success Handler
- Lưu/cập nhật user trong database
- Tạo session với user info
- Redirect đến `/dashboard.jsp`

### 5. Session Management
- User info được lưu trong session
- JavaScript có thể call API để lấy thông tin
- Logout xóa session và redirect

## API Endpoints

### GET /oauth2/user-info
Lấy thông tin user hiện tại
```json
{
  "email": "user@gmail.com",
  "name": "User Name",
  "picture": "https://...",
  "isLoggedIn": true,
  "loginType": "google"
}
```

### GET /oauth2/login-status
Kiểm tra trạng thái đăng nhập
```json
{
  "isLoggedIn": true,
  "email": "user@gmail.com",
  "name": "User Name",
  "loginType": "google"
}
```

### POST /oauth2/logout
Đăng xuất user
```json
{
  "success": true,
  "message": "Đăng xuất thành công"
}
```

## Testing

### 1. Test Page
- Truy cập `/google-oauth-test.jsp`
- Kiểm tra các chức năng OAuth
- Xem debug logs và API responses

### 2. Manual Testing
1. Vào `/login.jsp`
2. Click "Đăng nhập bằng Google"
3. Authorize ở Google
4. Kiểm tra redirect đến dashboard
5. Verify user info được lưu

## Troubleshooting

### 1. OAuth Errors
- Kiểm tra Google Console configuration
- Verify redirect URIs match exactly
- Check client ID/secret

### 2. Database Errors
- Verify SQL Server connection
- Check if oauth_users table exists
- Review user permissions

### 3. Session Issues
- Clear browser cookies
- Check session timeout configuration
- Verify Spring Security configuration

### 4. JavaScript Errors
- Check browser console
- Verify API endpoints are accessible
- Test with network tab open

## Security Notes

### 1. HTTPS in Production
- Google OAuth requires HTTPS in production
- Update redirect URIs for production domain

### 2. Environment Variables
- Move secrets to environment variables
- Don't commit sensitive data

### 3. CSRF Protection
- CSRF is disabled for OAuth endpoints
- Re-enable for production with proper configuration

### 4. Session Security
- Configure session timeout
- Use secure session cookies in production
- Implement proper logout functionality

## Next Steps

### 1. User Profile Management
- Implement user profile editing
- Add role-based access control
- User settings page

### 2. Enhanced Security
- Add 2FA support
- Implement refresh tokens
- Rate limiting for OAuth endpoints

### 3. Social Login Expansion
- Add Facebook OAuth
- Add GitHub OAuth
- Unified social login UI

### 4. Production Deployment
- Configure HTTPS
- Set up environment variables
- Configure production OAuth settings
