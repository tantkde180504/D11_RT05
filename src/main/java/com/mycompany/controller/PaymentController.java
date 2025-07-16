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

import jakarta.servlet.http.HttpSession;
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

    // ✅ HÀM DÙNG CHUNG ĐỂ LẤY userId AN TOÀN
    private Long getUserId(HttpSession session) {
        Object val = (session != null) ? session.getAttribute("userId") : null;
        if (val instanceof Integer) return ((Integer) val).longValue();
        if (val instanceof Long) return (Long) val;
        return null;
    }

    @PostMapping(value = "/payment", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> payment(HttpSession session,
                                                      @RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        
        // Debug logging
        System.out.println("=== PAYMENT REQUEST DEBUG ===");
        System.out.println("Payload received: " + payload);
        
        Long userId = getUserId(session);
        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "Bạn chưa đăng nhập!");
            return ResponseEntity.status(401).body(resp);
        }
        
        System.out.println("User ID: " + userId);

        try {
            String fullName = (String) payload.getOrDefault("fullName", "");
            String phone = (String) payload.getOrDefault("phone", "");
            String address = (String) payload.getOrDefault("address", "");
            String note = (String) payload.getOrDefault("note", "");
            String paymentMethod = (String) payload.getOrDefault("paymentMethod", "COD");
            
            // Kiểm tra chế độ mua hàng
            Boolean buyNowMode = (Boolean) payload.getOrDefault("buyNowMode", false);
            
            List<Cart> cartList;
            List<Long> selectedIds = new ArrayList<>(); // Di chuyển khai báo ra ngoài
            
            if (buyNowMode) {
                // Xử lý mua ngay (logic mới)
                Object productIdObj = payload.get("productId");
                Object quantityObj = payload.get("quantity");
                
                if (productIdObj == null || quantityObj == null) {
                    resp.put("success", false);
                    resp.put("message", "Thông tin sản phẩm không hợp lệ!");
                    return ResponseEntity.ok(resp);
                }
                
                Long productId = Long.valueOf(productIdObj.toString());
                Integer quantity = Integer.valueOf(quantityObj.toString());
                
                Product product = productRepository.findById(productId).orElse(null);
                if (product == null || !Boolean.TRUE.equals(product.getIsActive())) {
                    resp.put("success", false);
                    resp.put("message", "Sản phẩm không tồn tại hoặc ngừng kinh doanh!");
                    return ResponseEntity.ok(resp);
                }
                
                if (product.getStockQuantity() < quantity) {
                    resp.put("success", false);
                    resp.put("message", "Sản phẩm không đủ hàng!");
                    return ResponseEntity.ok(resp);
                }
                
                // Kiểm tra cart DB
                Cart cart = cartRepository.findByUserIdAndProductId(userId, productId);
                if (cart == null) {
                    cart = new Cart();
                    cart.setUserId(userId);
                    cart.setProductId(productId);
                    cart.setQuantity(quantity);
                    cartRepository.save(cart);
                } else {
                    // Nếu đã có, cập nhật lại số lượng nếu khác
                    if (!cart.getQuantity().equals(quantity)) {
                        cart.setQuantity(quantity);
                        cartRepository.save(cart);
                    }
                }
                cartList = Arrays.asList(cart);
            } else {
                // Xử lý từ giỏ hàng
                cartList = cartRepository.findByUserId(userId);
                if (cartList == null || cartList.isEmpty()) {
                    resp.put("success", false);
                    resp.put("message", "Giỏ hàng trống!");
                    return ResponseEntity.ok(resp);
                }
                
                // Lọc theo selectedCartIds nếu có
                Object selectedCartIdsObj = payload.get("selectedCartIds");
                
                if (selectedCartIdsObj instanceof List<?>) {
                    @SuppressWarnings("unchecked")
                    List<Object> selectedCartIdsList = (List<Object>) selectedCartIdsObj;
                    
                    for (Object obj : selectedCartIdsList) {
                        try {
                            if (obj instanceof Integer) {
                                selectedIds.add(((Integer) obj).longValue());
                            } else if (obj instanceof Long) {
                                selectedIds.add((Long) obj);
                            } else if (obj instanceof String) {
                                selectedIds.add(Long.parseLong((String) obj));
                            }
                        } catch (NumberFormatException e) {
                            // Bỏ qua ID không hợp lệ
                            System.err.println("Invalid cart ID: " + obj);
                        }
                    }
                }
                
                if (!selectedIds.isEmpty()) {
                    System.out.println("Processing selected cart IDs: " + selectedIds);
                    cartList = cartList.stream()
                        .filter(cart -> selectedIds.contains(cart.getProductId())) // SỬA: lọc theo cartId
                        .collect(java.util.stream.Collectors.toList());
                        
                    if (cartList.isEmpty()) {
                        resp.put("success", false);
                        resp.put("message", "Không có sản phẩm nào được chọn để thanh toán!");
                        return ResponseEntity.ok(resp);
                    }
                } else {
                    System.out.println("No selected cart IDs, processing all cart items");
                }
            }

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

                items.add(ItemData.builder()
                        .name(product.getName())
                        .quantity(cart.getQuantity())
                        .price(product.getPrice().intValue())
                        .build());
            }

            Order order = new Order();
            order.setUserId(userId);
            order.setTotalAmount(total);
            order.setStatus("PENDING");
            order.setShippingAddress(address);
            order.setShippingPhone(phone);
            order.setShippingName(fullName);
            order.setPaymentMethod(paymentMethod);
            order.setOrderDate(LocalDateTime.now());
            order.setNotes(note);                // Lưu selectedCartIds để dùng khi thanh toán thành công
                if (!buyNowMode && selectedIds != null && !selectedIds.isEmpty()) {
                    String selectedIdsStr = String.join(",", selectedIds.stream().map(String::valueOf).toArray(String[]::new));
                    order.setNotes((note != null ? note : "") + " [SELECTED_IDS:" + selectedIdsStr + "]");
                    System.out.println("Saved selectedIds to order notes: " + selectedIdsStr);
                } else {
                    System.out.println("No selectedIds to save. buyNowMode: " + buyNowMode + ", selectedIds: " + selectedIds);
                }

            String orderNumber = "ORD" + String.format("%06d", System.currentTimeMillis() % 1000000);
            order.setOrderNumber(orderNumber);
            orderRepository.save(order);

            if ("BANK_TRANSFER".equalsIgnoreCase(paymentMethod)) {
                // Tạo OrderItems ngay cho PayOS (giống COD)
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
                }

                // Tạo PayOS payment link
                Long orderCode = order.getId();
                PaymentData paymentData = PaymentData.builder()
                        .orderCode(orderCode)
                        .amount(total.intValue())
                        .description("Don hang " + orderNumber.substring(3))
                        .returnUrl(payOSConfig.getReturnUrl() + "?orderCode=" + orderCode)
                        .cancelUrl(payOSConfig.getCancelUrl() + "?orderCode=" + orderCode)
                        .items(items)
                        .build();

                CheckoutResponseData checkoutResponse = payOS.createPaymentLink(paymentData);

                // KHÔNG xóa cart ở đây, chỉ xóa khi thanh toán thành công trong confirmPayOSPayment

                resp.put("success", true);
                resp.put("message", "Đã tạo link thanh toán!");
                resp.put("checkoutUrl", checkoutResponse.getCheckoutUrl());
                resp.put("orderCode", orderCode);
                resp.put("orderNumber", orderNumber);
                return ResponseEntity.ok(resp);
            } else {
                // COD - Xử lý đặt hàng ngay
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

                    product.setStockQuantity(product.getStockQuantity() - cart.getQuantity());
                    productRepository.save(product);
                }

                // Sau khi thanh toán thành công (COD)
                if (buyNowMode) {
                    // Luôn xóa cart item khỏi giỏ
                    for (Cart cart : cartList) {
                        cartRepository.deleteByUserIdAndProductId(userId, cart.getProductId());
                    }
                } else {
                    // Xóa chỉ những sản phẩm đã thanh toán
                    for (Cart cart : cartList) {
                        cartRepository.deleteByUserIdAndProductId(userId, cart.getProductId());
                    }
                }
                
                resp.put("success", true);
                resp.put("message", "Đặt hàng thành công!");
                resp.put("orderNumber", orderNumber);
                return ResponseEntity.ok(resp);
            }

        } catch (Exception ex) {
            System.err.println("=== PAYMENT ERROR ===");
            System.err.println("Error message: " + ex.getMessage());
            ex.printStackTrace();
            
            resp.put("success", false);
            resp.put("message", "Lỗi xử lý đơn hàng: " + ex.getMessage());
            return ResponseEntity.status(500).body(resp);
        }
    }

    @GetMapping("/orders/history")
    public ResponseEntity<?> getOrderHistory(HttpSession session) {
        Long userId = getUserId(session);
        if (userId == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Bạn chưa đăng nhập!"));
        }

        List<Order> orders = orderRepository.findByUserIdOrderByOrderDateDesc(userId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Order order : orders) {
            Map<String, Object> o = new HashMap<>();
            o.put("id", order.getId());
            o.put("orderNumber", order.getOrderNumber());
            o.put("orderDate", order.getOrderDate());
            o.put("status", order.getStatus());
            o.put("totalAmount", order.getTotalAmount());

            List<OrderItem> items = order.getOrderItems();
            if (items != null && !items.isEmpty()) {
                OrderItem first = items.get(0);
                Map<String, Object> productInfo = new HashMap<>();
                productInfo.put("name", first.getProduct().getName());
                productInfo.put("image", first.getProduct().getImageUrl());
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
    public ResponseEntity<?> cancelOrder(HttpSession session,
                                         @PathVariable Long orderId) {
        Long userId = getUserId(session);
if (userId == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "message", "Bạn chưa đăng nhập!"));
        }

        Optional<Order> optOrder = orderRepository.findById(orderId);
        if (optOrder.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Không tìm thấy đơn hàng!"));
        }

        Order order = optOrder.get();
        if (!order.getUserId().equals(userId)) {
            return ResponseEntity.ok(Map.of("success", false, "message", "Bạn không có quyền hủy đơn này!"));
        }

        String status = order.getStatus();
        if (status.equals("PENDING") || status.equals("CONFIRMED") || status.equals("PROCESSING")) {
            order.setStatus("CANCELLED");
            orderRepository.save(order);
            return ResponseEntity.ok(Map.of("success", true, "message", "Đã hủy đơn hàng thành công!"));
        } else {
            return ResponseEntity.ok(Map.of("success", false, "message", "Đơn hàng đã chuyển sang trạng thái vận chuyển/giao hàng, không thể hủy!"));
        }
    }

    @PostMapping("/payment/payos/confirm")
    @Transactional
    public ResponseEntity<?> confirmPayOSPayment(@RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        try {
            Long orderCode = Long.valueOf(payload.get("orderCode").toString());
            String status = payload.get("status").toString();

            Optional<Order> optOrder = orderRepository.findById(orderCode);
            if (optOrder.isEmpty()) {
                resp.put("success", false);
                resp.put("message", "Không tìm thấy đơn hàng!");
                return ResponseEntity.ok(resp);
            }

            Order order = optOrder.get();

            if ("PAID".equalsIgnoreCase(status)) {
                order.setStatus("PAID");
                orderRepository.save(order);

                // Lấy selectedCartIds từ order notes nếu có
                List<Long> selectedCartIds = new ArrayList<>();
                String notes = order.getNotes();
                System.out.println("Order notes: " + notes);
                
                if (notes != null && notes.contains("[SELECTED_IDS:")) {
                    int start = notes.indexOf("[SELECTED_IDS:") + 14;
                    int end = notes.indexOf("]", start);
                    if (end > start) {
                        String idsStr = notes.substring(start, end);
                        String[] ids = idsStr.split(",");
                        for (String id : ids) {
                            try {
                                selectedCartIds.add(Long.parseLong(id.trim()));
                            } catch (NumberFormatException e) {
                                // Bỏ qua ID không hợp lệ
                                System.err.println("Invalid cart ID in notes: " + id);
                            }
                        }
                    }
                }
                
                System.out.println("Extracted selectedCartIds from order notes: " + selectedCartIds);

                // Cập nhật stock quantity và xóa cart items
                List<OrderItem> orderItems = order.getOrderItems();
                for (OrderItem orderItem : orderItems) {
                    Product product = orderItem.getProduct();
                    if (product != null) {
                        // Giảm stock quantity
                        product.setStockQuantity(product.getStockQuantity() - orderItem.getQuantity());
                        productRepository.save(product);
                        
                        // Xóa sản phẩm khỏi cart
                        cartRepository.deleteByUserIdAndProductId(order.getUserId(), product.getId());
                    }
                }

                System.out.println("PayOS payment confirmed. Selected cart IDs were: " + selectedCartIds);

                resp.put("success", true);
                resp.put("message", "Thanh toán thành công!");
            } else {
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