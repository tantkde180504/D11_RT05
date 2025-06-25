package com.mycompany;

import java.util.List;
import java.util.Optional;

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

    // ✅ API: Lấy danh sách đơn hàng
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Order> getOrders(@RequestParam(value = "status", required = false) String status) {
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            return orderRepository.findByStatusOrderByOrderDateDesc(status);
        }
        return orderRepository.findAllByOrderByOrderDateDesc();
    }

    // ✅ API: Xác nhận đơn hàng
    @PostMapping("/confirm")
    @Transactional
    public ResponseEntity<String> confirmOrder(@RequestParam Long orderId) {
        int updated = orderRepository.confirmOrderById(orderId);
        if (updated > 0) {
            return ResponseEntity.ok("✅ Đơn hàng đã được xác nhận");
        }
        return ResponseEntity.badRequest().body("❌ Không thể xác nhận đơn hàng.");
    }

    // ✅ API: Cập nhật trạng thái đơn hàng
    @PostMapping("/update-status")
    @Transactional
    public ResponseEntity<String> updateOrderStatus(@RequestParam Long orderId, @RequestParam String status) {
        int updated = orderRepository.updateOrderStatus(orderId, status);
        if (updated > 0) {
            return ResponseEntity.ok("✅ Trạng thái đã cập nhật");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("❌ Không tìm thấy đơn hàng");
    }

    // ✅ API: Xem chi tiết đơn hàng
    @GetMapping(value = "/detail", produces = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<OrderDetailDTO> getOrderDetail(@RequestParam Long id) {
    Optional<Order> orderOpt = orderRepository.findById(id);
    if (orderOpt.isEmpty()) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    Order order = orderOpt.get();

    OrderDetailDTO dto = new OrderDetailDTO();
    dto.id = order.getId();
    dto.orderNumber = order.getOrderNumber();
    dto.shippingName = order.getShippingName();
    dto.shippingPhone = order.getShippingPhone();
    dto.shippingAddress = order.getShippingAddress();
    dto.paymentMethod = order.getPaymentMethod();
    dto.status = order.getStatus();
    dto.orderDate = order.getOrderDate();
    dto.totalAmount = order.getTotalAmount();
    dto.email = "customer@example.com";

    return ResponseEntity.ok(dto);
}

public static class OrderDetailDTO {
    public Long id;
    public String orderNumber;
    public String shippingName;
    public String shippingPhone;
    public String shippingAddress;
    public String paymentMethod;
    public String status;
    public String email;
    public Object orderDate;
    public Object totalAmount;
}
}
