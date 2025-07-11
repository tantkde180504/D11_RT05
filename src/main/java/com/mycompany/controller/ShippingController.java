package com.mycompany.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mycompany.model.Order;
import com.mycompany.model.Shipping;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.ShippingRepository;

@RestController
@RequestMapping("/api/shipping")
public class ShippingController {

    @Autowired
    private ShippingRepository shippingRepository;

    @Autowired
    private OrderRepository orderRepository;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ShippingDTO> getAllShipping(@RequestParam(value = "status", required = false) String status) {

        List<Shipping> shippings = (status != null && !status.equalsIgnoreCase("ALL"))
                ? shippingRepository.findByStatusOrderByAssignedAtDesc(status)
                : shippingRepository.findAllByOrderByAssignedAtDesc();

        return shippings.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @PostMapping("/update-status")
    public ResponseEntity<String> updateShippingStatus(@RequestParam Long shippingId, @RequestParam String status, @RequestParam(required = false) String note) {
        Optional<Shipping> shippingOpt = shippingRepository.findById(shippingId);
        if (shippingOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Không tìm thấy bản ghi shipping.");
        }
        Shipping shipping = shippingOpt.get();
        // Chuyển FAILED thành CANCELLED để không vi phạm constraint
        if ("FAILED".equalsIgnoreCase(status)) {
            status = "CANCELLED";
        }
        // Chỉ cho phép các status hợp lệ
        if (!status.equalsIgnoreCase("PENDING") &&
            !status.equalsIgnoreCase("SHIPPING") &&
            !status.equalsIgnoreCase("DELIVERED") &&
            !status.equalsIgnoreCase("CANCELLED")) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Trạng thái không hợp lệ.");
        }
        shipping.setStatus(status);
        if (note != null) {
            shipping.setNote(note);
        }
        if ("SHIPPING".equalsIgnoreCase(status)) {
            if (shipping.getOrderId() != null) {
                orderRepository.updateOrderStatus(shipping.getOrderId(), "CONFIRMED");
            }
        }
        if ("DELIVERED".equalsIgnoreCase(status)) {
            shipping.setConfirmedAt(java.time.LocalDateTime.now());
            if (shipping.getOrderId() != null) {
                orderRepository.updateOrderStatus(shipping.getOrderId(), "DELIVERED");
            }
        }
        if ("CANCELLED".equalsIgnoreCase(status)) {
            if (shipping.getOrderId() != null) {
                orderRepository.updateOrderStatus(shipping.getOrderId(), "CANCELLED");
            }
        }
        shippingRepository.save(shipping);
        return ResponseEntity.ok("Đã cập nhật trạng thái shipping.");
    }

    @GetMapping(value = "/detail", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ShippingDTO> getShippingDetail(@RequestParam Long id) {
        Optional<Shipping> shippingOpt = shippingRepository.findById(id);
        if (shippingOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
        Shipping shipping = shippingOpt.get();
        ShippingDTO dto = mapToDTO(shipping);
        return ResponseEntity.ok(dto);
    }

    private ShippingDTO mapToDTO(Shipping shipping) {
        ShippingDTO dto = new ShippingDTO();
        dto.id = shipping.getId();
        dto.orderId = shipping.getOrderId();
        dto.status = shipping.getStatus();
        dto.assignedAt = shipping.getAssignedAt();
        dto.confirmedAt = shipping.getConfirmedAt();
        dto.note = shipping.getNote();
        // Lấy thông tin đơn hàng gốc và sản phẩm
        if (shipping.getOrderId() != null) {
            Optional<Order> orderOpt = orderRepository.findById(shipping.getOrderId());
            if (orderOpt.isPresent()) {
                Order order = orderOpt.get();
                dto.customerName = order.getShippingName();
                dto.shippingAddress = order.getShippingAddress();
                dto.shippingPhone = order.getShippingPhone();
                dto.orderDate = order.getOrderDate() != null ? order.getOrderDate().toString() : null;
                // Lấy danh sách sản phẩm, số lượng, số tiền từ bảng order_items
                List<Object[]> itemRows = orderRepository.findOrderItemDetailsByOrderId(order.getId());
                java.util.List<ProductItemInfo> items = new java.util.ArrayList<>();
                if (itemRows != null && !itemRows.isEmpty()) {
                    for (Object[] row : itemRows) {
                        String name = (String) row[0];
                        Integer quantity = row[1] != null ? ((Number) row[1]).intValue() : 0;
                        java.math.BigDecimal unitPrice = row[2] instanceof java.math.BigDecimal ? (java.math.BigDecimal) row[2] : null;
                        java.math.BigDecimal total = (unitPrice != null) ? unitPrice.multiply(new java.math.BigDecimal(quantity)) : null;
                        ProductItemInfo info = new ProductItemInfo();
                        info.name = name;
                        info.quantity = quantity;
                        info.unitPrice = unitPrice;
                        info.total = total;
                        items.add(info);
                    }
                    dto.items = items;
                    // productNames cho tương thích UI cũ
                    dto.productNames = items.stream().map(i -> i.name + " x" + i.quantity).collect(java.util.stream.Collectors.toList());
                } else if (order.getProductName() != null) {
                    // fallback nếu không có order_items
                    dto.productNames = java.util.List.of(order.getProductName());
                }
            }
        }
        return dto;
    }

    public static class ShippingDTO {
        public String orderDate;
        public java.util.List<String> productNames;
        public java.util.List<ProductItemInfo> items;
        public Long id;
        public Long orderId;
        public String status;
        public Object assignedAt;
        public Object confirmedAt;
        public String note;
        public String customerName;
        public String shippingAddress;
        public String shippingPhone;
    }

    public static class ProductItemInfo {
        public String name;
        public Integer quantity;
        public java.math.BigDecimal unitPrice;
        public java.math.BigDecimal total;
    }
}

