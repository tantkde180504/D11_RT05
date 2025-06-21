package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api")
public class CartController {
    private final CartRepository cartRepository;
    private final ProductRepository productRepository;

    public CartController(CartRepository cartRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.productRepository = productRepository;
    }

    @GetMapping(value = "/cart", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> getCart(@SessionAttribute(name = "userId", required = false) Long userId) {
        System.out.println("=== API /cart REQUEST ===");
        System.out.println("userId in session: " + userId);
        Map<String, Object> resp = new HashMap<>();
        List<CartItem> cartItems = new ArrayList<>();
        double grandTotal = 0;
        if (userId != null) {
            List<Cart> cartList = cartRepository.findByUserId(userId);
            for (Cart cart : cartList) {
                Optional<Product> productOpt = productRepository.findById(cart.getProductId());
                if (productOpt.isPresent()) {
                    Product product = productOpt.get();
                    CartItem item = new CartItem(
                        product.getId(),
                        product.getName(),
                        product.getImageUrl(),
                        product.getPrice() != null ? product.getPrice().doubleValue() : 0.0,
                        cart.getQuantity()
                    );
                    cartItems.add(item);
                    grandTotal += item.getPrice() * item.getQuantity();
                }
            }
            resp.put("success", true);
            resp.put("cartItems", cartItems);
            resp.put("grandTotal", grandTotal);
        } else {
            System.out.println("No userId in session, cart is empty or user not logged in.");
            resp.put("success", false);
            resp.put("message", "User not logged in");
            resp.put("cartItems", cartItems);
            resp.put("grandTotal", grandTotal);
            return ResponseEntity.status(401).body(resp);
        }
        return ResponseEntity.ok(resp);
    }

    @Transactional
    @PostMapping(value = "/cart/update", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> updateCart(
            @SessionAttribute(name = "userId", required = false) Long userId,
            @RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "User not logged in");
            resp.put("cartItems", Collections.emptyList());
            resp.put("grandTotal", 0);
            return ResponseEntity.status(401).body(resp);
        }
        Object itemsObj = payload.get("items");
        List<Map<String, Object>> items = new ArrayList<>();
        Set<Long> updatedProductIds = new HashSet<>();
        if (itemsObj instanceof List<?>) {
            ObjectMapper mapper = new ObjectMapper();
            for (Object o : (List<?>) itemsObj) {
                Map<String, Object> map = mapper.convertValue(o, Map.class);
                items.add(map);
                if (map.get("productId") != null) {
                    updatedProductIds.add(((Number) map.get("productId")).longValue());
                }
            }
        }
        // Lấy toàn bộ cart hiện tại của user
        List<Cart> currentCartList = cartRepository.findByUserId(userId);
        // Xóa các sản phẩm không còn trong danh sách gửi lên
        for (Cart cart : currentCartList) {
            if (!updatedProductIds.contains(cart.getProductId())) {
                cartRepository.deleteByUserIdAndProductId(userId, cart.getProductId());
            }
        }
        // Cập nhật số lượng các sản phẩm còn lại
        if (!items.isEmpty()) {
            for (Map<String, Object> item : items) {
                Long productId = ((Number) item.get("productId")).longValue();
                Integer quantity = ((Number) item.get("quantity")).intValue();
                Cart cart = cartRepository.findByUserIdAndProductId(userId, productId);
                if (cart != null) {
                    if (quantity <= 0) {
                        cartRepository.deleteByUserIdAndProductId(userId, productId);
                    } else {
                        cart.setQuantity(quantity);
                        cartRepository.save(cart);
                    }
                }
            }
        }
        // Trả về cart mới
        List<Cart> cartList = cartRepository.findByUserId(userId);
        List<CartItem> cartItems = new ArrayList<>();
        double grandTotal = 0;
        for (Cart cart : cartList) {
            Optional<Product> productOpt = productRepository.findById(cart.getProductId());
            if (productOpt.isPresent()) {
                Product product = productOpt.get();
                CartItem cartItem = new CartItem(
                    product.getId(),
                    product.getName(),
                    product.getImageUrl(),
                    product.getPrice() != null ? product.getPrice().doubleValue() : 0.0,
                    cart.getQuantity()
                );
                cartItems.add(cartItem);
                grandTotal += cartItem.getPrice() * cartItem.getQuantity();
            }
        }
        resp.put("success", true);
        resp.put("cartItems", cartItems);
        resp.put("grandTotal", grandTotal);
        return ResponseEntity.ok(resp);
    }

    // XÓA SẢN PHẨM KHỎI GIỎ HÀNG NGAY LẬP TỨC (AJAX)
    @Transactional
    @PostMapping(value = "/cart/remove", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String, Object>> removeCartItem(
            @SessionAttribute(name = "userId", required = false) Long userId,
            @RequestBody Map<String, Object> payload) {
        Map<String, Object> resp = new HashMap<>();
        if (userId == null) {
            resp.put("success", false);
            resp.put("message", "User not logged in");
            return ResponseEntity.status(401).body(resp);
        }
        Object productIdObj = payload.get("productId");
        if (productIdObj == null) {
            resp.put("success", false);
            resp.put("message", "Missing productId");
            return ResponseEntity.badRequest().body(resp);
        }
        Long productId = ((Number) productIdObj).longValue();
        cartRepository.deleteByUserIdAndProductId(userId, productId);
        resp.put("success", true);
        return ResponseEntity.ok(resp);
    }
}
