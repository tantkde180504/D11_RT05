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

    List<Order> findAllByOrderByOrderDateDesc();
    List<Order> findByStatusOrderByOrderDateDesc(String status);

    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = 'CONFIRMED' WHERE o.id = :orderId AND o.status = 'PENDING'")
    int confirmOrderById(@Param("orderId") Long orderId);

    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = :status WHERE o.id = :orderId")
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);

    Order findByUserIdAndOrderNumber(Long userId, String orderNumber);

    // ✅ Truy vấn tên sản phẩm theo đơn hàng
    @Query(value = "SELECT p.product_name " +
               "FROM order_details od " +
               "JOIN products p ON od.product_id = p.id " +
               "WHERE od.order_id = :orderId", 
       nativeQuery = true)
List<String> findProductNamesByOrderId(@Param("orderId") Long orderId);

}
