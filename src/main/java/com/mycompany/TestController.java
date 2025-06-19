package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class TestController {

    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> test() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("message", "Spring Boot Controller hoạt động!");
        response.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(response);
    }

    @PostMapping("/test-login")
    public ResponseEntity<Map<String, Object>> testLogin(@RequestParam String email, @RequestParam String password) {
        Map<String, Object> response = new HashMap<>();
        
        // Test data - không kết nối database
        if ("test@example.com".equals(email) && "123456".equals(password)) {
            response.put("success", true);
            response.put("role", "ADMIN");
            response.put("fullName", "Test User");
        } else {
            response.put("success", false);
            response.put("message", "Sai email hoặc mật khẩu!");
        }
        
        return ResponseEntity.ok(response);
    }
}
