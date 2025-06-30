package com.mycompany;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public ResponseEntity<Map<String, Object>> login(@RequestParam String email, @RequestParam String password) {
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
            
            String sql = "SELECT first_name, last_name, role, password FROM users WHERE email = ?";
            
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, email);
                
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        String dbPasswordFromDb = resultSet.getString("password");
                        String firstName = resultSet.getString("first_name");
                        String lastName = resultSet.getString("last_name");
                        String role = resultSet.getString("role");
                        
                        System.out.println("User found in database:");
                        System.out.println("  - Name: " + firstName + " " + lastName);
                        System.out.println("  - Role: " + role);
                        System.out.println("  - Password from DB: " + dbPasswordFromDb);
                        System.out.println("  - Password from input: " + password);
                        System.out.println("  - Passwords match: " + password.equals(dbPasswordFromDb));
                        
                        if (password.equals(dbPasswordFromDb)) {
                            // Lưu thông tin user vào session
                            session.setAttribute("user", email);
                            session.setAttribute("role", role);
                            session.setAttribute("fullName", firstName + " " + lastName);
                            session.setAttribute("isLoggedIn", true);
                            Map<String, Object> resp = new HashMap<>();
                            resp.put("success", true);
                            resp.put("role", role);
                            resp.put("fullName", firstName + " " + lastName);
                            System.out.println("Login successful for user: " + resp.get("fullName"));
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
}
