package com.mycompany.controller;

import com.mycompany.model.Product;
import com.mycompany.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping(value = "/api/admin/products", produces = "application/json")
public class ProductAdminController {
    
    @Autowired
    private ProductService productService;
    
    // Lấy tất cả sản phẩm (bao gồm inactive)
    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProducts() {
        try {
            List<Product> products = productService.getAllProducts();
            
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
    
    // Lấy chi tiết sản phẩm
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getProductById(@PathVariable Long id) {
        try {
            Optional<Product> product = productService.getProductById(id);
            
            if (product.isPresent()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("data", product.get());
                
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
    
    // Thêm sản phẩm mới
    @PostMapping
    public ResponseEntity<Map<String, Object>> createProduct(@RequestBody Map<String, Object> productData) {
        try {
            Product product = new Product();
            product.setName((String) productData.get("name"));
            product.setDescription((String) productData.get("description"));
            product.setPrice(new BigDecimal(productData.get("price").toString()));
            product.setStockQuantity(Integer.parseInt(productData.get("stockQuantity").toString()));
            product.setBrand((String) productData.get("brand"));
            product.setImageUrl((String) productData.get("imageUrl"));
            
            // Handle category
            if (productData.get("category") != null) {
                try {
                    Product.Category category = Product.Category.valueOf(productData.get("category").toString().toUpperCase());
                    product.setCategory(category);
                } catch (IllegalArgumentException e) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Category không hợp lệ: " + productData.get("category"));
                    return ResponseEntity.status(400)
                            .header("Content-Type", "application/json")
                            .body(errorResponse);
                }
            }
            
            // Handle grade
            if (productData.get("grade") != null) {
                try {
                    Product.Grade grade = Product.Grade.valueOf(productData.get("grade").toString().toUpperCase());
                    product.setGrade(grade);
                } catch (IllegalArgumentException e) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Grade không hợp lệ: " + productData.get("grade"));
                    return ResponseEntity.status(400)
                            .header("Content-Type", "application/json")
                            .body(errorResponse);
                }
            }
            
            // Handle boolean fields
            if (productData.get("isActive") != null) {
                product.setIsActive(Boolean.parseBoolean(productData.get("isActive").toString()));
            }
            if (productData.get("isFeatured") != null) {
                product.setIsFeatured(Boolean.parseBoolean(productData.get("isFeatured").toString()));
            }
            
            Product savedProduct = productService.saveProduct(product);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Thêm sản phẩm thành công");
            response.put("data", savedProduct);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Cập nhật sản phẩm
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateProduct(
            @PathVariable Long id, 
            @RequestBody Map<String, Object> productData) {
        try {
            Optional<Product> existingProductOpt = productService.getProductById(id);
            
            if (!existingProductOpt.isPresent()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Không tìm thấy sản phẩm với ID: " + id);
                return ResponseEntity.status(404)
                        .header("Content-Type", "application/json")
                        .body(errorResponse);
            }
            
            Product product = existingProductOpt.get();
            
            // Update fields if provided
            if (productData.get("name") != null) {
                product.setName((String) productData.get("name"));
            }
            if (productData.get("description") != null) {
                product.setDescription((String) productData.get("description"));
            }
            if (productData.get("price") != null) {
                product.setPrice(new BigDecimal(productData.get("price").toString()));
            }
            if (productData.get("stockQuantity") != null) {
                product.setStockQuantity(Integer.parseInt(productData.get("stockQuantity").toString()));
            }
            if (productData.get("brand") != null) {
                product.setBrand((String) productData.get("brand"));
            }
            if (productData.get("imageUrl") != null) {
                product.setImageUrl((String) productData.get("imageUrl"));
            }
            
            // Handle category
            if (productData.get("category") != null) {
                try {
                    Product.Category category = Product.Category.valueOf(productData.get("category").toString().toUpperCase());
                    product.setCategory(category);
                } catch (IllegalArgumentException e) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Category không hợp lệ: " + productData.get("category"));
                    return ResponseEntity.status(400)
                            .header("Content-Type", "application/json")
                            .body(errorResponse);
                }
            }
            
            // Handle grade
            if (productData.get("grade") != null) {
                try {
                    Product.Grade grade = Product.Grade.valueOf(productData.get("grade").toString().toUpperCase());
                    product.setGrade(grade);
                } catch (IllegalArgumentException e) {
                    Map<String, Object> errorResponse = new HashMap<>();
                    errorResponse.put("success", false);
                    errorResponse.put("message", "Grade không hợp lệ: " + productData.get("grade"));
                    return ResponseEntity.status(400)
                            .header("Content-Type", "application/json")
                            .body(errorResponse);
                }
            }
            
            // Handle boolean fields
            if (productData.get("isActive") != null) {
                product.setIsActive(Boolean.parseBoolean(productData.get("isActive").toString()));
            }
            if (productData.get("isFeatured") != null) {
                product.setIsFeatured(Boolean.parseBoolean(productData.get("isFeatured").toString()));
            }
            
            Product updatedProduct = productService.saveProduct(product);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Cập nhật sản phẩm thành công");
            response.put("data", updatedProduct);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Xóa sản phẩm (soft delete)
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteProduct(@PathVariable Long id) {
        try {
            Optional<Product> existingProductOpt = productService.getProductById(id);
            
            if (!existingProductOpt.isPresent()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Không tìm thấy sản phẩm với ID: " + id);
                return ResponseEntity.status(404)
                        .header("Content-Type", "application/json")
                        .body(errorResponse);
            }
            
            // Soft delete - set isActive to false
            Product product = existingProductOpt.get();
            product.setIsActive(false);
            productService.saveProduct(product);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Xóa sản phẩm thành công");
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi xóa sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Khôi phục sản phẩm
    @PutMapping("/{id}/restore")
    public ResponseEntity<Map<String, Object>> restoreProduct(@PathVariable Long id) {
        try {
            Optional<Product> existingProductOpt = productService.getProductById(id);
            
            if (!existingProductOpt.isPresent()) {
                Map<String, Object> errorResponse = new HashMap<>();
                errorResponse.put("success", false);
                errorResponse.put("message", "Không tìm thấy sản phẩm với ID: " + id);
                return ResponseEntity.status(404)
                        .header("Content-Type", "application/json")
                        .body(errorResponse);
            }
            
            Product product = existingProductOpt.get();
            product.setIsActive(true);
            Product restoredProduct = productService.saveProduct(product);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Khôi phục sản phẩm thành công");
            response.put("data", restoredProduct);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
                    
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi khôi phục sản phẩm: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy danh sách categories
    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> getCategories() {
        try {
            Product.Category[] categories = Product.Category.values();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", categories);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy danh sách categories: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
    
    // Lấy danh sách grades
    @GetMapping("/grades")
    public ResponseEntity<Map<String, Object>> getGrades() {
        try {
            Product.Grade[] grades = Product.Grade.values();
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", grades);
            
            return ResponseEntity.ok()
                    .header("Content-Type", "application/json")
                    .body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Lỗi khi lấy danh sách grades: " + e.getMessage());
            
            return ResponseEntity.status(500)
                    .header("Content-Type", "application/json")
                    .body(errorResponse);
        }
    }
}
