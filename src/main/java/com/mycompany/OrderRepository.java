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

    // ✅ Lấy tất cả đơn hàng, mới nhất trước
    List<Order> findAllByOrderByOrderDateDesc();

    // ✅ Lọc theo trạng thái
    List<Order> findByStatusOrderByOrderDateDesc(String status);

    // ✅ Xác nhận đơn hàng từ PENDING -> CONFIRMED
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = 'CONFIRMED' WHERE o.id = :orderId AND o.status = 'PENDING'")
    int confirmOrderById(@Param("orderId") Long orderId);

    // ✅ Cập nhật trạng thái bất kỳ
    @Modifying
    @Transactional
    @Query("UPDATE Order o SET o.status = :status WHERE o.id = :orderId")
    int updateOrderStatus(@Param("orderId") Long orderId, @Param("status") String status);

    // ✅ Tìm đơn hàng theo userId và mã đơn
    Order findByUserIdAndOrderNumber(Long userId, String orderNumber);

    // ✅ Danh sách tên sản phẩm trong đơn (không có số lượng)
    @Query(value = "SELECT p.name " +
                   "FROM order_items oi " +
                   "JOIN products p ON oi.product_id = p.id " +
                   "WHERE oi.order_id = :orderId", 
           nativeQuery = true)
    List<String> findProductNamesByOrderId(@Param("orderId") Long orderId);

    // ✅ Danh sách tên sản phẩm kèm số lượng (VD: "MG Barbatos x2")
    @Query(value = "SELECT p.name + ' x' + CAST(oi.quantity AS NVARCHAR) " +
                   "FROM order_items oi " +
                   "JOIN products p ON oi.product_id = p.id " +
                   "WHERE oi.order_id = :orderId", 
           nativeQuery = true)
    List<String> findProductNamesWithQuantityByOrderId(@Param("orderId") Long orderId);

    @Query(value = "SELECT p.name, oi.quantity, oi.unit_price " +
               "FROM order_items oi " +
               "JOIN products p ON oi.product_id = p.id " +
               "WHERE oi.order_id = :orderId", nativeQuery = true)

List<Object[]> findOrderItemDetails(@Param("orderId") Long orderId);

@Query(value = "SELECT p.name, oi.quantity, oi.unit_price " +
               "FROM order_items oi " +
               "JOIN products p ON oi.product_id = p.id " +
               "WHERE oi.order_id = :orderId", nativeQuery = true)
List<Object[]> findOrderItemDetailsByOrderId(@Param("orderId") Long orderId);

}
