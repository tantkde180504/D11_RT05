package com.mycompany;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import java.util.*;

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
}
