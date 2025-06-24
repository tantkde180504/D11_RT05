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

    // ✅ Lấy toàn bộ đơn hàng theo thời gian giảm dần
    List<Order> findAllByOrderByOrderDateDesc();

    // ✅ Lọc theo trạng thái đơn hàng (ví dụ: PENDING, CONFIRMED...)
    List<Order> findByStatusOrderByOrderDateDesc(String status);

    // ✅ Cập nhật trạng thái đơn hàng từ PENDING sang CONFIRMED
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = 'CONFIRMED' WHERE o.id = :orderId AND o.status = 'PENDING'")
    int confirmOrderById(@Param("orderId") Long orderId);

    // ✅ Cập nhật linh hoạt sang bất kỳ trạng thái nào
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = :newStatus WHERE o.id = :orderId")
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("newStatus") String newStatus);
}

