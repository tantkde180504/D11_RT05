package com.mycompany;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;

    @PersistenceContext
    private EntityManager entityManager;

    // API: Lấy danh sách đơn hàng (optionally lọc theo trạng thái)
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Order> getOrders(@RequestParam(value = "status", required = false) String status) {
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            return orderRepository.findByStatusOrderByOrderDateDesc(status);
        }
        return orderRepository.findAllByOrderByOrderDateDesc();
    }

    // API: Xác nhận đơn hàng bằng stored procedure
    @PostMapping("/confirm")
    public ResponseEntity<?> confirmOrder(@RequestParam Long orderId) {
        try {
            StoredProcedureQuery query = entityManager.createStoredProcedureQuery("sp_confirm_order");
            query.registerStoredProcedureParameter("order_id", Long.class, ParameterMode.IN);
            query.setParameter("order_id", orderId);
            query.execute();

            return ResponseEntity.ok("✅ Đơn hàng đã được xác nhận");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body("❌ Xác nhận thất bại: " + e.getMessage());
        }
    }
}
