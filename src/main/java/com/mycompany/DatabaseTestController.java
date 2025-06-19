package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;

@RestController
@RequestMapping("/api")
public class DatabaseTestController {

    @GetMapping("/db-test")
    public ResponseEntity<Map<String, Object>> testDatabase() {
        Map<String, Object> response = new HashMap<>();
        
        // Test với các thông tin kết nối khác nhau
        String[] testConfigs = {            // Config 1: Thông tin hiện tại
            "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;|admin43@43gundam|Se18d06.",
            
            // Config 2: Thử không có @server trong username
            "jdbc:sqlserver://43gundam.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;|admin43|Se18d06",
            
            // Config 3: Thử server name khác
            "jdbc:sqlserver://43gundam-server.database.windows.net:1433;database=gundamhobby;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;|admin43@43gundam-server|Se18d06"
        };
        
        for (int i = 0; i < testConfigs.length; i++) {
            String[] parts = testConfigs[i].split("\\|");
            String connectionUrl = parts[0];
            String username = parts[1];
            String password = parts[2];
            
            System.out.println("=== TESTING CONFIG " + (i + 1) + " ===");
            System.out.println("URL: " + connectionUrl);
            System.out.println("Username: " + username);
            System.out.println("Password: " + password);
            
            try (Connection connection = DriverManager.getConnection(connectionUrl, username, password)) {
                System.out.println("✅ Config " + (i + 1) + " - Connection successful!");
                
                // Test query
                String sql = "SELECT COUNT(*) as count FROM users";
                try (PreparedStatement stmt = connection.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int userCount = rs.getInt("count");
                        System.out.println("✅ Config " + (i + 1) + " - Users in database: " + userCount);
                        response.put("success", true);
                        response.put("workingConfig", i + 1);
                        response.put("url", connectionUrl);
                        response.put("username", username);
                        response.put("userCount", userCount);
                        return ResponseEntity.ok(response);
                    }
                }
            } catch (SQLException e) {
                System.out.println("❌ Config " + (i + 1) + " - Failed: " + e.getMessage());
            }
        }
        
        response.put("success", false);
        response.put("message", "All database configurations failed");
        return ResponseEntity.status(500).body(response);
    }
}
