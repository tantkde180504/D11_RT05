package com.mycompany.repository;

import com.mycompany.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Tìm tất cả sản phẩm active
    List<Product> findByIsActiveTrue();
    
    // Tìm sản phẩm featured
    List<Product> findByIsFeaturedTrueAndIsActiveTrue();
    
    // Tìm sản phẩm theo category
    List<Product> findByCategoryAndIsActiveTrue(Product.Category category);
    
    // Tìm sản phẩm theo grade
    List<Product> findByGradeAndIsActiveTrue(Product.Grade grade);
    
    // Tìm sản phẩm theo tên (search)
    @Query("SELECT p FROM Product p WHERE p.name LIKE %:keyword% AND p.isActive = true")
    List<Product> findByNameContainingIgnoreCaseAndIsActiveTrue(@Param("keyword") String keyword);
    
    // Lấy sản phẩm mới nhất
    @Query("SELECT p FROM Product p WHERE p.isActive = true ORDER BY p.createdAt DESC")
    List<Product> findLatestProducts();
    
    // Lấy top sản phẩm (có thể dựa vào số lượng bán hoặc featured)
    @Query("SELECT p FROM Product p WHERE p.isActive = true ORDER BY p.isFeatured DESC, p.createdAt DESC")
    List<Product> findTopProducts();
}