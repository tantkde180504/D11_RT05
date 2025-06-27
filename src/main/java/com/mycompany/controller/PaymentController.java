package com.mycompany.controller;

import com.mycompany.repository.CartRepository;
import com.mycompany.repository.OrderItemRepository;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.ProductRepository;
import com.mycompany.model.Cart;
import com.mycompany.model.Order;
import com.mycompany.model.OrderItem;
import com.mycompany.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api")
public class PaymentController {
    @Autowired
    private CartRepository cartRepository;
    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private OrderRepository orderRepository;
    @Autowired
    private OrderItemRepository orderItemRepository;

    @PostMapping(value = "/payment", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> payment(@SessionAttribute(name = "userId", required = false) Long userId,
                                                      @RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "Bạn chưa đăng nhập!");
            return ResponseEntity.status(401).body(resp);
        }
        try {
            String fullName = (String) payload.getOrDefault("fullName", "");
            String phone = (String) payload.getOrDefault("phone", "");
            String address = (String) payload.getOrDefault("address", "");
            String note = (String) payload.getOrDefault("note", "");
            String paymentMethod = (String) payload.getOrDefault("paymentMethod", "COD");
            // Lấy cart từ database theo userId
            List<Cart> cartList = cartRepository.findByUserId(userId);
            if (cartList == null || cartList.isEmpty()) {
                resp.put("success", false);
                resp.put("message", "Giỏ hàng trống!");
                return ResponseEntity.ok(resp);
            }
            // Tính tổng tiền
            BigDecimal total = BigDecimal.ZERO;
            for (Cart cart : cartList) {
                Product product = productRepository.findById(cart.getProductId()).orElse(null);
                if (product == null || !Boolean.TRUE.equals(product.getIsActive())) {
                    resp.put("success", false);
                    resp.put("message", "Sản phẩm không tồn tại hoặc ngừng kinh doanh!");
                    return ResponseEntity.ok(resp);
                }
                if (product.getStockQuantity() < cart.getQuantity()) {
                    resp.put("success", false);
                    resp.put("message", "Sản phẩm '" + product.getName() + "' không đủ hàng!");
                    return ResponseEntity.ok(resp);
                }
                total = total.add(product.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity())));
            }
            // Tạo đơn hàng
            Order order = new Order();
            order.setUserId(userId);
            order.setTotalAmount(total);
            order.setStatus("PENDING");
            order.setShippingAddress(address);
            order.setShippingPhone(phone);
            order.setShippingName(fullName);
            order.setPaymentMethod(paymentMethod);
            order.setOrderDate(LocalDateTime.now());
            order.setNotes(note);
            // Sinh order_number 6 số cuối
            String orderNumber = "ORD" + String.format("%06d", System.currentTimeMillis() % 1000000);
            order.setOrderNumber(orderNumber);
            orderRepository.save(order);
            // Tạo order_items và cập nhật stock
            for (Cart cart : cartList) {
                Product product = productRepository.findById(cart.getProductId()).orElse(null);
                if (product == null) continue;
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setProduct(product);
                orderItem.setQuantity(cart.getQuantity());
                orderItem.setUnitPrice(product.getPrice());
                orderItem.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity())));
                orderItemRepository.save(orderItem);
                // Trừ tồn kho
                product.setStockQuantity(product.getStockQuantity() - cart.getQuantity());
                productRepository.save(product);
            }
            // Xóa cart
            cartRepository.deleteByUserId(userId);
            resp.put("success", true);
            resp.put("message", "Đặt hàng thành công!");
            return ResponseEntity.ok(resp);
        } catch (Exception ex) {
            resp.put("success", false);
            resp.put("message", "Lỗi xử lý đơn hàng!");
            return ResponseEntity.status(500).body(resp);
        }
    }

    @GetMapping("/orders/history")
    public ResponseEntity<?> getOrderHistory(@SessionAttribute(name = "userId", required = false) Long userId) {
        if (userId == null) {
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("message", "Bạn chưa đăng nhập!");
            return ResponseEntity.status(401).body(resp);
        }
        List<Order> orders = orderRepository.findByUserIdOrderByOrderDateDesc(userId);
        // Chuẩn bị dữ liệu trả về gồm: order info + list sản phẩm (tên, ảnh)
        List<Map<String, Object>> result = new ArrayList<>();
        for (Order order : orders) {
            Map<String, Object> o = new HashMap<>();
            o.put("id", order.getId());
            o.put("orderNumber", order.getOrderNumber());
            o.put("orderDate", order.getOrderDate());
            o.put("status", order.getStatus());
            o.put("totalAmount", order.getTotalAmount());
            // Lấy sản phẩm đầu tiên (nếu có)
            List<OrderItem> items = order.getOrderItems();
            if (items != null && !items.isEmpty()) {
                OrderItem first = items.get(0);
                Map<String, Object> productInfo = new HashMap<>();
                productInfo.put("name", first.getProduct().getName());
                productInfo.put("image", first.getProduct().getImageUrl()); // cần có trường imageUrl trong Product
                o.put("firstProduct", productInfo);
            } else {
                o.put("firstProduct", null);
            }
            result.add(o);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/orders/{orderId}/cancel")
    @Transactional
    public ResponseEntity<?> cancelOrder(@SessionAttribute(name = "userId", required = false) Long userId,
                                         @PathVariable Long orderId) {
        Map<String, Object> resp = new HashMap<>();
        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "Bạn chưa đăng nhập!");
            return ResponseEntity.status(401).body(resp);
        }
        Optional<Order> optOrder = orderRepository.findById(orderId);
        if (optOrder.isEmpty()) {
            resp.put("success", false);
            resp.put("message", "Không tìm thấy đơn hàng!");
            return ResponseEntity.ok(resp);
        }
        Order order = optOrder.get();
        if (!order.getUserId().equals(userId)) {
            resp.put("success", false);
            resp.put("message", "Bạn không có quyền hủy đơn này!");
            return ResponseEntity.ok(resp);
        }
        String status = order.getStatus();
        if (status.equals("PENDING") || status.equals("CONFIRMED") || status.equals("PROCESSING")) {
            order.setStatus("CANCELLED");
            orderRepository.save(order);
            resp.put("success", true);
            resp.put("message", "Đã hủy đơn hàng thành công!");
        } else {
            resp.put("success", false);
            resp.put("message", "Đơn hàng đã chuyển sang trạng thái vận chuyển/giao hàng, không thể hủy!");
        }
        return ResponseEntity.ok(resp);
    }
}
