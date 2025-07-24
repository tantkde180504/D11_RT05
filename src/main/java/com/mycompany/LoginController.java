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

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api")
public class LoginController {

    @Autowired
    private HttpSession session;

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
            String sql = "SELECT id, first_name, last_name, role, password, status, ban_reason FROM users WHERE email = ?";
            
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
                        String status = resultSet.getString("status");
                        String banReason = resultSet.getString("ban_reason");
                        
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

                        // Kiểm tra trạng thái ban trước khi kiểm tra mật khẩu
                        if ("banned".equalsIgnoreCase(status)) {
                            Map<String, Object> resp = new HashMap<>();
                            resp.put("success", false);
                            resp.put("message", "Tài khoản của bạn đã bị cấm.");
                            resp.put("banReason", banReason != null ? banReason : "Không có lý do cụ thể.");
                            // Không cho đăng nhập, không tạo session
                            return ResponseEntity.status(200)
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
    
    @GetMapping("/debug-session")
    public ResponseEntity<Map<String, Object>> debugSession(HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.put("sessionExists", false);
            response.put("message", "No session found");
            return ResponseEntity.ok(response);
        }
        
        response.put("sessionExists", true);
        response.put("sessionId", session.getId());
        response.put("userEmail", session.getAttribute("userEmail"));
        response.put("userName", session.getAttribute("userName"));
        response.put("userRole", session.getAttribute("userRole"));
        response.put("loginType", session.getAttribute("loginType"));
        response.put("userId", session.getAttribute("userId"));
        response.put("isLoggedIn", session.getAttribute("isLoggedIn"));
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/debug-user")
    public ResponseEntity<Map<String, Object>> debugUser(@RequestParam String email) {
        Map<String, Object> response = new HashMap<>();
        
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Email is required");
            return ResponseEntity.badRequest().body(response);
        }
        
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            String sql = "SELECT id, email, first_name, last_name, role, provider, oauth_provider, password FROM users WHERE email = ?";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, email);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        response.put("found", true);
                        response.put("userId", rs.getLong("id"));
                        response.put("email", rs.getString("email"));
                        response.put("firstName", rs.getString("first_name"));
                        response.put("lastName", rs.getString("last_name"));
                        response.put("role", rs.getString("role"));
                        response.put("provider", rs.getString("provider"));
                        response.put("oauthProvider", rs.getString("oauth_provider"));
                        response.put("hasPassword", rs.getString("password") != null);
                        response.put("passwordLength", rs.getString("password") != null ? rs.getString("password").length() : 0);
                        response.put("passwordPreview", rs.getString("password") != null ? rs.getString("password").substring(0, Math.min(10, rs.getString("password").length())) + "..." : "null");
                    } else {
                        response.put("found", false);
                        response.put("message", "User not found");
                    }
                }
            }
            
            response.put("success", true);
            return ResponseEntity.ok(response);
            
        } catch (SQLException e) {
            response.put("success", false);
            response.put("message", "Database error: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
    
    @PostMapping("/debug-hash")
    public ResponseEntity<Map<String, Object>> debugHash(@RequestParam String password) {
        Map<String, Object> response = new HashMap<>();
        
        if (password == null || password.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Password is required");
            return ResponseEntity.badRequest().body(response);
        }
        
        try {
            String hashedPassword = hashPassword(password);
            response.put("success", true);
            response.put("originalPassword", password);
            response.put("hashedPassword", hashedPassword);
            response.put("hashLength", hashedPassword.length());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error hashing password: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
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
                return "shippersc.jsp"; // Shipper management page
            default:
                return "index.jsp"; // Default fallback for unknown roles
        }
    }
}
