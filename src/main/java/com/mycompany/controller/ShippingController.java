package com.mycompany.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mycompany.model.Order;
import com.mycompany.model.OrderImage;
import com.mycompany.model.Shipping;
import com.mycompany.repository.OrderImageRepository;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.ShippingRepository;

@RestController
@RequestMapping("/api/shipping")
public class ShippingController {

    @Autowired
    private ShippingRepository shippingRepository;

    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OrderImageRepository orderImageRepository;

    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<ShippingDTO> getAllShipping(@RequestParam(value = "status", required = false) String status) {

        List<Shipping> shippings = (status != null && !status.equalsIgnoreCase("ALL"))
                ? shippingRepository.findByStatusOrderByAssignedAtDesc(status)
                : shippingRepository.findAllByOrderByAssignedAtDesc();

        return shippings.stream().map(this::mapToDTO).collect(Collectors.toList());
    }

    @PostMapping("/update-status")
    @Transactional
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
                System.out.println("🚚 SHIPPING: Cập nhật Order #" + shipping.getOrderId() + " từ trạng thái cũ sang SHIPPING");
                int updated = orderRepository.updateOrderStatus(shipping.getOrderId(), "SHIPPING");
                System.out.println("📝 Order cập nhật kết quả: " + updated + " bản ghi được thay đổi");
            } else {
                System.out.println("⚠️ SHIPPING: Không có OrderId để cập nhật");
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
                System.out.println("❌ CANCELLED: Cập nhật Order #" + shipping.getOrderId() + " sang trạng thái CANCELLED");
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
                dto.shippingType = order.getShippingType();
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
        public String shippingType;
    }

    public static class ProductItemInfo {
        public String name;
        public Integer quantity;
        public java.math.BigDecimal unitPrice;
        public java.math.BigDecimal total;
    }
    
    // Upload ảnh delivery confirmation
    @PostMapping("/upload-delivery-photo")
    public ResponseEntity<Map<String, Object>> uploadDeliveryPhoto(
            @RequestParam("shippingId") Long shippingId,
            @RequestParam("photo") MultipartFile photo) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Kiểm tra shipping tồn tại
            Optional<Shipping> shippingOpt = shippingRepository.findById(shippingId);
            if (!shippingOpt.isPresent()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy thông tin giao hàng");
                return ResponseEntity.badRequest().body(response);
            }
            
            Shipping shipping = shippingOpt.get();
            
            // Tạo thư mục upload nếu chưa tồn tại
            Path uploadPath = Paths.get("src/main/webapp/uploads/delivery-photos");
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            // Tạo tên file unique
            String fileExtension = "";
            String originalFilename = photo.getOriginalFilename();
            
            if (originalFilename != null && originalFilename.contains(".")) {
                fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String uniqueFilename = "delivery_" + shippingId + "_" + 
                                  LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) +
                                  fileExtension;
            
            // Lưu file
            Path filePath = uploadPath.resolve(uniqueFilename);
            Files.copy(photo.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // Lưu thông tin vào database (sử dụng orderId từ shipping)
            Long orderId = shipping.getOrderId();
            String photoUrl = "/uploads/delivery-photos/" + uniqueFilename;
            OrderImage orderImage = new OrderImage();
            orderImage.setOrderId(orderId);
            orderImage.setImageUrl(photoUrl);
            orderImageRepository.save(orderImage);
            
            response.put("success", true);
            response.put("message", "Upload ảnh thành công");
            response.put("photoUrl", photoUrl);
            response.put("photoId", orderImage.getId());
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Lỗi lưu file: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Lỗi hệ thống: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    // Lấy danh sách ảnh delivery
    @GetMapping("/delivery-photos")
    public ResponseEntity<List<Map<String, Object>>> getDeliveryPhotos(@RequestParam("shippingId") Long shippingId) {
        try {
            // Tìm shipping để lấy orderId
            Optional<Shipping> shippingOpt = shippingRepository.findById(shippingId);
            if (!shippingOpt.isPresent()) {
                return ResponseEntity.badRequest().body(new ArrayList<>());
            }
            
            Long orderId = shippingOpt.get().getOrderId();
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

    @GetMapping("/stats")
    @ResponseBody
    public ResponseEntity<?> getShippingStats() {
        try {
            List<Shipping> allShippings = shippingRepository.findAll();
            
            long pending = allShippings.stream().filter(s -> "PENDING".equals(s.getStatus())).count();
            long shipping = allShippings.stream().filter(s -> "SHIPPING".equals(s.getStatus())).count();
            long delivered = allShippings.stream().filter(s -> "DELIVERED".equals(s.getStatus())).count();
            long cancelled = allShippings.stream().filter(s -> "CANCELLED".equals(s.getStatus())).count();
            
            Map<String, Object> stats = new HashMap<>();
            stats.put("pending", pending);
            stats.put("shipping", shipping);
            stats.put("delivered", delivered);
            stats.put("cancelled", cancelled);
            stats.put("total", allShippings.size());
            
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("❌ Lỗi lấy thống kê: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Lỗi lấy thống kê shipping");
        }
    }
}
