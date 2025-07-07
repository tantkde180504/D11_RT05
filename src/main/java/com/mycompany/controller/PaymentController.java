package com.mycompany.controller;

import com.mycompany.config.PayOSConfig;
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
import vn.payos.PayOS;
import vn.payos.type.CheckoutResponseData;
import vn.payos.type.ItemData;
import vn.payos.type.PaymentData;

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
    @Autowired
    private PayOS payOS;
    @Autowired
    private PayOSConfig payOSConfig;

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
            
            // Tính tổng tiền và chuẩn bị dữ liệu
            BigDecimal total = BigDecimal.ZERO;
            List<ItemData> items = new ArrayList<>();
            
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
                
                BigDecimal itemTotal = product.getPrice().multiply(BigDecimal.valueOf(cart.getQuantity()));
                total = total.add(itemTotal);
                
                // Tạo item data cho PayOS
                ItemData itemData = ItemData.builder()
                    .name(product.getName())
                    .quantity(cart.getQuantity())
                    .price(product.getPrice().intValue())
                    .build();
                items.add(itemData);
            }
            
            // Xử lý thanh toán dựa trên phương thức
            if ("BANK_TRANSFER".equalsIgnoreCase(paymentMethod)) {
                // Tạo đơn hàng cho PayOS
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
                
                // Tạo link thanh toán PayOS
                Long orderCode = order.getId(); // Sử dụng ID của order làm orderCode
                
                PaymentData paymentData = PaymentData.builder()
                    .orderCode(orderCode)
                    .amount(total.intValue())
                    .description("Don hang " + orderNumber.substring(3)) // Rút gọn: "Don hang 123456"
                    .returnUrl(payOSConfig.getReturnUrl() + "?orderCode=" + orderCode)
                    .cancelUrl(payOSConfig.getCancelUrl() + "?orderCode=" + orderCode)
                    .items(items)
                    .build();
                
                CheckoutResponseData checkoutResponse = payOS.createPaymentLink(paymentData);
                
                // Trả về URL thanh toán
                resp.put("success", true);
                resp.put("message", "Đã tạo link thanh toán!");
                resp.put("checkoutUrl", checkoutResponse.getCheckoutUrl());
                resp.put("orderCode", orderCode);
                resp.put("orderNumber", orderNumber);
                
                return ResponseEntity.ok(resp);
                
            } else {
                // Xử lý thanh toán COD như cũ
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
                resp.put("orderNumber", orderNumber);
                
                return ResponseEntity.ok(resp);
            }
            
        } catch (Exception ex) {
            resp.put("success", false);
            resp.put("message", "Lỗi xử lý đơn hàng: " + ex.getMessage());
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

    // PayOS Payment confirmation endpoint
    @PostMapping("/payment/payos/confirm")
    @Transactional
    public ResponseEntity<?> confirmPayOSPayment(@RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        try {
            Long orderCode = Long.valueOf(payload.get("orderCode").toString());
            String status = payload.get("status").toString();
            
            // Tìm order theo orderCode (sử dụng ID)
            Optional<Order> optOrder = orderRepository.findById(orderCode);
            if (optOrder.isEmpty()) {
                resp.put("success", false);
                resp.put("message", "Không tìm thấy đơn hàng!");
                return ResponseEntity.ok(resp);
            }
            
            Order order = optOrder.get();
            
            if ("PAID".equalsIgnoreCase(status)) {
                // Thanh toán thành công - xử lý đơn hàng
                order.setStatus("PAID");
                orderRepository.save(order);
                
                // Tạo order_items và cập nhật stock
                List<Cart> cartList = cartRepository.findByUserId(order.getUserId());
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
                cartRepository.deleteByUserId(order.getUserId());
                
                resp.put("success", true);
                resp.put("message", "Thanh toán thành công!");
            } else {
                // Thanh toán thất bại - hủy đơn hàng
                order.setStatus("CANCELLED");
                orderRepository.save(order);
                
                resp.put("success", false);
                resp.put("message", "Thanh toán thất bại!");
            }
            
            return ResponseEntity.ok(resp);
            
        } catch (Exception ex) {
            resp.put("success", false);
            resp.put("message", "Lỗi xử lý thanh toán: " + ex.getMessage());
            return ResponseEntity.status(500).body(resp);
        }
    }
    

}