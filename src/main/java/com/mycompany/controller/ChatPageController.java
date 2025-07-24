package com.mycompany.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatPageController {
    
    @GetMapping("/chat")
    public String chatPage(HttpSession session, Model model) {
        // Kiểm tra đăng nhập
        Object userIdObj = session.getAttribute("userId");
        String userType = (String) session.getAttribute("userType");
        
        Long userId = null;
        if (userIdObj instanceof Integer) {
            userId = ((Integer) userIdObj).longValue();
        } else if (userIdObj instanceof Long) {
            userId = (Long) userIdObj;
        }
        
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Thêm thông tin user vào model
        model.addAttribute("userId", userId);
        model.addAttribute("userType", userType);
        
        return "chat";
    }
    
    // Test endpoint để set session (chỉ dùng để test)
    @GetMapping("/chat-test")
    public String chatTest(@RequestParam(defaultValue = "1") Long userId,
                          @RequestParam(defaultValue = "CUSTOMER") String userType,
                          HttpSession session) {
        session.setAttribute("userId", userId);
        session.setAttribute("userType", userType);
        return "redirect:/chat";
    }
}
