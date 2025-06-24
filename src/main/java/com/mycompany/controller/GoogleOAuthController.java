package com.mycompany.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/oauth2")
public class GoogleOAuthController {    @GetMapping("/user-info")
    public ResponseEntity<Map<String, Object>> getUserInfo(@AuthenticationPrincipal OAuth2User principal, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        System.out.println("=== USER INFO REQUEST ===");
        System.out.println("Principal: " + (principal != null ? "exists" : "null"));
        System.out.println("Session ID: " + session.getId());
        
        if (principal != null) {
            // User đăng nhập qua OAuth2
            response.put("email", principal.getAttribute("email"));
            response.put("name", principal.getAttribute("name"));
            response.put("picture", principal.getAttribute("picture"));
            response.put("role", session.getAttribute("userRole"));
            response.put("isLoggedIn", true);
            response.put("loginType", "google");
            System.out.println("OAuth2 user found: " + principal.getAttribute("name"));
        } else {
            // Kiểm tra session cho user thường
            Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
            System.out.println("Session isLoggedIn: " + isLoggedIn);
            
            if (isLoggedIn != null && isLoggedIn) {
                response.put("email", session.getAttribute("userEmail"));
                response.put("name", session.getAttribute("userName"));
                response.put("picture", session.getAttribute("userPicture"));
                response.put("role", session.getAttribute("userRole"));
                response.put("isLoggedIn", true);
                response.put("loginType", session.getAttribute("loginType"));
                System.out.println("Session user found: " + session.getAttribute("userName"));
            } else {
                response.put("isLoggedIn", false);
                System.out.println("No user found in session or OAuth2");
            }
        }
          System.out.println("Response: " + response);
        return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
    }@PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        
        Map<String, Object> response = new HashMap<>();        response.put("success", true);
        response.put("message", "Đăng xuất thành công");
        
        return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body(response);
    }@GetMapping("/login-status")
    public ResponseEntity<Map<String, Object>> getLoginStatus(@AuthenticationPrincipal OAuth2User principal, HttpSession session) {
        // Redirect to user-info endpoint for consistency
        return getUserInfo(principal, session);
    }@GetMapping("/test")
    public Map<String, Object> testEndpoint() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "working");
        response.put("timestamp", System.currentTimeMillis());
        System.out.println("Test endpoint called");
        return response;
    }
}
