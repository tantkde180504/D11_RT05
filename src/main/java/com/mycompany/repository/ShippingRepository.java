package com.mycompany.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mycompany.model.Shipping;

@Repository
public interface ShippingRepository extends JpaRepository<Shipping, Long> {
    List<Shipping> findAllByOrderByAssignedAtDesc();
    List<Shipping> findByStatusOrderByAssignedAtDesc(String status);
}

