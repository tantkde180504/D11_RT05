package com.mycompany;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class RegisterController {

    // Email validation pattern
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");

    @PostMapping(value = "/register", 
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> register(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam(required = false) String phone) {
        
        System.out.println("=== REGISTER REQUEST RECEIVED ===");
        System.out.println("First Name: " + firstName);
        System.out.println("Last Name: " + lastName);
        System.out.println("Email: " + email);
        System.out.println("Phone: " + phone);
        
        Map<String, Object> response = new HashMap<>();
        
        // Validate input
        if (!validateInput(firstName, lastName, email, password, confirmPassword, response)) {
            return ResponseEntity.badRequest()
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(response);
        }
        
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            System.out.println("Database connection successful!");
            
            // Check if email already exists
            if (emailExists(connection, email)) {
                response.put("success", false);
                response.put("message", "Email đã được sử dụng!");
                return ResponseEntity.badRequest()
                        .contentType(MediaType.APPLICATION_JSON)
                        .body(response);
            }
            
            // Insert new user
            String sql = "INSERT INTO users (first_name, last_name, email, password, phone, role) VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, firstName.trim());
                statement.setString(2, lastName.trim());
                statement.setString(3, email.toLowerCase().trim());
                statement.setString(4, hashPassword(password)); // Hash password before storing
                statement.setString(5, phone != null ? phone.trim() : null);
                statement.setString(6, "CUSTOMER"); // Default role
                
                int rowsAffected = statement.executeUpdate();
                
                if (rowsAffected > 0) {
                    System.out.println("User registered successfully: " + email);
                    response.put("success", true);
                    response.put("message", "Đăng ký thành công!");
                    response.put("fullName", firstName + " " + lastName);
                    
                    return ResponseEntity.ok()
                            .contentType(MediaType.APPLICATION_JSON)
                            .body(response);
                } else {
                    System.out.println("Failed to insert user");
                    response.put("success", false);
                    response.put("message", "Có lỗi xảy ra khi đăng ký!");
                    return ResponseEntity.internalServerError()
                            .contentType(MediaType.APPLICATION_JSON)
                            .body(response);
                }
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
    
    private boolean validateInput(String firstName, String lastName, String email, 
                                String password, String confirmPassword, Map<String, Object> response) {
        
        // Check required fields
        if (firstName == null || firstName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập họ!");
            return false;
        }
        
        if (lastName == null || lastName.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập tên!");
            return false;
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
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng xác nhận mật khẩu!");
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
        
        // Check password confirmation
        if (!password.equals(confirmPassword)) {
            response.put("success", false);
            response.put("message", "Mật khẩu xác nhận không khớp!");
            return false;
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
}