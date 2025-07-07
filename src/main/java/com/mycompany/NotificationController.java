// NotificationController.java
package com.mycompany;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.MediaType;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private ProductRepository productRepository;

    // ✅ API lấy sản phẩm có tồn kho < 5
    @GetMapping(value = "/low-stock", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Product> getLowStockProducts() {
        List<Product> products = productRepository.findByIsActiveTrueOrderByUpdatedAtDesc();
        return products.stream()
                .filter(p -> p.getStockQuantity() <= 5)
                .collect(Collectors.toList());
    }
}
