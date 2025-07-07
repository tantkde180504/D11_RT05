package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;
import jakarta.servlet.http.HttpSession;

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
}
