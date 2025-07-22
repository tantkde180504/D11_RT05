package com.mycompany.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/oauth2")
public class GoogleOAuthController {    @GetMapping("/user-info")
    public ResponseEntity<Map<String, Object>> getUserInfo(@AuthenticationPrincipal OAuth2User principal, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        System.out.println("=== USER INFO REQUEST ===");
        System.out.println("Principal: " + (principal != null ? "exists" : "null"));
        System.out.println("Session ID: " + session.getId());
        
        if (principal != null) {
            // User đăng nhập qua OAuth2
            String email = principal.getAttribute("email");
            if (email != null) email = email.trim().toLowerCase();
            System.out.println("[BAN CHECK] Email nhận từ Google: '" + email + "'");
            String name = principal.getAttribute("name");
            String picture = principal.getAttribute("picture");
            String role = (String) session.getAttribute("userRole");
            if (role == null) role = "CUSTOMER"; // Default role

            boolean foundUser = false;
            String statusLog = "";
            String banReasonLog = "";
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
                String username = "admin43@43gundam";
                String dbPassword = "Se18d06.";
                try (java.sql.Connection connection = java.sql.DriverManager.getConnection(connectionUrl, username, dbPassword)) {
                    String sql = "SELECT status, ban_reason FROM users WHERE email = ?";
                    try (java.sql.PreparedStatement stmt = connection.prepareStatement(sql)) {
                        stmt.setString(1, email);
                        try (java.sql.ResultSet rs = stmt.executeQuery()) {
                            if (rs.next()) {
                                foundUser = true;
                                String status = rs.getString("status");
                                String banReason = rs.getString("ban_reason");
                                statusLog = status;
                                banReasonLog = banReason;
                                System.out.println("[BAN CHECK] Email: " + email + ", Status: " + status + ", BanReason: " + banReason);
                                if ("banned".equalsIgnoreCase(status)) {
                                    response.put("success", false);
                                    response.put("isLoggedIn", false);
                                    response.put("banReason", banReason != null ? banReason : "Không có lý do cụ thể.");
                                    response.put("message", "Tài khoản của bạn đã bị cấm.");
                                    System.out.println("Google OAuth user is banned: " + email);
                                    System.out.println("[BAN RESPONSE] " + response);
                                    // Xóa session nếu user bị ban
                                    session.invalidate();
                                    return ResponseEntity.status(200)
                                            .header("Content-Type", "application/json")
                                            .body(response);
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                System.err.println("Error checking ban status for Google OAuth user: " + ex.getMessage());
            }

            if (!foundUser) {
                System.out.println("[BAN CHECK] Không tìm thấy user trong DB với email: " + email);
            } else {
                System.out.println("[BAN CHECK] User found, status: " + statusLog + ", banReason: " + banReasonLog);
            }

            response.put("email", email);
            response.put("name", name);
            response.put("picture", picture);
            response.put("role", role);
            response.put("isLoggedIn", true);
            response.put("loginType", "google");
            System.out.println("OAuth2 user found: " + name + " (" + email + ")");
            System.out.println("[BAN RESPONSE] " + response);
        } else {
            // Kiểm tra session cho user thường
            Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
            System.out.println("Session isLoggedIn: " + isLoggedIn);
            
            if (isLoggedIn != null && isLoggedIn) {
                response.put("email", session.getAttribute("userEmail"));
                response.put("name", session.getAttribute("userName"));
                response.put("picture", session.getAttribute("userPicture"));
                response.put("role", session.getAttribute("userRole"));
                response.put("isLoggedIn", true);
                response.put("loginType", session.getAttribute("loginType"));
                System.out.println("Session user found: " + session.getAttribute("userName"));
            } else {
                response.put("isLoggedIn", false);
                System.out.println("No user found in session or OAuth2");
            }
        }
          System.out.println("Response: " + response);
        return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
    }@PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        
        Map<String, Object> response = new HashMap<>();        response.put("success", true);
        response.put("message", "Đăng xuất thành công");
        
        return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
    }@GetMapping("/login-status")
    public ResponseEntity<Map<String, Object>> getLoginStatus(@AuthenticationPrincipal OAuth2User principal, HttpSession session) {
        // Redirect to user-info endpoint for consistency
        return getUserInfo(principal, session);
    }@GetMapping("/test")
    public Map<String, Object> testEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "working");
        response.put("timestamp", System.currentTimeMillis());
        System.out.println("Test endpoint called");
        return response;
    }
}