package com.mycompany;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        System.out.println("=== HOME PAGE REQUEST ===");
        System.out.println("Forwarding to index.jsp");
        return "forward:/index.jsp";
    }
    
    // Handle incorrect /login.jsp/ URL that's causing errors
    @GetMapping("/login.jsp/")
    public String handleIncorrectLoginUrl() {
        System.out.println("=== INCORRECT LOGIN URL ACCESSED: /login.jsp/ ===");
        System.out.println("Redirecting to home page");
        return "redirect:/";
    }
    
    // Also handle /login.jsp for consistency
    @GetMapping("/login.jsp")
    public String handleLoginJsp() {
        System.out.println("=== LOGIN JSP ACCESSED ===");
        System.out.println("Forwarding to login.jsp");
        return "forward:/login.jsp";
    }
}
