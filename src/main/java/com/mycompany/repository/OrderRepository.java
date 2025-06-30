package com.mycompany.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.mycompany.model.Order;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    // Có thể thêm custom query nếu cần
    java.util.List<Order> findByUserIdOrderByOrderDateDesc(Long userId);

    /**
     * Kiểm tra xem người dùng đã mua sản phẩm chưa
     * Chỉ xét các đơn hàng đã giao thành công
     */
    @Query("SELECT COUNT(o) > 0 FROM Order o JOIN o.orderItems oi JOIN oi.product p " +
           "WHERE o.userId = :userId AND p.id = :productId " +
           "AND o.status = 'DELIVERED'")
    boolean existsByUserIdAndProductId(@Param("userId") Long userId, @Param("productId") Long productId);
}