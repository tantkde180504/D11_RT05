package com.mycompany.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/oauth-success")
public class OAuthSuccessController {    @GetMapping
    public String handleOAuthSuccess(HttpSession session) {
        System.out.println("=== OAUTH SUCCESS CONTROLLER ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("User in session: " + session.getAttribute("userName"));
        System.out.println("Is logged in: " + session.getAttribute("isLoggedIn"));
        System.out.println("Rendering OAuth success page with JavaScript redirect");
        
        // Render HTML page with JavaScript redirect
        return "forward:/oauth-success.html";
    }
}