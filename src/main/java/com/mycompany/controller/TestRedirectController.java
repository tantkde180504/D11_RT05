package com.mycompany.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpSession;

@Controller
public class TestRedirectController {

    @GetMapping("/test-oauth-redirect")
    public String testOAuthRedirect(HttpSession session) {
        System.out.println("=== TEST OAUTH REDIRECT ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("User in session: " + session.getAttribute("userName"));
        System.out.println("Is logged in: " + session.getAttribute("isLoggedIn"));
        System.out.println("Redirecting to: /");
        
        return "redirect:/";
    }
}
