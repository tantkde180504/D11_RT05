package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import java.util.regex.Pattern;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.util.UUID;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@RestController
@RequestMapping("/api")
public class ForgotPasswordController {

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

    @PostMapping(value = "/forgot-password", 
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestParam String email) {
        
        System.out.println("=== FORGOT PASSWORD REQUEST RECEIVED ===");
        System.out.println("Email: " + email);
        
        Map<String, Object> response = new HashMap<>();
        
        // Validate email
        if (!validateEmail(email, response)) {
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            System.out.println("Database connection successful!");
            
            // Check if email exists
            if (!emailExists(connection, email)) {
                // For security, return success even if email doesn't exist
                System.out.println("Email not found: " + email);
                response.put("success", true);
                response.put("message", "Nếu email này tồn tại trong hệ thống, bạn sẽ nhận được email hướng dẫn đặt lại mật khẩu.");
                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
            // Generate reset token
            String resetToken = generateResetToken();
            String resetTokenExpiry = LocalDateTime.now().plusHours(24)
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            
            // Store reset token in database
            if (storeResetToken(connection, email, resetToken, resetTokenExpiry)) {
                // Here you would normally send email
                // For now, we'll just return success with the token (for testing)
                System.out.println("Reset token generated: " + resetToken);
                System.out.println("Reset token expires: " + resetTokenExpiry);
                
                response.put("success", true);
                response.put("message", "Email hướng dẫn đặt lại mật khẩu đã được gửi!");
                // In production, don't return the token
                response.put("resetToken", resetToken); // Only for testing
                
                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            } else {
                response.put("success", false);
                response.put("message", "Có lỗi xảy ra, vui lòng thử lại!");
                return ResponseEntity.internalServerError()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi kết nối cơ sở dữ liệu!");
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }
    
    @PostMapping(value = "/reset-password", 
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> resetPassword(
            @RequestParam String token,
            @RequestParam String newPassword,
            @RequestParam String confirmNewPassword) {
        
        System.out.println("=== RESET PASSWORD REQUEST RECEIVED ===");
        System.out.println("Token: " + token);
        
        Map<String, Object> response = new HashMap<>();
        
        // Validate input
        if (!validateResetInput(token, newPassword, confirmNewPassword, response)) {
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            System.out.println("Database connection successful!");
            
            // Verify token and get email
            String email = verifyResetToken(connection, token);
            if (email == null) {
                response.put("success", false);
                response.put("message", "Liên kết đặt lại mật khẩu không hợp lệ hoặc đã hết hạn!");
                return ResponseEntity.badRequest()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
            // Update password
            if (updatePassword(connection, email, newPassword)) {
                // Delete used token
                deleteResetToken(connection, token);
                
                System.out.println("Password reset successful for: " + email);
                response.put("success", true);
                response.put("message", "Mật khẩu đã được đặt lại thành công!");
                
                return ResponseEntity.ok()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            } else {
                response.put("success", false);
                response.put("message", "Có lỗi xảy ra khi đặt lại mật khẩu!");
                return ResponseEntity.internalServerError()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi kết nối cơ sở dữ liệu!");
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }
    
    @GetMapping("/verify-reset-token")
    public ResponseEntity<Map<String, Object>> verifyResetToken(@RequestParam String token) {
        Map<String, Object> response = new HashMap<>();
        
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            String email = verifyResetToken(connection, token);
            
            if (email != null) {
                response.put("success", true);
                response.put("email", email);
                response.put("message", "Token hợp lệ");
            } else {
                response.put("success", false);
                response.put("message", "Token không hợp lệ hoặc đã hết hạn");
            }
            
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
                    
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            response.put("success", false);
            response.put("message", "Lỗi kết nối cơ sở dữ liệu!");
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }
    
    // Helper methods
    private boolean validateEmail(String email, Map<String, Object> response) {
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập email!");
            return false;
        }
        
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            response.put("success", false);
            response.put("message", "Email không hợp lệ!");
            return false;
        }
        
        return true;
    }
    
    private boolean validateResetInput(String token, String newPassword, String confirmNewPassword, Map<String, Object> response) {
        if (token == null || token.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Token không hợp lệ!");
            return false;
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập mật khẩu mới!");
            return false;
        }
        
        if (confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng xác nhận mật khẩu mới!");
            return false;
        }
        
        if (newPassword.length() < 6) {
            response.put("success", false);
            response.put("message", "Mật khẩu phải có ít nhất 6 ký tự!");
            return false;
        }
        
        if (!newPassword.equals(confirmNewPassword)) {
            response.put("success", false);
            response.put("message", "Mật khẩu xác nhận không khớp!");
            return false;
        }
        
        return true;
    }
    
    private boolean emailExists(Connection connection, String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.toLowerCase().trim());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    private String generateResetToken() {
        return UUID.randomUUID().toString().replace("-", "") + 
               UUID.randomUUID().toString().replace("-", "");
    }
    
    private boolean storeResetToken(Connection connection, String email, String resetToken, String expiry) throws SQLException {
        // First, delete any existing tokens for this email
        String deleteSql = "DELETE FROM password_reset_tokens WHERE email = ?";
        try (PreparedStatement deleteStatement = connection.prepareStatement(deleteSql)) {
            deleteStatement.setString(1, email.toLowerCase().trim());
            deleteStatement.executeUpdate();
        }
        
        // Create table if it doesn't exist
        createPasswordResetTokensTable(connection);
        
        // Insert new token
        String sql = "INSERT INTO password_reset_tokens (email, token, expires_at, created_at) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.toLowerCase().trim());
            statement.setString(2, resetToken);
            statement.setString(3, expiry);
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    private void createPasswordResetTokensTable(Connection connection) throws SQLException {
        String sql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='password_reset_tokens' AND xtype='U') " +
                     "CREATE TABLE password_reset_tokens (" +
                     "id INT IDENTITY(1,1) PRIMARY KEY, " +
                     "email NVARCHAR(255) NOT NULL, " +
                     "token NVARCHAR(255) NOT NULL UNIQUE, " +
                     "expires_at DATETIME NOT NULL, " +
                     "created_at DATETIME NOT NULL, " +
                     "used_at DATETIME NULL" +
                     ")";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.execute();
        }
    }
    
    private String verifyResetToken(Connection connection, String token) throws SQLException {
        String sql = "SELECT email FROM password_reset_tokens WHERE token = ? AND expires_at > GETDATE() AND used_at IS NULL";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, token);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getString("email");
                }
            }
        }
        return null;
    }
    
    private boolean updatePassword(Connection connection, String email, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, hashPassword(newPassword));
            statement.setString(2, email.toLowerCase().trim());
            
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    private void deleteResetToken(Connection connection, String token) throws SQLException {
        String sql = "UPDATE password_reset_tokens SET used_at = GETDATE() WHERE token = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, token);
            statement.executeUpdate();
        }
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return password; // Fallback to plain text in case of error
        }
    }
    
    @GetMapping("/forgot-password-test")
    public ResponseEntity<Map<String, Object>> testForgotPasswordEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "ForgotPasswordController is working");
        response.put("endpoints", new String[]{"/api/forgot-password", "/api/reset-password", "/api/verify-reset-token"});
        return ResponseEntity.ok(response);
    }
}