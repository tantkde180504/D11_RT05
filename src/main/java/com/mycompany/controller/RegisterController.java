package com.mycompany.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.beans.factory.annotation.Autowired;
import com.mycompany.service.OTPService;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import java.util.regex.Pattern;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", maxAge = 3600)
public class RegisterController {

    @Autowired
    private OTPService otpService;

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

    @PostMapping(value = "/register", 
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> register(
            @RequestParam(required = false) String firstName,
            @RequestParam(required = false) String lastName,
            @RequestParam(required = false) String fullName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam(required = false) String confirmPassword,
            @RequestParam(required = false) String phone) {
        
        System.out.println("=== REGISTER REQUEST RECEIVED ===");
        
        // Handle fullName parameter - split into firstName and lastName
        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] nameParts = fullName.trim().split("\\s+", 2);
            if (firstName == null || firstName.trim().isEmpty()) {
                firstName = nameParts[0];
            }
            if (lastName == null || lastName.trim().isEmpty()) {
                lastName = nameParts.length > 1 ? nameParts[1] : "";
            }
        }
        
        System.out.println("Full Name: " + fullName);
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Validate input
            if (!validateInput(firstName, lastName, email, password, confirmPassword, response)) {
                System.out.println("Validation failed: " + response.get("message"));
                return ResponseEntity.badRequest()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
            String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
            String username = "admin43@43gundam";
            String dbPassword = "Se18d06.";
            
            try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
                System.out.println("Database connection successful!");
                
                // Check if email already exists in users table
                if (emailExists(connection, email)) {
                    response.put("success", false);
                    response.put("message", "Email đã được sử dụng!");
                    System.out.println("Email already exists: " + email);
                    return ResponseEntity.badRequest()
                            .contentType(MediaType.APPLICATION_JSON)
                            .body(response);
                }
                
                // Hash password
                String hashedPassword = hashPassword(password);
                
                // Send OTP instead of creating user directly
                System.out.println("Attempting to send OTP...");
                if (otpService.sendOTP(email, firstName.trim(), lastName.trim(), hashedPassword, phone != null ? phone.trim() : null)) {
                    System.out.println("OTP sent successfully to: " + email);
                    response.put("success", true);
                    response.put("message", "Mã OTP đã được gửi đến email của bạn!");
                    response.put("email", email);
                    response.put("nextStep", "verify-otp");
                    
                    return ResponseEntity.ok()
                            .contentType(MediaType.APPLICATION_JSON)
                            .body(response);
                } else {
                    System.out.println("Failed to send OTP to: " + email);
                    response.put("success", false);
                    response.put("message", "Có lỗi xảy ra khi gửi mã OTP!");
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
            
        } catch (Exception e) {
            System.out.println("Unexpected error in register endpoint: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra khi đăng ký! Vui lòng thử lại.");
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }
    
    private boolean validateInput(String firstName, String lastName, String email, 
                                String password, String confirmPassword, Map<String, Object> response) {
        
        // Check required fields
        if (firstName == null || firstName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập họ tên!");
            return false;
        }
        
        // lastName can be empty (when splitting fullName)
        if (lastName == null) {
            lastName = "";
        }
        
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập email!");
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập mật khẩu!");
            return false;
        }
        
        // Validate email format
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            response.put("success", false);
            response.put("message", "Email không hợp lệ!");
            return false;
        }
        
        // Validate password length
        if (password.length() < 6) {
            response.put("success", false);
            response.put("message", "Mật khẩu phải có ít nhất 6 ký tự!");
            return false;
        }
        
        if (confirmPassword != null && !confirmPassword.trim().isEmpty()) {
            // Check password confirmation only if confirmPassword is provided
            if (!password.equals(confirmPassword)) {
                response.put("success", false);
                response.put("message", "Mật khẩu xác nhận không khớp!");
                return false;
            }
        }
        
        // Validate name length
        if (firstName.trim().length() > 50) {
            response.put("success", false);
            response.put("message", "Họ không được vượt quá 50 ký tự!");
            return false;
        }
        
        if (lastName.trim().length() > 50) {
            response.put("success", false);
            response.put("message", "Tên không được vượt quá 50 ký tự!");
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
    
    // Password hashing methods
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
    
    @GetMapping("/register-test")
    public ResponseEntity<Map<String, Object>> testRegisterEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "RegisterController is working");
        response.put("endpoint", "/api/register");
        response.put("method", "POST");
        return ResponseEntity.ok(response);
    }
    
    // OTP Verification endpoint
    @PostMapping(value = "/verify-otp",
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> verifyOTP(
            @RequestParam String email,
            @RequestParam String otp) {
        
        System.out.println("=== OTP VERIFICATION REQUEST ===");
        System.out.println("Email: " + email);
        System.out.println("OTP: " + otp);
        
        Map<String, Object> response = new HashMap<>();
        
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Email không được để trống!");
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        if (otp == null || otp.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Mã OTP không được để trống!");
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        // Verify OTP
        Map<String, Object> verificationResult = otpService.verifyOTP(email.toLowerCase().trim(), otp.trim());
        
        if ((Boolean) verificationResult.get("success")) {
            System.out.println("OTP verification successful for: " + email);
            response.put("success", true);
            response.put("message", "Xác thực thành công! Tài khoản đã được tạo.");
            response.put("redirectTo", "/login.jsp");
            
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        } else {
            System.out.println("OTP verification failed for: " + email);
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(verificationResult);
        }
    }
    
    // Resend OTP endpoint
    @PostMapping(value = "/resend-otp",
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> resendOTP(@RequestParam String email) {
        
        System.out.println("=== RESEND OTP REQUEST ===");
        System.out.println("Email: " + email);
        
        Map<String, Object> response = new HashMap<>();
        
        // Validate input
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Email không được để trống!");
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        // Resend OTP
        if (otpService.resendOTP(email.toLowerCase().trim())) {
            System.out.println("OTP resent successfully to: " + email);
            response.put("success", true);
            response.put("message", "Mã OTP mới đã được gửi đến email của bạn!");
            
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        } else {
            System.out.println("Failed to resend OTP for: " + email);
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra khi gửi lại mã OTP!");
            
            return ResponseEntity.internalServerError()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
    }
}
