package com.mycompany.controller;

import com.mycompany.model.Product;
import com.mycompany.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    // Lấy tất cả sản phẩm active
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProducts() {
        try {
            List<Product> products = productService.getAllActiveProducts();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy danh sách sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy sản phẩm featured cho trang chủ
    @GetMapping("/featured")
    public ResponseEntity<Map<String, Object>> getFeaturedProducts() {
        try {
            List<Product> products = productService.getFeaturedProducts();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy sản phẩm nổi bật: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy sản phẩm mới nhất
    @GetMapping("/latest")
    public ResponseEntity<Map<String, Object>> getLatestProducts(@RequestParam(defaultValue = "8") int limit) {
        try {
            List<Product> products = productService.getLatestProducts(limit);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy sản phẩm mới: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy top sản phẩm
    @GetMapping("/top")
    public ResponseEntity<Map<String, Object>> getTopProducts(@RequestParam(defaultValue = "12") int limit) {
        try {
            List<Product> products = productService.getTopProducts(limit);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy top sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy sản phẩm theo category
    @GetMapping("/category/{category}")
    public ResponseEntity<Map<String, Object>> getProductsByCategory(@PathVariable String category) {
        try {
            Product.Category categoryEnum = Product.Category.valueOf(category.toUpperCase());
            List<Product> products = productService.getProductsByCategory(categoryEnum);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            response.put("category", category);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Category không hợp lệ: " + category);
            
            return ResponseEntity.status(400)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy sản phẩm theo category: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy sản phẩm theo grade
    @GetMapping("/grade/{grade}")
    public ResponseEntity<Map<String, Object>> getProductsByGrade(@PathVariable String grade) {
        try {
            Product.Grade gradeEnum = Product.Grade.valueOf(grade.toUpperCase());
            List<Product> products = productService.getProductsByGrade(gradeEnum);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            response.put("grade", grade);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (IllegalArgumentException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Grade không hợp lệ: " + grade);
            
            return ResponseEntity.status(400)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy sản phẩm theo grade: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Tìm kiếm sản phẩm
    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchProducts(@RequestParam String keyword) {
        try {
            List<Product> products = productService.searchProducts(keyword);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", products);
            response.put("total", products.size());
            response.put("keyword", keyword);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi tìm kiếm sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy chi tiết sản phẩm
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getProductById(@PathVariable Long id) {
        try {
            Optional<Product> product = productService.getProductById(id);
            
            if (product.isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("data", product.get());
                response.put("inStock", productService.isInStock(id));
                
                return ResponseEntity.ok()
                        .header("Content-Type", "application/json")
                        .body(response);
            } else {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Không tìm thấy sản phẩm với ID: " + id);
                
                return ResponseEntity.status(404)
                        .header("Content-Type", "application/json")
                        .body(errorResponse);
            }
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy chi tiết sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
}
