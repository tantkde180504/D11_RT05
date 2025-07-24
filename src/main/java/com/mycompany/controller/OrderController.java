package com.mycompany.controller;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.model.Order;
import com.mycompany.model.OrderImage;
import com.mycompany.repository.OrderImageRepository;
import com.mycompany.repository.OrderRepository;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OrderImageRepository orderImageRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<OrderDetailDTO> getOrders(@RequestParam(value = "status", required = false) String status) {
        List<Order> orders = (status != null && !status.equalsIgnoreCase("ALL"))
                ? orderRepository.findByStatusOrderByOrderDateDesc(status)
                : orderRepository.findAllByOrderByOrderDateDesc();

        return orders.stream().map(order -> {
            OrderDetailDTO dto = mapToDTO(order);
            dto.productNames = orderRepository.findProductNamesWithQuantityByOrderId(order.getId());
            return dto;
        }).collect(Collectors.toList());
    }

    @PostMapping("/confirm")
    @Transactional
    public ResponseEntity<String> confirmOrder(@RequestParam Long orderId) {
        int updated = orderRepository.confirmOrderById(orderId);
        if (updated > 0) {
            return ResponseEntity.ok("✅ Đơn hàng đã được xác nhận");
        }
        return ResponseEntity.badRequest().body("❌ Không thể xác nhận đơn hàng.");
    }

    @PostMapping("/update-status")
    @Transactional
    public ResponseEntity<String> updateOrderStatus(@RequestParam Long orderId, @RequestParam String status) {
        int updated = orderRepository.updateOrderStatus(orderId, status);
        if (updated > 0) {
            return ResponseEntity.ok("✅ Trạng thái đã cập nhật");
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body("❌ Không tìm thấy đơn hàng");
    }

    @PostMapping("/cancel")
    @Transactional
    public ResponseEntity<String> cancelOrder(@RequestParam Long orderId) {
        Optional<Order> orderOpt = orderRepository.findById(orderId);
        if (orderOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("❌ Không tìm thấy đơn hàng.");
        }

        Order order = orderOpt.get();
        if ("DELIVERED".equals(order.getStatus())) {
            return ResponseEntity.badRequest().body("❌ Không thể hủy đơn đã giao.");
        }
        if ("CANCELLED".equals(order.getStatus())) {
            return ResponseEntity.badRequest().body("❌ Đơn hàng đã bị hủy trước đó.");
        }

        int updated = orderRepository.updateOrderStatus(orderId, "CANCELLED");
        if (updated > 0) {
            return ResponseEntity.ok("✅ Đơn hàng đã được hủy");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("❌ Không thể hủy đơn hàng.");
    }

    @GetMapping(value = "/detail", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<OrderDetailDTO> getOrderDetail(@RequestParam Long id) {
        Optional<Order> orderOpt = orderRepository.findById(id);
        if (!orderOpt.isPresent()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        Order order = orderOpt.get();
        OrderDetailDTO dto = mapToDTO(order);

        // ✅ Lấy danh sách sản phẩm kèm số lượng, giá từ repository (tránh gọi getOrderItems nếu không tồn tại)
        List<Object[]> itemRows = orderRepository.findOrderItemDetailsByOrderId(order.getId());

        List<OrderItemDTO> items = new ArrayList<>();
        for (Object[] row : itemRows) {
            OrderItemDTO item = new OrderItemDTO();
            item.name = (String) row[0];
            item.quantity = ((Number) row[1]).intValue();
            item.price = ((Number) row[2]).longValue();
            items.add(item);
        }

        dto.items = items;
        dto.productNames = items.stream()
                .map(i -> i.name + " x" + i.quantity)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dto);
    }

    // ✅ Endpoint lấy ảnh giao hàng theo orderId
    @GetMapping("/{orderId}/delivery-photos")
    public ResponseEntity<List<Map<String, Object>>> getDeliveryPhotosByOrderId(@PathVariable Long orderId) {
        try {
            List<OrderImage> photos = orderImageRepository.findByOrderIdOrderByCreatedAtDesc(orderId);
            
            List<Map<String, Object>> photoList = new ArrayList<>();
            for (OrderImage photo : photos) {
                Map<String, Object> photoInfo = new HashMap<>();
                photoInfo.put("id", photo.getId());
                photoInfo.put("photoUrl", photo.getImageUrl());
                photoInfo.put("uploadedAt", photo.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                photoList.add(photoInfo);
            }
            
            return ResponseEntity.ok(photoList);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ArrayList<>());
        }
    }

    private OrderDetailDTO mapToDTO(Order order) {
        OrderDetailDTO dto = new OrderDetailDTO();
        dto.id = order.getId();
        dto.orderNumber = order.getOrderNumber();
        dto.shippingName = order.getShippingName();
        dto.shippingPhone = order.getShippingPhone();
        dto.shippingAddress = order.getShippingAddress();
        dto.paymentMethod = order.getPaymentMethod();
        dto.status = order.getStatus();
        dto.orderDate = order.getOrderDate() != null ? order.getOrderDate().format(DATE_FORMATTER) : null;
        dto.totalAmount = order.getTotalAmount();
        dto.email = "customer@example.com";
        return dto;
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
        public String orderDate;
        public Object totalAmount;
        public List<String> productNames;
        public List<OrderItemDTO> items;
    }

    public static class OrderItemDTO {
        public String name;
        public int quantity;
        public long price;
    }
}
