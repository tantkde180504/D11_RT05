package com.mycompany.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api")
public class UserController {

    /**
     * Endpoint để kiểm tra thông tin người dùng từ session
     */
    @GetMapping("/user-info")
    public ResponseEntity<Map<String, Object>> getUserInfo(
            @SessionAttribute(name = "userId", required = false) Long userId,
            @SessionAttribute(name = "isLoggedIn", required = false) Boolean isLoggedIn,
            @SessionAttribute(name = "userRole", required = false) String role,
            @SessionAttribute(name = "email", required = false) String email,
            @SessionAttribute(name = "fullName", required = false) String fullName,
            @SessionAttribute(name = "name", required = false) String name,
            @SessionAttribute(name = "picture", required = false) String picture,
            HttpServletRequest request) {
        
        System.out.println("=== USER INFO REQUEST ===");
        System.out.println("userId from SessionAttribute: " + userId);
        System.out.println("isLoggedIn from SessionAttribute: " + isLoggedIn);
        System.out.println("userRole from SessionAttribute: " + role);
        
        Map<String, Object> response = new HashMap<>();
        
        if (isLoggedIn != null && isLoggedIn) {
            response.put("isLoggedIn", true);
            response.put("userId", userId);
            response.put("role", role);
            response.put("email", email);
            response.put("name", name != null ? name : fullName);
            response.put("picture", picture);
            
            // For debugging purposes, also display the session ID
            HttpSession session = request.getSession(false);
            if (session != null) {
                System.out.println("Session ID: " + session.getId());
                System.out.println("Session attributes:");
                System.out.println("- userId: " + session.getAttribute("userId"));
                System.out.println("- isLoggedIn: " + session.getAttribute("isLoggedIn"));
                System.out.println("- userRole: " + session.getAttribute("userRole"));
                System.out.println("- email: " + session.getAttribute("email"));
                System.out.println("- fullName: " + session.getAttribute("fullName"));
                System.out.println("- name: " + session.getAttribute("name"));
            }
            
            System.out.println("User is logged in with ID: " + userId);
        } else {
            System.out.println("User is not logged in");
            response.put("isLoggedIn", false);
        }
        
        System.out.println("Response: " + response);
        return ResponseEntity.ok(response);
    }
}
