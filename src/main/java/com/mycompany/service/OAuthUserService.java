package com.mycompany.service;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.springframework.stereotype.Service;

import com.mycompany.model.OAuthUser;

@Service
public class OAuthUserService {
    
    private final String connectionUrl = "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;";
    private final String username = "admin43@43gundam";
    private final String password = "Se18d06.";
    
    public OAuthUser saveOrUpdateOAuthUser(String email, String name, String picture, String provider, String providerId) {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            
            // First, check if user exists in main users table
            String checkUsersSql = "SELECT * FROM users WHERE email = ?";
            OAuthUser existingUser = null;
            
            try (PreparedStatement checkUsersStmt = connection.prepareStatement(checkUsersSql)) {
                checkUsersStmt.setString(1, email);
                
                try (ResultSet rs = checkUsersStmt.executeQuery()) {
                    if (rs.next()) {
                        // User exists in main users table, update with OAuth info
                        existingUser = new OAuthUser();
                        existingUser.setId(rs.getLong("id"));
                        existingUser.setEmail(rs.getString("email"));
                        
                        // Parse name into first_name and last_name
                        String[] nameParts = name != null ? name.split(" ", 2) : new String[]{"", ""};
                        String firstName = nameParts.length > 0 ? nameParts[0] : "";
                        String lastName = nameParts.length > 1 ? nameParts[1] : "";
                        
                        existingUser.setName(rs.getString("first_name") + " " + rs.getString("last_name"));
                        existingUser.setPicture(picture);
                        existingUser.setProvider(provider);
                        existingUser.setProviderId(providerId);
                        existingUser.setRole(rs.getString("role"));
                        
                        // Update users table with OAuth info
                        String updateUsersSql = "UPDATE users SET provider = ?, provider_id = ?, picture = ?, first_name = ?, last_name = ? WHERE id = ?";
                        try (PreparedStatement updateUsersStmt = connection.prepareStatement(updateUsersSql)) {
                            updateUsersStmt.setString(1, provider);
                            updateUsersStmt.setString(2, providerId);
                            updateUsersStmt.setString(3, picture);
                            updateUsersStmt.setString(4, firstName);
                            updateUsersStmt.setString(5, lastName);
                            updateUsersStmt.setLong(6, existingUser.getId());
                            updateUsersStmt.executeUpdate();
                            
                            System.out.println("Updated existing user with OAuth info: " + existingUser.getEmail());
                            return existingUser;
                        }
                    }
                }
            }
            
            // If user doesn't exist in main users table, create new user
            if (existingUser == null) {
                // Parse name into first_name and last_name
                String[] nameParts = name != null ? name.split(" ", 2) : new String[]{"", ""};
                String firstName = nameParts.length > 0 ? nameParts[0] : "";
                String lastName = nameParts.length > 1 ? nameParts[1] : "";
                
                String insertUsersSql = "INSERT INTO users (email, first_name, last_name, role, provider, provider_id, picture, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement insertUsersStmt = connection.prepareStatement(insertUsersSql, Statement.RETURN_GENERATED_KEYS)) {
                    insertUsersStmt.setString(1, email);
                    insertUsersStmt.setString(2, firstName);
                    insertUsersStmt.setString(3, lastName);
                    insertUsersStmt.setString(4, "CUSTOMER");
                    insertUsersStmt.setString(5, provider);
                    insertUsersStmt.setString(6, providerId);
                    insertUsersStmt.setString(7, picture);
                    insertUsersStmt.setString(8, "OAUTH_USER"); // Special password for OAuth users
                    
                    int affectedRows = insertUsersStmt.executeUpdate();
                    if (affectedRows > 0) {
                        try (ResultSet generatedKeys = insertUsersStmt.getGeneratedKeys()) {
                            if (generatedKeys.next()) {
                                OAuthUser newUser = new OAuthUser(email, name, picture, provider, providerId);
                                newUser.setId(generatedKeys.getLong(1));
                                newUser.setRole("CUSTOMER");
                                
                                System.out.println("Created new OAuth user in users table: " + newUser);
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
            // Search in main users table first
            String sql = "SELECT * FROM users WHERE email = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, email);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        OAuthUser user = new OAuthUser();
                        user.setId(rs.getLong("id"));
                        user.setEmail(rs.getString("email"));
                        
                        // Combine first_name and last_name
                        String firstName = rs.getString("first_name") != null ? rs.getString("first_name") : "";
                        String lastName = rs.getString("last_name") != null ? rs.getString("last_name") : "";
                        user.setName(firstName + " " + lastName);
                        
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
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            // Add OAuth fields to existing users table if they don't exist
            String addOAuthFieldsSql = 
                "IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'users' AND COLUMN_NAME = 'provider') " +
                "BEGIN " +
                "ALTER TABLE users ADD provider NVARCHAR(50) NULL; " +
                "ALTER TABLE users ADD provider_id NVARCHAR(255) NULL; " +
                "ALTER TABLE users ADD picture NVARCHAR(500) NULL; " +
                "END";
            
            try (PreparedStatement stmt = connection.prepareStatement(addOAuthFieldsSql)) {
                stmt.executeUpdate();
                System.out.println("OAuth fields added to users table or already exist");
            }
            
            // Keep the oauth_users table creation for backward compatibility (if needed for migration)
            String createOAuthTableSql = "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='oauth_users' AND xtype='U') " +
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
                "updated_at DATETIME2 DEFAULT GETDATE(), " +
                "migrated_to_users BIT DEFAULT 0" +
                ")";
            
            try (PreparedStatement stmt = connection.prepareStatement(createOAuthTableSql)) {
                stmt.executeUpdate();
                System.out.println("OAuth users table created or already exists (for migration purposes)");
            }
            
        } catch (SQLException e) {
            System.err.println("Error setting up OAuth integration: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Migrate existing OAuth users from oauth_users table to main users table
     * This method should be called once during deployment to consolidate user data
     */
    public void migrateOAuthUsersToMainTable() {
        try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
            System.out.println("=== Starting OAuth Users Migration ===");
            
            // Check if oauth_users table exists
            String checkTableSql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'oauth_users'";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkTableSql);
                 ResultSet rs = checkStmt.executeQuery()) {
                
                if (!rs.next() || rs.getInt(1) == 0) {
                    System.out.println("oauth_users table does not exist. Migration not needed.");
                    return;
                }
            }
            
            // Get all OAuth users that haven't been migrated
            String selectOAuthUsersSql = "SELECT * FROM oauth_users WHERE migrated_to_users = 0 OR migrated_to_users IS NULL";
            try (PreparedStatement selectStmt = connection.prepareStatement(selectOAuthUsersSql);
                 ResultSet rs = selectStmt.executeQuery()) {
                
                int migratedCount = 0;
                while (rs.next()) {
                    String email = rs.getString("email");
                    String name = rs.getString("name");
                    String picture = rs.getString("picture");
                    String provider = rs.getString("provider");
                    String providerId = rs.getString("provider_id");
                    String role = rs.getString("role");
                    
                    // Check if user already exists in main users table
                    String checkUserSql = "SELECT COUNT(*) FROM users WHERE email = ?";
                    try (PreparedStatement checkUserStmt = connection.prepareStatement(checkUserSql)) {
                        checkUserStmt.setString(1, email);
                        try (ResultSet checkResult = checkUserStmt.executeQuery()) {
                            if (checkResult.next() && checkResult.getInt(1) > 0) {
                                // User exists, update with OAuth info
                                String[] nameParts = name != null ? name.split(" ", 2) : new String[]{"", ""};
                                String firstName = nameParts.length > 0 ? nameParts[0] : "";
                                String lastName = nameParts.length > 1 ? nameParts[1] : "";
                                
                                String updateUserSql = "UPDATE users SET provider = ?, provider_id = ?, picture = ?, first_name = COALESCE(NULLIF(first_name, ''), ?), last_name = COALESCE(NULLIF(last_name, ''), ?) WHERE email = ?";
                                try (PreparedStatement updateStmt = connection.prepareStatement(updateUserSql)) {
                                    updateStmt.setString(1, provider);
                                    updateStmt.setString(2, providerId);
                                    updateStmt.setString(3, picture);
                                    updateStmt.setString(4, firstName);
                                    updateStmt.setString(5, lastName);
                                    updateStmt.setString(6, email);
                                    updateStmt.executeUpdate();
                                    
                                    System.out.println("Updated existing user with OAuth info: " + email);
                                }
                            } else {
                                // User doesn't exist, create new
                                String[] nameParts = name != null ? name.split(" ", 2) : new String[]{"", ""};
                                String firstName = nameParts.length > 0 ? nameParts[0] : "";
                                String lastName = nameParts.length > 1 ? nameParts[1] : "";
                                
                                String insertUserSql = "INSERT INTO users (email, first_name, last_name, role, provider, provider_id, picture, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement insertStmt = connection.prepareStatement(insertUserSql)) {
                                    insertStmt.setString(1, email);
                                    insertStmt.setString(2, firstName);
                                    insertStmt.setString(3, lastName);
                                    insertStmt.setString(4, role != null ? role : "CUSTOMER");
                                    insertStmt.setString(5, provider);
                                    insertStmt.setString(6, providerId);
                                    insertStmt.setString(7, picture);
                                    insertStmt.setString(8, "OAUTH_USER");
                                    insertStmt.executeUpdate();
                                    
                                    System.out.println("Migrated OAuth user to users table: " + email);
                                }
                            }
                            
                            // Mark as migrated
                            String markMigratedSql = "UPDATE oauth_users SET migrated_to_users = 1 WHERE email = ?";
                            try (PreparedStatement markStmt = connection.prepareStatement(markMigratedSql)) {
                                markStmt.setString(1, email);
                                markStmt.executeUpdate();
                            }
                            
                            migratedCount++;
                        }
                    }
                }
                
                System.out.println("=== Migration Complete ===");
                System.out.println("Total users migrated: " + migratedCount);
            }
            
        } catch (SQLException e) {
            System.err.println("Error during OAuth users migration: " + e.getMessage());
            e.printStackTrace();
        }
    }
}