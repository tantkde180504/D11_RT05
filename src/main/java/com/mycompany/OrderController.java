package com.mycompany;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;

    // ✅ API: Lấy danh sách đơn hàng (tùy chọn lọc theo trạng thái)
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Order> getOrders(@RequestParam(value = "status", required = false) String status) {
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            return orderRepository.findByStatusOrderByOrderDateDesc(status);
        }
        return orderRepository.findAllByOrderByOrderDateDesc();
    }

    // ✅ API: Xác nhận đơn hàng (từ PENDING sang CONFIRMED)
    @PostMapping("/confirm")
    @Transactional
    public ResponseEntity<String> confirmOrder(@RequestParam Long orderId) {
        int updatedRows = orderRepository.confirmOrderById(orderId);
        if (updatedRows > 0) {
            return ResponseEntity.ok("✅ Đơn hàng đã được xác nhận");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("❌ Không thể xác nhận đơn hàng. Đơn không ở trạng thái PENDING hoặc không tồn tại.");
        }
    }

    // ✅ API: Cập nhật trạng thái bất kỳ (DELIVERED, SHIPPING, PROCESSING,...)
    @PostMapping("/update-status")
    @Transactional
    public ResponseEntity<String> updateOrderStatus(@RequestParam Long orderId,
                                                    @RequestParam String status) {
        int updatedRows = orderRepository.updateOrderStatus(orderId, status.toUpperCase());
        if (updatedRows > 0) {
            return ResponseEntity.ok("✅ Cập nhật trạng thái đơn hàng thành công: " + status.toUpperCase());
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("❌ Không thể cập nhật trạng thái đơn hàng.");
        }
    }

    // ✅ API: Lấy chi tiết đơn hàng theo ID
    @GetMapping("/detail")
    public ResponseEntity<?> getOrderDetail(@RequestParam Long orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            return ResponseEntity.ok(order);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("❌ Không tìm thấy đơn hàng với ID: " + orderId);
        }
    }
}
