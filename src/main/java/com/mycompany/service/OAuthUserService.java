package com.mycompany.service;

import com.mycompany.model.OAuthUser;
import org.springframework.stereotype.Service;
import java.sql.*;

@Service
public class OAuthUserService {
    
    private final String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private final String username = "admin43@43gundam";
    private final String password = "Se18d06.";
    
    public OAuthUser saveOrUpdateOAuthUser(String email, String name, String picture, String provider, String providerId) {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            
            // Kiểm tra xem user đã tồn tại chưa
            String checkSql = "SELECT * FROM oauth_users WHERE email = ? OR (provider = ? AND provider_id = ?)";
            OAuthUser existingUser = null;
            
            try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);
                checkStmt.setString(2, provider);
                checkStmt.setString(3, providerId);
                
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        existingUser = new OAuthUser();
                        existingUser.setId(rs.getLong("id"));
                        existingUser.setEmail(rs.getString("email"));
                        existingUser.setName(rs.getString("name"));
                        existingUser.setPicture(rs.getString("picture"));
                        existingUser.setProvider(rs.getString("provider"));
                        existingUser.setProviderId(rs.getString("provider_id"));
                        existingUser.setRole(rs.getString("role"));
                    }
                }
            }
            
            if (existingUser != null) {
                // Cập nhật thông tin user
                String updateSql = "UPDATE oauth_users SET name = ?, picture = ?, email = ? WHERE id = ?";
                try (PreparedStatement updateStmt = connection.prepareStatement(updateSql)) {
                    updateStmt.setString(1, name);
                    updateStmt.setString(2, picture);
                    updateStmt.setString(3, email);
                    updateStmt.setLong(4, existingUser.getId());
                    updateStmt.executeUpdate();
                    
                    existingUser.setName(name);
                    existingUser.setPicture(picture);
                    existingUser.setEmail(email);
                    
                    System.out.println("Updated OAuth user: " + existingUser);
                    return existingUser;
                }
            } else {                // Tạo user mới
                String insertSql = "INSERT INTO oauth_users (email, name, picture, provider, provider_id, role) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement insertStmt = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertStmt.setString(1, email);
                    insertStmt.setString(2, name);
                    insertStmt.setString(3, picture);
                    insertStmt.setString(4, provider);
                    insertStmt.setString(5, providerId);
                    insertStmt.setString(6, "CUSTOMER");
                    
                    int affectedRows = insertStmt.executeUpdate();
                    if (affectedRows > 0) {
                        try (ResultSet generatedKeys = insertStmt.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                OAuthUser newUser = new OAuthUser(email, name, picture, provider, providerId);
                                newUser.setId(generatedKeys.getLong(1));
                                newUser.setRole("CUSTOMER");
                                
                                System.out.println("Created new OAuth user: " + newUser);
                                return newUser;
                            }
                        }
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error saving OAuth user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public OAuthUser findByEmail(String email) {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            String sql = "SELECT * FROM oauth_users WHERE email = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, email);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        OAuthUser user = new OAuthUser();
                        user.setId(rs.getLong("id"));
                        user.setEmail(rs.getString("email"));
                        user.setName(rs.getString("name"));
                        user.setPicture(rs.getString("picture"));
                        user.setProvider(rs.getString("provider"));
                        user.setProviderId(rs.getString("provider_id"));
                        user.setRole(rs.getString("role"));
                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding OAuth user by email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public void createOAuthUsersTableIfNotExists() {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {            String createTableSql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='oauth_users' AND xtype='U') " +
                "CREATE TABLE oauth_users (" +
                "id BIGINT IDENTITY(1,1) PRIMARY KEY, " +
                "email NVARCHAR(255) NOT NULL UNIQUE, " +
                "name NVARCHAR(255) NOT NULL, " +
                "picture NVARCHAR(500), " +
                "provider NVARCHAR(50) NOT NULL, " +
                "provider_id NVARCHAR(255) NOT NULL UNIQUE, " +
                "first_name NVARCHAR(255), " +
                "last_name NVARCHAR(255), " +
                "role NVARCHAR(50) DEFAULT 'CUSTOMER', " +
                "created_at DATETIME2 DEFAULT GETDATE(), " +
                "updated_at DATETIME2 DEFAULT GETDATE()" +
                ")";
            
            try (PreparedStatement stmt = connection.prepareStatement(createTableSql)) {
                stmt.executeUpdate();
                System.out.println("OAuth users table created or already exists");
            }
        } catch (SQLException e) {
            System.err.println("Error creating OAuth users table: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
