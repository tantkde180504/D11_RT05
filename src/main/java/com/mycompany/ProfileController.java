package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpServletRequest;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    @PostMapping(value = "/update", 
                consumes = MediaType.APPLICATION_JSON_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> updateProfile(@RequestBody Map<String, String> profileData, HttpSession session) {
        System.out.println("=== PROFILE UPDATE REQUEST RECEIVED ===");
        System.out.println("Profile data: " + profileData);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            String firstName = profileData.get("firstName");
            String lastName = profileData.get("lastName");
            String phone = profileData.get("phone");
            String address = profileData.get("address");
            String email = profileData.get("email");
            String dateOfBirth = profileData.get("dateOfBirth");
            String gender = profileData.get("gender");
            
            // Validation
            if (firstName == null || firstName.trim().isEmpty() || 
                lastName == null || lastName.trim().isEmpty() || 
                email == null || email.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Thiếu thông tin bắt buộc (họ, tên, email)!");
                return ResponseEntity.badRequest().body(response);
            }
            
            String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
            String username = "admin43@43gundam";
            String dbPassword = "Se18d06.";
            
            try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
                System.out.println("Database connection successful for profile update!");
                
                // Check if user exists
                String checkSql = "SELECT id, first_name, last_name, full_name FROM users WHERE email = ?";
                try (PreparedStatement checkStatement = connection.prepareStatement(checkSql)) {
                    checkStatement.setString(1, email);
                    
                    try (ResultSet resultSet = checkStatement.executeQuery()) {
                        if (resultSet.next()) {
                            // User exists, update profile
                            String fullName = firstName.trim() + " " + lastName.trim();
                            
                            String updateSql = "UPDATE users SET first_name = ?, last_name = ?, full_name = ?, phone = ?, address = ?, date_of_birth = ?, gender = ?, updated_at = GETDATE() WHERE email = ?";
                            try (PreparedStatement updateStatement = connection.prepareStatement(updateSql)) {
                                updateStatement.setString(1, firstName.trim());
                                updateStatement.setString(2, lastName.trim());
                                updateStatement.setString(3, fullName);
                                updateStatement.setString(4, phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
                                updateStatement.setString(5, address != null && !address.trim().isEmpty() ? address.trim() : null);
                                
                                // Handle date of birth
                                if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                                    try {
                                        updateStatement.setDate(6, java.sql.Date.valueOf(dateOfBirth));
                                    } catch (IllegalArgumentException e) {
                                        updateStatement.setDate(6, null);
                                    }
                                } else {
                                    updateStatement.setDate(6, null);
                                }
                                
                                updateStatement.setString(7, gender != null && !gender.trim().isEmpty() ? gender.trim() : null);
                                updateStatement.setString(8, email);
                                
                                int rowsUpdated = updateStatement.executeUpdate();
                                
                                if (rowsUpdated > 0) {
                                    System.out.println("Profile updated successfully for user: " + email);
                                    
                                    // Update session with new info
                                    session.setAttribute("userName", fullName);
                                    
                                    response.put("success", true);
                                    response.put("message", "Cập nhật thông tin thành công!");
                                    response.put("userData", Map.of(
                                        "firstName", firstName.trim(),
                                        "lastName", lastName.trim(),
                                        "fullName", fullName,
                                        "phone", phone != null ? phone.trim() : "",
                                        "address", address != null ? address.trim() : "",
                                        "dateOfBirth", dateOfBirth != null ? dateOfBirth.trim() : "",
                                        "gender", gender != null ? gender.trim() : ""
                                    ));
                                    
                                    return ResponseEntity.ok(response);
                                } else {
                                    response.put("success", false);
                                    response.put("message", "Không thể cập nhật thông tin!");
                                    return ResponseEntity.status(500).body(response);
                                }
                            }
                        } else {
                            System.out.println("User not found with email: " + email);
                            response.put("success", false);
                            response.put("message", "Không tìm thấy người dùng!");
                            return ResponseEntity.status(404).body(response);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error during profile update: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        } catch (Exception e) {
            System.out.println("General error during profile update: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
    
    @GetMapping(value = "/info", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getProfileInfo(HttpSession session) {
        System.out.println("=== PROFILE INFO REQUEST ===");
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            String userEmail = (String) session.getAttribute("userEmail");
            
            if (userEmail == null || userEmail.isEmpty()) {
                response.put("success", false);
                response.put("message", "Chưa đăng nhập!");
                return ResponseEntity.status(401).body(response);
            }
            
            String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
            String username = "admin43@43gundam";
            String dbPassword = "Se18d06.";
            
            try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
                String sql = "SELECT first_name, last_name, email, phone, address, date_of_birth, gender, role, provider FROM users WHERE email = ?";
                
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setString(1, userEmail);
                    
                    try (ResultSet resultSet = statement.executeQuery()) {
                        if (resultSet.next()) {
                            String firstName = resultSet.getString("first_name");
                            String lastName = resultSet.getString("last_name");
                            String phone = resultSet.getString("phone");
                            String address = resultSet.getString("address");
                            Date dateOfBirth = resultSet.getDate("date_of_birth");
                            String gender = resultSet.getString("gender");
                            String role = resultSet.getString("role");
                            String provider = resultSet.getString("provider");
                            
                            response.put("success", true);
                            response.put("userData", Map.of(
                                "firstName", firstName != null ? firstName : "",
                                "lastName", lastName != null ? lastName : "",
                                "fullName", (firstName != null ? firstName : "") + " " + (lastName != null ? lastName : ""),
                                "email", userEmail,
                                "phone", phone != null ? phone : "",
                                "address", address != null ? address : "",
                                "dateOfBirth", dateOfBirth != null ? dateOfBirth.toString() : "",
                                "gender", gender != null ? gender : "",
                                "role", role != null ? role : "CUSTOMER",
                                "provider", provider != null ? provider : "local"
                            ));
                            
                            return ResponseEntity.ok(response);
                        } else {
                            response.put("success", false);
                            response.put("message", "Không tìm thấy thông tin người dùng!");
                            return ResponseEntity.status(404).body(response);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi cơ sở dữ liệu!");
            return ResponseEntity.status(500).body(response);
        } catch (Exception e) {
            System.out.println("General error: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi hệ thống!");
            return ResponseEntity.status(500).body(response);
        }
    }
    
    @PostMapping(value = "/change-password", 
                consumes = MediaType.APPLICATION_JSON_VALUE,
                produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> request, HttpServletRequest httpRequest) {
        System.out.println("=== CHANGE PASSWORD REQUEST ===");
        
        Map<String, Object> response = new HashMap<>();
        
        // Get data from request
        String currentPassword = request.get("currentPassword");
        String newPassword = request.get("newPassword");
        String confirmPassword = request.get("confirmPassword");
        
        System.out.println("Current password: " + currentPassword);
        System.out.println("New password: " + newPassword);
        System.out.println("Confirm password: " + confirmPassword);
        
        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập mật khẩu hiện tại!");
            return ResponseEntity.badRequest().body(response);
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng nhập mật khẩu mới!");
            return ResponseEntity.badRequest().body(response);
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Vui lòng xác nhận mật khẩu mới!");
            return ResponseEntity.badRequest().body(response);
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.put("success", false);
            response.put("message", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            return ResponseEntity.badRequest().body(response);
        }
        
        if (newPassword.length() < 6) {
            response.put("success", false);
            response.put("message", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            return ResponseEntity.badRequest().body(response);
        }
        
        if (currentPassword.equals(newPassword)) {
            response.put("success", false);
            response.put("message", "Mật khẩu mới phải khác mật khẩu hiện tại!");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Get session
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để thay đổi mật khẩu!");
            return ResponseEntity.status(401).body(response);
        }
        
        String userEmail = (String) session.getAttribute("userEmail");
        String loginType = (String) session.getAttribute("loginType");
        
        System.out.println("User email from session: " + userEmail);
        System.out.println("Login type: " + loginType);
        
        // Check if user is OAuth-only user
        if ("google".equals(loginType)) {
            response.put("success", false);
            response.put("message", "Tài khoản Google không thể đổi mật khẩu trong hệ thống!");
            return ResponseEntity.badRequest().body(response);
        }
        
        // Database connection
        String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
        String username = "admin43@43gundam";
        String dbPassword = "Se18d06.";
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, dbPassword)) {
            System.out.println("Database connection successful for password change");
            
            // First, get current user info and verify current password
            String selectSql = "SELECT id, password, first_name, last_name, provider, oauth_provider FROM users WHERE email = ?";
            try (PreparedStatement selectStmt = connection.prepareStatement(selectSql)) {
                selectStmt.setString(1, userEmail);
                
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (!rs.next()) {
                        response.put("success", false);
                        response.put("message", "Không tìm thấy thông tin người dùng!");
                        return ResponseEntity.badRequest().body(response);
                    }
                    
                    long userId = rs.getLong("id");
                    String currentDbPassword = rs.getString("password");
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String provider = rs.getString("provider");
                    String oauthProvider = rs.getString("oauth_provider");
                    
                    System.out.println("Found user: " + firstName + " " + lastName);
                    System.out.println("Current DB password: " + currentDbPassword);
                    System.out.println("Provider: " + provider);
                    System.out.println("OAuth Provider: " + oauthProvider);
                    
                    // Check if this is an OAuth-only user
                    if ("OAUTH_USER".equals(currentDbPassword) || "google".equals(provider) || "google".equals(oauthProvider)) {
                        response.put("success", false);
                        response.put("message", "Tài khoản OAuth không thể đổi mật khẩu trong hệ thống!");
                        return ResponseEntity.badRequest().body(response);
                    }
                    
                    // Verify current password
                    String hashedCurrentPassword = hashPassword(currentPassword);
                    boolean currentPasswordMatch = hashedCurrentPassword.equals(currentDbPassword) || currentPassword.equals(currentDbPassword);
                    
                    System.out.println("=== PASSWORD VERIFICATION DEBUG ===");
                    System.out.println("Input password: " + currentPassword);
                    System.out.println("Hashed input password: " + hashedCurrentPassword);
                    System.out.println("DB password: " + currentDbPassword);
                    System.out.println("Hash match: " + hashedCurrentPassword.equals(currentDbPassword));
                    System.out.println("Plain match: " + currentPassword.equals(currentDbPassword));
                    System.out.println("Current password match: " + currentPasswordMatch);
                    
                    if (!currentPasswordMatch) {
                        response.put("success", false);
                        response.put("message", "Mật khẩu hiện tại không đúng!");
                        return ResponseEntity.badRequest().body(response);
                    }
                    
                    // Hash new password
                    String hashedNewPassword = hashPassword(newPassword);
                    
                    System.out.println("=== PASSWORD UPDATE DEBUG ===");
                    System.out.println("New password: " + newPassword);
                    System.out.println("Hashed new password: " + hashedNewPassword);
                    System.out.println("User ID: " + userId);
                    
                    // Update password in database
                    String updateSql = "UPDATE users SET password = ?, updated_at = GETDATE() WHERE id = ?";
                    System.out.println("Update SQL: " + updateSql);
                    
                    try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                        updateStmt.setString(1, hashedNewPassword);
                        updateStmt.setLong(2, userId);
                        
                        System.out.println("Executing update statement...");
                        int rowsUpdated = updateStmt.executeUpdate();
                        System.out.println("Rows updated: " + rowsUpdated);
                        
                        if (rowsUpdated > 0) {
                            System.out.println("Password updated successfully for user: " + userEmail);
                            response.put("success", true);
                            response.put("message", "Đổi mật khẩu thành công!");
                            return ResponseEntity.ok(response);
                        } else {
                            System.out.println("No rows were updated!");
                            response.put("success", false);
                            response.put("message", "Có lỗi xảy ra khi cập nhật mật khẩu!");
                            return ResponseEntity.badRequest().body(response);
                        }
                    } catch (SQLException updateEx) {
                        System.err.println("SQL Exception during update: " + updateEx.getMessage());
                        updateEx.printStackTrace();
                        response.put("success", false);
                        response.put("message", "Lỗi SQL khi cập nhật mật khẩu: " + updateEx.getMessage());
                        return ResponseEntity.status(500).body(response);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Database error during password change: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        } catch (Exception e) {
            System.err.println("Unexpected error during password change: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
    
    @GetMapping("/debug/session-info")
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
    
    @PostMapping("/debug/test-user-lookup")
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
    
    @PostMapping("/debug/test-password-hash")
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
}
