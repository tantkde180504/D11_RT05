package com.mycompany;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;

    // In hóa đơn theo order_number
    @GetMapping("/{orderNumber}/invoice")
    public ResponseEntity<Map<String, Object>> printInvoice(@PathVariable String orderNumber) {
        try {
            String invoice = orderService.printInvoiceByOrderNumber(orderNumber);
            Map<String, Object> resp = new HashMap<>();
            resp.put("orderNumber", orderNumber);
            resp.put("invoice", invoice);
            resp.put("success", invoice != null);
            resp.put("message", invoice != null ? "Invoice generated" : "Order not found");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("orderNumber", orderNumber);
            error.put("success", false);
            error.put("message", "Server error: " + e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }

    // Hủy đơn hàng theo order_number
    @PostMapping("/{orderNumber}/cancel")
    public ResponseEntity<Map<String, Object>> cancelOrder(@PathVariable String orderNumber) {
        try {
            boolean result = orderService.cancelOrderByOrderNumber(orderNumber);
            Map<String, Object> resp = new HashMap<>();
            resp.put("orderNumber", orderNumber);
            resp.put("cancelled", result);
            resp.put("message", result ? "Order cancelled" : "Order not found");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("orderNumber", orderNumber);
            error.put("cancelled", false);
            error.put("message", "Server error: " + e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }

    // Xác nhận đơn hàng
    @PostMapping("/{orderId}/confirm")
    public ResponseEntity<Map<String, Object>> confirmOrder(@PathVariable Long orderId) {
        try {
            boolean result = orderService.confirmOrder(orderId);
            Map<String, Object> resp = new HashMap<>();
            resp.put("orderId", orderId);
            resp.put("confirmed", result);
            resp.put("message", result ? "Order confirmed" : "Order not found");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("orderId", orderId);
            error.put("confirmed", false);
            error.put("message", "Server error: " + e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }

    // Cập nhật trạng thái đơn hàng
    @PostMapping("/{orderId}/status")
    public ResponseEntity<Map<String, Object>> updateOrderStatus(@PathVariable Long orderId, @RequestParam String status) {
        try {
            boolean result = orderService.updateOrderStatus(orderId, status);
            Map<String, Object> resp = new HashMap<>();
            resp.put("orderId", orderId);
            resp.put("updated", result);
            resp.put("message", result ? "Order status updated" : "Order not found");
            return ResponseEntity.ok(resp);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("orderId", orderId);
            error.put("updated", false);
            error.put("message", "Server error: " + e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }
}