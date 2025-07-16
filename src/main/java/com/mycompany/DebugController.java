package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@RestController
@RequestMapping("/api/debug")
public class DebugController {

    @GetMapping("/session-info")
    public ResponseEntity<Map<String, Object>> getSessionInfo(HttpServletRequest request) {
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
    
    @PostMapping("/test-user-lookup")
    public ResponseEntity<Map<String, Object>> testUserLookup(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String email = request.get("email");
        
        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Email is required");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Database connection
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
    
    @PostMapping("/test-password-hash")
    public ResponseEntity<Map<String, Object>> testPasswordHash(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String password = request.get("password");
        
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
    
    // Password hashing method (same as PasswordController)
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
}
