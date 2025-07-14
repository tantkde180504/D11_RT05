package com.mycompany.repository;

import com.mycompany.model.OrderImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderImageRepository extends JpaRepository<OrderImage, Long> {
    List<OrderImage> findByOrderIdOrderByCreatedAtDesc(Long orderId);
    void deleteByOrderId(Long orderId);
}