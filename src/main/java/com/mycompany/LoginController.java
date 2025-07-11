package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@RestController
@RequestMapping("/api")
public class LoginController {

    @GetMapping("/login-test")
    public ResponseEntity<Map<String, Object>> testLoginEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "LoginController is working");
        response.put("endpoint", "/api/login");
        response.put("method", "POST");
        return ResponseEntity.ok(response);
    }    @PostMapping(value = "/login", 
                consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> login(@RequestParam String email, @RequestParam String password, HttpServletRequest request) {
        System.out.println("=== LOGIN REQUEST RECEIVED ===");
        System.out.println("Email: " + email);
        System.out.println("Password: " + password);          String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        System.out.println("=== CONNECTION INFO ===");
        System.out.println("URL: " + connectionUrl);
        System.out.println("Username: " + username);
        System.out.println("Password: " + dbPassword);
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            System.out.println("Database connection successful!");
            
            // Đầu tiên, hãy kiểm tra xem có user nào trong database không
            String countSql = "SELECT COUNT(*) as user_count FROM users";
            try (PreparedStatement countStatement = connection.prepareStatement(countSql);
                 ResultSet countResult = countStatement.executeQuery()) {
                if (countResult.next()) {
                    System.out.println("Total users in database: " + countResult.getInt("user_count"));
                }
            }
            
            // Liệt kê tất cả users để debug
            String listSql = "SELECT email, first_name, last_name, role FROM users";
            try (PreparedStatement listStatement = connection.prepareStatement(listSql);
                 ResultSet listResult = listStatement.executeQuery()) {
                System.out.println("=== ALL USERS IN DATABASE ===");
                while (listResult.next()) {
                    System.out.println("Email: " + listResult.getString("email") + 
                                     " | Name: " + listResult.getString("first_name") + " " + listResult.getString("last_name") +
                                     " | Role: " + listResult.getString("role"));
                }
            }
            
            // For now, let's use a simple approach without provider column
            // to avoid the SQL error and get login working first
            String sql = "SELECT id, first_name, last_name, role, password FROM users WHERE email = ?";
            
            System.out.println("Using SQL: " + sql);
            
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, email);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        int userId = resultSet.getInt("id"); // Lấy id từ DB
                        String dbPasswordFromDb = resultSet.getString("password");
                        String firstName = resultSet.getString("first_name");
                        String lastName = resultSet.getString("last_name");
                        String role = resultSet.getString("role");
                        
                        // Skip provider column for now to avoid SQL errors
                        String provider = null;
                        
                        System.out.println("User found in database:");
                        System.out.println("  - UserID: " + userId);
                        System.out.println("  - Name: " + firstName + " " + lastName);
                        System.out.println("  - Role: " + role);
                        System.out.println("  - Provider: " + provider + " (skipped for now)");
                        System.out.println("  - Password from DB: " + dbPasswordFromDb);
                        System.out.println("  - Password from input: " + password);
                        
                        // Check if this is an OAuth-only user (no password set)
                        if ("OAUTH_USER".equals(dbPasswordFromDb)) {
                            System.out.println("OAuth-only user trying to login with password - not allowed");
                            Map<String, Object> resp = new HashMap<>();
                            resp.put("success", false);
                            resp.put("message", "Tài khoản này chỉ có thể đăng nhập bằng Google!");
                            return ResponseEntity.status(401)
                                    .contentType(MediaType.APPLICATION_JSON)
                                    .body(resp);
                        }
                        
                        // For users with both OAuth and password, allow password login
                        System.out.println("User has both OAuth and password capability - allowing password login");
                        
                        String hashedInputPassword = hashPassword(password);
                        boolean passwordMatch = hashedInputPassword.equals(dbPasswordFromDb) || password.equals(dbPasswordFromDb);
                        System.out.println("  - Passwords match: " + passwordMatch);
                        
                        if (passwordMatch) {
                            // Create session for email/password login
                            HttpSession session = request.getSession(true);
                            session.setAttribute("isLoggedIn", true);
                            session.setAttribute("userEmail", email);
                            session.setAttribute("userName", firstName + " " + lastName);
                            session.setAttribute("userRole", role);
                            session.setAttribute("loginType", "email");
                            session.setAttribute("userId", userId);
                            
                            System.out.println("=== EMAIL LOGIN SESSION CREATED ===");
                            System.out.println("Session ID: " + session.getId());
                            System.out.println("User: " + firstName + " " + lastName);
                            System.out.println("Email: " + email);
                            System.out.println("Role: " + role);
                            
                            // Determine redirect URL based on role
                            String redirectUrl = getRedirectUrlByRole(role);
                            
                            Map<String, Object> resp = new HashMap<>();
                            resp.put("success", true);
                            resp.put("role", role);
                            resp.put("userId", userId);
                            resp.put("fullName", firstName + " " + lastName);
                            resp.put("email", email);
                            resp.put("avatarUrl", ""); // Will be generated on client-side from email
                            resp.put("redirectUrl", redirectUrl); // Add redirect URL based on role
                            System.out.println("Login successful for user: " + resp.get("fullName") + " - Redirecting to: " + redirectUrl);
                            return ResponseEntity.ok()
                                    .contentType(MediaType.APPLICATION_JSON)
                                    .body(resp);
                        } else {
                            System.out.println("Password mismatch");
                        }
                    } else {
                        System.out.println("User not found in database with email: " + email);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
        }
        
        Map<String, Object> resp = new HashMap<>();
        resp.put("success", false);
        resp.put("message", "Sai email hoặc mật khẩu!");
        System.out.println("Login failed");
        return ResponseEntity.status(401)
                .contentType(MediaType.APPLICATION_JSON)
                .body(resp);
    }
    
    @GetMapping("/login-status")
    public ResponseEntity<Map<String, Object>> loginStatus() {
        Map<String, Object> resp = new HashMap<>();
        resp.put("status", "Login endpoint is working");
        resp.put("endpoint", "/api/login");
        resp.put("method", "POST");
        System.out.println("Login status check");
        return ResponseEntity.ok(resp);
    }
    
    // Password hashing method
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
    
    // Method to determine redirect URL based on user role
    private String getRedirectUrlByRole(String role) {
        if (role == null) {
            return "index.jsp"; // Default fallback
        }
        
        switch (role.toUpperCase()) {
            case "ADMIN":
                return "dashboard.jsp"; // Admin dashboard page
            case "STAFF":
                return "staffsc.jsp"; // Staff management page
            case "CUSTOMER":
                return "index.jsp"; // Customer homepage
            case "SHIPPER":
                return "dashboard.jsp"; // Shipper dashboard (you can create a specific page later)
            default:
                return "index.jsp"; // Default fallback for unknown roles
        }
    }
}
