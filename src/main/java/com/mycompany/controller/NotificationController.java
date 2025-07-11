// NotificationController.java
package com.mycompany.controller;
import com.mycompany.model.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.mycompany.repository.InventoryRepository;

import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.MediaType;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private InventoryRepository inventoryRepository;

    // ✅ API lấy sản phẩm có tồn kho < 5
    @GetMapping(value = "/low-stock", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Product> getLowStockProducts() {
        List<Product> products = inventoryRepository.findByIsActiveTrueOrderByUpdatedAtDesc();
        return products.stream()
                .filter(p -> p.getStockQuantity() <= 5)
                .collect(Collectors.toList());
    }
}
