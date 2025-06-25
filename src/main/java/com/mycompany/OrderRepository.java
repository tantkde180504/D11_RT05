package com.mycompany;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    // Lấy toàn bộ đơn hàng theo thời gian giảm dần
    List<Order> findAllByOrderByOrderDateDesc();

    // Lọc theo trạng thái đơn hàng
    List<Order> findByStatusOrderByOrderDateDesc(String status);

    // ✅ Cập nhật trạng thái đơn hàng từ PENDING → CONFIRMED
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = 'CONFIRMED' WHERE o.id = :orderId AND o.status = 'PENDING'")
    int confirmOrderById(@Param("orderId") Long orderId);

    // ✅ Cập nhật trạng thái đơn hàng bất kỳ
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = :status WHERE o.id = :orderId")
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);

    // Tìm theo userId và mã đơn
    Order findByUserIdAndOrderNumber(Long userId, String orderNumber);
}
