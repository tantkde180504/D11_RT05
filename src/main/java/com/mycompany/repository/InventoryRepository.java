package com.mycompany.repository;
import com.mycompany.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface InventoryRepository extends JpaRepository<Product, Long> {
    List<Product> findByIsActiveTrueOrderByUpdatedAtDesc();
    // ✅ Thêm method lấy sản phẩm sắp hết hàng
    List<Product> findByIsActiveTrueAndStockQuantityLessThanOrderByStockQuantityAsc(int quantityThreshold);
}
