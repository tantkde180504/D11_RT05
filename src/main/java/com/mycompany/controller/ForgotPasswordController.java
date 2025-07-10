package com.mycompany.controller;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@RestController
@RequestMapping("/api/forgot-password")
public class ForgotPasswordController {
    
    @Autowired
    private JavaMailSender mailSender;
    
    // Store OTP data temporarily (in production, use Redis or database)
    private static final Map<String, OTPData> otpStorage = new ConcurrentHashMap<>();
    
    // Database connection details
    private static final String CONNECTION_URL = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private static final String DB_USERNAME = "admin43@43gundam";
    private static final String DB_PASSWORD = "Se18d06.";
    
    @PostMapping("/send-otp")
    public ResponseEntity<Map<String, Object>> sendOTP(@RequestBody Map<String, String> request) {
        System.out.println("=== SEND OTP REQUEST ===");
        
        String email = request.get("email");
        System.out.println("Email: " + email);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Check if email exists in database
            if (!isEmailExists(email)) {
                response.put("success", false);
                response.put("message", "Email không tồn tại trong hệ thống!");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Generate 6-digit OTP
            String otp = generateOTP();
            System.out.println("Generated OTP: " + otp);
            
            // Store OTP with expiration (10 minutes)
            OTPData otpData = new OTPData(otp, LocalDateTime.now().plusMinutes(10));
            otpStorage.put(email, otpData);
            
            // Send OTP via email
            boolean emailSent = sendOTPEmail(email, otp);
            
            if (emailSent) {
                response.put("success", true);
                response.put("message", "Mã OTP đã được gửi đến email của bạn!");
                System.out.println("OTP sent successfully to: " + email);
            } else {
                response.put("success", false);
                response.put("message", "Không thể gửi email! Vui lòng thử lại.");
                System.out.println("Failed to send OTP email");
            }
            
        } catch (Exception e) {
            System.err.println("Error in send OTP: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra! Vui lòng thử lại.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/verify-otp")
    public ResponseEntity<Map<String, Object>> verifyOTP(@RequestBody Map<String, String> request) {
        System.out.println("=== VERIFY OTP REQUEST ===");
        
        String email = request.get("email");
        String inputOtp = request.get("otp");
        System.out.println("Email: " + email + ", OTP: " + inputOtp);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            OTPData otpData = otpStorage.get(email);
            
            if (otpData == null) {
                response.put("success", false);
                response.put("message", "Mã OTP không tồn tại hoặc đã hết hạn!");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Check if OTP is expired
            if (LocalDateTime.now().isAfter(otpData.getExpiryTime())) {
                otpStorage.remove(email); // Clean up expired OTP
                response.put("success", false);
                response.put("message", "Mã OTP đã hết hạn! Vui lòng yêu cầu mã mới.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Verify OTP
            if (!otpData.getOtp().equals(inputOtp)) {
                response.put("success", false);
                response.put("message", "Mã OTP không chính xác!");
                return ResponseEntity.badRequest().body(response);
            }
            
            // OTP is valid, generate verification token
            String verificationToken = generateVerificationToken(email);
            
            response.put("success", true);
            response.put("token", verificationToken);
            response.put("message", "Mã OTP chính xác!");
            
            System.out.println("OTP verified successfully for: " + email);
            
        } catch (Exception e) {
            System.err.println("Error in verify OTP: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra! Vui lòng thử lại.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(@RequestBody Map<String, String> request) {
        System.out.println("=== RESET PASSWORD REQUEST ===");
        
        String token = request.get("token");
        String newPassword = request.get("newPassword");
        String email = request.get("email");
        
        System.out.println("Email: " + email + ", Token: " + token);
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Verify token (in this simple implementation, decode email from token)
            String decodedEmail = verifyAndDecodeToken(token);
            
            if (decodedEmail == null || !decodedEmail.equals(email)) {
                response.put("success", false);
                response.put("message", "Token không hợp lệ!");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Update password in database
            boolean passwordUpdated = updatePasswordInDatabase(email, newPassword);
            
            if (passwordUpdated) {
                // Clean up OTP data
                otpStorage.remove(email);
                
                response.put("success", true);
                response.put("message", "Mật khẩu đã được cập nhật thành công!");
                System.out.println("Password updated successfully for: " + email);
            } else {
                response.put("success", false);
                response.put("message", "Không thể cập nhật mật khẩu! Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.err.println("Error in reset password: " + e.getMessage());
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra! Vui lòng thử lại.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Helper methods
    private boolean isEmailExists(String email) {
        try (Connection conn = DriverManager.getConnection(CONNECTION_URL, DB_USERNAME, DB_PASSWORD)) {
            String sql = "SELECT COUNT(*) FROM [users] WHERE email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // Generate 6-digit number
        return String.valueOf(otp);
    }
    
    private boolean sendOTPEmail(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("43gundamhobby@gmail.com");
            message.setTo(toEmail);
            message.setSubject("43 Gundam Hobby - Mã OTP đặt lại mật khẩu");
            
            String emailBody = String.format(
                "Xin chào,\n\n" +
                "Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản 43 Gundam Hobby.\n\n" +
                "Mã OTP của bạn là: %s\n\n" +
                "Mã này có hiệu lực trong 10 phút.\n\n" +
                "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.\n\n" +
                "Trân trọng,\n" +
                "Đội ngũ 43 Gundam Hobby",
                otp
            );
            
            message.setText(emailBody);
            
            mailSender.send(message);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    private String generateVerificationToken(String email) {
        try {
            // Simple token: Base64 encoded email with timestamp
            String data = email + ":" + System.currentTimeMillis();
            return Base64.getEncoder().encodeToString(data.getBytes());
        } catch (Exception e) {
            System.err.println("Error generating token: " + e.getMessage());
            return null;
        }
    }
    
    private String verifyAndDecodeToken(String token) {
        try {
            String decoded = new String(Base64.getDecoder().decode(token));
            String[] parts = decoded.split(":");
            if (parts.length == 2) {
                String email = parts[0];
                long timestamp = Long.parseLong(parts[1]);
                
                // Check if token is not older than 30 minutes
                long currentTime = System.currentTimeMillis();
                if (currentTime - timestamp < 30 * 60 * 1000) { // 30 minutes
                    return email;
                }
            }
        } catch (Exception e) {
            System.err.println("Error verifying token: " + e.getMessage());
        }
        return null;
    }
    
    private boolean updatePasswordInDatabase(String email, String newPassword) {
        try (Connection conn = DriverManager.getConnection(CONNECTION_URL, DB_USERNAME, DB_PASSWORD)) {
            String hashedPassword = hashPassword(newPassword);
            String sql = "UPDATE [users] SET password = ? WHERE email = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, hashedPassword);
                stmt.setString(2, email);
                
                int rowsAffected = stmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            System.err.println("Error hashing password: " + e.getMessage());
            return password; // Fallback (not recommended for production)
        }
    }
    
    // Inner class for OTP data
    private static class OTPData {
        private final String otp;
        private final LocalDateTime expiryTime;
        
        public OTPData(String otp, LocalDateTime expiryTime) {
            this.otp = otp;
            this.expiryTime = expiryTime;
        }
        
        public String getOtp() {
            return otp;
        }
        
        public LocalDateTime getExpiryTime() {
            return expiryTime;
        }
    }
}
