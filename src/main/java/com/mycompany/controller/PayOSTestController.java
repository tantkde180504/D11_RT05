package com.mycompany.controller;

import com.mycompany.config.PayOSConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
public class PayOSTestController {

    @Autowired
    private PayOS payOS;

    @Autowired
    private PayOSConfig payOSConfig;

    @PostMapping("/payos")
    public ResponseEntity<Map<String, Object>> testPayOS() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Create test payment data
            Long orderCode = System.currentTimeMillis() / 1000;
            
            ItemData itemData = ItemData.builder()
                .name("Test Product - Gundam Model")
                .quantity(1)
                .price(299000)
                .build();

            PaymentData paymentData = PaymentData.builder()
                .orderCode(orderCode)
                .amount(299000)
                .description("Test Gundam Hobby") // Rút gọn xuống dưới 25 ký tự
                .returnUrl(payOSConfig.getReturnUrl())
                .cancelUrl(payOSConfig.getCancelUrl())
                .item(itemData)
                .build();

            CheckoutResponseData checkoutResponse = payOS.createPaymentLink(paymentData);
            
            response.put("success", true);
            response.put("message", "PayOS integration test successful!");
            response.put("orderCode", orderCode);
            response.put("checkoutUrl", checkoutResponse.getCheckoutUrl());
            response.put("qrCode", checkoutResponse.getQrCode());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "PayOS integration test failed: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/config")
    public ResponseEntity<Map<String, Object>> testConfig() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            response.put("success", true);
            response.put("clientId", payOSConfig.getClientId());
            response.put("returnUrl", payOSConfig.getReturnUrl());
            response.put("cancelUrl", payOSConfig.getCancelUrl());
            response.put("message", "PayOS configuration loaded successfully!");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "PayOS configuration test failed: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}
