package com.mycompany.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class OTPService {
    
    @Autowired
    private EmailService emailService;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    // Database connection details
    private final String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private final String username = "admin43@43gundam";
    private final String password = "Se18d06.";
    
    public boolean sendOTP(String email, String firstName, String lastName, String userPassword, String phone) {
        try {
            System.out.println("=== STARTING SEND OTP PROCESS ===");
            
            // Generate OTP
            String otp = emailService.generateOTP();
            System.out.println("Generated OTP: " + otp);
            
            // Create user data JSON
            Map<String, Object> userData = new HashMap<>();
            userData.put("firstName", firstName);
            userData.put("lastName", lastName);
            userData.put("email", email);
            userData.put("password", userPassword); // Already hashed
            userData.put("phone", phone);
            userData.put("role", "CUSTOMER");
            
            String userDataJson = objectMapper.writeValueAsString(userData);
            System.out.println("User data JSON created");
            
            // Check if email_verification table exists
            if (!checkEmailVerificationTableExists()) {
                System.err.println("email_verification table does not exist! Creating it...");
                if (!createEmailVerificationTable()) {
                    System.err.println("Failed to create email_verification table!");
                    return false;
                }
            }
            
            // Store OTP in database
            if (storeOTP(email, otp, userDataJson)) {
                System.out.println("OTP stored successfully, now sending email...");
                // Send OTP email
                return emailService.sendOTPEmail(email, otp, firstName, lastName);
            } else {
                System.err.println("Failed to store OTP in database");
                return false;
            }
            
        } catch (Exception e) {
            System.err.println("Error sending OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean storeOTP(String email, String otp, String userDataJson) {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            
            System.out.println("=== STORING OTP ===");
            System.out.println("Email: " + email);
            System.out.println("OTP: " + otp);
            System.out.println("UserData: " + userDataJson);
            
            // Clean up existing OTP records for this email
            String deleteOldOTP = "DELETE FROM email_verification WHERE email = ?";
            try (PreparedStatement deleteStmt = connection.prepareStatement(deleteOldOTP)) {
                deleteStmt.setString(1, email);
                int deletedRows = deleteStmt.executeUpdate();
                System.out.println("Deleted " + deletedRows + " old OTP records");
            }
            
            // Insert new OTP record
            String insertOTP = "INSERT INTO email_verification (email, otp_code, user_data, expires_at) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insertStmt = connection.prepareStatement(insertOTP)) {
                insertStmt.setString(1, email);
                insertStmt.setString(2, otp);
                insertStmt.setString(3, userDataJson);
                
                // Set expiration time (10 minutes from now)
                LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(10);
                insertStmt.setTimestamp(4, Timestamp.valueOf(expiresAt));
                
                int rowsAffected = insertStmt.executeUpdate();
                System.out.println("Inserted " + rowsAffected + " OTP record");
                System.out.println("OTP will expire at: " + expiresAt);
                return rowsAffected > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error storing OTP: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    public Map<String, Object> verifyOTP(String email, String otp) {
        Map<String, Object> result = new HashMap<>();
        
        System.out.println("=== VERIFYING OTP ===");
        System.out.println("Email: " + email);
        System.out.println("OTP: " + otp);
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            
            // Get OTP record
            String selectOTP = "SELECT id, otp_code, user_data, expires_at, attempts FROM email_verification WHERE email = ? AND verified = 0";
            try (PreparedStatement selectStmt = connection.prepareStatement(selectOTP)) {
                selectStmt.setString(1, email);
                
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        long id = rs.getLong("id");
                        String storedOTP = rs.getString("otp_code");
                        String userDataJson = rs.getString("user_data");
                        Timestamp expiresAt = rs.getTimestamp("expires_at");
                        int attempts = rs.getInt("attempts");
                        
                        System.out.println("Found OTP record with ID: " + id);
                        System.out.println("Stored OTP: " + storedOTP);
                        System.out.println("Expires at: " + expiresAt);
                        System.out.println("Attempts: " + attempts);
                        
                        // Check if OTP has expired
                        if (expiresAt.before(new Timestamp(System.currentTimeMillis()))) {
                            System.out.println("OTP has expired!");
                            result.put("success", false);
                            result.put("message", "Mã OTP đã hết hạn!");
                            return result;
                        }
                        
                        // Check max attempts
                        if (attempts >= 3) {
                            System.out.println("Max attempts reached!");
                            result.put("success", false);
                            result.put("message", "Bạn đã nhập sai OTP quá 3 lần!");
                            return result;
                        }
                        
                        // Verify OTP
                        if (storedOTP.equals(otp)) {
                            System.out.println("OTP matches! Creating user account...");
                            // OTP is correct, create user account
                            if (createUserAccount(userDataJson, connection)) {
                                // Mark OTP as verified
                                markOTPAsVerified(id, connection);
                                
                                result.put("success", true);
                                result.put("message", "Xác thực thành công! Tài khoản đã được tạo.");
                                return result;
                            } else {
                                System.out.println("Failed to create user account!");
                                result.put("success", false);
                                result.put("message", "Có lỗi xảy ra khi tạo tài khoản!");
                                return result;
                            }
                        } else {
                            System.out.println("OTP does not match! Expected: " + storedOTP + ", Got: " + otp);
                            // Increment attempts
                            incrementOTPAttempts(id, connection);
                            
                            result.put("success", false);
                            result.put("message", "Mã OTP không đúng!");
                            return result;
                        }
                    } else {
                        System.out.println("No OTP record found for email: " + email);
                        result.put("success", false);
                        result.put("message", "Không tìm thấy mã OTP hoặc email không hợp lệ!");
                        return result;
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error verifying OTP: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Có lỗi xảy ra khi xác thực OTP!");
            return result;
        }
    }
    
    @SuppressWarnings("unchecked")
    private boolean createUserAccount(String userDataJson, Connection connection) {
        try {
            Map<String, Object> userData = objectMapper.readValue(userDataJson, Map.class);
            
            String sql = "INSERT INTO users (first_name, last_name, email, password, phone, role, email_verified, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, (String) userData.get("firstName"));
                stmt.setString(2, (String) userData.get("lastName"));
                stmt.setString(3, (String) userData.get("email"));
                stmt.setString(4, (String) userData.get("password"));
                stmt.setString(5, (String) userData.get("phone"));
                stmt.setString(6, (String) userData.get("role"));
                stmt.setBoolean(7, true); // Email verified
                stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
                
                int rowsAffected = stmt.executeUpdate();
                return rowsAffected > 0;
            }
            
        } catch (Exception e) {
            System.err.println("Error creating user account: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private void markOTPAsVerified(long id, Connection connection) throws SQLException {
        String updateSQL = "UPDATE email_verification SET verified = 1 WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(updateSQL)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }
    
    private void incrementOTPAttempts(long id, Connection connection) throws SQLException {
        String updateSQL = "UPDATE email_verification SET attempts = attempts + 1 WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(updateSQL)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }
    
    @SuppressWarnings("unchecked")
    public boolean resendOTP(String email) {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            
            // Get existing user data
            String selectOTP = "SELECT user_data FROM email_verification WHERE email = ? AND verified = 0";
            try (PreparedStatement selectStmt = connection.prepareStatement(selectOTP)) {
                selectStmt.setString(1, email);
                
                try (ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        String userDataJson = rs.getString("user_data");
                        Map<String, Object> userData = objectMapper.readValue(userDataJson, Map.class);
                        
                        // Send new OTP
                        return sendOTP(email, 
                                     (String) userData.get("firstName"),
                                     (String) userData.get("lastName"),
                                     (String) userData.get("password"),
                                     (String) userData.get("phone"));
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error resending OTP: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    private boolean checkEmailVerificationTableExists() {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String checkTableSQL = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'email_verification'";
            try (PreparedStatement stmt = connection.prepareStatement(checkTableSQL)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        System.out.println("email_verification table exists: " + (count > 0));
                        return count > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking email_verification table: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    private boolean createEmailVerificationTable() {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String createTableSQL = "CREATE TABLE email_verification (" +
                    "id BIGINT IDENTITY(1,1) PRIMARY KEY," +
                    "email NVARCHAR(255) NOT NULL," +
                    "otp_code NVARCHAR(6) NOT NULL," +
                    "user_data NVARCHAR(MAX) NOT NULL," +
                    "created_at DATETIME2 DEFAULT GETDATE()," +
                    "expires_at DATETIME2 NOT NULL," +
                    "verified BIT DEFAULT 0," +
                    "attempts INT DEFAULT 0," +
                    "INDEX idx_email_otp (email, otp_code)," +
                    "INDEX idx_expires_at (expires_at)" +
                    ")";
            
            try (PreparedStatement stmt = connection.prepareStatement(createTableSQL)) {
                stmt.executeUpdate();
                System.out.println("email_verification table created successfully");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating email_verification table: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
