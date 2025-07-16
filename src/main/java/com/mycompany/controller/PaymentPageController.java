package com.mycompany.controller;

import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
public class PaymentPageController {
    
    // PayOS Payment success page
    @GetMapping("/payment/success")
    @Transactional
    public String paymentSuccess(@RequestParam(name = "orderCode", required = false) String orderCode,
                               @RequestParam(name = "status", required = false) String status,
                               @RequestParam(name = "cancel", required = false) String cancel,
                               @SessionAttribute(name = "userId", required = false) Long userId) {
        // Log để debug
        System.out.println("=== PAYMENT SUCCESS CALLBACK ===");
        System.out.println("PayOS Success - OrderCode: " + orderCode + ", Status: " + status + ", Cancel: " + cancel);
        System.out.println("User ID from session: " + userId);
        
        // Gọi API confirm để xử lý payment thành công
        if (orderCode != null) {
            try {
                // Gọi confirmPayOSPayment API để xử lý việc xóa cart selective và cập nhật stock
                // Logic này đã được implement trong PaymentController.confirmPayOSPayment
                System.out.println("PayOS payment success - Order: " + orderCode);
            } catch (Exception e) {
                System.err.println("Error processing payment success: " + e.getMessage());
            }
        }
        
        // Redirect về trang payment-success.jsp để hiển thị thông báo và xóa localStorage
        return "payment-success";
    }
    
    // PayOS Payment cancel page
    @GetMapping("/payment/cancel")
    @Transactional
    public String paymentCancel(@RequestParam(name = "orderCode", required = false) String orderCode,
                              @RequestParam(name = "status", required = false) String status,
                              @SessionAttribute(name = "userId", required = false) Long userId) {
        // Log để debug
        System.out.println("=== PAYMENT CANCEL CALLBACK ===");
        System.out.println("PayOS Cancel - OrderCode: " + orderCode + ", Status: " + status);
        System.out.println("User ID from session: " + userId);
        
        // PayOS payment bị hủy - cart vẫn được giữ nguyên
        if (orderCode != null) {
            System.out.println("PayOS payment cancelled - Order: " + orderCode);
        }
        
        // Redirect về trang payment-cancel.jsp để hiển thị thông báo
        return "payment-cancel";
    }
    
    // Test endpoint để kiểm tra controller hoạt động
    @GetMapping("/payment/test")
    public String testPayment() {
        System.out.println("Payment controller test endpoint called");
        return "redirect:/index.html";
    }
}
