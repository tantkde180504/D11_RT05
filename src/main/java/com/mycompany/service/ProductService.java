package com.mycompany.service;

import com.mycompany.model.Product;
import com.mycompany.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    // Lấy tất cả sản phẩm active
    public List<Product> getAllActiveProducts() {
        return productRepository.findByIsActiveTrue();
    }
    
    // Lấy sản phẩm featured cho trang chủ
    public List<Product> getFeaturedProducts() {
        return productRepository.findByIsFeaturedTrueAndIsActiveTrue();
    }
    
    // Lấy sản phẩm mới nhất (limit)
    public List<Product> getLatestProducts(int limit) {
        List<Product> allLatest = productRepository.findLatestProducts();
        return allLatest.size() > limit ? 
            allLatest.subList(0, limit) : allLatest;
    }
    
    // Lấy top sản phẩm cho trang chủ
    public List<Product> getTopProducts(int limit) {
        List<Product> allTop = productRepository.findTopProducts();
        return allTop.size() > limit ? 
            allTop.subList(0, limit) : allTop;
    }
    
    // Lấy sản phẩm theo category
    public List<Product> getProductsByCategory(Product.Category category) {
        return productRepository.findByCategoryAndIsActiveTrue(category);
    }
    
    // Lấy sản phẩm theo grade
    public List<Product> getProductsByGrade(Product.Grade grade) {
        return productRepository.findByGradeAndIsActiveTrue(grade);
    }
    
    // Tìm kiếm sản phẩm
    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllActiveProducts();
        }
        return productRepository.findByNameContainingIgnoreCaseAndIsActiveTrue(keyword.trim());
    }
    
    // Lấy sản phẩm theo ID
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    // Lưu sản phẩm
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }
    
    // Xóa sản phẩm (soft delete)
    public void deleteProduct(Long id) {
        Optional<Product> product = productRepository.findById(id);
        if (product.isPresent()) {
            Product p = product.get();
            p.setIsActive(false);
            productRepository.save(p);
        }
    }
    
    // Kiểm tra sản phẩm còn hàng
    public boolean isInStock(Long productId) {
        Optional<Product> product = productRepository.findById(productId);
        return product.isPresent() && 
               product.get().getStockQuantity() != null && 
               product.get().getStockQuantity() > 0;
    }
}
