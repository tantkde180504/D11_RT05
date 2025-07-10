package com.mycompany.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import com.mycompany.repository.CartRepository;
import com.mycompany.repository.OrderRepository;
import com.mycompany.repository.OrderItemRepository;
import com.mycompany.repository.ProductRepository;
import com.mycompany.model.Cart;
import com.mycompany.model.Order;
import com.mycompany.model.OrderItem;
import com.mycompany.model.Product;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Controller
public class PaymentPageController {
    
    @Autowired
    private CartRepository cartRepository;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    // PayOS Payment success page
    @GetMapping("/payment/success")
    @Transactional
    public String paymentSuccess(@RequestParam(name = "orderCode", required = false) String orderCode,
                               @RequestParam(name = "status", required = false) String status,
                               @RequestParam(name = "cancel", required = false) String cancel,
                               @SessionAttribute(name = "userId", required = false) Long userId) {
        // Log để debug
        System.out.println("=== PAYMENT SUCCESS CALLBACK ===");
        System.out.println("PayOS Success - OrderCode: " + orderCode + ", Status: " + status + ", Cancel: " + cancel);
        System.out.println("User ID from session: " + userId);
        
        // Xử lý sau thanh toán thành công
        if (orderCode != null && userId != null) {
            try {
                // orderCode là ID của order trong PayOS
                Long orderId = Long.valueOf(orderCode);
                Optional<Order> orderOpt = orderRepository.findById(orderId);
                
                if (orderOpt.isPresent()) {
                    Order order = orderOpt.get();
                    
                    // Kiểm tra xem order có thuộc về user hiện tại không
                    if (order.getUserId().equals(userId)) {
                        // Cập nhật trạng thái order thành CONFIRMED 
                        if (!"CONFIRMED".equals(order.getStatus()) && !"DELIVERED".equals(order.getStatus())) {
                            order.setStatus("CONFIRMED");
                            orderRepository.save(order);
                            System.out.println("Order status updated to CONFIRMED: " + orderId);
                            
                            // Tạo order_items và trừ stock (chỉ khi order chuyển thành CONFIRMED)
                            List<Cart> cartList = cartRepository.findByUserId(userId);
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
                            System.out.println("Order items created and stock updated for order: " + orderId);
                        }
                        
                        // Xóa giỏ hàng của user sau khi thanh toán thành công
                        cartRepository.deleteByUserId(userId);
                        System.out.println("Cart cleared for user: " + userId);
                    } else {
                        System.out.println("Order does not belong to the current user: " + orderId);
                    }
                } else {
                    System.out.println("Order not found: " + orderId);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid orderCode format: " + orderCode);
            } catch (Exception e) {
                System.err.println("Error processing payment success: " + e.getMessage());
            }
        }
        
        // Redirect về trang chủ luôn (index.jsp là trang chủ thực)
        return "redirect:/index.jsp";
    }
    
    // PayOS Payment cancel page
    @GetMapping("/payment/cancel")
    @Transactional
    public String paymentCancel(@RequestParam(name = "orderCode", required = false) String orderCode,
                              @RequestParam(name = "status", required = false) String status,
                              @SessionAttribute(name = "userId", required = false) Long userId) {
        // Log để debug
        System.out.println("PayOS Cancel - OrderCode: " + orderCode + ", Status: " + status);
        System.out.println("User ID from session: " + userId);
        
        // Xử lý khi hủy thanh toán
        if (orderCode != null && userId != null) {
            try {
                // orderCode là ID của order trong PayOS
                Long orderId = Long.valueOf(orderCode);
                Optional<Order> orderOpt = orderRepository.findById(orderId);
                
                if (orderOpt.isPresent()) {
                    Order order = orderOpt.get();
                    
                    // Kiểm tra xem order có thuộc về user hiện tại không
                    if (order.getUserId().equals(userId)) {
                        // Cập nhật trạng thái order thành CANCELLED
                        if (!"CANCELLED".equals(order.getStatus())) {
                            order.setStatus("CANCELLED");
                            orderRepository.save(order);
                            System.out.println("Order cancelled: " + orderId);
                        }
                    } else {
                        System.out.println("Order does not belong to the current user: " + orderId);
                    }
                } else {
                    System.out.println("Order not found: " + orderId);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid orderCode format: " + orderCode);
            } catch (Exception e) {
                System.err.println("Error processing payment cancel: " + e.getMessage());
            }
        }
        
        // Redirect về trang giỏ hàng để user có thể thử thanh toán lại
        return "redirect:/cart.jsp";
    }
    
    // Test endpoint để kiểm tra controller hoạt động
    @GetMapping("/payment/test")
    public String testPayment() {
        System.out.println("Payment controller test endpoint called");
        return "redirect:/index.html";
    }
}
