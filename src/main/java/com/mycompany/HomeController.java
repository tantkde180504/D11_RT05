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
}
