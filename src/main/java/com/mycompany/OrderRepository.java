package com.mycompany;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    // Lấy toàn bộ đơn hàng theo thời gian giảm dần
    List<Order> findAllByOrderByOrderDateDesc();

    // Lọc theo trạng thái đơn hàng
    List<Order> findByStatusOrderByOrderDateDesc(String status);
}
