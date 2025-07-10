package com.mycompany.service;

import org.springframework.stereotype.Service;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * Service để lấy thông tin user từ database
 */
@Service
public class UserService {
    
    private final String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private final String username = "admin43@43gundam";
    private final String password = "Se18d06.";

    /**
     * Lấy họ tên đầy đủ của user theo ID
     */
    public String getUserFullName(Long userId) {
        if (userId == null) {
            return "Khách";
        }
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String sql = "SELECT first_name, last_name FROM users WHERE id = ?";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setLong(1, userId);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String firstName = rs.getString("first_name");
                        String lastName = rs.getString("last_name");
                        
                        firstName = (firstName != null) ? firstName : "";
                        lastName = (lastName != null) ? lastName : "";
                        
                        String fullName = (firstName + " " + lastName).trim();
                        return fullName.isEmpty() ? "Người dùng #" + userId : fullName;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user name by ID " + userId + ": " + e.getMessage());
        }
        
        return "Người dùng #" + userId;
    }

    /**
     * Lấy thông tin user theo nhiều ID cùng lúc (tối ưu hóa)
     */
    public Map<Long, String> getUserFullNames(java.util.List<Long> userIds) {
        Map<Long, String> userNames = new HashMap<>();
        
        if (userIds == null || userIds.isEmpty()) {
            return userNames;
        }
        
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            // Tạo placeholders cho IN clause
            String placeholders = String.join(",", java.util.Collections.nCopies(userIds.size(), "?"));
            String sql = "SELECT id, first_name, last_name FROM users WHERE id IN (" + placeholders + ")";
            
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                // Set parameters
                for (int i = 0; i < userIds.size(); i++) {
                    stmt.setLong(i + 1, userIds.get(i));
                }
                
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Long userId = rs.getLong("id");
                        String firstName = rs.getString("first_name");
                        String lastName = rs.getString("last_name");
                        
                        firstName = (firstName != null) ? firstName : "";
                        lastName = (lastName != null) ? lastName : "";
                        
                        String fullName = (firstName + " " + lastName).trim();
                        userNames.put(userId, fullName.isEmpty() ? "Người dùng #" + userId : fullName);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting user names: " + e.getMessage());
        }
        
        // Thêm các userId không tìm thấy
        for (Long userId : userIds) {
            if (!userNames.containsKey(userId)) {
                userNames.put(userId, "Người dùng #" + userId);
            }
        }
        
        return userNames;
    }
}
