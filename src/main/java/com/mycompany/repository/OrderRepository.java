package com.mycompany.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.mycompany.model.Order;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    // Có thể thêm custom query nếu cần
    java.util.List<Order> findByUserIdOrderByOrderDateDesc(Long userId);
}